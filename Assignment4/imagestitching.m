function imagestitching(im1, im2)
    %Get optimal transformation matrix for im1 and im2, 
    %20 iterations in RANSAC should be enough
    tform = imagetransform(im1, im2, 20);
    %Load images
    [pathstr,name,ext] = fileparts(im1);
    if ext == '.pgm'
        ext
        im1 = im2single(imread(im1));
        im2 = im2single(imread(im2));
    else
        im1 = im2single(rgb2gray(imread(im1)));
        im2 = im2single(rgb2gray(imread(im2)));
    end
    %Transform second image
    transformed_im = imtransform(im2, tform);
    
    [frames1, desc1] = vl_sift(im1);
    [frames2, desc2] = vl_sift(transformed_im);
    %Set of supposed matches between region descriptors in each image
    [matches] = vl_ubcmatch(desc1, desc2)
    

    start_x_array = ones(1,size(matches,2));
    start_y_array = ones(1,size(matches,2));
    % Calculate start x,y pixel of image 2 in image 1 for every match
    for j=1:size(matches,2)
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
    % Get highest frequency of possible x,y start values
    y = mode(start_x_array);
    x = mode(start_y_array);
   
    % Get size for new image
    x_length = max(x + size(transformed_im,1), size(im1,1));
    y_length = max(y + size(transformed_im,2), size(im1,2));

    % Create new image
    newimage = zeros(x_length, y_length);
    % Overlap image 1 in new image
    newimage(1:size(im1,1), 1:size(im1,2)) = im1;
    % Overlape image 2 over new image + image 1
    newimage(x:size(transformed_im,1)-1+x, y:size(transformed_im,2)-1+y) = transformed_im;

    % Find all black pixels from image2 that overlapped image 1
    partialimage = newimage(1:size(im1,1), 1:size(im1,2));
    % Substitute black pixels by original pixel in image 1
    newimage(partialimage < 1) = im1(partialimage < 1);    
    figure, imshow(newimage)   

