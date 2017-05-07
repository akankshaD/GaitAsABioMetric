import cv2
import numpy as np

def createGaitSignature(videoPath, textFilePath):
    ### This function returns the Average Flow Histogram as gait features
    ### with respect to every input video/person.

    cap = cv2.VideoCapture(videoPath)
    ret, frame1 = cap.read()          ### Reading first frame
    prvs = cv2.cvtColor(frame1,cv2.COLOR_BGR2GRAY)    ### Converting the first frame into grayscale
    print("Inside function")

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
            print(i)
            next = cv2.cvtColor(frame2,cv2.COLOR_BGR2GRAY)
            # Calculating the optical flow 
            flow = cv2.calcOpticalFlowFarneback(prvs,next, None, 0.5, 1, 15, 3, 5, 1.1, 0)
            print(flow.shape)
            print("Inside Loop")

            numList =[]
            numList = list(map(int, bBoxDimensions[i]))
            left = numList[0]
            right = numList[1]
            top= numList[2]
            bot = numList[3]
            print(left)
            print(right)
            print(bot)
            print(top)

            ### Filtering out the u and v vectors of optical flow from the frame    
            u = flow[left:right, top:bot, 0]
            print(flow[left:right, top:bot, 0])
            print(u)
            v = flow[left:right, top:bot, 1]
            print(v)
            #print(u.shape)

            # print(flow.shape)
            ### Converting (u,v) to polar coordinates
            mag, ang = cv2.cartToPolar(u, v)
            print(mag)
            print(ang)

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
            
            i = i+1
        else:
            break

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
    print(diffFroNorm)

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

    print(firstMin)
    print(diff1)

    ### Computing the second minimum for gait cycle
    j=0
    diff2 = diffFroNorm[0]
    secondMin =0
    while j < total_rows:
        if (diffFroNorm[j] < diff2) & (j != mid) & (diffFroNorm[j] != diff1):
            diff2 = diffFroNorm[j]
            secondMin = j
        j = j+1

    print(secondMin)
    print(diff2)

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


    AFH = AFH/(in2-in1);

    print(AFH)
    print(AFH.shape)

if __name__ == "__main__":
     ### For Test Video 34: Subject Taarini
    videoPath17 = "/home/akanksha/Desktop/MPPE/videos/test34.MOV"
    textFilePath17 = "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox34.txt"
    AFH17 = createGaitSignature(videoPath17, textFilePath17)

    print("AFH17 extracted successfully!!")


    cap.release()
    cv2.destroyAllWindows()