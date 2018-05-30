#!/bin/bash
#this script to perform 2nd level statsisitcs (between sessions) on preprocessed 1st level
#each of the three frequencies has a folder with copes, varcopes and tdofs
#the design is already done using the user interface

Anat_Mask='/media/amr/HDD/Work/October_Acquistion/Anat_Template_Mask.nii.gz'
Anat_Template='/media/amr/HDD/Work/October_Acquistion/Anat_Template.nii.gz'


cd /media/amr/HDD/Work/Stimulation/

#-------------------------------------------------------------------------------------
#10Hz 4sec
cd 10Hz_higher_level_stats


design_mat='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_10Hz_20Hz.mat' 
design_con='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_10Hz_20Hz.con'
design_grp='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_10Hz_20Hz.grp'
design_fsf='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_10Hz_20Hz.fsf'
design_fts='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_10Hz_20Hz.fts'


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
--fc=${design_fts} \
--runmode=fe

out=`smoothest -d 11 -m ${Anat_Mask} -r 2nd_level_stats/res4d`; echo $out
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
	--zthresh=2.3 \
	--othresh=thresh_${zstat} \
	--oindex=cluster_mask_${zstat} \
	--connectivity=26 \
	--mm \
	--olmax=lmax_${zstat}_std.txt \
	--scalarname=Z \
	--pthresh=0.05 \
	--dlh=$dlh \
	--volume=$vol \
	--cope=cope${no} > cluster_${zstat}_std.txt


	overlay 1 0 ${Anat_Template} -a thresh_${zstat}.nii.gz 3.100029 19.821642 rendered_thresh_$zstat

	slicer rendered_thresh_$zstat -S 2 750 rendered_thresh_$zstat.png


done



for zfstat in zfstat?.nii.gz;do
	zfstat=`remove_ext $zfstat`
	no=`echo $zfstat | sed 's/.*zfstat/''/'`
	echo $no
	cluster \
	--in=$zfstat \
	--zthresh=2.3 \
	--othresh=thresh_${zfstat} \
	--oindex=cluster_mask_${zfstat} \
	--connectivity=26 \
	--mm \
	--olmax=lmax_${zfstat}_std.txt \
	--scalarname=Z \
	--pthresh=0.05 \
	--dlh=$dlh \
	--volume=$vol \
	--cope=cope${no} > cluster_${zfstat}_std.txt


	overlay 1 0 ${Anat_Template} -a thresh_${zfstat}.nii.gz 2.3 6 rendered_thresh_$zfstat

	slicer rendered_thresh_$zfstat -S 2 750 rendered_thresh_$zfstat.png

done
cd ../..
########################################################################################################
#20Hz 4sec
cd 20Hz_higher_level_stats


design_mat='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_10Hz_20Hz.mat' 
design_con='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_10Hz_20Hz.con'
design_grp='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_10Hz_20Hz.grp'
design_fsf='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_10Hz_20Hz.fsf'
design_fts='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_10Hz_20Hz.fts'


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
--fc=${design_fts} \
--runmode=fe

out=`smoothest -d 11 -m ${Anat_Mask} -r 2nd_level_stats/res4d`; echo $out
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
	--zthresh=2.3 \
	--othresh=thresh_${zstat} \
	--oindex=cluster_mask_${zstat} \
	--connectivity=26 \
	--mm \
	--olmax=lmax_${zstat}_std.txt \
	--scalarname=Z \
	--pthresh=0.05 \
	--dlh=$dlh \
	--volume=$vol \
	--cope=cope${no} > cluster_${zstat}_std.txt


	overlay 1 0 ${Anat_Template} -a thresh_${zstat}.nii.gz 3.100029 19.821642 rendered_thresh_$zstat

	slicer rendered_thresh_$zstat -S 2 750 rendered_thresh_$zstat.png


done



for zfstat in zfstat?.nii.gz;do
	zfstat=`remove_ext $zfstat`
	no=`echo $zfstat | sed 's/.*zfstat/''/'`
	echo $no
	cluster \
	--in=$zfstat \
	--zthresh=2.3 \
	--othresh=thresh_${zfstat} \
	--oindex=cluster_mask_${zfstat} \
	--connectivity=26 \
	--mm \
	--olmax=lmax_${zfstat}_std.txt \
	--scalarname=Z \
	--pthresh=0.05 \
	--dlh=$dlh \
	--volume=$vol \
	--cope=cope${no} > cluster_${zfstat}_std.txt


	overlay 1 0 ${Anat_Template} -a thresh_${zfstat}.nii.gz 2.3 6 rendered_thresh_$zfstat

	slicer rendered_thresh_$zfstat -S 2 750 rendered_thresh_$zfstat.png

