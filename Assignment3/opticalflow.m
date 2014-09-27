function opticalflow(image_path, sigma, n)
    %Load image, change to grayscale double matrix
    im = im2double(rgb2gray(imread(image_path)));
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
    
    %Create blocks of image and corresponding blocks for derivatives
    im_x_blocks = mat2cell(im_x, x,y);
	im_y_blocks = mat2cell(im_y, x,y);
    
    %Loop over blocks, for every block calculate A
    for i=1:size(blocks,1),
        for j=1:size(blocks,2),
            %Get block for x and y gradient
            im_x_region = im_x_blocks{i,j};
            im_y_region = im_y_blocks{i,j};  
    
            %Reshape to vectors
            im_x_region = reshape(im_x_region, numel(im_x_region), 1);
            im_y_region = reshape(im_y_region, numel(im_y_region), 1);
            %Create A
            A= [im_x_region im_y_region];
        end
    end
    


    
    %B=blockproc(im, [n n], @(x) mean(x.data(:)))
