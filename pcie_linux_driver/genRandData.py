import random as rd

num_dword = 256
num_desc = 128

with open("AlexNet_data.txt", 'w') as fp:
	for i in xrange(num_dword*num_desc):
		fp.write(str(int(rd.random()*100)) + '\n')
