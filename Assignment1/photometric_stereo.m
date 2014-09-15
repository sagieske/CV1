function trap = photometric_stereo

%Load 5 images into matrices.
%im2double is not available on this version of matlab
im1 = imread('sphere1.png');
im2 = imread('sphere2.png');
im3 = imread('sphere3.png');
im4 = imread('sphere4.png');
im5 = imread('sphere5.png');

%Create distance scalar for easy editing of 
%light source matrix V
d = 1;

%Create light source matrix V
V = [
    %light source straight ahead
    0, 0, d;
    %light source upper left corner
    -d, d, d;
    %light source upper right corner
    d, d, d;
    %light source lower left corner
    -d, -d, d;
    %light source lower right corner
    d, -d, d
    ];

%Store the length and width of the images
%to save time re-calculating
[length,width] = size(im1);

%Intensity vector to save pixel intensities for
%one pixel in all 5 images
i = zeros(1,5);

%Matrix to save albedo for every pixel i,j
A = zeros(length,width);

%matrix to save normal vector for every pixel i,j
N = zeros(length,width,3);

%Matrix to save difference in width for every pixel i,j
P = zeros(length, width);

%Matrix to save difference in width for every pixel i,j
Q = zeros(length, width);

%Note: no matrix I is used to offset shading, as solving
%the linear equation would cancel out I. Thus, it is left 
%out to save processing time

%Double for loop to access every pixel i,j
for i = 1:length,
    for j = 1:width,
        %Save the pixel values in each image for i,j in vector i
        ivector = [im1(i,j); im2(i,j); im3(i,j); im4(i,j); im5(i,j)];

        %To determine vector g, the linear equation i = Vg 
        %is solved. Both V and vector i are cast to double for linsolve
        %to work.
        g = linsolve(double(V), double(ivector));
        
        %The norm of vector g is the albedo of pixel i,j
        a = norm(g);

        %Store the albedo in the albedo-matrix
        A(i,j) = a;

        %Since some pixel values are 0, g and thus its norm, a,
        %can be 0 too. However, division by 0 leads to NaNs and
        %thus unusable values. So, if a=0, the normal vector is the
        %1x3 0-vector, and p and q are both 0. If a is not 0,
        %the normal vector is determined by dividing the vector g
        %by its norm, and P and Q are given by N1/N3 and N2/N3,
        %respectively
        if (a == 0)
            N(i,j,:) = [0;0;0;];
    		P(i,j) = 0;
        	Q(i,j) = 0;
        else
            N(i,j,:) = g./a;
            P(i,j) = N(i,j,1)/ N(i,j,3);
            Q(i,j) = N(i,j,2)/N(i,j,3);
        end 
    end
end

% Create height map
Z = zeros(length, width);
% set initial height for each pixel in left column
Z(1,1) = 0.0;
for i=2:length,
   Z(i,1) = Z(i-1,1) + Q(i,1);
end

for i=1:length,
	for j=2:width,
		Z(i,j) = Z(i,j-1) + P(i,j);
	end
end

%Before quiver3 can be used, a meshgrid must first be created.
%This meshgrid runs from over the entire image length and width
%in steps of 10.
[x,y] = meshgrid(1:20:width, 1:20:length);

%Now, a height map must be made to store the height of the image.
%The most left column is filled by setting the height value to the
%that of the previous pixel + the difference in y for the current pixel.
%Then, each row is filled by setting the height value to that of the 
%previous pixel + the difference in x for the current pixel

%The height map has the size of the original images
Z = zeros(length, width);

%The upper left pixel has height 0
Z(1,1) = 0;

%Filling the entire most left column
for i=2:length,
   Z(i,1) = Z(i-1,1) + Q(i,1);
end

%Filling the rest of the matrix
for i=1:length,
	for j=2:width,
		Z(i,j) = Z(i,j-1) + P(i,j);
	end
end

%Now, the height map Z and the unit vector matrix N need to be scaled 
%to the size of the meshgrid, which is 10x smaller than the original image

Z10 = zeros(size(x,1), size(x,2));
N10 = zeros(size(x,1), size(x,2),3);

for l = 1:size(x,1),
	for w = 1:size(x,2),
		i = x(l,w);
		j = y(l,w);
		Z10(l,w) = Z(i,j);
		N10(l,w,:) = N(i,j,:);
	end
end

%Plotting the normal vectors using quiver3 to show directions of 
%vectors perpendicular to the surface
quiver3(x, y, Z10, N10(:,:,1), N10(:,:,2), N10(:,:,3));

%Plotting the reconstructed surface using a mesh, plots the 
%reconstructed height of the surface
mesh(x, y, Z10)

