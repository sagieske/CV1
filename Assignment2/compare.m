function imOut = compare(image_path, sigma_x)
    im = im2double(rgb2gray(imread(image_path)));
    G = fspecial('gaussian', [19 1], sigma_x);
    imOut = conv2(im, G, 'same');
    
    subplot(1,2,1);
    caption = sprintf('fspecial');
    imshow(imOut);
    title(caption, 'FontSize', 20);
    subplot(1,2,2);
    caption = sprintf('gaussianConv');
    imshow(gaussianConv(image_path, sigma_x, sigma_x));
    title(caption, 'FontSize', 20);