#!/bin/bash
#After prerforming the 1st level analysis on your subjects using Simulation_??Hz_Nipype.py, 
#You need to trasnfer the following files to start the 2nd level analysis:
# copes
# varcopes
# FeTdof_t1
#all in study_template space and masked

#make the following tree for each frequency manually, you lazy fuck
#Nah...
# 10Hz_higher_level_stats/
# ├── copes
# ├── dof
# └── varcopes

# 10Hz
cd /media/amr/HDD/Work/Stimulation/

cd 10Hz_Task_Based_WorkingDir/preproc_task/

mkdir /media/amr/HDD/Work/Stimulation/10Hz_higher_level_stats/

mkdir /media/amr/HDD/Work/Stimulation/10Hz_higher_level_stats/copes
mkdir /media/amr/HDD/Work/Stimulation/10Hz_higher_level_stats/varcopes
mkdir /media/amr/HDD/Work/Stimulation/10Hz_higher_level_stats/tdof
for folder in _session*;do
	echo $folder
	cd $folder

	pwd
	#get the name of the run as run00? (e.g run001)
	id_run=`echo "$folder" | sed 's/_session_id_/''/' | sed 's/_subject_id_.*/''/'`;
	#get the name of the subject as ??? (e.g 003)
	id_sub=`echo "$folder" | sed 's/_session_id_run00[0-9]/''/' | sed 's/_subject_id_/''/'`;
	#get the frequency variable from the folder name to be sure what belongs to what
	freq=`echo $PWD | sed 's/\/media\/amr\/HDD\/Work\/Stimulation\//''/' | sed 's/_Task_Based_WorkingDir\/preproc_task\/_session_id_'${id_run}'_subject_id_'${id_sub}'/''/'`


	echo ${id_run}; echo ${id_sub}; echo $freq
	#copy cope1 to cope1 folder
	imcp Apply_Transformations_cope1/cope1_trans.nii.gz \
	/media/amr/HDD/Work/Stimulation/10Hz_higher_level_stats/copes/${freq}_${id_run}_${id_sub}_cope1.nii.gz
	#copy varcope1 to varcope folder
	imcp Apply_Transformations_varcope1/varcope1_trans.nii.gz \
	/media/amr/HDD/Work/Stimulation/10Hz_higher_level_stats/varcopes/${freq}_${id_run}_${id_sub}_varcope1.nii.gz
	#copy FEtdof to  FEtdof folder
	imcp Mask_FEtdof/FEtdof_t1_trans_masked.nii.gz \
	/media/amr/HDD/Work/Stimulation/10Hz_higher_level_stats/tdof/${freq}_${id_run}_${id_sub}_tdof1.nii.gz

	cd ..
done



#######################################################################################
# 20 Hz

cd /media/amr/HDD/Work/Stimulation/

cd 20Hz_Task_Based_WorkingDir/preproc_task/

mkdir /media/amr/HDD/Work/Stimulation/20Hz_higher_level_stats/

mkdir /media/amr/HDD/Work/Stimulation/20Hz_higher_level_stats/copes
mkdir /media/amr/HDD/Work/Stimulation/20Hz_higher_level_stats/varcopes
mkdir /media/amr/HDD/Work/Stimulation/20Hz_higher_level_stats/tdof
for folder in _session*;do
	echo $folder
	cd $folder

	pwd
	#get the name of the run as run00? (e.g run001)
	id_run=`echo "$folder" | sed 's/_session_id_/''/' | sed 's/_subject_id_.*/''/'`;
	#get the name of the subject as ??? (e.g 003)
	id_sub=`echo "$folder" | sed 's/_session_id_run00[0-9]/''/' | sed 's/_subject_id_/''/'`;
	#get the frequency variable from the folder name to be sure what belongs to what
	freq=`echo $PWD | sed 's/\/media\/amr\/HDD\/Work\/Stimulation\//''/' | sed 's/_Task_Based_WorkingDir\/preproc_task\/_session_id_'${id_run}'_subject_id_'${id_sub}'/''/'`


	echo ${id_run}; echo ${id_sub}; echo $freq
	#copy cope1 to cope1 folder
	imcp Apply_Transformations_cope1/cope1_trans.nii.gz \
	/media/amr/HDD/Work/Stimulation/20Hz_higher_level_stats/copes/${freq}_${id_run}_${id_sub}_cope1.nii.gz
	#copy varcope1 to varcope folder
	imcp Apply_Transformations_varcope1/varcope1_trans.nii.gz \
	/media/amr/HDD/Work/Stimulation/20Hz_higher_level_stats/varcopes/${freq}_${id_run}_${id_sub}_varcope1.nii.gz
	#copy FEtdof to  FEtdof folder
	imcp Mask_FEtdof/FEtdof_t1_trans_masked.nii.gz \
	/media/amr/HDD/Work/Stimulation/20Hz_higher_level_stats/tdof/${freq}_${id_run}_${id_sub}_tdof1.nii.gz

	cd ..
