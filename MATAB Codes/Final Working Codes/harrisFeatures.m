I = imread('test1.png');
corners = detectHarrisFeatures(I);
[features, validCorners] = extractFeatures(I, corners);
figure;
imshow(I);
hold on;
plot(validCorners);