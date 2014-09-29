function opticalflow(image_path1, image_path2, sigma, n)
    %Switch case for loading image due to different process pgm or ppm
    %Load image and possibly change to grayscale double matrix
    dot = regexp(image_path1,'\.');
	switch(image_path1(dot+1:end))
    case {'pgm'}
        im = im2double(imread(image_path1));
        im2 = im2double(imread(image_path2));
    otherwise
        im = im2double(rgb2gray(imread(image_path1)));
        im2 = im2double(rgb2gray(imread(image_path2)));
    end

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
    
    %Create blocks of image and corresponding blocks for derivatives
    im_x_blocks = mat2cell(im_x, x,y);
	im_y_blocks = mat2cell(im_y, x,y);
    im_t_blocks = mat2cell(im_t, x,y);

    %Initialize matrix for i,j, v and initialize counter for row of this
    %matrix
    counter = 1;
    V_total = zeros(numel(blocks), 4);
    %Loop over blocks, for every block calculate v
    for i=1:size(blocks,1),
        for j=1:size(blocks,2),
            %Get block for x and y gradient
            im_x_region = im_x_blocks{i,j};
            im_y_region = im_y_blocks{i,j};
            im_t_region = im_t_blocks{i,j};  
            %Calculate v
            v = calculate_opticalflowmatrix(im_x_region, im_y_region, im_t_region);
            %Add v to total matrix of v's
            V_total(counter,:) = [i j v(1) v(2)];
            counter = counter +1;
        end
    end
    %Plot image
    figure, imshow(imread(image_path1));
    hold on;
    %Caculate middle of sliding window
    midofblock = n/2;
    %Plot opticalflow
    quiver(V_total(:,1)*n-midofblock,V_total(:,2)*n-midofblock, V_total(:,3), V_total(:,4));


   
