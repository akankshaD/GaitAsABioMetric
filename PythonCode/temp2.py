import cv2
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as patches

allNumbers= []
i=0

with open("/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox42.txt", "r") as file:
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

frame1 = cv2.imread("/home/akanksha/Desktop/MPPE/videos/test42/image1.png")
prvs = cv2.cvtColor(frame1,cv2.COLOR_BGR2GRAY)

frame2 = cv2.imread("/home/akanksha/Desktop/MPPE/videos/test42/image2.png")
next = cv2.cvtColor(frame2, cv2.COLOR_BGR2GRAY)

flow = cv2.calcOpticalFlowFarneback(prvs,next, None, 0.5, 1, 15, 3, 5, 1.1, 0)
print(flow)
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

img = cv2.imread('/home/akanksha/Desktop/MPPE/videos/test42/image1.png')
print(img.shape)

fig,ax = plt.subplots(1)

# Display the image
ax.imshow(img)

# Create a Rectangle patch
rect = patches.Rectangle((left,top),(right-left),(bot-top),linewidth=1,edgecolor='r',facecolor='none')

# Add the patch to the Axes
ax.add_patch(rect)

plt.show()

### Filtering out the u and v vectors of optical flow from the frame    
u = flow[top:bot, left:right, 0]
print(u)
v = flow[top:bot, left:right, 1]
print(v)
#print(u.shape)
# print(flow.shape)
### Converting (u,v) to polar coordinates
mag, ang = cv2.cartToPolar(u, v)
print(mag)
print(ang)

### Computing the bivariate histogram with 15 bins for r and 360 bins for theta
flowHist, x, y = np.histogram2d(mag.flatten(), ang.flatten(), bins =(15, 360), normed =True)