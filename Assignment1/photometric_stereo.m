function y = photometric_stereo
im1 = imread('sphere1.png');
im2 = imread('sphere2.png');
im3 = imread('sphere3.png');
im4 = imread('sphere4.png');
im5 = imread('sphere5.png');
V = [
    0.0,0.0,1.0;
    -1.0,1.0,1.0;
    1.0,1.0,1.0;
    -1.0,-1.0,1.0;
    1.0,-1.0,1.0
    ];
[length,width] = size(im1);
K = zeros(length,width,5);
G = zeros(length, width, 3);
holder = zeros(1, 5);
N = zeros(length, width,3);
P = zeros(length, width);
for i = 1:length,
    for j = 1:width,
        holder = [im1(i,j); im2(i,j); im3(i,j); im4(i,j); im5(i,j)];
         G(i,j,:) = double(V)\double(holder);
         % CHECK
         N(i,j,:) = (1/norm(G(i,j)))* G(i,j,:);
         P(i,j) = N(i,j,1)/N(i,j,3);
         Q(i,j) = N(i,j,2)/N(i,j,3);
    end
end
x = 1:length;
y = 1:width;
[X,Y] = meshgrid(x,y);

Z = zeros(length, width);

for i=2:length,
   Z(i,1) = Z(i-1,1) + Q(i,j) 
end

%quiver3(X,Y,N(:,:,1),N(:,:,2), N(:,:,3))
