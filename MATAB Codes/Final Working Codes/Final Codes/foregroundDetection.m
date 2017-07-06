% COMPUTING THE BOUNDING BOXES USING BLOB ANALYSIS FROM AN INPUT VIDEO

videoSource = vision.VideoFileReader('C:\Users\Akanksha\Desktop\Project\Dataset\videos\test48.MOV','ImageColorSpace','Intensity','VideoOutputDataType','uint8');
detector = vision.ForegroundDetector('NumTrainingFrames', 123, 'InitialVariance', 'Auto');
blob = vision.BlobAnalysis('CentroidOutputPort', false, 'AreaOutputPort', false, 'BoundingBoxOutputPort', true, 'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 250);
shapeInserter = vision.ShapeInserter('Shape','Lines','BorderColor','Custom', 'CustomBorderColor', 255);
%videoPlayer = vision.VideoPlayer;
i=1;
while ~isDone(videoSource)
     frame  = step(videoSource);
     fm = figure;
     fgMask = step(detector, frame);
     bbox   = step(blob, fgMask);
     [r, c] = size(bbox);
     dim = [0, 0, 0, 0];
     for j=1:r
        dim = bbox(j,:);
        imshow(frame);
        hold on;
        rectangle('Position',dim,'EdgeColor', 'r','LineWidth', 3,'LineStyle','-');
     end
     out = getframe(fm);
     filename = strcat('C:\Users\Akanksha\Documents\MATLAB\test48BBox\output_test48_',num2str(i),'.png');
     imwrite(out.cdata, filename);

     i = i+1;
end

 release(videoPlayer);
 
 %For the readme
