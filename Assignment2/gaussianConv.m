function imOut = gaussianConv(image_path, sigma_x, sigma_y)
im = imread(image_path);

A = conv2(gaussian(sigma_y), gaussian(sigma_x), im(:,:,1));
B = conv2(gaussian(sigma_y), gaussian(sigma_x), im(:,:,2));
C = conv2(gaussian(sigma_y), gaussian(sigma_x), im(:,:,3));
%image(A);
%image(B);
image(C);

%for i=1:size(im,1),
%    A(i,:) = conv2(double(im(i,:)), double(gaussian(sigma_x)));
%end 
%image(A);
%for j=1:size(im,2),
%    B(:,j) = conv2(double(A(:,j)'), double(gaussian(sigma_y)));
%end
%image(B);
%imOut = conv2(A,B);
%image(imOut)

%G = fspecial('gaussian', 5, sigma_x) ;
%imOut = conv(im, G, 'same');
%image(imOut);
%image(imOut)