function imagestitching(im1, im2)
    tform = imagetransform(im1, im2, 100);
    [pathstr,name,ext] = fileparts(im1);
    if ext == '.pgm'
        ext
        im1 = im2single(imread(im1));
        im2 = im2single(imread(im2));
    else
        im1 = im2single(rgb2gray(imread(im1)));
        im2 = im2single(rgb2gray(imread(im2)));
    end
    transformed_im = imtransform(im2, tform);
    figure,
    subplot(1,2,1);
    imshow(im1);
    subplot(1,2,2);
    imshow(transformed_im);