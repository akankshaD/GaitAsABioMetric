import cv2
import numpy as np
from matplotlib import pyplot as plt

##############################################################################################################################
def createGaitSignature(videoPath, textFilePath):
    ### This function returns the Average Flow Histogram as gait features
    ### with respect to every input video/person.

    cap = cv2.VideoCapture(videoPath)
    ret, frame1 = cap.read()          ### Reading first frame
    prvs = cv2.cvtColor(frame1,cv2.COLOR_BGR2GRAY)    ### Converting the first frame into grayscale

    ### Reading the bounding box dimensions from the text file

    ### Filename for the text file containing bounding box dimensions for the video.
    ### Example: "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox.txt"
    filename= textFilePath   

    ### Retrieving the bounding box dimensions from the text file.
    allNumbers= []

    with open(filename, "r") as file:
        data = file.readlines()
        for line in data:
            numbers = line.split(",")
            allNumbers.append(numbers)
            #print(numbers)

    #print(allNumbers)
    bBoxDimensions = []
    for _ in range(len(allNumbers)):
        for numList in allNumbers:
            bBoxDimensions.append([item.strip() for item in numList])

    #print(bBoxDimensions)

    ### Flow Histogram data structure for storing normalized flow histogram of all frames.
    FH =[]

    i=0

    while(1):
        ret, frame2 = cap.read()
        ### Reading the next frame the video and return True if found
        if ret == True:
            next = cv2.cvtColor(frame2,cv2.COLOR_BGR2GRAY)
            # Calculating the optical flow 
            flow = cv2.calcOpticalFlowFarneback(prvs,next, None, 0.5, 1, 15, 3, 5, 1.1, 0)

            numList =[]
            numList = list(map(int, bBoxDimensions[i]))
            left = numList[0]
            right = numList[1]
            top= numList[2]
            bot = numList[3]

            ### Filtering out the u and v vectors of optical flow from the frame    
            u = flow[ top:bot, left:right, 0]
            #print(u)
            v = flow[ top:bot, left:right, 1]
            #print(v)
            #print(u.shape)

            # print(flow.shape)
            ### Converting (u,v) to polar coordinates
            mag, ang = cv2.cartToPolar(u, v)
            #print(mag)
            #print(ang)

            ### Computing the bivariate histogram with 15 bins for r and 360 bins for theta
            flowHist, x, y = np.histogram2d(mag.flatten(), ang.flatten(), bins =(15, 360), normed =True)
            #print(flowHist.shape)
            #print(flowHist)

            ### Normalize the flow histogram
            normHist = flowHist/np.sum(flowHist)

            #print(normHist.shape)
            #print(normHist)

            ### Storing the normalized histograms of all frames
            FH.append(normHist)
           
            prvs = next
            print(i)
            i = i+1
        else:
            break
    cap.release()

    ### Calculating Frobenius Norm
    froNorm =[]
    for array in FH:
        froNorm.append(np.linalg.norm(array, ord ='fro'))

    #print(froNorm)

    ### Finding the reference frame (middle frame used)
    mid =round(len(froNorm)/2)
    refFroNorm = froNorm[round(len(froNorm)/2)]
    #print(refFroNorm)

    ### Calculating the similarity function of flow histograms by calculating the absolute difference of Frobenius Norms
    diffFroNorm = abs(froNorm - refFroNorm)
    #print(diffFroNorm)

    ### Computing first minimum index for gait cycle 
    total_rows = i-1    ### Total frames in the video
    j=0
    diff1 = diffFroNorm[0]
    firstMin =0
    while j < total_rows:
        if (diffFroNorm[j] < diff1) & (j != mid):
            diff1 = diffFroNorm[j]
            firstMin = j
        j = j+1

    #print(firstMin)
    #print(diff1)

    ### Computing the second minimum for gait cycle
    j=0
    diff2 = diffFroNorm[0]
    secondMin =0
    while j < total_rows:
        if (diffFroNorm[j] < diff2) & (j != mid) & (diffFroNorm[j] != diff1):
            diff2 = diffFroNorm[j]
            secondMin = j
        j = j+1

    #print(secondMin)
    #print(diff2)

    ### Computing the indices of the gait cycle
    var = firstMin > secondMin
    in1 =0
    in2 =0
    if var:
        in1 = secondMin
        in2 = firstMin
    else:
        in1 = firstMin
        in2 = secondMin

    #print(in1)
    #print(in2)

    ### Computing the Average Flow Histograms by computing the sum of frames in gait cycle
    AFH = FH[in1]
    for i in range(in1 + 1, in2 +1):
        AFH = AFH + FH[i]


    ### Final Average Flow Histogram with respect to every person
    AFH = AFH/(in2-in1);

    #print(AFH)
    #print(AFH.shape)

    cv2.destroyAllWindows()

    return AFH


