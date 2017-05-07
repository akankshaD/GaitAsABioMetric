minsize = 8;
maxsize = 100;
videoSource = vision.VideoFileReader('C:\Users\Akanksha\Desktop\Project\Dataset\videos\test23.mp4','VideoOutputDataType','uint8');
detector = vision.ForegroundDetector('NumTrainingFrames', 5,...
    'InitialVariance', 200, 'NumGaussians', 8, 'MinimumBackgroundRatio', 0.1);
blobbbox = vision.BlobAnalysis(...
       'CentroidOutputPort', false, 'AreaOutputPort', false, ...
       'BoundingBoxOutputPort', true, ...
       'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', minsize,...
       'MaximumBlobAreaSource', 'Property', 'MaximumBlobArea',maxsize);
   shapeInserter = vision.ShapeInserter('BorderColor','White');
   videoPlayer = vision.VideoPlayer();
  for i = 1:10
       frame  = step(videoSource);
       fgMask = step(detector, frame);
       bbox = step(blobbbox, fgMask);
       out = step(shapeInserter, frame, bbox);
       step(videoPlayer, out);
       pause(0.5)
  end
release(videoPlayer);
release(videoSource);