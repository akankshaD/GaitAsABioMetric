opticalFlow = vision.OpticalFlow('ReferenceFrameSource','Input port');
opticalFlow.OutputValue = 'Horizontal and vertical components in complex form';
converter = vision.ImageDataTypeConverter;

% FIRST VIDEO - Video No 23
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

% SECOND VIDEO- Video No 10

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

% THIRD VIDEO- Video No 14

% Bounding Box Matrix
mat_w = [140 200; 150 200; 150 200; 160 200; 170 205; 170 210; 170 210; 170 230; 185 350; 190 230; 185 240; 185 235; 195 270; 295 330; 300 330; 300 340; 305 380; 355 400; 360 410; 390 420; 405 430; 460 500; 540 595; 580 630];
mat_h = [170 310; 170 310; 170 310; 170 310; 170 315; 170 315; 170 325; 180 330; 180 330; 180 330; 180 335; 180 340; 185 345; 190 350; 180 350; 180 350; 190 350; 190 350; 180 350; 180 350; 180 350; 160 350; 170 350; 180 355];

% Declaring the cell for storing flow histograms
FH2 = cell(24, 1);

j = 1;
I = [3; 4; 7; 8; 11; 12; 13; 18; 19; 20; 21; 22; 24; 37; 38; 39; 41; 45; 47; 51; 53; 59; 71; 75];
%disp(size(I,1));
while j < size(I, 1);
    imPrev = im2double(rgb2gray(imread(strcat('C:\Users\Akanksha\Documents\MATLAB\test14BBox\output_test14_',num2str(I(j)),'.png'))));
    imCurr = im2double(rgb2gray(imread(strcat('C:\Users\Akanksha\Documents\MATLAB\test14BBox\output_test14_', num2str(I(j+1)),'.png'))));
    %disp(j);
    of = step(opticalFlow, imPrev, imCurr);
    %disp(matrix(j,1));
    %disp(matrix(j,2));
    %disp(size(of));
    ofBBox = of(mat_h(j,1):mat_h(j, 2), mat_w(j, 1):mat_w(j,2));
    %disp(ofBBox(1,1));
    rV = zeros((size(ofBBox,1)*size(ofBBox,2)), 1);
    iV = zeros((size(ofBBox,1)*size(ofBBox,2)), 1);

    k=1;
    for p=1:(mat_h(j,2) - mat_h(j,1))
        for q=1:(mat_w(j,2)-mat_w(j,1))
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
    
    FH2{j} = nh;

    %nfh = histogram(Vec, 360,  'Normalization', 'probability');
    %%plot(nfh);
    %view(3);
    
    j = j+1; 
end

%disp(FH1{1});
%disp(FH1{2});

% Histogram Matching
j =1;
fro_norm2 = zeros(24,1);
while j< 24
    fro_norm2(j, 1) = norm(FH2{j}, 'fro');
    j = j+1;
end

%disp(fro_norm1);
mid = round(size(I,1)/2);
ref_fro_norm2 = fro_norm2(mid);

diff_fro_norm2 = abs(fro_norm2 - ref_fro_norm2);

%disp(diff_fro_norm1);

j=1;
diff1 = diff_fro_norm2(1);
firstMin =0;
while j < 24
    if (diff_fro_norm2(j) < diff1) && (j ~= mid) 
        diff1 = diff_fro_norm2(j);
        firstMin = j; 
    end
    
    j = j+1;
end

j=1;
diff2 = diff_fro_norm2(1);
secondMin =0;
while j < 24
    if (diff_fro_norm2(j) < diff2) && (j ~= mid) && (diff_fro_norm2(j) ~= diff1)
        diff2 = diff_fro_norm2(j);
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

AFH2 = FH2{in1};
for i=in1+1:in2
    AFH2 = AFH2 + sum(FH2{i}(:));
end

AFH2 = AFH2/(in2-in1);

%disp(AFH2);

% FOURTH VIDEO- Video No 13

% Bounding Box Matrix
mat_w = [630 720; 600 705; 590 700; 605 700; 600 695; 600 680; 600 680; 600 680; 580 670; 550 670; 540 660;560 650; 540 640; 530 640; 550 630; 550 620; 550 610; 540 610; 530 610; 530 600; 520 600; 520 590; 510 580; 500 580; 500 570; 490 560; 490 550; 480 550; 480 550; 480 520; 470 520; 460 510; 450 500; 440 490; 440 490; 430 470; 430 470; 430 470; 420 470; 410 470; 400 460; 400 460; 400 460; 390 450; 390 450; 380 440; 380 440; 350 390; 340 400; 330 380; 330 380; 330 370; 320 360; 300 320; 280 310; 280 310; 270 310; 270 320; 260 320; 230 260; 220 280; 220 260; 220 270; 220 270; 210 260];
mat_h = [160 360; 160 360; 150 370; 150 370; 150 370; 155 370; 160 370; 150 370; 150 370; 150 360; 148 350; 150 370; 150 370; 150 360; 160 380; 160 380; 175 380; 170 375; 160 370; 160 370; 160 365;155 350; 150 360; 150 360; 160 360; 160 370; 170 370; 160 370; 160 370; 160 370; 160 365; 150 360; 150 350; 155 345; 160 350; 160 350; 150 350; 150 350; 150 350; 150 350; 150 350; 155 350; 155 350; 155 350; 155 340; 155 350; 150 350; 160 350; 165 350; 160 350; 155 340; 150 350; 150 340; 155 345; 155 345; 155 345; 150 345; 150 350; 150 340; 150 345; 150 335; 150 335; 145 325; 145 325];
% Declaring the cell for storing flow histograms
FH3 = cell(65, 1);

