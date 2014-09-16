function imOut = gaussianConv(image_path, sigma_x, sigma_y)
    im = im2double(rgb2gray(imread(image_path)));
    imOut = conv2(gaussian(sigma_x), gaussian(sigma_y), im);