i =1;
while i< 11
    X = imread(strcat('test',num2str(i),'.png'));
    bb = regionprops(X,'BoundingBox');
    %bbMatrix = vertcat(bb(:).BoundingBox);
    disp(size(X));
    imshow(X);
    hold on;
    for k =1:length(bb)
        thisBB = bb(k).BoundingBox;
        rectangle('Position',[thisBB(1),thisBB(2),thisBB(3),thisBB(4)],'EdgeColor', 'r','LineWidth', 3,'LineStyle','-');
    end
    subImage = X(thisBB(2):thisBB(2)+thisBB(4), thisBB(1):thisBB(1)+thisBB(3));
    hold off;
    imwrite(subImage, sprintf('test_cropped_%d.jpg', i) );
    i = i+1;
end