j = 1;
I = [1; 3; 5; 6; 7; 8; 9; 10; 11; 12; 13; 14; 15; 16; 17; 18; 19; 20; 21; 22; 23; 24; 25; 26; 27; 28; 29; 31; 32; 33; 34; 35; 38; 39; 40; 41; 42; 43; 44; 45; 46; 47; 48; 49; 50; 51; 52; 56; 57; 58; 59; 60; 61; 64; 66; 67; 68; 69; 70; 74; 75; 76; 77; 78;79];
%disp(size(I,1));
while j < size(I, 1);
    imPrev = im2double(rgb2gray(imread(strcat('C:\Users\Akanksha\Documents\MATLAB\test13BBox\output_test13_',num2str(I(j)),'.png'))));
    imCurr = im2double(rgb2gray(imread(strcat('C:\Users\Akanksha\Documents\MATLAB\test13BBox\output_test13_', num2str(I(j+1)),'.png'))));
    %disp(j);
    of = step(opticalFlow, imPrev, imCurr);
    %disp(matrix(j,1));
    %disp(matrix(j,2));
    %disp(size(of));
    ofBBox = of(mat_h(j,1):mat_h(j, 2), mat_w(j, 1):mat_w(j,2));
    %disp(ofBBox(1,1));
    rV = zeros((size(ofBBox,1)*size(ofBBox,2)), 1);
    iV = zeros((size(ofBBox,1)*size(ofBBox,2)), 1);

    k=1;
    for p=1:(mat_h(j,2) - mat_h(j,1))
        for q=1:(mat_w(j,2)-mat_w(j,1))
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
    
    FH3{j} = nh;

    %nfh = histogram(Vec, 360,  'Normalization', 'probability');
    %%plot(nfh);
    %view(3);
    
    j = j+1; 
end

%disp(FH1{1});
%disp(FH1{2});

% Histogram Matching
j =1;
fro_norm3 = zeros(65,1);
while j< 65
    fro_norm3(j, 1) = norm(FH3{j}, 'fro');
    j = j+1;
end

%disp(fro_norm1);
mid = round(size(I,1)/2);
ref_fro_norm3 = fro_norm3(mid);

diff_fro_norm3 = abs(fro_norm3 - ref_fro_norm3);

%disp(diff_fro_norm1);

j=1;
diff1 = diff_fro_norm3(1);
firstMin =0;
while j < 65
    if (diff_fro_norm3(j) < diff1) && (j ~= mid) 
        diff1 = diff_fro_norm3(j);
        firstMin = j; 
    end
    
    j = j+1;
end

j=1;
diff2 = diff_fro_norm3(1);
secondMin =0;
while j < 65
    if (diff_fro_norm3(j) < diff2) && (j ~= mid) && (diff_fro_norm3(j) ~= diff1)
        diff2 = diff_fro_norm3(j);
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

AFH3 = FH3{in1};
for i=in1+1:in2
    AFH3 = AFH3 + sum(FH3{i}(:));
end

AFH3 = AFH3/(in2-in1);

%disp(AFH3);

% FIFTH VIDEO- Video No 11

