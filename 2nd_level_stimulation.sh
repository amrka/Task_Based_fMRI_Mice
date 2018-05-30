#!/bin/bash
#this script to perform 2nd level statsisitcs (between sessions) on preprocessed 1st level
#each of the three frequencies has a folder with copes, varcopes and tdofs
#the design is already done using the user interface

Anat_Mask='/media/amr/HDD/Work/October_Acquistion/Anat_Template_Mask.nii.gz'
Anat_Template='/media/amr/HDD/Work/October_Acquistion/Anat_Template.nii.gz'

#The copes here for each subject are in the anatomical space rather than in the template space
#the subjects are as follow
# 1  -> 008
# 2  -> 011
# 3  -> 059
# 4  -> 060
# 5  -> 062
# 6  -> 063
# 7  -> 066
# 8  -> 003
# 9  -> 005
# 10 -> 018
# 11 -> 019
# 12 -> 020

#These two variables just to shorten the script line that invokes the anatomical image of each subject
Anat_Handle='/media/amr/HDD/Work/Stimulation/Registration_Stimulation_WorkingDir/Registration_Stimulation/'
Bias_Handle=/media/amr/HDD/Work/Stimulation/Registration_Stimulation_WorkingDir/Registration_Stimulation/_subject_id_003/BiasFieldCorrection
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
for zstat in zstat*.nii.gz;do
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


done



for zfstat in zfstat*.nii.gz;do
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

