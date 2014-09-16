function imOut = gaussianConv(image_path, sigma_x, sigma_y)
im = imread(image_path);
for i=1:size(im,1),
    A(i,:) = conv2(double(im(i,:)), double(gaussian(sigma_x)));
end 
image(A);
for j=1:size(im,2),
    B(:,j) = conv2(double(im(:,j)), double(gaussian(sigma_y)));
end
%image(B);
imOut = conv2(A,B);
%image(imOut)

%image(imOut)