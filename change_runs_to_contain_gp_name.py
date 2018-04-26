#This script to change images' name to include the group name instead of doing it manually, 
#You have to pass the folder name from the bash script
#The image's name format is 40Hz_run001_003_cope1.nii.gz
#You can modify the indexing


import os
import re
import sys
dir = sys.argv[1]
os.chdir (dir)
for image in os.listdir(dir):
    A = ['008','011']
    B = ['018','019','020','003','005','13x']
    print image
    number = image[12:15]
    run = image[8:11]
    print number
    print run
    if number in A:
         os.rename(image, 'A_%s_%s' % (run,image))
        
    elif number in B:
         os.rename(image, 'B_%s_%s' % (run,image))
        