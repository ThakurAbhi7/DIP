function [BFImage, corruptedImage, rmsd, spaceMask] = myBilateralFiltering(img, stdS, stdI, window)
    rng(0);
    img = double(img);
    range = max(img(:))-min(img(:));
    corruptedImage = img + randn(size(img))*(range*0.05);
    filterS = fspecial('gaussian', 2*window+1, stdS);
    shape = size(img);
    BFImage = zeros(shape);
    for ii = 1:shape(1)
        for jj = 1:shape(2)
            if ii-window>0
                left = 1;
            else
                left = window+2-ii;
            end
            if ii+window<=shape(1)
                right = 2*window+1;
            else
                right = window+1+(shape(1)-ii);
            end
            if jj-window>0
                top = 1;
            else
                top = window+2-jj;
            end
            if jj+window<=shape(2)
                bottom = 2*window+1;
            else
                bottom = window+1+(shape(2)-jj);
            end
            curFilS = filterS(left:right, top:bottom);
            curWindow = corruptedImage(max(1, ii-window):min(shape(1), ii+window), max(1, jj-window):min(shape(2), jj+window));
            curFilI = gaussian(curWindow - corruptedImage(ii,jj), stdI);
            weight = sum((curFilS.*curFilI), 'all');
            BFImage(ii,jj) = sum(curFilS.*curFilI.*curWindow/weight, 'all');
        end
    end
    rmsd = RMSD(img, BFImage);
    spaceMask = filterS;
    spaceMask(spaceMask>0) = 255*spaceMask(spaceMask>0);
end

function distance = RMSD(A, B)
    distance = sqrt(sum((A-B).^2/(numel(A)), 'all'));
end

function filter = gaussian(matrix, std)
    constant = 1/sqrt(2*std);
    filter = constant.*exp(-(matrix.^2)/(2*std));
end