################################################################################################################
### Main Function:
if __name__ == "__main__":

    ### Extracting GAIT FEATURES
    ### For Test Video 1: Subject 1
    videoPath1 = "/home/akanksha/Desktop/MPPE/videos/test1.mp4"
    textFilePath1 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox1.txt"
    AFH1 = createGaitSignature(videoPath1, textFilePath1)

    print("AFH1 extracted successfully!!")

    ### For Test Video 3: Subject 2
    videoPath2 = "/home/akanksha/Desktop/MPPE/videos/test3.mp4"
    textFilePath2 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox3.txt"
    AFH2 = createGaitSignature(videoPath2, textFilePath2)

    print("AFH2 extracted successfully!!")

    ### For Test Video 5: Subject 3
    videoPath3 = "/home/akanksha/Desktop/MPPE/videos/test5.mp4"
    textFilePath3 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox5.txt"
    AFH3 = createGaitSignature(videoPath3, textFilePath3)

    print("AFH3 extracted successfully!!")

    ### For Test Video 8: Subject 4
    videoPath4 = "/home/akanksha/Desktop/MPPE/videos/test8.mp4"
    textFilePath4 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox8.txt"
    AFH4 = createGaitSignature(videoPath4, textFilePath4)

    print("AFH4 extracted successfully!!")

    ### For Test Video 10: Subject 5
    videoPath5 = "/home/akanksha/Desktop/MPPE/videos/test10.mp4"
    textFilePath5 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox10.txt"
    AFH5 = createGaitSignature(videoPath5, textFilePath5)

    print("AFH5 extracted successfully!!")

    ### For Test Video 12: Subject 6
    videoPath6 = "/home/akanksha/Desktop/MPPE/videos/test12.mp4"
    textFilePath6 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox12.txt"
    AFH6 = createGaitSignature(videoPath6, textFilePath6)

    print("AFH6 extracted successfully!!")

    ### For Test Video 17: Subject 7
    videoPath7 = "/home/akanksha/Desktop/MPPE/videos/test17.mp4"
    textFilePath7 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox17.txt"
    AFH7 = createGaitSignature(videoPath7, textFilePath7)

    print("AFH7 extracted successfully!!")

    ### For Test Video 21: Subject 9
    videoPath8 = "/home/akanksha/Desktop/MPPE/videos/test21.mp4"
    textFilePath8 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox21.txt"
    AFH8 = createGaitSignature(videoPath8, textFilePath8)

    print("AFH8 extracted successfully!!")

    ### For Test Video 25: Subject Ayush
    videoPath9 = "/home/akanksha/Desktop/MPPE/videos/test25_cutted.mp4"
    textFilePath9 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox25.txt"
    AFH9 = createGaitSignature(videoPath9, textFilePath9)

    print("AFH9 extracted successfully!!")

    ### For Test Video 26: Subject Taarini
    videoPath10 = "/home/akanksha/Desktop/MPPE/videos/test26.MOV"
    textFilePath10 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox26.txt"
    AFH10 = createGaitSignature(videoPath10, textFilePath10)

    print("AFH10 extracted successfully!!")

    ### For Test Video 27: Subject Akanksha
    videoPath11 = "/home/akanksha/Desktop/MPPE/videos/test27_cutted.mp4"
    textFilePath11 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox27.txt"
    AFH11 = createGaitSignature(videoPath11, textFilePath11)

    print("AFH11 extracted successfully!!")

    ### For Test Video 28: Subject Ankit
    videoPath12 = "/home/akanksha/Desktop/MPPE/videos/test28_cutted.mp4"
    textFilePath12 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox28.txt"
    AFH12 = createGaitSignature(videoPath12, textFilePath12)

    print("AFH12 extracted successfully!!")

    ### For Test Video 30: Subject Ayush
    videoPath13 = "/home/akanksha/Desktop/MPPE/videos/test30_cutted.mp4"
    textFilePath13 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox30.txt"
    AFH13 = createGaitSignature(videoPath13, textFilePath13)

    print("AFH13 extracted successfully!!")

    ### For Test Video 31: Subject Akanksha
    videoPath14 = "/home/akanksha/Desktop/MPPE/videos/test31_cutted.mp4"
    textFilePath14 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox31.txt"
    AFH14 = createGaitSignature(videoPath14, textFilePath14)

    print("AFH14 extracted successfully!!")

    ### For Test Video 32: Subject Taarini
    videoPath15 = "/home/akanksha/Desktop/MPPE/videos/test32_cutted.mp4"
    textFilePath15 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox32.txt"
    AFH15 = createGaitSignature(videoPath15, textFilePath15)

    print("AFH15 extracted successfully!!")

    ### For Test Video 33: Subject Ankit
    videoPath16 = "/home/akanksha/Desktop/MPPE/videos/test33_cutted.mp4"
    textFilePath16 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox33.txt"
    AFH16 = createGaitSignature(videoPath16, textFilePath16)

    print("AFH16 extracted successfully!!")

    ### For Test Video 34: Subject Taarini
    videoPath17 = "/home/akanksha/Desktop/MPPE/videos/test34.MOV"
    textFilePath17 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox34.txt"
    AFH17 = createGaitSignature(videoPath17, textFilePath17)

    print("AFH17 extracted successfully!!")

    ### For Test Video 35: Subject Taarini
    videoPath18 = "/home/akanksha/Desktop/MPPE/videos/test35.MOV"
    textFilePath18 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox35.txt"
    AFH18 = createGaitSignature(videoPath18, textFilePath18)

    print("AFH18 extracted successfully!!")

    ### For Test Video 36: Subject Taarini
    videoPath19 = "/home/akanksha/Desktop/MPPE/videos/test36.MOV"
    textFilePath19 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox36.txt"
    AFH19 = createGaitSignature(videoPath19, textFilePath19)

    print("AFH19 extracted successfully!!")

    ### For Test Video 37: Subject Ayush
    videoPath20 = "/home/akanksha/Desktop/MPPE/videos/test37_cutted.mp4"
    textFilePath20 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox37.txt"
    AFH20 = createGaitSignature(videoPath20, textFilePath20)

    print("AFH20 extracted successfully!!")

    ### For Test Video 38: Subject Ayush
    videoPath21 = "/home/akanksha/Desktop/MPPE/videos/test38_cutted.mp4"
    textFilePath21 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox38.txt"
    AFH21 = createGaitSignature(videoPath21, textFilePath21)

    print("AFH21 extracted successfully!!")

    ### For Test Video 39: Subject Ankit
    videoPath22 = "/home/akanksha/Desktop/MPPE/videos/test39_cutted.mp4"
    textFilePath22 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox39.txt"
    AFH22 = createGaitSignature(videoPath22, textFilePath22)

    print("AFH22 extracted successfully!!")

    ### For Test Video 40: Subject Ankit
    videoPath23 = "/home/akanksha/Desktop/MPPE/videos/test40_cutted.mp4"
    textFilePath23 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox40.txt"
    AFH23 = createGaitSignature(videoPath23, textFilePath23)

    print("AFH23 extracted successfully!!")

    ### For Test Video 41: Subject Akanksha
    videoPath24 = "/home/akanksha/Desktop/MPPE/videos/test41_cutted.mp4"
    textFilePath24 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox41.txt"
    AFH24 = createGaitSignature(videoPath24, textFilePath24)

    print("AFH24 extracted successfully!!")

    ### For Test Video 42: Subject Akanksha
    videoPath25 = "/home/akanksha/Desktop/MPPE/videos/test42_cutted.mp4"
    textFilePath25 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox42.txt"
    AFH25 = createGaitSignature(videoPath25, textFilePath25)

    print("AFH25 extracted successfully!!")

    ### LABELS:
    labels = np.array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 9, 11, 10, 12, 10, 10, 10, 9, 9, 12, 12, 11, 11])

    ### Writing the features to a file:
    np.savez('features', AFH1, AFH2, AFH3, AFH4, AFH5, AFH6, AFH7, AFH8, AFH9, AFH10, AFH11, AFH12, AFH13, AFH14, AFH15, AFH16, AFH17, AFH18, AFH19, AFH20, AFH21, AFH22, AFH23, AFH24, AFH25, labels)