opticalFlow = vision.OpticalFlow('ReferenceFrameDelay', 1);
opticalFlow.OutputValue = 'Horizontal and vertical components in complex form';
i=20;
while i<142
    im = imread(strcat('C:\Users\Akanksha\Documents\MATLAB\test11\test11_', num2str(i), '.jpg'));
    fm = figure;
    bb = regionprops(im,'BoundingBox');
    bbMatrix = vertcat(bb(:).BoundingBox);
    %disp(bbMatrix);
    %disp('Break here!');
    [r, c] = size(bbMatrix);
    aRatio = 0;
    dim = [0, 0, 0, 0];
    for j=1:r
        pos = bbMatrix(j, :);
        %rectangle('Position',dim,'EdgeColor', 'r','LineWidth', 3,'LineStyle','-');
        temp = pos(4)/pos(3);
        if (temp > aRatio) && (pos(1) >= 20)
            aRatio = temp;
            dim = pos;
        end
    end
    %disp(strcat('Frame', num2str(i)));
    disp(dim);
    imshow(im);
    hold on;
    rectangle('Position',dim,'EdgeColor', 'r','LineWidth', 3,'LineStyle','-');
    out = getframe(fm);
    filename = strcat('C:\Users\Akanksha\Documents\MATLAB\test11BBox\output_test11_',num2str(i),'.png');
    imwrite(out.cdata, filename);

    i = i+1;
end