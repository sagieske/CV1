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

    start_x_array = ones(1,size(matches,2));
    start_y_array = ones(1,size(matches,2));
    % Create 5 random match indices
    for j=1:size(matches,2)
        % Get random match
        %j = round(rand * size(matches,1));
        %if j < 1
        %    j = 1;
        %elseif j > size(matches,2)
        %    j = size(matches,2);
        %end
         % Get index of first matches
        index1 = matches(1, j);
        index2 = matches(2, j);
        % Get x,y coordinates that correspond in both images
        x = frames1(1, index1);
        y = frames1(2, index1);
        x2 = frames2(1, index2);
        y2 = frames2(2, index2);
        % start x for image
        new_x = round(x - x2);
        new_y = round(y - y2);
        start_x_array(j) = new_x;
        start_y_array(j) = new_y;
    end
    % x and y of highest frequency
    y = mode(start_x_array)
    x = mode(start_y_array)
   
    x_1 = size(im1, 1);
    x_2 = size(transformed_im, 1);
    x_length = max(x + x_2, x_1);
    y_1 = size(im1, 2);
    y_2 = size(transformed_im, 2);
    y_length = max(y + y_2, y_1);

    newimage = zeros(x_length, y_length);
    newimage(1:size(im1,1), 1:size(im1,2)) = im1;
    figure, imshow(newimage);
    newimage(x:x_2+x-1, y:y_2+y-1) = transformed_im;
    figure, imshow(newimage)
    %imtest(x:size(im1,1)-x,y:size(im2,1)-y) = im2(1:size(im1,1)-x, 1,1:size(im1,2)-y)
    %imshow(imtest)
    
    figure,
    %subplot(1,3,1);
    imshow(im1);
    hold on;
    plot(start_x_array, start_y_array, 'r.', 'MarkerSize', 40);
    %hold off;
    %subplot(1,3,2);
    %imshow(transformed_im);
    %subplot(1,3,3);
    %imshow(im2);
