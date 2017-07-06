GAIT AS A BIOMETRIC
By - Akanksha Dwivedi, Tarini Chandrashekhar

MP Project Elective I Human Identification involves biometric features such as fingerprints/palm-prints, face, signatures etc. but the problem with these features is that they require specific devices to capture these features.
Here is where gait classification is beneficial because it requires just a single camera and is an effective and non-intrusive way of recognizing different subjects.
This project seeks out to verify if every human being has, in fact a unique gait signature. Following steps are followed in order to verify our claim:
1. The system first converts the input color images to gray level images.
2. The optical flow algorithm is employed on the image sequence to get the flow field with respect to two contiguous frames and use the difference in the optical flow between the two frames to draw a bounding box around the object. Now, the moving object detection is done using two separate methods, but their overall impact on the efficiency of the algorithm were no different. 
•	Blob Analysis: First, a mask is obtained by applying a foreground detector, to discern the foreground object from the rest of the image, and then Blob Detector is employed to detect the consistent image regions. We got 70-80 % frames with good bounding boxes.
•	YOLO detection – You Only Look Once (YOLO) is a real-time object detection which uses a single pre-trained neural network model on the entire image. It predicts varying objects in a single frame with varying weighted probabilities. It looks at the whole image at test time so its predictions are informed by global context in the image, so the detection is 100 percent accurate, with respect to the bounding box.

3.Now, we construct a bivariate flow histogram for each frame based on the polar component of flows inside the bounding box. We normalise the histogram.  Since, the number of frames differ for each video, we calculate a discerning feature called Gait Cycle for each subject, by performing histogram matching. 
Given a video sequence with T frames, we compute the gait similarity function d using the following equation:
 ,     1
Where  is the flow histogram at frame i and is the flow histogram of the reference frame. f is the  -norm 
similarity measurement function. The middle frame of the frame sequence is usually taken as the reference frame to
estimate the gait cycle accurately
We take the frames between two best matched valley points (marked as green boxes) as a gait cycle. Finally, we can obtain an Averaged Flow Histogram (AFH) which is the “unique gait signature” using the following equation: 

where  and  are the beginning and ending frame indices of a gait cycle

4. After finding the unbiased feature, we use PCA (using 5 principal components) and LDA to find the best projected feature space. From our experimental analysis, we found that the performance of prediction with or without the dimensionality reduction was almost similar.

5.  Experimental Analysis : We trained our data with five machine learning algorithms, namely- 1. K-nearest neighbor(kNN), 2. Support Vector machines (SVM) , 3. Multinomial Logistic Regression, 4. Linear Discriminant Analysis (LDA), and 5. Generalized Linear Regression (GLR) separately, to see the results of classification for each one of them individually. Following is a tabulation of the error rates for each model. 
We get the least error and correct prediction when r=15, with kNN. We got the minimum classification error of 53% and best accuracy of 50% with the former.

6. Graphical Representation: In this graph, we have 9 subjects and 25 videos, and we plot a multivariate parallel coordinates graph for them. With sufficient data, we would get a graph similar to the one on the right, with the videos of the same person represented as a single-color band.

Folder wise info:
Final Working Codes : It follows a sequence of using Blob Analysis to computing the Bounding Boxes, to using it to compute Gait signature for an individual. Finally, the main program uses it to train and train data and models.m uses this data, and tests it against different models, and checks for class error in each.
	


REFERENCES:

ϖ	A Gait Classification System using Optical Flow Features  by Chih-Chang Yu and Kuo-Chin Fan
ϖ	 GitHub repository link : https://github.com/akankshaD/GaitAsABioMetric
ϖ	 Dataset link : https://drive.google.com/drive/folders/0B1vDbt13Vaf1SDExX3NDYm1OZVU
 


