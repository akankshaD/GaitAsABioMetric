load('trainingData.mat', 'trainData', 'labels');
disp(size(trainData));
disp(labels);
% PCA 
%[coeff score] = pca(trainData);
%rd = coeff(:, 1:8);
%rData = trainData*rd;
%disp(rData);

labels =    [ 1; 2; 3 ; 4 ; 5 ; 6 ; 6 ; 7 ; 7 ; 8 ; 8  ; 9  ; 9 ; 6  ; 6  ; 9  ; 9 ];     % training labels
disp(size(labels));

% GDA
disp(size(trainData'));
disp(size(labels));
newData = gda(trainData',trainData', labels, 8, 'linear');
disp(size(newData));
