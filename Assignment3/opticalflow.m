function opticalflow(image_path,n)
    %Load image, change to grayscale double matrix
    im = im2double(rgb2gray(imread(image_path)));
	x(1:size(im,1)/n) = n;
	y(1:size(im,2)/n) = n;
	mat2cell(im, x,y)