done
cd ../..

########################################################################################################
#40Hz 4sec
cd 40Hz_higher_level_stats


design_mat='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_40Hz.mat' 
design_con='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_40Hz.con'
design_grp='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_40Hz.grp'
design_fsf='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_40Hz.fsf'
design_fts='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_40Hz.fts'


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
--fc=${design_fts} \
--runmode=fe

out=`smoothest -d 10 -m ${Anat_Mask} -r 2nd_level_stats/res4d`; echo $out
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
	--zthresh=2.3 \
	--othresh=thresh_${zstat} \
	--oindex=cluster_mask_${zstat} \
	--connectivity=26 \
	--mm \
	--olmax=lmax_${zstat}_std.txt \
	--scalarname=Z \
	--pthresh=0.05 \
	--dlh=$dlh \
	--volume=$vol \
	--cope=cope${no} > cluster_${zstat}_std.txt


	overlay 1 0 ${Anat_Template} -a thresh_${zstat}.nii.gz 3.100029 19.821642 rendered_thresh_$zstat

	slicer rendered_thresh_$zstat -S 2 750 rendered_thresh_$zstat.png


done



for zfstat in zfstat?.nii.gz;do
	zfstat=`remove_ext $zfstat`
	no=`echo $zfstat | sed 's/.*zfstat/''/'`
	echo $no
	cluster \
	--in=$zfstat \
	--zthresh=2.3 \
	--othresh=thresh_${zfstat} \
	--oindex=cluster_mask_${zfstat} \
	--connectivity=26 \
	--mm \
	--olmax=lmax_${zfstat}_std.txt \
	--scalarname=Z \
	--pthresh=0.05 \
	--dlh=$dlh \
	--volume=$vol \
	--cope=cope${no} > cluster_${zfstat}_std.txt


	overlay 1 0 ${Anat_Template} -a thresh_${zfstat}.nii.gz 2.3 6 rendered_thresh_$zfstat

	slicer rendered_thresh_$zfstat -S 2 750 rendered_thresh_$zfstat.png

done
cd ../..

########################################################################################################
#10Hz 10sec
cd 10Hz_10s_higher_level_stats


design_mat='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_10Hz_10s.mat' 
design_con='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_10Hz_10s.con'
design_grp='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_10Hz_10s.grp'
design_fsf='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_10Hz_10s.fsf'
design_fts='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_10Hz_10s.fts'


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
--fc=${design_fts} \
--runmode=fe

out=`smoothest -d 5 -m ${Anat_Mask} -r 2nd_level_stats/res4d`; echo $out
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
	--zthresh=2.3 \
	--othresh=thresh_${zstat} \
	--oindex=cluster_mask_${zstat} \
	--connectivity=26 \
	--mm \
	--olmax=lmax_${zstat}_std.txt \
	--scalarname=Z \
	--pthresh=0.05 \
	--dlh=$dlh \
	--volume=$vol \
	--cope=cope${no} > cluster_${zstat}_std.txt


	overlay 1 0 ${Anat_Template} -a thresh_${zstat}.nii.gz 3.100029 19.821642 rendered_thresh_$zstat

	slicer rendered_thresh_$zstat -S 2 750 rendered_thresh_$zstat.png


done



for zfstat in zfstat?.nii.gz;do
	zfstat=`remove_ext $zfstat`
	no=`echo $zfstat | sed 's/.*zfstat/''/'`
	echo $no
	cluster \
	--in=$zfstat \
	--zthresh=2.3 \
	--othresh=thresh_${zfstat} \
	--oindex=cluster_mask_${zfstat} \
	--connectivity=26 \
	--mm \
	--olmax=lmax_${zfstat}_std.txt \
	--scalarname=Z \
	--pthresh=0.05 \
	--dlh=$dlh \
	--volume=$vol \
	--cope=cope${no} > cluster_${zfstat}_std.txt


	overlay 1 0 ${Anat_Template} -a thresh_${zfstat}.nii.gz 2.3 6 rendered_thresh_$zfstat

	slicer rendered_thresh_$zfstat -S 2 750 rendered_thresh_$zfstat.png