done
#1
overlay 1 0 ${Anat_Handle}/_subject_id_008/BiasFieldCorrection/*.nii.gz -a thresh_zfstat1.nii.gz 2.3 6 rendered_thresh_zfstat_1_008
slicer rendered_thresh_zfstat_1_008 -S 2 750 rendered_thresh_zfstat_1_008.png

#2
overlay 1 0 ${Anat_Handle}/_subject_id_011/BiasFieldCorrection/*.nii.gz -a thresh_zfstat2.nii.gz 2.3 6 rendered_thresh_zfstat_2_011
slicer rendered_thresh_zfstat_2_011 -S 2 750 rendered_thresh_zfstat_2_011.png

#3
overlay 1 0 ${Anat_Handle}/_subject_id_059/BiasFieldCorrection/*.nii.gz -a thresh_zfstat3.nii.gz 2.3 6 rendered_thresh_zfstat_3_059
slicer rendered_thresh_zfstat_3_059 -S 2 750 rendered_thresh_zfstat_3_059.png

#4
overlay 1 0 ${Anat_Handle}/_subject_id_060/BiasFieldCorrection/*.nii.gz -a thresh_zfstat4.nii.gz 2.3 6 rendered_thresh_zfstat_4_060
slicer rendered_thresh_zfstat_4_060 -S 2 750 rendered_thresh_zfstat_4_060.png

#5
overlay 1 0 ${Anat_Handle}/_subject_id_062/BiasFieldCorrection/*.nii.gz -a thresh_zfstat5.nii.gz 2.3 6 rendered_thresh_zfstat_5_062
slicer rendered_thresh_zfstat_5_062 -S 2 750 rendered_thresh_zfstat_5_062.png

#6
overlay 1 0 ${Anat_Handle}/_subject_id_063/BiasFieldCorrection/*.nii.gz -a thresh_zfstat6.nii.gz 2.3 6 rendered_thresh_zfstat_6_063
slicer rendered_thresh_zfstat_6_063 -S 2 750 rendered_thresh_zfstat_6_063.png

#7
overlay 1 0 ${Anat_Handle}/_subject_id_066/BiasFieldCorrection/*.nii.gz -a thresh_zfstat7.nii.gz 2.3 6 rendered_thresh_zfstat_7_066
slicer rendered_thresh_zfstat_7_066 -S 2 750 rendered_thresh_zfstat_7_066.png

#8
overlay 1 0 ${Anat_Handle}/_subject_id_003/BiasFieldCorrection/*.nii.gz -a thresh_zfstat8.nii.gz 2.3 6 rendered_thresh_zfstat_8_003
slicer rendered_thresh_zfstat_8_003 -S 2 750 rendered_thresh_zfstat_8_003.png

#9
overlay 1 0 ${Anat_Handle}/_subject_id_005/BiasFieldCorrection/*.nii.gz -a thresh_zfstat9.nii.gz 2.3 6 rendered_thresh_zfstat_9_005
slicer rendered_thresh_zfstat_9_005 -S 2 750 rendered_thresh_zfstat_9_005.png

#10
overlay 1 0 ${Anat_Handle}/_subject_id_018/BiasFieldCorrection/*.nii.gz -a thresh_zfstat10.nii.gz 2.3 6 rendered_thresh_zfstat_10_018
slicer rendered_thresh_zfstat_10_018 -S 2 750 rendered_thresh_zfstat_10_018.png

#11
overlay 1 0 ${Anat_Handle}/_subject_id_019/BiasFieldCorrection/*.nii.gz -a thresh_zfstat11.nii.gz 2.3 6 rendered_thresh_zfstat_11_019
slicer rendered_thresh_zfstat_11_019 -S 2 750 rendered_thresh_zfstat_11_019.png

#12
overlay 1 0 ${Anat_Handle}/_subject_id_020/BiasFieldCorrection/*.nii.gz -a thresh_zfstat12.nii.gz 2.3 6 rendered_thresh_zfstat_12_020
slicer rendered_thresh_zfstat_12_020 -S 2 750 rendered_thresh_zfstat_12_020.png


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
for zstat in zstat*.nii.gz;do
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


done



for zfstat in zfstat*.nii.gz;do
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

done
#1
overlay 1 0 ${Anat_Handle}/_subject_id_008/BiasFieldCorrection/*.nii.gz -a thresh_zfstat1.nii.gz 2.3 6 rendered_thresh_zfstat_1_008
slicer rendered_thresh_zfstat_1_008 -S 2 750 rendered_thresh_zfstat_1_008.png

#2
overlay 1 0 ${Anat_Handle}/_subject_id_011/BiasFieldCorrection/*.nii.gz -a thresh_zfstat2.nii.gz 2.3 6 rendered_thresh_zfstat_2_011
slicer rendered_thresh_zfstat_2_011 -S 2 750 rendered_thresh_zfstat_2_011.png

#3
overlay 1 0 ${Anat_Handle}/_subject_id_059/BiasFieldCorrection/*.nii.gz -a thresh_zfstat3.nii.gz 2.3 6 rendered_thresh_zfstat_3_059
slicer rendered_thresh_zfstat_3_059 -S 2 750 rendered_thresh_zfstat_3_059.png

#4
overlay 1 0 ${Anat_Handle}/_subject_id_060/BiasFieldCorrection/*.nii.gz -a thresh_zfstat4.nii.gz 2.3 6 rendered_thresh_zfstat_4_060
slicer rendered_thresh_zfstat_4_060 -S 2 750 rendered_thresh_zfstat_4_060.png

#5
overlay 1 0 ${Anat_Handle}/_subject_id_062/BiasFieldCorrection/*.nii.gz -a thresh_zfstat5.nii.gz 2.3 6 rendered_thresh_zfstat_5_062
slicer rendered_thresh_zfstat_5_062 -S 2 750 rendered_thresh_zfstat_5_062.png

#6
overlay 1 0 ${Anat_Handle}/_subject_id_063/BiasFieldCorrection/*.nii.gz -a thresh_zfstat6.nii.gz 2.3 6 rendered_thresh_zfstat_6_063
slicer rendered_thresh_zfstat_6_063 -S 2 750 rendered_thresh_zfstat_6_063.png

#7
overlay 1 0 ${Anat_Handle}/_subject_id_066/BiasFieldCorrection/*.nii.gz -a thresh_zfstat7.nii.gz 2.3 6 rendered_thresh_zfstat_7_066
slicer rendered_thresh_zfstat_7_066 -S 2 750 rendered_thresh_zfstat_7_066.png

#8
overlay 1 0 ${Anat_Handle}/_subject_id_003/BiasFieldCorrection/*.nii.gz -a thresh_zfstat8.nii.gz 2.3 6 rendered_thresh_zfstat_8_003
slicer rendered_thresh_zfstat_8_003 -S 2 750 rendered_thresh_zfstat_8_003.png

#9
overlay 1 0 ${Anat_Handle}/_subject_id_005/BiasFieldCorrection/*.nii.gz -a thresh_zfstat9.nii.gz 2.3 6 rendered_thresh_zfstat_9_005
slicer rendered_thresh_zfstat_9_005 -S 2 750 rendered_thresh_zfstat_9_005.png

#10
overlay 1 0 ${Anat_Handle}/_subject_id_018/BiasFieldCorrection/*.nii.gz -a thresh_zfstat10.nii.gz 2.3 6 rendered_thresh_zfstat_10_018
slicer rendered_thresh_zfstat_10_018 -S 2 750 rendered_thresh_zfstat_10_018.png

#11
overlay 1 0 ${Anat_Handle}/_subject_id_019/BiasFieldCorrection/*.nii.gz -a thresh_zfstat11.nii.gz 2.3 6 rendered_thresh_zfstat_11_019
slicer rendered_thresh_zfstat_11_019 -S 2 750 rendered_thresh_zfstat_11_019.png

#12
overlay 1 0 ${Anat_Handle}/_subject_id_020/BiasFieldCorrection/*.nii.gz -a thresh_zfstat12.nii.gz 2.3 6 rendered_thresh_zfstat_12_020
slicer rendered_thresh_zfstat_12_020 -S 2 750 rendered_thresh_zfstat_12_020.png


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
for zstat in zstat*.nii.gz;do
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


done



for zfstat in zfstat*.nii.gz;do
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

done

#1
overlay 1 0 ${Anat_Handle}/_subject_id_011/BiasFieldCorrection/*.nii.gz -a thresh_zfstat1.nii.gz 2.3 6 rendered_thresh_zfstat_1_011
slicer rendered_thresh_zfstat_1_011 -S 2 750 rendered_thresh_zfstat_1_011.png

#2
overlay 1 0 ${Anat_Handle}/_subject_id_059/BiasFieldCorrection/*.nii.gz -a thresh_zfstat2.nii.gz 2.3 6 rendered_thresh_zfstat_2_059
slicer rendered_thresh_zfstat_2_059 -S 2 750 rendered_thresh_zfstat_2_059.png

#3
overlay 1 0 ${Anat_Handle}/_subject_id_060/BiasFieldCorrection/*.nii.gz -a thresh_zfstat3.nii.gz 2.3 6 rendered_thresh_zfstat_3_060
slicer rendered_thresh_zfstat_3_060 -S 2 750 rendered_thresh_zfstat_3_060.png

#4
overlay 1 0 ${Anat_Handle}/_subject_id_062/BiasFieldCorrection/*.nii.gz -a thresh_zfstat4.nii.gz 2.3 6 rendered_thresh_zfstat_4_062
slicer rendered_thresh_zfstat_4_062 -S 2 750 rendered_thresh_zfstat_4_062.png

#5
overlay 1 0 ${Anat_Handle}/_subject_id_063/BiasFieldCorrection/*.nii.gz -a thresh_zfstat5.nii.gz 2.3 6 rendered_thresh_zfstat_5_063
slicer rendered_thresh_zfstat_5_063 -S 2 750 rendered_thresh_zfstat_5_063.png

#6
overlay 1 0 ${Anat_Handle}/_subject_id_066/BiasFieldCorrection/*.nii.gz -a thresh_zfstat6.nii.gz 2.3 6 rendered_thresh_zfstat_6_066
slicer rendered_thresh_zfstat_6_066 -S 2 750 rendered_thresh_zfstat_6_066.png

#7
overlay 1 0 ${Anat_Handle}/_subject_id_003/BiasFieldCorrection/*.nii.gz -a thresh_zfstat7.nii.gz 2.3 6 rendered_thresh_zfstat_7_003
slicer rendered_thresh_zfstat_7_003 -S 2 750 rendered_thresh_zfstat_7_003.png

#8
overlay 1 0 ${Anat_Handle}/_subject_id_005/BiasFieldCorrection/*.nii.gz -a thresh_zfstat8.nii.gz 2.3 6 rendered_thresh_zfstat_8_005
slicer rendered_thresh_zfstat_8_005 -S 2 750 rendered_thresh_zfstat_8_005.png

#9
overlay 1 0 ${Anat_Handle}/_subject_id_018/BiasFieldCorrection/*.nii.gz -a thresh_zfstat9.nii.gz 2.3 6 rendered_thresh_zfstat_9_018
slicer rendered_thresh_zfstat_9_018 -S 2 750 rendered_thresh_zfstat_9_018.png

#10
overlay 1 0 ${Anat_Handle}/_subject_id_019/BiasFieldCorrection/*.nii.gz -a thresh_zfstat10.nii.gz 2.3 6 rendered_thresh_zfstat_10_019
slicer rendered_thresh_zfstat_10_019 -S 2 750 rendered_thresh_zfstat_10_019.png

#11
overlay 1 0 ${Anat_Handle}/_subject_id_020/BiasFieldCorrection/*.nii.gz -a thresh_zfstat11.nii.gz 2.3 6 rendered_thresh_zfstat_11_020
slicer rendered_thresh_zfstat_11_020 -S 2 750 rendered_thresh_zfstat_11_020.png


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
for zstat in zstat*.nii.gz;do
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


done



for zfstat in zfstat*.nii.gz;do
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

done

#1
overlay 1 0 ${Anat_Handle}/_subject_id_059/BiasFieldCorrection/*.nii.gz -a thresh_zfstat1.nii.gz 2.3 6 rendered_thresh_zfstat_1_059
slicer rendered_thresh_zfstat_1_059 -S 2 750 rendered_thresh_zfstat_1_059.png

#2
overlay 1 0 ${Anat_Handle}/_subject_id_060/BiasFieldCorrection/*.nii.gz -a thresh_zfstat2.nii.gz 2.3 6 rendered_thresh_zfstat_2_060
slicer rendered_thresh_zfstat_2_060 -S 2 750 rendered_thresh_zfstat_2_060.png

#3
overlay 1 0 ${Anat_Handle}/_subject_id_062/BiasFieldCorrection/*.nii.gz -a thresh_zfstat3.nii.gz 2.3 6 rendered_thresh_zfstat_3_062
slicer rendered_thresh_zfstat_3_062 -S 2 750 rendered_thresh_zfstat_3_062.png

#4
overlay 1 0 ${Anat_Handle}/_subject_id_063/BiasFieldCorrection/*.nii.gz -a thresh_zfstat4.nii.gz 2.3 6 rendered_thresh_zfstat_4_063
slicer rendered_thresh_zfstat_4_063 -S 2 750 rendered_thresh_zfstat_4_063.png

#5
overlay 1 0 ${Anat_Handle}/_subject_id_066/BiasFieldCorrection/*.nii.gz -a thresh_zfstat5.nii.gz 2.3 6 rendered_thresh_zfstat_5_066
slicer rendered_thresh_zfstat_5_066 -S 2 750 rendered_thresh_zfstat_5_066.png


#6
overlay 1 0 ${Anat_Handle}/_subject_id_005/BiasFieldCorrection/*.nii.gz -a thresh_zfstat6.nii.gz 2.3 6 rendered_thresh_zfstat_6_005
slicer rendered_thresh_zfstat_6_005 -S 2 750 rendered_thresh_zfstat_6_005.png

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
for zstat in zstat*.nii.gz;do
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


done



for zfstat in zfstat*.nii.gz;do
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

done
#1
overlay 1 0 ${Anat_Handle}/_subject_id_059/BiasFieldCorrection/*.nii.gz -a thresh_zfstat1.nii.gz 2.3 6 rendered_thresh_zfstat_1_059
slicer rendered_thresh_zfstat_1_059 -S 2 750 rendered_thresh_zfstat_1_059.png

#2
overlay 1 0 ${Anat_Handle}/_subject_id_060/BiasFieldCorrection/*.nii.gz -a thresh_zfstat2.nii.gz 2.3 6 rendered_thresh_zfstat_2_060
slicer rendered_thresh_zfstat_2_060 -S 2 750 rendered_thresh_zfstat_2_060.png

#3
overlay 1 0 ${Anat_Handle}/_subject_id_062/BiasFieldCorrection/*.nii.gz -a thresh_zfstat3.nii.gz 2.3 6 rendered_thresh_zfstat_3_062
slicer rendered_thresh_zfstat_3_062 -S 2 750 rendered_thresh_zfstat_3_062.png

#4
overlay 1 0 ${Anat_Handle}/_subject_id_063/BiasFieldCorrection/*.nii.gz -a thresh_zfstat4.nii.gz 2.3 6 rendered_thresh_zfstat_4_063
slicer rendered_thresh_zfstat_4_063 -S 2 750 rendered_thresh_zfstat_4_063.png

#5
overlay 1 0 ${Anat_Handle}/_subject_id_066/BiasFieldCorrection/*.nii.gz -a thresh_zfstat5.nii.gz 2.3 6 rendered_thresh_zfstat_5_066
slicer rendered_thresh_zfstat_5_066 -S 2 750 rendered_thresh_zfstat_5_066.png


#6
overlay 1 0 ${Anat_Handle}/_subject_id_005/BiasFieldCorrection/*.nii.gz -a thresh_zfstat6.nii.gz 2.3 6 rendered_thresh_zfstat_6_005
slicer rendered_thresh_zfstat_6_005 -S 2 750 rendered_thresh_zfstat_6_005.png



cd ../..
########################################################################################################
#40Hz 10sec
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
for zstat in zstat*.nii.gz;do
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


done



for zfstat in zfstat*.nii.gz;do
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

done
#1
overlay 1 0 ${Anat_Handle}/_subject_id_059/BiasFieldCorrection/*.nii.gz -a thresh_zfstat1.nii.gz 2.3 6 rendered_thresh_zfstat_1_059
slicer rendered_thresh_zfstat_1_059 -S 2 750 rendered_thresh_zfstat_1_059.png

#2
overlay 1 0 ${Anat_Handle}/_subject_id_060/BiasFieldCorrection/*.nii.gz -a thresh_zfstat2.nii.gz 2.3 6 rendered_thresh_zfstat_2_060
slicer rendered_thresh_zfstat_2_060 -S 2 750 rendered_thresh_zfstat_2_060.png

#3
overlay 1 0 ${Anat_Handle}/_subject_id_062/BiasFieldCorrection/*.nii.gz -a thresh_zfstat3.nii.gz 2.3 6 rendered_thresh_zfstat_3_062
slicer rendered_thresh_zfstat_3_062 -S 2 750 rendered_thresh_zfstat_3_062.png

#4
overlay 1 0 ${Anat_Handle}/_subject_id_063/BiasFieldCorrection/*.nii.gz -a thresh_zfstat4.nii.gz 2.3 6 rendered_thresh_zfstat_4_063
slicer rendered_thresh_zfstat_4_063 -S 2 750 rendered_thresh_zfstat_4_063.png

#5
overlay 1 0 ${Anat_Handle}/_subject_id_066/BiasFieldCorrection/*.nii.gz -a thresh_zfstat5.nii.gz 2.3 6 rendered_thresh_zfstat_5_066
slicer rendered_thresh_zfstat_5_066 -S 2 750 rendered_thresh_zfstat_5_066.png


cd ../..