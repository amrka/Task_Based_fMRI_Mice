#!/bin/bash
#this script to perform 2nd level statsisitcs (between sessions) on preprocessed 1st level
#each of the three frequencies has a folder with copes, varcopes and tdofs
#the design is already done using the user interface

Anat_Mask='/media/amr/HDD/Work/October_Acquistion/Anat_Template_Mask.nii.gz'
Anat_Template='/media/amr/HDD/Work/October_Acquistion/Anat_Template.nii.gz'

design_mat='/media/amr/HDD/Work/Stimulation/design_2nd_level.mat' 
design_con='/media/amr/HDD/Work/Stimulation/design_2nd_level.con'
design_grp='/media/amr/HDD/Work/Stimulation/design_2nd_level.grp'
design_fsf='/media/amr/HDD/Work/Stimulation/design_2nd_level.fsf'

cd /media/amr/HDD/Work/Stimulation/

#-------------------------------------------------------------------------------------
cd 10Hz_higher_level_stats

fslmerge -t copes    copes/*.nii.gz 
fslmerge -t varcopes varcopes/*.nii.gz
fslmerge -t tdofs    tdof/*.nii.gz

flameo \
--cope=copes \
--vc=varcopes \
--dvc=tdofs \
--mask=${Anat_Mask} \
--ld=2nd_level_stats \
--dm=${design_mat} \
--cs=${design_grp} \
--tc=${design_con}  \
--runmode=fe

out=`smoothest -d 8 -m ${Anat_Mask} -r 20Hz_higher_level_stats/res4d`; echo $out
dlh=`echo $out | sed 's/DLH /''/' | sed 's/ V.*/''/'`; echo DHL:$dlh
vol=`echo $out | sed 's/D.*VOLUME /''/' | sed 's/ R.*/''/'`; echo VOLUME:$vol
resl=`echo $out | sed 's/.*RESELS /''/'`;  echo RESELS:$resl

cd 2nd_level_stats
for zstat in zstat?.nii.gz;do
	zstat=`remove_ext $zstat`
	no=`echo $zstat | sed 's/.*zstat/''/'`
	echo $no
	cluster \
	--in=$zstat \
	--zthresh=3.1 \
	--othresh=thresh_${zstat} \
	--oindex=cluster_mask_${zstat} \
	--connectivity=26 \
	--mm \
	--olmax=lmax_${zstat}_std.txt \
	--scalarname=Z \
	--pthresh=0.001 \
	--dlh=$dlh \
	--volume=$vol \
	--cope=cope${no} > cluster_${zstat}_std.txt


	overlay 1 0 ${Anat_Template} -a thresh_${zstat}.nii.gz 3.100029 19.821642 rendered_thresh_$zstat

	slicer rendered_thresh_$zstat -S 2 750 rendered_thresh_$zstat.png
done







