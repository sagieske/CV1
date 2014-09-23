function [Hmat,r,c] = harris(image_path, sigma, thresh,n)
    %Load image, change to grayscale double matrix
    im = im2double(rgb2gray(imread(image_path)));
    %Create 1d Gaussian filter
    G = gaussian(sigma);
    x = -3*sigma:3*sigma;
    %Take the derivative of 1d Gaussian filter
    Gd = G' * (-(x/(sigma^2)));
    %Convolve image with derivative of Gaussian in x-direction
    im_x = conv2(im, Gd);
    %Convolve image with derivative of Gaussian in y-direction
    im_y = conv2(im, transpose(Gd));
    %Square Ix
    im_x_squared = im_x.^2;
    %Square Iy
    im_y_squared = im_y.^2;
    %Product of IxIy
    im_xy = im_x .* im_y;
    %Convolve IxIx, IyIy and IxIy with 1d Gaussian to compute A,B,C
    A = conv2(im_x_squared, G);
    C = conv2(im_y_squared, G);
    B = conv2(im_xy, G);
    %Calculate cornerness of each pixel and store in Hmat
    Hmat = (A.*C - B.^2) - 0.04*((A+C).^2);
    %Calculate maxima of Hmat in nxn window
    Bmat = imdilate(Hmat, true(n));
    %Define maxima in Hmat higher than threshold
    cornerPoints = ((Hmat == Bmat) & (Hmat > thresh));
    %Find rows, columns of cornerPoints
    [r,c] = find(cornerPoints);
    
    subplot(1,2,1);
    caption = sprintf('Ix');
    imshow(im_x);
    subplot(1,2,2);
    caption = sprintf('Iy');
    imshow(im_y);
    caption = sprintf('Im + corners');
    figure, imshowpair(im, cornerPoints);
    figure, imshow(Bmat);

    
    
    
    