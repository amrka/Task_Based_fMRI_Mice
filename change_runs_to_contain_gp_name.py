#This script to change images' name to include the group name instead of doing it manually, 
#You have to pass the folder name from the bash script<<<<<<<<<<<<<<<<<<<
#The image's name format is :
#4s  -> 40Hz_run001_003_cope1.nii.gz
#OR
#10s -> 10Hz_10s_run001_005_cope1.nii.gz
#You can modify the indexing


import os
import re
import sys
dir = sys.argv[1]
os.chdir (dir)
for image in os.listdir(dir):
    A = ['008','011','059','060','062','063','066']
    B = ['018','019','020','003','005','13x']
    print (image)

    if image[5:8] == '10s':
        number = image[16:19]
        run = image[12:15]
        print (number)
        print (run)
        if number in A:
             os.rename(image, 'A_%s_%s' % (number,image))
            
        elif number in B:
             os.rename(image, 'B_%s_%s' % (number,image))


    elif image[5:8] != '10s':   
        number = image[12:15]
        run = image[8:11]
        print (number)
        print (run)
        if number in A:
             os.rename(image, 'A_%s_%s' % (number,image))
            
        elif number in B:
             os.rename(image, 'B_%s_%s' % (number,image))
     
