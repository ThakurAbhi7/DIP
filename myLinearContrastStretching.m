function lcs_img = myLinearContrastStretching(img, lower, upper)
lcs_img = zeros(size(img));
img_size = size(img);
[temp, dims] = size(img_size);
if dims == 2
    img_size(3) = 1;
end
for dim = 1:img_size(3)
    temp = double(img(:,:,dim));
    temp = (temp-lower)*255/(upper-lower+1);
    temp(temp<0) = 0;
    temp(temp>255) = 255;
    lcs_img(:,:,dim) = temp;
end