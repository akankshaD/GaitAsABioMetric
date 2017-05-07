import cv2 
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as patches


### Reading the bounding box dimensions from the text file

filename= "/home/akanksha/Desktop/MPPE/WorkingCode/PythonCode/Results/boundingBox.txt"

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

### 

for List in bBoxDimensions:
	numList =[]
	numList = list(map(int, bBoxDimensions[0]))
	print(numList)
	left = numList[0]
	right = map(int, numList[1])
	top= map(int, numList[2])
	bot = map(int, numList[3])

#print(left)



img = cv2.imread('/home/akanksha/Desktop/MPPE/videos/test1/image70.png')

fig,ax = plt.subplots(1)

# Display the image
ax.imshow(img)

# Create a Rectangle patch
rect = patches.Rectangle((left,top),(right-left),(bot-top),linewidth=1,edgecolor='r',facecolor='none')

# Add the patch to the Axes
ax.add_patch(rect)

plt.show()

#u = flow[left:right, top:bot, 0]
#v = flow[left:right, top:bot, 1]



##### Wrting in a file:
X = np.array([[1, 1, 8], [2, 1, 9], [3, 2, 19], [-1, -1, 2], [-2, -1, 4], [-3, -2, 5]])
X_ = np.array([[1, 2, 8], [2, 3, 9], [3, 4, 19], [-1, 5, 2], [-2, 6, 4], [-3, 7, 5]])
y = np.array([3, 1, 1, 3, 2, 2])

#np.savetxt('temp.txt', XX, fmt='%f')
np.savez('temp.txt', X, X_, y)

npzfile = np.load('temp.txt.npz')
X = npzfile['arr_0']
X_ = npzfile['arr_1']
y = npzfile['arr_2']

x1 = X.flatten()
x2 = X_.flatten()
print(x1.shape)
print(x2)
XX = np.concatenate((x1, x2), axis =0)
print(XX)