function imOut = compare(image_path, sigma_x)
    im = im2double(rgb2gray(imread(image_path)));
    G = fspecial('gaussian', [19 1], sigma_x);
    imOut = conv2(im, G, 'same');