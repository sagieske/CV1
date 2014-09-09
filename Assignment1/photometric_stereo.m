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
for i = 1:length,
    for j = 1:width,
        holder = [im1(i,j); im2(i,j); im3(i,j); im4(i,j); im5(i,j)];
         G(i,j,:) = double(V)\double(holder);
         det(G(i,j,:))
    end
end
