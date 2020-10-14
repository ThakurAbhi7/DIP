function [finalImage, corruptedImage, RMSD, kernel] = myPatchBasedFiltering(img, h, stdS)
    rng(0);
    pWinSize = 4;
    qWinSize = 12;
    img = double(img);
    range = max(img(:))-min(img(:));
    corruptedImage = img + randn(size(img))*(range*0.05);
    paddedImage = padarray(corruptedImage, [pWinSize pWinSize], 0);
    [rows, columns] = size(img);
    finalImage = zeros(size(corruptedImage));
    kernel = fspecial('gaussian', 2*pWinSize+1, stdS);
    kernel(pWinSize+1, pWinSize+1) = 0;
    for row = 1:rows
        for col = 1:columns
            pwindow = paddedImage(row:row+2*pWinSize, col:col+2*pWinSize);
            window = corruptedImage(max(1, row-qWinSize):min(rows, row+qWinSize), max(1, col-qWinSize):min(columns, col+qWinSize));
            weight = zeros(min(rows, row+qWinSize)-max(1, row-qWinSize)+1, min(columns, col+qWinSize)-max(1, col-qWinSize)+1);
            pKernel = kernel;
            if row<=pWinSize
                pKernel(1:max(1, pWinSize+1-row), 1:end) = 0;
            end
            if row+pWinSize>rows
                pKernel(min(end+1, end+1+rows-row-pWinSize), 1:end) = 0;
            end
            if col<=pWinSize
                pKernel(1:end, 1:max(1, pWinSize+1-col)) = 0;
            end
            if col+pWinSize>columns
                pKernel(1:end, min(end+1, end+1+columns-col-pWinSize)) = 0;
            end
           for qrow = max(1, row-qWinSize):min(rows, row+qWinSize)
               for qcol = max(1, col-qWinSize):min(columns, col+qWinSize)
                   qKernel = pKernel;
                    if qrow<=pWinSize
                        qKernel(1:max(1, pWinSize+1-qrow), 1:end) = 0;
                    end
                    if qrow+pWinSize>rows
                        qKernel(min(end+1, end+1+rows-qrow-pWinSize), 1:end) = 0;
                    end
                    if qcol<=pWinSize
                        qKernel(1:end, 1:max(1, pWinSize+1-qcol)) = 0;
                    end
                    if qcol+pWinSize>columns
                        qKernel(1:end, min(end+1, end+1+columns-qcol-pWinSize)) = 0;
                    end
                   qwindow = paddedImage(qrow:qrow+2*pWinSize, qcol:qcol+2*pWinSize);
                   distance = eculdiean(qKernel.*pwindow, qKernel.*qwindow);
                   weight(qrow+1-max(1, row-qWinSize), qcol+1-max(1, col-qWinSize)) = distance/sum(qKernel, 'all');
               end
           end
           weight = exp(-weight/(h^2));
           weight = weight/sum(weight , 'all');
           finalImage(row, col) = sum(weight.*window, 'all');
        end
    end
    RMSD = sqrt(eculdiean(img, finalImage)/numel(img));
end

function distance = eculdiean(A, B)
    distance = sum((A-B).^2, 'all');
end