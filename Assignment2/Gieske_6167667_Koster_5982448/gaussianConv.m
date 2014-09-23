function imOut = gaussianConv(image_path, sigma_x, sigma_y)
    %Read image in grayscale and convert to double
    im = im2double(rgb2gray(imread(image_path)));
    %Return convolution of rows with gaussian filter over sigma_x and of
    %columns with gaussian filter over sigma_y. Parameter 'valid' removes
    %edges from result.
    imOut = conv2(gaussian(sigma_x), gaussian(sigma_y), im, 'valid');