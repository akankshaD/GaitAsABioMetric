I0 = imread('test1.png')
sumImage = double(I0); % Inialize to first image.
for i=2:10 % Read in remaining images.
  rgbImage = imread(['test',num2str(i),'.png']);
  sumImage = sumImage + double(rgbImage);
end;
meanImage = sumImage / 10;
imshow(meanImage);