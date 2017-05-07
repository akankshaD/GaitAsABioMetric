opticalFlow = vision.OpticalFlow('ReferenceFrameSource','Input port');
opticalFlow.OutputValue = 'Horizontal and vertical components in complex form';
converter = vision.ImageDataTypeConverter;

% FIRST VIDEO
% Bounding Box Matrix
matrix = [130 230; 170 220; 210 280; 210 310; 240 320; 300 350; 300 370; 300 400; 380 420; 400 500; 410 500; 430 500;460 500; 470 510; 550 610; 550 650; 550 640; 600 650; 610 660];

% Declaring the cell for storing flow histograms
FH = cell(19, 1);

j = 1;
I = [12;13;16;17;18;21;22;23;27;30;31;32;33;34;41;44;45;47;48];
%disp(size(I,1));
while j < size(I, 1);
    imPrev = im2double(rgb2gray(imread(strcat('C:\Users\Akanksha\Documents\MATLAB\test23BBox\output_test23_',num2str(I(j)),'.png'))));
    imCurr = im2double(rgb2gray(imread(strcat('C:\Users\Akanksha\Documents\MATLAB\test23BBox\output_test23_', num2str(I(j+1)),'.png'))));
    %disp(j);
    of = step(opticalFlow, imPrev, imCurr);
    %disp(matrix(j,1));
    %disp(matrix(j,2));
    %disp(size(of));
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
    %[minR, in1] = min(r);
    %disp(minR);
    %[maxR, in2] = max(r);
    %disp(maxR);
    %[minTheta, in3] = min(theta);
    %disp(minTheta);
    %[maxTheta, in4] = max(theta);
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

%disp(FH{1});
%disp(FH{2});

% Histogram Matching
j =1;
fro_norm = zeros(18,1);
while j< 19
    fro_norm(j, 1) = norm(FH{j}, 'fro');
    j = j+1;
end

%disp(fro_norm);
mid = round(size(I,1)/2);
ref_fro_norm = fro_norm(mid);

diff_fro_norm = abs(fro_norm - ref_fro_norm);

%disp(diff_fro_norm);

j=1;
diff1 = diff_fro_norm(1);
firstMin =0;
while j < 19
    if (diff_fro_norm(j) < diff1) && (j ~= mid) 
        diff1 = diff_fro_norm(j);
        firstMin = j; 
    end
    
    j = j+1;
end

j=1;
diff2 = diff_fro_norm(1);
secondMin =0;
while j < 19
    if (diff_fro_norm(j) < diff2) && (j ~= mid) && (diff_fro_norm(j) ~= diff1)
        diff2 = diff_fro_norm(j);
        secondMin = j; 
    end
    j = j+1;
end


%disp(diff1);
%disp(diff2);
%disp(firstMin);
%disp(secondMin);


% Computing Average Flow Histogram
var = firstMin > secondMin;
in1 =0;
in2=0;
if var
    in1 = secondMin;
    in2 = firstMin;
else
    in1 = firstMin;
    in2 = secondMin;
end

AFH = FH{in1};
for i=in1+1:in2
    AFH = AFH + sum(FH{i}(:));
end

AFH = AFH/(in2-in1);

%disp(AFH);



% SECOND VIDEO

% Bounding Box Matrix
mat = [280 380; 350 400; 370 440; 410 480; 420 480; 540 600; 550 600; 560 630; 570 640; 580 630; 585 640; 585 650;600 640];

% Declaring the cell for storing flow histograms
FH1 = cell(13, 1);

j = 1;
I = [43;49;55;60;61;77;78;79;80;81;82;83;85];
%disp(size(I,1));
while j < size(I, 1);
    imPrev = im2double(rgb2gray(imread(strcat('C:\Users\Akanksha\Documents\MATLAB\test10BBox\output_test10_',num2str(I(j)),'.png'))));
    imCurr = im2double(rgb2gray(imread(strcat('C:\Users\Akanksha\Documents\MATLAB\test10BBox\output_test10_', num2str(I(j+1)),'.png'))));
    %disp(j);
    of = step(opticalFlow, imPrev, imCurr);
    %disp(matrix(j,1));
    %disp(matrix(j,2));
    %disp(size(of));
    ofBBox = of(140:340, mat(j, 1):mat(j,2));
    %disp(ofBBox(1,1));
    rV = zeros((size(ofBBox,1)*size(ofBBox,2)), 1);
    iV = zeros((size(ofBBox,1)*size(ofBBox,2)), 1);

    k=1;
    for p=1:201
        for q=1:(mat(j,2)-mat(j,1))
            rV(k,1) = real(ofBBox(p,q));
            iV(k,1) = imag(ofBBox(p,q));
            k = k+1;
        end
    end

    [theta, r] =  cart2pol(rV, iV);
    %[minR, in1] = min(r);
    %disp(minR);
    %[maxR, in2] = max(r);
    %disp(maxR);
    %[minTheta, in3] = min(theta);
    %disp(minTheta);
    %[maxTheta, in4] = max(theta);
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
    
    FH1{j} = nh;

    %nfh = histogram(Vec, 360,  'Normalization', 'probability');
    %%plot(nfh);
    %view(3);
    
    j = j+1; 
end

%disp(FH1{1});
%disp(FH1{2});

% Histogram Matching
j =1;
fro_norm1 = zeros(13,1);
while j< 13
    fro_norm1(j, 1) = norm(FH1{j}, 'fro');
    j = j+1;
end

%disp(fro_norm1);
mid = round(size(I,1)/2);
ref_fro_norm1 = fro_norm1(mid);

diff_fro_norm1 = abs(fro_norm1 - ref_fro_norm1);

%disp(diff_fro_norm1);

j=1;
diff1 = diff_fro_norm1(1);
firstMin =0;
while j < 13
    if (diff_fro_norm1(j) < diff1) && (j ~= mid) 
        diff1 = diff_fro_norm1(j);
        firstMin = j; 
    end
    
    j = j+1;
end

j=1;
diff2 = diff_fro_norm1(1);
secondMin =0;
while j < 13
    if (diff_fro_norm1(j) < diff2) && (j ~= mid) && (diff_fro_norm1(j) ~= diff1)
        diff2 = diff_fro_norm1(j);
        secondMin = j; 
    end
    j = j+1;
end


%disp(diff1);
%disp(diff2);
%disp(firstMin);
%disp(secondMin);


% Computing Average Flow Histogram
var = firstMin > secondMin;
in1 =0;
in2=0;
if var
    in1 = secondMin;
    in2 = firstMin;
else
    in1 = firstMin;
    in2 = secondMin;
end

AFH1 = FH1{in1};
for i=in1+1:in2
    AFH1 = AFH1 + sum(FH1{i}(:));
end

AFH1 = AFH1/(in2-in1);

%disp(AFH1);

% THIRD VIDEO


% Linear Discriminant Analysis

trainData = [AFH'; AFH1';AFH'; AFH1';AFH'; AFH1';AFH'; AFH1';AFH'; AFH1';AFH'; AFH1'];
testData = [AFH1';AFH1'];
labels = ['S1';'S2';'S1';'S2';'S1';'S2';'S1';'S2';'S1';'S2';'S1';'S2'];
disp(trainData);
disp(labels);

model = fitcdiscr(trainData, labels,'discrimType','pseudoQuadratic');
meanClass = predict(model, testData)