% Bounding Box Matrix
mat_w = [150 220; 170 240; 190 240; 190 250; 190 260; 200 270; 260 310; 270 310; 270 310; 270 320; 280 320; 290 330; 300 340; 280 350; 280 360; 290 370; 300 370; 310 380; 320 390; 340 400; 350 400; 360 410; 360 410; 350 400; 350 400; 340 400; 330 400; 340 400; 360 420; 360 420; 360 430; 370 440; 390 450; 400 460; 400 460; 400 460; 400 460; 390 470; 400 470; 400 470; 410 480; 410 490; 410 490; 420 510; 410 505; 420 510; 430 510; 440 510; 460 520; 470 530; 470 530; 480 530; 490 560; 490 570; 500 580; 500 590; 500 600; 520 605; 520 610; 530 610; 560 610; 570 620; 560 620; 560 620; 560 630; 570 640; 580 650; 580 660; 600 660; 600 670; 590 670; 600 680; 600 680; 610 700; 610 700; 610 710; 630 720];
mat_h = [160 355; 155 360; 155 355; 155 360; 160 360; 170 355; 160 360; 160 360; 160 360; 160 355; 160 350; 160 350; 160 350; 170 350; 175 355; 175 360; 175 360; 175 350; 160 350; 155 350; 155 350; 150 350; 145 350; 150 350; 145 350; 145 345; 150 350; 150 350; 155 350; 155 360; 160 350; 155 350; 155 355; 150 350; 150 355; 150 355; 145 350; 150 350; 150 355; 150 350; 150 345; 145 345; 150 350; 150 350; 155 350; 155 350; 150 350; 150 350; 150 345; 150 350; 150 355; 145 350; 150 360; 150 375; 160 375; 160 360; 155 360; 150 350; 150 345; 145 345; 145 355; 150 360; 145 360; 145 360; 140 360; 145 370; 145 370; 150 355; 150 355; 150 360; 155 365; 155 360; 155 350; 150 355; 145 355; 145 360; 145 360];

% Declaring the cell for storing flow histograms
FH4 = cell(77, 1);

j = 1;
I = [30; 34; 35; 41; 44; 47; 57; 58; 59; 61; 62; 65; 66; 67; 68; 69; 70; 71; 72; 73; 75; 76; 77; 78; 79; 80; 81; 82; 84; 85; 86; 87; 89; 90; 91; 92; 93; 94; 95; 96; 97; 98; 100; 101; 102; 103; 104; 105; 106; 107; 108; 109; 114; 116; 118; 119; 20; 121; 122; 123; 124; 125; 126; 127; 129; 130; 131; 132; 133; 134; 135; 136; 137; 138; 139; 140; 141];
%disp(size(I,1));
while j < size(I, 1);
    imPrev = im2double(rgb2gray(imread(strcat('C:\Users\Akanksha\Documents\MATLAB\test11BBox\output_test11_',num2str(I(j)),'.png'))));
    imCurr = im2double(rgb2gray(imread(strcat('C:\Users\Akanksha\Documents\MATLAB\test11BBox\output_test11_', num2str(I(j+1)),'.png'))));
    %disp(j);
    of = step(opticalFlow, imPrev, imCurr);
    %disp(matrix(j,1));
    %disp(matrix(j,2));
    %disp(size(of));
    ofBBox = of(mat_h(j,1):mat_h(j, 2), mat_w(j, 1):mat_w(j,2));
    %disp(ofBBox(1,1));
    rV = zeros((size(ofBBox,1)*size(ofBBox,2)), 1);
    iV = zeros((size(ofBBox,1)*size(ofBBox,2)), 1);

    k=1;
    for p=1:(mat_h(j,2) - mat_h(j,1))
        for q=1:(mat_w(j,2)-mat_w(j,1))
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
    
    FH4{j} = nh;

    %nfh = histogram(Vec, 360,  'Normalization', 'probability');
    %%plot(nfh);
    %view(3);
    
    j = j+1; 
end

%disp(FH1{1});
%disp(FH1{2});

% Histogram Matching
j =1;
fro_norm4 = zeros(77,1);
while j< 77
    fro_norm4(j, 1) = norm(FH4{j}, 'fro');
    j = j+1;
end

%disp(fro_norm1);
mid = round(size(I,1)/2);
ref_fro_norm4 = fro_norm4(mid);

diff_fro_norm4 = abs(fro_norm4 - ref_fro_norm4);

%disp(diff_fro_norm1);

j=1;
diff1 = diff_fro_norm4(1);
firstMin =0;
while j < 77
    if (diff_fro_norm4(j) < diff1) && (j ~= mid) 
        diff1 = diff_fro_norm4(j);
        firstMin = j; 
    end
    
    j = j+1;
end

j=1;
diff2 = diff_fro_norm4(1);
secondMin =0;
while j < 77
    if (diff_fro_norm4(j) < diff2) && (j ~= mid) && (diff_fro_norm4(j) ~= diff1)
        diff2 = diff_fro_norm4(j);
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

AFH4 = FH4{in1};
for i=in1+1:in2
    AFH4 = AFH4 + sum(FH4{i}(:));
end

AFH4 = AFH4/(in2-in1);

disp(AFH4);

% LINEAR DISCRIMINANT ANALYSIS

trainData = [AFH'; AFH1';AFH2'; AFH3';AFH4'; AFH1';AFH'; AFH1';AFH'; AFH1';AFH'; AFH1'];
testData = [AFH4';AFH';AFH2'; AFH1'; AFH3'];
labels = ['S1';'S2';'S3';'S4';'S5';'S2';'S1';'S2';'S1';'S2';'S1';'S1'];
disp(trainData);
disp(labels);

model = fitcdiscr(trainData, labels,'discrimType','pseudoLinear');
meanClass = predict(model, testData)






