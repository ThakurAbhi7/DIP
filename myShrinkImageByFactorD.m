function [sub_img, img] = myShrinkImageByFactorD(img_path, d)
img = imread(img_path);
[r, c] = size(img);
sub_img = zeros(floor(r/d), floor(c/d));
for ii = 1:floor(r/d)
    for jj = 1:floor(c/d)
        sub_img(ii,jj) = img(ii*d, jj*d);
    end
end
img = mat2gray(img);
sub_img = mat2gray(sub_img);