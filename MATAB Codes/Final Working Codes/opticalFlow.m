%vidReader = VideoReader('test1.mp4','CurrentTime',11);
imread('image1.png');
i=2;
opticFlow = opticalFlowFarneback;
while i<11
    frameRGB = imread('image%d', i);
    i= i+1;
    frameGray = rgb2gray(frameRGB);

    flow = estimateFlow(opticFlow,frameGray);

    imshow(frameRGB)
    hold on
    plot(flow,'DecimationFactor',[5 5],'ScaleFactor',2)
    hold off
end