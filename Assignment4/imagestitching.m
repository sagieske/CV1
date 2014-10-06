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
    trans2 = imtransform(im1, tform);
    [frames1, desc1] = vl_sift(im1);
    [frames2, desc2] = vl_sift(transformed_im);
    %Set of supposed matches between region descriptors in each image
    [matches] = vl_ubcmatch(desc1, desc2)
    frames1(matches(1,1))
    frames2(matches(2,1))
    for i=1:size(matches,1)
        index1 = matches(1, i);
        index2 = matches(2, i);
        x = frames1(1, index1);
        y = frames1(2, index1);
        x2 = frames2(1, index2);
        y2 = frames2(2, index2);
        new_x = round(x - x2)
    end
    figure,
    subplot(1,3,1);
    imshow(im1);
    subplot(1,3,2);
    imshow(transformed_im);
    subplot(1,3,3);
    imshow(im2);