done


########################################################################################
# 40 Hz
cd /media/amr/HDD/Work/Stimulation/

cd 40Hz_Task_Based_WorkingDir/preproc_task/

mkdir /media/amr/HDD/Work/Stimulation/40Hz_higher_level_stats/

mkdir /media/amr/HDD/Work/Stimulation/40Hz_higher_level_stats/copes
mkdir /media/amr/HDD/Work/Stimulation/40Hz_higher_level_stats/varcopes
mkdir /media/amr/HDD/Work/Stimulation/40Hz_higher_level_stats/tdof
for folder in _session*;do
	echo $folder
	cd $folder

	pwd
	#get the name of the run as run00? (e.g run001)
	id_run=`echo "$folder" | sed 's/_session_id_/''/' | sed 's/_subject_id_.*/''/'`;
	#get the name of the subject as ??? (e.g 003)
	id_sub=`echo "$folder" | sed 's/_session_id_run00[0-9]/''/' | sed 's/_subject_id_/''/'`;
	#get the frequency variable from the folder name to be sure what belongs to what
	freq=`echo $PWD | sed 's/\/media\/amr\/HDD\/Work\/Stimulation\//''/' | sed 's/_Task_Based_WorkingDir\/preproc_task\/_session_id_'${id_run}'_subject_id_'${id_sub}'/''/'`


	echo ${id_run}; echo ${id_sub}; echo $freq
	#copy cope1 to cope1 folder
	imcp Apply_Transformations_cope1/cope1_trans.nii.gz \
	/media/amr/HDD/Work/Stimulation/40Hz_higher_level_stats/copes/${freq}_${id_run}_${id_sub}_cope1.nii.gz
	#copy varcope1 to varcope folder
	imcp Apply_Transformations_varcope1/varcope1_trans.nii.gz \
	/media/amr/HDD/Work/Stimulation/40Hz_higher_level_stats/varcopes/${freq}_${id_run}_${id_sub}_varcope1.nii.gz
	#copy FEtdof to  FEtdof folder
	imcp Mask_FEtdof/FEtdof_t1_trans_masked.nii.gz \
	/media/amr/HDD/Work/Stimulation/40Hz_higher_level_stats/tdof/${freq}_${id_run}_${id_sub}_tdof1.nii.gz

	cd ..
done



# #######################################################################################


# 10Hz 10s
cd /media/amr/HDD/Work/Stimulation/

cd 10Hz_10s_Task_Based_WorkingDir/preproc_task/

mkdir /media/amr/HDD/Work/Stimulation/10Hz_10s_higher_level_stats/

mkdir /media/amr/HDD/Work/Stimulation/10Hz_10s_higher_level_stats/copes
mkdir /media/amr/HDD/Work/Stimulation/10Hz_10s_higher_level_stats/varcopes
mkdir /media/amr/HDD/Work/Stimulation/10Hz_10s_higher_level_stats/tdof
for folder in _session*;do
	echo $folder
	cd $folder

	pwd
	#get the name of the run as run00? (e.g run001)
	id_run=`echo "$folder" | sed 's/_session_id_/''/' | sed 's/_subject_id_.*/''/'`;
	#get the name of the subject as ??? (e.g 003)
	id_sub=`echo "$folder" | sed 's/_session_id_run00[0-9]/''/' | sed 's/_subject_id_/''/'`;
	#get the frequency variable from the folder name to be sure what belongs to what (here 10Hz_10s)
	freq=`echo $PWD | sed 's/\/media\/amr\/HDD\/Work\/Stimulation\//''/' | sed 's/_Task_Based_WorkingDir\/preproc_task\/_session_id_'${id_run}'_subject_id_'${id_sub}'/''/'`


	echo ${id_run}; echo ${id_sub}; echo $freq
	#copy cope1 to cope1 folder
	imcp Apply_Transformations_cope1/cope1_trans.nii.gz \
	/media/amr/HDD/Work/Stimulation/10Hz_10s_higher_level_stats/copes/${freq}_${id_run}_${id_sub}_cope1.nii.gz
	#copy varcope1 to varcope folder
	imcp Apply_Transformations_varcope1/varcope1_trans.nii.gz \
	/media/amr/HDD/Work/Stimulation/10Hz_10s_higher_level_stats/varcopes/${freq}_${id_run}_${id_sub}_varcope1.nii.gz
	#copy FEtdof to  FEtdof folder
	imcp Mask_FEtdof/FEtdof_t1_trans_masked.nii.gz \
	/media/amr/HDD/Work/Stimulation/10Hz_10s_higher_level_stats/tdof/${freq}_${id_run}_${id_sub}_tdof1.nii.gz

	cd ..
