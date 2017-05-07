I = imread('activecontour_ex1a.png');
imshow(I);
title('Original Image');
G = rgb2gray(I);
mask = zeros(size(G));
mask(25:end-25,25:end-25) = 1;
  
figure, imshow(mask);
title('Initial Contour Location');
bw = activecontour(G,mask,300);
  
figure, imshow(bw);
title('Segmented Image');