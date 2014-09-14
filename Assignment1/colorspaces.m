%#function imshow,imfilter
function test = colorspaces(filename, colorspace)
img = imread(filename); % Read image
R = img(:,:,1); % Red channel
G = img(:,:,2); % Green channel
B = img(:,:,3); % Blue channel

fprintf('Chosen colorspace: %s\n', colorspace);
switch(colorspace)
   case 'Opponent' 
		O1 = (R-G)./(sqrt(2));
		O2 = (R+G-(2*B))./(sqrt(6));
		O3 = (R+G+B)./sqrt(3);
		conv_img = cat(3, O1, O2, O3);
   case 'rgb' 
		r = (R)/(R+B+G);
		g = (G)/(R+B+G);
		b = (B)/(R+B+G);
		conv_img = cat(3, r,g,b);
   case 'HSV' 
		conv_img = rgb2hsv(img);
   otherwise
     fprintf('Unknown colorspace\n' );
   end

empty = zeros(size(img,1), size(img,2));
image(cat(3, conv_img(:,:,1), empty, empty)); title('channel #1');
figure, image(cat(3, empty, conv_img(:,:,2), empty)); title('channel #2');
figure, image(cat(3,empty, empty, conv_img(:,:,3))); title('channel #3');