done

# #######################################################################################


# 20Hz 10s
cd /media/amr/HDD/Work/Stimulation/

cd 20Hz_10s_Task_Based_WorkingDir/preproc_task/

mkdir /media/amr/HDD/Work/Stimulation/20Hz_10s_higher_level_stats/

mkdir /media/amr/HDD/Work/Stimulation/20Hz_10s_higher_level_stats/copes
mkdir /media/amr/HDD/Work/Stimulation/20Hz_10s_higher_level_stats/varcopes
mkdir /media/amr/HDD/Work/Stimulation/20Hz_10s_higher_level_stats/tdof
for folder in _session*;do
	echo $folder
	cd $folder

	pwd
	#get the name of the run as run00? (e.g run001)
	id_run=`echo "$folder" | sed 's/_session_id_/''/' | sed 's/_subject_id_.*/''/'`;
	#get the name of the subject as ??? (e.g 003)
	id_sub=`echo "$folder" | sed 's/_session_id_run00[0-9]/''/' | sed 's/_subject_id_/''/'`;
	#get the frequency variable from the folder name to be sure what belongs to what (here 20Hz_10s)
	freq=`echo $PWD | sed 's/\/media\/amr\/HDD\/Work\/Stimulation\//''/' | sed 's/_Task_Based_WorkingDir\/preproc_task\/_session_id_'${id_run}'_subject_id_'${id_sub}'/''/'`


	echo ${id_run}; echo ${id_sub}; echo $freq
	#copy cope1 to cope1 folder
	imcp Apply_Transformations_cope1/cope1_trans.nii.gz \
	/media/amr/HDD/Work/Stimulation/20Hz_10s_higher_level_stats/copes/${freq}_${id_run}_${id_sub}_cope1.nii.gz
	#copy varcope1 to varcope folder
	imcp Apply_Transformations_varcope1/varcope1_trans.nii.gz \
	/media/amr/HDD/Work/Stimulation/20Hz_10s_higher_level_stats/varcopes/${freq}_${id_run}_${id_sub}_varcope1.nii.gz
	#copy FEtdof to  FEtdof folder
	imcp Mask_FEtdof/FEtdof_t1_trans_masked.nii.gz \
	/media/amr/HDD/Work/Stimulation/20Hz_10s_higher_level_stats/tdof/${freq}_${id_run}_${id_sub}_tdof1.nii.gz

	cd ..
done

# #######################################################################################


# 40Hz 10s
cd /media/amr/HDD/Work/Stimulation/

cd 40Hz_10s_Task_Based_WorkingDir/preproc_task/

mkdir /media/amr/HDD/Work/Stimulation/40Hz_10s_higher_level_stats/

mkdir /media/amr/HDD/Work/Stimulation/40Hz_10s_higher_level_stats/copes
mkdir /media/amr/HDD/Work/Stimulation/40Hz_10s_higher_level_stats/varcopes
mkdir /media/amr/HDD/Work/Stimulation/40Hz_10s_higher_level_stats/tdof
for folder in _session*;do
	echo $folder
	cd $folder

	pwd
	#get the name of the run as run00? (e.g run001)
	id_run=`echo "$folder" | sed 's/_session_id_/''/' | sed 's/_subject_id_.*/''/'`;
	#get the name of the subject as ??? (e.g 003)
	id_sub=`echo "$folder" | sed 's/_session_id_run00[0-9]/''/' | sed 's/_subject_id_/''/'`;
	#get the frequency variable from the folder name to be sure what belongs to what (here 40Hz_10s)
	freq=`echo $PWD | sed 's/\/media\/amr\/HDD\/Work\/Stimulation\//''/' | sed 's/_Task_Based_WorkingDir\/preproc_task\/_session_id_'${id_run}'_subject_id_'${id_sub}'/''/'`


	echo ${id_run}; echo ${id_sub}; echo $freq
	#copy cope1 to cope1 folder
	imcp Apply_Transformations_cope1/cope1_trans.nii.gz \
	/media/amr/HDD/Work/Stimulation/40Hz_10s_higher_level_stats/copes/${freq}_${id_run}_${id_sub}_cope1.nii.gz
	#copy varcope1 to varcope folder
	imcp Apply_Transformations_varcope1/varcope1_trans.nii.gz \
	/media/amr/HDD/Work/Stimulation/40Hz_10s_higher_level_stats/varcopes/${freq}_${id_run}_${id_sub}_varcope1.nii.gz
	#copy FEtdof to  FEtdof folder
	imcp Mask_FEtdof/FEtdof_t1_trans_masked.nii.gz \
	/media/amr/HDD/Work/Stimulation/40Hz_10s_higher_level_stats/tdof/${freq}_${id_run}_${id_sub}_tdof1.nii.gz

	cd ..
done

# #######################################################################################
