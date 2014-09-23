function Hmat = harris(image_path, sigma)
    im = im2double(rgb2gray(imread(image_path)));
    G = gaussian(sigma);
    I = eye;
    x = -3*sigma:3*sigma;
    %Take the derivative of supplied distribution G
    Gd = G' * (-(x/(sigma^2)));
    Gd
    im_x = conv2(im, Gd);
    im_y = conv2(im, transpose(Gd));
    figure,imshowpair(im_x,im_y);
    im_x_squared = im_x.^2;
    im_y_squared = im_y.^2;
    figure,imshowpair(im_x_squared,im_y_squared)
    A = conv2(im_x_squared, G);
    C = conv2(im_y_squared, G);
    im_xy = im_x .* im_y;
    B = conv2(im_xy, G);
    Hmat = (A.*C - B.^2) - 0.04*((A+C).^2);
    imshow(Hmat);
    