function trap = photometric_stereo
%Load 5 images into matrices
im1 = imread('sphere1.png');
im2 = imread('sphere2.png');
im3 = imread('sphere3.png');
im4 = imread('sphere4.png');
im5 = imread('sphere5.png');
%Assume matrix V
V = [
    0.0, 0.0, 1.0;
    1.0, -1.0, 1.0;
    -1.0, -1.0, 1.0;
    1.0, 1.0, 1.0;
    -1.0, 1.0, 1.0
    ];
%To nullify shades
Sxy = zeros(5,5);
%Save images length and width in pixels
[length,width] = size(im1);
%
%G = zeros(length, width, 3);
%holder = zeros(1, 5);
%N = zeros(length, width,3);
%P = zeros(length, width);
ixy = zeros(1,5);
gxy = zeros(1,5);
for i = 1:length,
    for j = 1:width,
        ixy = [im1(i,j); im2(i,j); im3(i,j); im4(i,j); im5(i,j)];
        Sxy = [im1(i,j),0,0,0,0;
            0,im2(i,j),0,0,0;
            0,0,im3(i,j),0,0;
            0,0,0,im4(i,j),0;
            0,0,0,0,im5(i,j)];
       % ixy2 = double(Sxy)*double(ixy);
        %V2 = double(Sxy)*double(V);
         %G(i,j,:) = double(V)\double(holder);
        gxy = double(V)\double(ixy);
        g = norm(gxy);
         % CHECK
         %N(i,j,:) = (1/norm(G(i,j)))* G(i,j,:);
         %P(i,j) = N(i,j,1)/N(i,j,3);
         %Q(i,j) = N(i,j,2)/N(i,j,3);
    end
end

ixy = [im1(200,200); im2(200,200); im3(200,200); im4(200,200); im5(200,200)]
gxy = double(V)\double(ixy)
g = norm(gxy)
%plot(G,1000)
%x = 1:length;
%y = 1:width;
%[X,Y] = meshgrid(x,y);

%Z = zeros(length, width);

%for i=2:length,
%   Z(i,1) = Z(i-1,1) + Q(i,j);
%end

%quiver3(X,Y,N(:,:,1),N(:,:,2), N(:,:,3))
