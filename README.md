# GaitAsABioMetric
MP Project Elective I
Human Identification involves biometric features such as fingerprints/palm-prints, face, signatures etc. but the problem with these features is that they require specific devices to capture these features.

Here is where gait classification is beneficial because it requires just a single camera and is an effective and non-intrusive way of recognizing different subjects.

This project seeks out to verify if every human being has, in fact a unique gait signature. Following steps are followed in order to verify our claim:

1.The system first converts the input color images to gray level images.

2.We employ optical flow algorithm on the image sequence to get the flow field and employ the Gaussian Model (GM) on the flow field to find the location of the foreground object.

3.Now, we construct flow histogram for each frame based on the polar component of flows inside the bounding box. Since, the number of frames differ for each video,we calculate a discerning feature called Gait Cycle for each subject which is unbiased/

4.After finding the unbiased feature, we use PCA and LDA to find the best projected feature space. 

5.Finally, we use different machine learning models for best recognition results.





