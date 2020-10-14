function [he_img, new_he_img] = mynewHE(img)
    he_img = zeros(size(img));
    new_he_img = zeros(size(img));
    img_size = size(img);
    [temp, dims] = size(img_size);
    if dims == 2
        img_size(3) = 1;
    end
    for dim = 1:img_size(3)
        temp = img(:,:,dim);
        img_cdf = freq(temp(:));
        req_cdf = zeros(1, 256);
        for i = 1:256
            req_cdf(i) = i*img_cdf(256)/(256);
        end
        [r, c] = size(img(:,:,dim));
        map = zeros(1,256);
        i = 1;
        for j = 1:256
            while i<256 && req_cdf(i)<img_cdf(j)
                i = i+1;
            end
            map(j) = i-1;
        end
        for ii = 1:r
            for jj = 1:c
                temp(ii, jj) = map(temp(ii,jj)+1);
            end
        end
        he_img(:,:,dim) = temp;
        
        % for new he
        temp = img(:,:,dim);
        img_cdf = freq(temp(:));
        req_cdf = zeros(1, 256);
        cut_freq = double(median(temp(:)));
        part_one_mass = img_cdf(floor(cut_freq));
        part_two_mass = img_cdf(256)-part_one_mass;
        for i = 1:256
            req_cdf(i) = double(min(i, cut_freq))*part_one_mass/cut_freq + double(max(0,i-cut_freq))*part_two_mass/max(1, 255-cut_freq);
        end
        [r, c] = size(img(:,:,dim));
        map = zeros(1,256);
        i = 1;
        for j = 1:256
            while i<256 && req_cdf(i)<img_cdf(j)
                i = i+1;
            end
            map(j) = i-1;
        end
        for ii = 1:r
            for jj = 1:c
                temp(ii, jj) = map(temp(ii,jj)+1);
            end
        end
        new_he_img(:,:,dim) = temp;
    end



function out = freq(A)
    out = zeros(1, 256);
    for i = 0:255
        out(i+1) = sum(A==i);
    end
    for i = 2:256
        out(i) = out(i)+out(i-1);
    end