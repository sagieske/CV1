function [imOut Gd] = gaussianDer(image_path, G, sigma)
    %Create vector like gaussian.m's x-vector
    x = -3*sigma:3*sigma;
    %Take the derivative of supplied distribution G
    Gd = G' * (-(x/(sigma^2)));
    %Read image in gray-scale and convert to double
    im = im2double(rgb2gray(imread(image_path)));
    %Return image convolved with derivative of distribution
    imOut = conv2(im, Gd, 'valid');