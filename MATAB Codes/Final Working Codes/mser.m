I = imread('test1.png');
regions= detectMSERFeatures(I);
figure; imshow(I); hold on;
plot(regions, 'showPixelList', true, 'showEllipses', false);
figure; imshow(I);
hold on;
plot(regions);