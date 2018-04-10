#!/bin/bash
#Batch processing
cd /media/amr/HDD/Work/Stimulation/Stims
for folder in *;do
	pvconv.pl $folder -outdir $folder
	cd $folder;
	pwd
	for image in *.img;do
		fslchfiletype NIFTI_GZ $image;
		rm *.brkhdr
		rm *.mat
		rm  AdjStatePerStudy
		rm subject
	done
cd ..
done


for folder in *;do
	cd $folder
	for image in *.nii.gz;do
		dim=`fslval $image dim4`

		if [ $dim -eq 150 ];then

			#adjust the orientation to anatomical left and right
			image=`remove_ext $image`
			fslorient -deleteorient   ${image}
			fslorient -setsformcode 1 ${image}

			#Augment the image by multiplying the voxel's dimensions by 10 and adjust the TR to 2.0 sec
			Augment.sh ${image} 10 2.0


			#Adjust the orientation of the image 
			fslswapdim ${image} LR AP IS ${image}

			#Extract the middle image to use as a target for motion correction
			fslroi ${image} ${image}_example_func 75 1;


			#motion correction using linear interpolation as sinc creates negative voxels
			mcflirt -in ${image} -out ${image}_mcf  -refvol ${image}_example_func -plots -mats  -report;

			#Remove parts of skull using thresholding to save time
			#This is not the optimum solution, but for the sake of speed
			fslmaths ${image}_mcf -Tmean ${image}_mean 
			p_95=`fslstats ${image}_mean -p 95`


			fslmaths ${image}_mean -thr ${p_95} -bin ${image}_mask

			#Remove the skull from the motion_corrected_4D_images
			fslmaths ${image}_mcf -mas ${image}_mask ${image}_mcf_bet 

			#----------------------------------------------------------------------------------------------
			brain_threshold=`fslstats ${image}_mcf_bet  -p 2 -p 98`;
			echo ${brain_threshold}
			int2=${brain_threshold::8};
			int98=${brain_threshold:8};
			echo $int2;
			echo $int98;

			threshold=`echo "(($int98 / 10) + $int2) - ($int2 / 10) " | bc -l`;
			echo threshold $threshold;

			fslmaths ${image}_mcf_bet -thr $threshold -Tmin -bin ${image}_mask -odt char;
			median_intensity=`fslstats ${image}_mcf_bet -k  ${image}_mask -p 50`;
			brightness=`echo "(${median_intensity} - $int2) * 0.75" | bc -l`
			echo brightness $brightness;

			fslmaths ${image}_mask -dilF ${image}_mask;



			fslmaths ${image}_mcf_bet -mas ${image}_mask ${image}_mcf_thresh;

			fslmaths ${image}_mcf_thresh -Tmean mean_func;

			#Smoothing
			#FWHM to sigma FWHM/2.35  2.5 * 2.3 = 5.75 -> 5.75/2.35=2.44
			susan ${image}_mcf_thresh $brightness 2.44 3 1 1 mean_func $brightness ${image}_mcf_smooth;

			fslmaths ${image}_mcf_smooth -mas ${image}_mask ${image}_mcf_smooth;
			scaling=`echo "(10000 / ${median_intensity})" | bc -l`;
			echo $scaling;

			#intensity normalization
			fslmaths ${image}_mcf_smooth -mul $scaling ${image}_mcf_intnorm;

			fslmaths ${image}_mcf_intnorm -Tmean tempMean;

			#High-pass filtering
			fslmaths ${image}_mcf_intnorm -bptf 22.5 -1 -add tempMean ${image}_mcf_tempfilt;

			imrm tempMean;

			fslmaths ${image}_mcf_tempfilt ${image}_filtered;

			#-----------------------------------------------------------------------------------------

			film_gls \
			--in=${image}_filtered \
			--rn=results \
			--pd='/media/amr/HDD/Nipype_Trial/design.mat' \
			--thr=1000.0 \
			--sa  \
			--ms=5 \
			--con='/media/amr/HDD/Nipype_Trial/design.con' \
			--fcon='/media/amr/HDD/Nipype_Trial/design.fts'

			cd results
			for file in *;do
				mv $file ${image}_${file}
			done

			cd ..

			cp results/* .
			rm -r results

			smoothest -d 148 \
			-m ${image}_mask \
			-r ${image}_res4d > smoothness 


			fslmaths ${image}_zstat1 -mas ${image}_mask ${image}_thresh_zstat1

			fslmaths ${image}_zfstat1 -mas ${image}_mask ${image}_thresh_zfstat1

			DHL=`sed -n 1p  smoothness | tr -dc '.0-9'`
			echo $DHL
			VOL=`sed -n 2p  smoothness | tr -dc '.0-9'`
			echo $VOL


			cluster \
			-i ${image}_thresh_zstat1 \
			-c ${image}_cope1 \
			-t 2.3 \
			-p 0.05 \
			-d $DHL \
			--volume=$VOL \
			--othresh=${image}_thresh_zstat1 \
			-o ${image}_cluster_mask_zstat1 \
			--connectivity=26  \
			--olmax=${image}_lmax_zstat1.txt \
			--scalarname=Z > ${image}_cluster_zstat1.txt


			cluster \
			-i ${image}_thresh_zfstat1  \
			-t 2.3 \
			-p 0.05 \
			-d $DHL \
			--volume=$VOL \
			--othresh=${image}_thresh_zfstat1 \
			-o ${image}_cluster_mask_zfstat1 \
			--connectivity=26  \
			--olmax=${image}_lmax_zfstat1.txt \
			--scalarname=Z > ${image}_cluster_zfstat1.txt


			fslstats ${image}_thresh_zstat1 -l 0.0001 -R 2>/dev/null

			fslstats ${image}_thresh_zfstat1 -l 0.0001 -R 2>/dev/null

			overlay 1 0 ${image}_example_func -a ${image}_thresh_zstat1 2.300302 4.877862 ${image}_rendered_thresh_zstat1

			slicer ${image}_rendered_thresh_zstat1 -A 750 ${image}_rendered_thresh_zstat1.png

			overlay 1 0 ${image}_example_func -a ${image}_thresh_zfstat1 2.300302 4.877862 ${image}_rendered_thresh_zfstat1

			slicer ${image}_rendered_thresh_zfstat1 -A 750 ${image}_rendered_thresh_zfstat1.png

			eog ${image}_rendered_thresh_zfstat1.png
		fi
	done
cd ..
done

			 




