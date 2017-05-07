import cv2
import numpy as np
from sklearn.decomposition import PCA
from sklearn.lda import LDA
from sklearn.neighbors import KNeighborsClassifier
from sklearn.cross_validation import train_test_split
from sklearn import svm
from sklearn import linear_model

#X = np.array([[1, 1, 8], [2, 1, 9], [3, 2, 19], [-1, -1, 2], [-2, -1, 4], [-3, -2, 5]])
#y = np.array([3, 1, 1, 3, 2, 2])
### Reading features from 'features.npz' file:
npzfile = np.load('features.npz')
AFH1 = npzfile['arr_0']
AFH2 = npzfile['arr_1']
AFH3 = npzfile['arr_2']
AFH4 = npzfile['arr_3']
AFH5 = npzfile['arr_4']
AFH6 = npzfile['arr_5']
AFH7 = npzfile['arr_6']
AFH8 = npzfile['arr_7']
AFH9 = npzfile['arr_8']
AFH10 = npzfile['arr_9']
AFH11 = npzfile['arr_10']
AFH12 = npzfile['arr_11']
AFH13 = npzfile['arr_12']
AFH14 = npzfile['arr_13']
AFH15 = npzfile['arr_14']
AFH16 = npzfile['arr_15']
AFH17 = npzfile['arr_16']
AFH18 = npzfile['arr_17']
AFH19 = npzfile['arr_18']
AFH20 = npzfile['arr_19']
AFH21 = npzfile['arr_20']
AFH22 = npzfile['arr_21']
AFH23 = npzfile['arr_22']
AFH24 = npzfile['arr_23']
AFH25 = npzfile['arr_24']
print(AFH25.shape)
labels = npzfile['arr_25']
print(labels.shape)

### Flattening the features into a row
x1 = AFH1.flatten()
print(x1.shape)
x2 = AFH2.flatten()
print(x2.shape)
x3 = AFH3.flatten()
x4 = AFH4.flatten()
x5 = AFH5.flatten()
x6 = AFH6.flatten()
x7 = AFH7.flatten()
x8 = AFH8.flatten()
x9 = AFH9.flatten()
x10 = AFH10.flatten()
x11 = AFH11.flatten()
x12 = AFH12.flatten()
x13 = AFH13.flatten()
x14 = AFH14.flatten()
x15 = AFH15.flatten()
x16 = AFH16.flatten()
x17 = AFH17.flatten()
x18 = AFH18.flatten()
x19 = AFH19.flatten()
x20 = AFH20.flatten()
x21 = AFH21.flatten()
x22 = AFH22.flatten()
x23 = AFH23.flatten()
x24 = AFH24.flatten()
x25 = AFH25.flatten()

features = np.vstack((x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25))
print(features.shape)

### PCA to reduce the dimensions of data
pca = PCA(n_components=5400)
pca.fit(features)
#print(pca.explained_variance_ratio_)
reduced_features = pca.transform(features);
print(reduced_features.shape)

### LDA to project data into most discriminative (n-1) directions where n is the number of classes
lda = LDA()
lda.fit(reduced_features, labels)
new_features = lda.transform(reduced_features)
print(new_features.shape)

### Classification

# partition the data into training and testing splits, using 75%
# of the data for training and the remaining 25% for testing
(trainFeat, testFeat, trainLabels, testLabels) = train_test_split(features, labels, test_size=0.05, random_state=42)


### KNN Classifier with 20% accuracy score
# train and evaluate a k-NN classifer on the histogram
# representations
print("[INFO] evaluating Average Flow Histogram's accuracy...")
model = KNeighborsClassifier(n_neighbors=18,n_jobs=100)
model.fit(trainFeat, trainLabels)
acc = model.score(testFeat, testLabels)
print("[INFO] KNN's accuracy: {:.2f}%".format(acc * 100))


### SVM Classifier
### One against one approach
clf = svm.SVC(decision_function_shape='ovo')
clf.fit(trainFeat, trainLabels)
acc = model.score(testFeat, testLabels)
print("[INFO] SVM's accuracy with one against one approach: {:.2f}%".format(acc * 100))

### One against rest approach
clf = svm.SVC(decision_function_shape='ovr')
clf.fit(trainFeat, trainLabels)
acc = model.score(testFeat, testLabels)
print("[INFO] SVM's accuracy with one against rest approach: {:.2f}%".format(acc * 100))

### Logistic Regression Classifier
lr = linear_model.LogisticRegression(C=1e5)
lr.fit(trainFeat, trainLabels)
acc = lr.score(testFeat, testLabels)
print("[INFO] Multinomail Logistic Regression's Accuracy: {:.2f}%".format(acc * 100))