%img = imread('test1.png');
img = imread('test11.jpg');
[featureVector, hogVisualization ] = extractHOGFeatures(img);
figure;
imshow(img);
hold on;
plot(hogVisualization);