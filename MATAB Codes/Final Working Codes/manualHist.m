opticalFlow = vision.OpticalFlow('ReferenceFrameSource','Input port');
opticalFlow.OutputValue = 'Horizontal and vertical components in complex form';
converter = vision.ImageDataTypeConverter;

% Bounding Box Matrix
matrix = [130 230; 170 220; 210 280; 210 310; 240 320; 300 350; 300 370; 300 400; 380 420; 400 500; 410 500; 430 500;460 500; 470 510; 550 610; 550 650; 550 640; 600 650; 610 660];

% Declaring the cell for storing flow histograms
FH = cell(20, 1);

j = 1;
I = [12;13;16;17;18;21;22;23;27;30;31;32;33;34;41;44;45;47;48];
%disp(size(I,1));
while j < size(I, 1);
    imPrev = im2double(rgb2gray(imread(strcat('C:\Users\Akanksha\Documents\MATLAB\test23BBox\output_test23_',num2str(I(j)),'.png'))));
    imCurr = im2double(rgb2gray(imread(strcat('C:\Users\Akanksha\Documents\MATLAB\test23BBox\output_test23_', num2str(I(j+1)),'.png'))));
    disp(j);
    of = step(opticalFlow, imPrev, imCurr);
    %disp(matrix(j,1));
    %disp(matrix(j,2));
    disp(size(of));
    if j == 10
        imagesc(imPrev);
    end
    ofBBox = of(150:350, matrix(j, 1):matrix(j,2));
    %disp(ofBBox(1,1));
    rV = zeros((size(ofBBox,1)*size(ofBBox,2)), 1);
    iV = zeros((size(ofBBox,1)*size(ofBBox,2)), 1);

    k=1;
    for p=1:201
        for q=1:(matrix(j,2)-matrix(j,1))
            rV(k,1) = real(ofBBox(p,q));
            iV(k,1) = imag(ofBBox(p,q));
            k = k+1;
        end
    end

    [theta, r] =  cart2pol(rV, iV);
    [minR, in1] = min(r);
    %disp(minR);
    [maxR, in2] = max(r);
    %disp(maxR);
    [minTheta, in3] = min(theta);
    %disp(minTheta);
    [maxTheta, in4] = max(theta);
    %disp(maxTheta);

    bins = 3600;

    Vec = [r,theta];
    %disp(Vec);

    fh = hist3(Vec, [10 360]);
    
    % Normalizing Histogram
    nh = fh / sum(fh);
    %bar(nh, 'r', 'theta
    %plot(nh);
    %view(3);

    %disp(fh);
    
    FH{j} = nh;

    %nfh = histogram(Vec, 360,  'Normalization', 'probability');
    %%plot(nfh);
    %view(3);
    
    j = j+1;
    
end

disp(FH);

