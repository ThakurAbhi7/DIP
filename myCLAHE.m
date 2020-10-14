function clahe_img = myCLAHE(img, d, k)
    clahe_img = zeros(size(img));
    img_size = size(img);
    [temp, dims] = size(img_size);
    if dims == 2
        img_size(3) = 1;
    end
    for dim = 1:img_size(3)
        for ii = 1:img_size(1)
            for jj = 1:img_size(2)
                temp = img(max(1, ii-d):min(img_size(1), ii+d), max(1, jj-d):min(img_size(2), jj+d),dim);
                img_cdf = freq(temp(:), k);
                req_cdf = zeros(1, 256);
                for i = 1:256
                    req_cdf(i) = i*img_cdf(256)/(256);
                end 
                map = zeros(1,256);
                i = 1;
                for j = 1:256
                    while i<256 && req_cdf(i)<img_cdf(j)
                        i = i+1;
                    end
                    if i == 1
                        map(j) = i-1;
                    else
                        map(j) = (i-1)*(req_cdf(i)-img_cdf(j))+i*(img_cdf(j)-req_cdf(i-1));
                        map(j) = map(j)/(req_cdf(i)-req_cdf(i-1));
                    end
                end
                clahe_img(ii, jj, dim) = map(img(ii, jj, dim)+1);
            end
        end
    end
end


function out = freq(A, k)
    %out = zeros(1, 256);
    %for i = 0:255
    %    out(1, i+1) = sum(A==i);
    %end
    A = uint8(A);
    out = imhist(A);
    threshold = length(A)*k;
    extra = sum(out(out>threshold)-threshold);
    out(out>threshold) = threshold;
    for i = 2:256
        out(i) = out(i)+out(i-1);
    end
    for i = 1:256
        out(i) = out(i)+i*extra/256;
    end
end