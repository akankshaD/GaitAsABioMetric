% SEGMENTING THE INPUT VIDEO IN FRAMES AND COMPUTING THE OPTICAL FLOW IN EACH FRAME

videoReader = vision.VideoFileReader('C:\Users\Akanksha\Desktop\Project\Dataset\videos\test34.MOV','ImageColorSpace','Intensity','VideoOutputDataType','uint8');
converter = vision.ImageDataTypeConverter; 
opticalFlow = vision.OpticalFlow('ReferenceFrameDelay', 1);
opticalFlow.OutputValue = 'Horizontal and vertical components in complex form';
shapeInserter = vision.ShapeInserter('Shape','Lines','BorderColor','Custom', 'CustomBorderColor', 255);
videoPlayer = vision.VideoPlayer('Name','Motion Vector');
%Convert the image to single precision, then compute optical flow for the video. Generate coordinate points and draw lines to indicate flow. Display results.
i = 1;
while ~isDone(videoReader)
    frame = step(videoReader);
    im = step(converter, frame);
    %imwrite(im,sprintf('original_frame_%d.png',i));
    of = step(opticalFlow, im);
    
    lines = videooptflowlines(of, 20);
    if ~isempty(lines)
      out =  step(shapeInserter, im, lines); 
      step(videoPlayer, out);
      imwrite(temp_im, sprintf('binary34_%d.jpg', i));
      imwrite( out, sprintf('test34_%d.jpg', i) );
    i = i+1;
      
    end
end
% Close the video reader and player

release(videoPlayer);
release(videoReader);