#!/bin/bash

#This function is written to augment the voxel size by a certain number
#You have to provide the name of the file then the factor you would like to multiply your 
#voxels by
#and then the tr in seconds
#>>> Augment Anat.nii.gz 10 2
#the script retrieves the dimesnions of the image and multiply them by the specified factor
#finally it will apply fslchpixdim
#then fslorient -setsformcode 1





SizeX=`fslval $1 pixdim1`
SizeY=`fslval $1 pixdim2`
SizeZ=`fslval $1 pixdim3`

TR=$3

Aug_SizeX=`echo "$SizeX * $2"|bc -l`
Aug_SizeY=`echo "$SizeY * $2"|bc -l`
Aug_SizeZ=`echo "$SizeZ * $2"|bc -l`

fslchpixdim $1 ${Aug_SizeX} ${Aug_SizeY} ${Aug_SizeZ} $TR 

fslorient -setsformcode 1 $1