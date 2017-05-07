import os

### DETECTING THE BOUNDING BOX IN THE FRAMES WITH DARKNET

i = 1
os.chdir('/home/akanksha/darknet/')

for i in range(1, 105):
	path = '/home/akanksha/Desktop/MPPE/videos/test33/image' + str(i)+'.png';
	print(path)
	os.system('./darknet detect cfg/yolo.cfg yolo.weights ' + path)
	print("Done For Image "+ str(i))
	i = i+1