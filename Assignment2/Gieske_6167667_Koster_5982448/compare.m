function imOut = compare(image_path, sigma_x)
    %Read image in grayscale and convert to double
    im = im2double(rgb2gray(imread(image_path)));
    %Create Gaussian filter using built-in Matlab function, using
    %sigma_x and the same dimension as gaussian.m
    G = fspecial('gaussian', [19 1], sigma_x);
    %Convolve the image with the built-in filter
    imOut = conv2(im, G, 'same');
    %Create two subplots to compare images
    subplot(1,2,1);
    caption = sprintf('fspecial');
    %Show image convolved by built-in filter
    imshow(imOut);
    title(caption, 'FontSize', 20);
    subplot(1,2,2);
    caption = sprintf('gaussianConv');
    %Show image convolved by gaussian.m filter
    imshow(gaussianConv(image_path, sigma_x, sigma_x));
    title(caption, 'FontSize', 20);
    %gaussian.m blurs more than Matlab's fspecial