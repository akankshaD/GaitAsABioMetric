I = imread('test1.png');
points = detectSURFFeatures(I);

imshow(I);
hold on;
plot(points.selectStrongest(10),'showOrientation',true);