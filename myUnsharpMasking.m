function sharpenedImage = myUnsharpMasking(inputImage, filterSize, stdDev, scalingFactor)
    
    inputImage = double(inputImage);
    gaussianFilter = fspecial('gaussian', filterSize, stdDev);
    blurredImage = imfilter(inputImage, gaussianFilter);
    negatedBlurredImage = -blurredImage;
    unsharpMask = inputImage + negatedBlurredImage;
    sharpenedImage = inputImage + scalingFactor.*(unsharpMask);
    
end