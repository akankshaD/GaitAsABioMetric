
i=1;
while i<11
    im = imread(strcat('new_image_', num2str(i), '.jpg'));
    stats=regionprops(im,'Centroid','Area','BoundingBox');
    %center=cat(1,stats.Centroid);
    %area=[stats.Area];
    %[pixelArea, index]=max(area);
    %box=stats.BoundingBox;
    %area=box(3)*box(4);
    imshow(im);
    hold on;
    for k = 1 : length(stats) % Loop through all blobs.
	    % Find the bounding box of each blob.
	    thisBlobsBoundingBox = stats(k).BoundingBox;  
	    rectangle('Position', thisBlobsBoundingBox);
    end
    i = i+1;
end
