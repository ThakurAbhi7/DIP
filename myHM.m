function [img, hm_img he_img] = myHM(img_path, img_mask_path, ref_img_path, ref_img_mask_path)
    img = imread(img_path);
    img_mask = imread(img_mask_path);
    ref_img = imread(ref_img_path);
    ref_img_mask = imread(ref_img_mask_path);
    img = double(img);
    ref_img = double(ref_img);
    hm_img = zeros(size(img));
    he_img = zeros(size(img));
    img_size = size(img);
    [temp, dims] = size(img_size);
    if dims == 2
        img_size(3) = 1;
    end
    for dim = 1:img_size(3)
        temp = img(:,:,dim);
        temp = temp(img_mask==1);
        img_cdf = freq(temp(:));
        temp = ref_img(:,:,dim);
        temp = temp(ref_img_mask==1);
        req_cdf = freq(temp(:));
        [r, c] = size(img(:,:,dim));
        map = zeros(1,256);
        % for hm
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
        temp = img(:,:,dim);
        for ii = 1:r
            for jj = 1:c
                temp(ii, jj) = map(temp(ii,jj)+1);
            end
        end
        hm_img(:,:,dim) = temp;
        % for he
        temp = img(:,:,dim);
        temp = temp(img_mask==1);
        img_cdf = freq(temp(:));
        for i = 1:256
            req_cdf(i) = i*img_cdf(256)/(256);
        end
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
        temp = img(:,:,dim);
        for ii = 1:r
            for jj = 1:c
                temp(ii, jj) = map(temp(ii,jj)+1);
            end
        end
        he_img(:,:,dim) = temp;
    end



function out = freq(A)
    out = zeros(1, 256);
    for i = 0:255
        out(i+1) = sum(A==i);
    end
    for i = 2:256
        out(i) = out(i)+out(i-1);
    end