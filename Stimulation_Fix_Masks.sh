#!/bin/bash
#This script to adjust the sform and qform matrix of the manually drawn masks for the stimulation data


cd /media/amr/HDD/Work/Stimulation/Data

for folder in *;do
	cd $folder

	pwd

	fslorient -deleteorient    Anat_${folder}_Mask
	fslorient -setsformcode 1  Anat_${folder}_Mask

	#Remove the skull from anatomicla images ty multiplying with mask
	fslmaths Anat_${folder} -mas Anat_${folder}_Mask Anat_${folder}_bet

	fslorient -deleteorient    EPI_${folder}_Mask
	fslorient -setsformcode 1  EPI_${folder}_Mask

	cd ..
done

#After this you have to name the runs to 10, 20, 40 Hz manually	