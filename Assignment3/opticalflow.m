function opticalflow(image_path1, image_path2, sigma, n)
    %Load image, change to grayscale double matrix
    im = im2double(rgb2gray(imread(image_path1)));
    im2 = im2double(rgb2gray(imread(image_path2)));

    %Create vector that describes block sizes at division by n
    x(1:floor(size(im,1)/n)) = n;
    y(1:floor(size(im,2)/n)) = n;
    x(end+1) = rem(size(im,1),n);
    y(end+1) = rem(size(im,2),n);
    blocks = mat2cell(im, x, y);

    
    %Create 1d Gaussian filter
    G = gaussian(sigma);
    x_range = -3*sigma:3*sigma;
    %Take the derivative of 1d Gaussian filter
    Gd = G' * (-(x_range/(sigma^2)));
    %Convolve image with derivative of Gaussian in x-direction
    im_x = conv2(im, Gd, 'same');
    %Convolve image with derivative of Gaussian in y-direction
    im_y = conv2(im, transpose(Gd),'same');
    %Get gradient with respect to time
    im_t = imabsdiff(im, im2);
    figure, imshow(im_t);

    
    %Create blocks of image and corresponding blocks for derivatives
    im_x_blocks = mat2cell(im_x, x,y);
	im_y_blocks = mat2cell(im_y, x,y);
    im_t_blocks = mat2cell(im_t, x,y);

    %V_total = zeros(size(blocks,1)*size(blocks,2),4)
    %Loop over blocks, for every block calculate A
    counter = 1;
    V_total = zeros(numel(blocks), 4);
    for i=1:size(blocks,1),
        for j=1:size(blocks,2),
            %Get block for x and y gradient
            im_x_region = im_x_blocks{i,j};
            im_y_region = im_y_blocks{i,j};
            im_t_region = im_t_blocks{i,j};  
            %Reshape to vectors
            im_x_region = reshape(im_x_region, numel(im_x_region), 1);
            im_y_region = reshape(im_y_region, numel(im_y_region), 1);
            %Create A
            A= [im_x_region im_y_region];
            %Create b
            b = -1.* reshape(im_t_region, numel(im_t_region), 1);
            %Calculate v
            a = A' * A;
            ab = A' * b;
            v = inv(a) * ab;
            %Add v to total matrix of v's
            V_total(counter,:) = [i j v(1) v(2)];
            counter = counter +1;
        end
    end
    %Plot Optical flow
    % TODO: DOES NOT PLOT CORRECTLY? LOOKS SHIFTED. MAYBE GRADIENT IN TIME?
    figure, quiver(V_total(:,1),V_total(:,2), V_total(:,3), V_total(:,4))
   