done
cd ../..

########################################################################################################
#20Hz 10sec
cd 20Hz_10s_higher_level_stats


design_mat='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_20Hz_10s.mat' 
design_con='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_20Hz_10s.con'
design_grp='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_20Hz_10s.grp'
design_fsf='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_20Hz_10s.fsf'
design_fts='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_20Hz_10s.fts'


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
--fc=${design_fts} \
--runmode=fe

out=`smoothest -d 5 -m ${Anat_Mask} -r 2nd_level_stats/res4d`; echo $out
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
	--zthresh=2.3 \
	--othresh=thresh_${zstat} \
	--oindex=cluster_mask_${zstat} \
	--connectivity=26 \
	--mm \
	--olmax=lmax_${zstat}_std.txt \
	--scalarname=Z \
	--pthresh=0.05 \
	--dlh=$dlh \
	--volume=$vol \
	--cope=cope${no} > cluster_${zstat}_std.txt


	overlay 1 0 ${Anat_Template} -a thresh_${zstat}.nii.gz 3.100029 19.821642 rendered_thresh_$zstat

	slicer rendered_thresh_$zstat -S 2 750 rendered_thresh_$zstat.png


done



for zfstat in zfstat?.nii.gz;do
	zfstat=`remove_ext $zfstat`
	no=`echo $zfstat | sed 's/.*zfstat/''/'`
	echo $no
	cluster \
	--in=$zfstat \
	--zthresh=2.3 \
	--othresh=thresh_${zfstat} \
	--oindex=cluster_mask_${zfstat} \
	--connectivity=26 \
	--mm \
	--olmax=lmax_${zfstat}_std.txt \
	--scalarname=Z \
	--pthresh=0.05 \
	--dlh=$dlh \
	--volume=$vol \
	--cope=cope${no} > cluster_${zfstat}_std.txt


	overlay 1 0 ${Anat_Template} -a thresh_${zfstat}.nii.gz 2.3 6 rendered_thresh_$zfstat

	slicer rendered_thresh_$zfstat -S 2 750 rendered_thresh_$zfstat.png

done

cd ../..

########################################################################################################
#20Hz 10sec
cd 40Hz_10s_higher_level_stats


design_mat='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_40Hz_10s.mat' 
design_con='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_40Hz_10s.con'
design_grp='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_40Hz_10s.grp'
design_fsf='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_40Hz_10s.fsf'
design_fts='/media/amr/HDD/Work/Stimulation/2nd_Level_Designs/design_2nd_level_40Hz_10s.fts'


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
--fc=${design_fts} \
--runmode=fe

out=`smoothest -d 4 -m ${Anat_Mask} -r 2nd_level_stats/res4d`; echo $out
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
	--zthresh=2.3 \
	--othresh=thresh_${zstat} \
	--oindex=cluster_mask_${zstat} \
	--connectivity=26 \
	--mm \
	--olmax=lmax_${zstat}_std.txt \
	--scalarname=Z \
	--pthresh=0.05 \
	--dlh=$dlh \
	--volume=$vol \
	--cope=cope${no} > cluster_${zstat}_std.txt


	overlay 1 0 ${Anat_Template} -a thresh_${zstat}.nii.gz 3.100029 19.821642 rendered_thresh_$zstat

	slicer rendered_thresh_$zstat -S 2 750 rendered_thresh_$zstat.png


done



for zfstat in zfstat?.nii.gz;do
	zfstat=`remove_ext $zfstat`
	no=`echo $zfstat | sed 's/.*zfstat/''/'`
	echo $no
	cluster \
	--in=$zfstat \
	--zthresh=2.3 \
	--othresh=thresh_${zfstat} \
	--oindex=cluster_mask_${zfstat} \
	--connectivity=26 \
	--mm \
	--olmax=lmax_${zfstat}_std.txt \
	--scalarname=Z \
	--pthresh=0.05 \
	--dlh=$dlh \
	--volume=$vol \
	--cope=cope${no} > cluster_${zfstat}_std.txt


	overlay 1 0 ${Anat_Template} -a thresh_${zfstat}.nii.gz 2.3 6 rendered_thresh_$zfstat

	slicer rendered_thresh_$zfstat -S 2 750 rendered_thresh_$zfstat.png

done

cd ../..