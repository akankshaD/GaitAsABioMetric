videoReader = vision.VideoFileReader('C:\Users\Akanksha\Desktop\Project\Dataset\videos\test23.mp4','ImageColorSpace','Intensity','VideoOutputDataType','uint8');
converter = vision.ImageDataTypeConverter; 
videoPlayer = vision.VideoPlayer('Name','Motion Vector');
i =1;

while ~isDone(videoReader)
   frame = step(videoReader);
   im = step(converter, frame);
   fm = figure;
   bb = regionprops(im,'BoundingBox');
   bbMatrix = vertcat(bb(:).BoundingBox);
   disp(bbMatrix);
   imshow(im);
   hold on;
   rectangle('Position',bbMatrix,'EdgeColor', 'r','LineWidth', 3,'LineStyle','-');
   out = getframe(fm);
   filename = strcat('C:\Users\Akanksha\Documents\MATLAB\BoundingBoxWithOpticalFlow\cropped_image_%d',num2str(i),'.png');
   imwrite(out.cdata, filename);
   i = i+1;
    
end
%Close the video reader and player

release(videoPlayer);
release(videoReader);

% for the readme
