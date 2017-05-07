%img = imread('C:\Users\Akanksha\Documents\MATLAB\test45BBox\output_test45_106.png');
%imagesc(img);

load('trainingData.mat', 'trainData', 'labels');
labels =    [ 1; 2; 3 ; 4 ; 5 ; 6 ; 6 ; 7 ; 7 ; 8 ; 8  ; 9  ; 9 ; 6  ; 6  ; 9  ; 9 ];     % training labels

% PCA
[coeff score] = pca(trainData);
rd = coeff(:, 1:8);
rData = trainData*rd;
trainData = rData;
disp(trainData);

% GDA
%disp(size(trainData'));
%disp(size(labels));
trainData = gda(trainData',trainData', labels, 8, 'wave');
trainData = trainData';
disp(size(trainData));

% Fitting the KNN Model
model = fitcknn(trainData, labels, 'NumNeighbors',10, 'Standardize', 1);
cvknn = crossval(model);
classError = kfoldLoss(cvknn);
disp(classError);

testData = [trainData(15,:); trainData(17,:)];  % testing data

meanClass = predict(model, testData);
disp(meanClass);

% Fitting the Multi Class SVM Model
t = templateSVM('Standardize',1);
svmModel = fitcecoc(trainData, labels, 'Learners', t);
cvSvm = crossval(svmModel);
oosLoss = kfoldLoss(cvSvm);
disp(oosLoss);

testData = [trainData(15,:); trainData(17,:)];  % testing data

meanClass = predict(svmModel, testData);
disp(meanClass);

% Fitting the Multinomial Logistic Regression Model
lrModel = fitctree(trainData, labels);
cvLr = crossval(lrModel);
loss = kfoldLoss(cvLr);
disp(loss);

testData = [trainData(15,:); trainData(17,:)];  % testing data

meanClass = predict(lrModel, testData);
disp(meanClass);

% Fitting Discriminatory Model
DiscrMdl = fitcdiscr(trainData, labels);
cvDiscr = crossval(DiscrMdl);
loss = kfoldLoss(cvDiscr);
disp(loss);

% Fitting Generalized Logistic Regression Model
glr = fitcdiscr(trainData, labels);
cvGlr = crossval(glr);
loss = kfoldLoss(cvGlr);
disp(loss);
   

    
