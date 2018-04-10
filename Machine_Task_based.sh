fslchfiletype NIFTI_GZ  ${folder}

#adjust the orientation to anatomical left and right
fslorient -deleteorient   ${folder}
fslorient -setsformcode 1 ${folder}

#Augment the image by multiplying the voxel's dimensions by 10 and adjust the TR to 2.0 sec
Augment.sh ${folder} 10 2.0


#Adjust the orientation of the image 
fslswapdim ${folder} LR AP IS ${folder}

#Extract the middle image to use as a target for motion correction
fslroi ${folder} ${folder}_example_func 75 1;


#motion correction using linear interpolation as sinc creates negative voxels
mcflirt -in ${folder} -out ${folder}_mcf  -refvol ${folder}_example_func -plots -mats  -report;

#Remove parts of skull using thresholding to save time
#This is not the optimum solution, but for the sake of speed
fslmaths ${folder}_mcf -Tmean ${folder}_mean 
p_95=`fslstats ${folder}_mean -p 95`


fslmaths ${folder}_mean -thr ${p_95} -bin ${folder}_mask

#Remove the skull from the motion_corrected_4D_images
fslmaths ${folder}_mcf -mas ${folder}_mask ${folder}_mcf_bet 

#----------------------------------------------------------------------------------------------
brain_threshold=`fslstats ${folder}_mcf_bet  -p 2 -p 98`;
echo ${brain_threshold}
int2=${brain_threshold::8};
int98=${brain_threshold:8};
echo $int2;
echo $int98;

threshold=`echo "(($int98 / 10) + $int2) - ($int2 / 10) " | bc -l`;
echo threshold $threshold;

fslmaths ${folder}_mcf_bet -thr $threshold -Tmin -bin ${folder}_mask -odt char;
median_intensity=`fslstats ${folder}_mcf_bet -k  ${folder}_mask -p 50`;
brightness=`echo "(${median_intensity} - $int2) * 0.75" | bc -l`
echo brightness $brightness;

fslmaths ${folder}_mask -dilF ${folder}_mask;



fslmaths ${folder}_mcf_bet -mas ${folder}_mask ${folder}_mcf_thresh;

fslmaths ${folder}_mcf_thresh -Tmean mean_func;

#Smoothing
#FWHM to sigma FWHM/2.35  2.5 * 2.3 = 5.75 -> 5.75/2.35=2.44
susan ${folder}_mcf_thresh $brightness 2.44 3 1 1 mean_func $brightness ${folder}_mcf_smooth;

fslmaths ${folder}_mcf_smooth -mas ${folder}_mask ${folder}_mcf_smooth;
scaling=`echo "(10000 / ${median_intensity})" | bc -l`;
echo $scaling;

#intensity normalization
fslmaths ${folder}_mcf_smooth -mul $scaling ${folder}_mcf_intnorm;

fslmaths ${folder}_mcf_intnorm -Tmean tempMean;

#High-pass filtering
fslmaths ${folder}_mcf_intnorm -bptf 22.5 -1 -add tempMean ${folder}_mcf_tempfilt;

imrm tempMean;

fslmaths ${folder}_mcf_tempfilt ${folder}_filtered;

#-----------------------------------------------------------------------------------------

film_gls \
--in=${folder}_filtered \
--rn=results \
--pd='/media/amr/HDD/Nipype_Trial/design.mat' \
--thr=1000.0 \
--sa  \
--ms=5 \
--con='/media/amr/HDD/Nipype_Trial/design.con' \
--fcon='/media/amr/HDD/Nipype_Trial/design.fts'

cd results
for file in *;do
	mv $file ${folder}_${file}
done

cd ..

cp results/* .
rm -r results

smoothest -d 148 \
-m ${folder}_mask \
-r ${folder}_res4d > smoothness 


fslmaths ${folder}_zstat1 -mas ${folder}_mask ${folder}_thresh_zstat1

fslmaths ${folder}_zfstat1 -mas ${folder}_mask ${folder}_thresh_zfstat1

DHL=`sed -n 1p  smoothness | tr -dc '.0-9'`
echo $DHL
VOL=`sed -n 2p  smoothness | tr -dc '.0-9'`
echo $VOL


cluster \
-i ${folder}_thresh_zstat1 \
-c ${folder}_cope1 \
-t 2.3 \
-p 0.05 \
-d $DHL \
--volume=$VOL \
--othresh=${folder}_thresh_zstat1 \
-o ${folder}_cluster_mask_zstat1 \
--connectivity=26  \
--olmax=${folder}_lmax_zstat1.txt \
--scalarname=Z > ${folder}_cluster_zstat1.txt


cluster \
-i ${folder}_thresh_zfstat1  \
-t 2.3 \
-p 0.05 \
-d $DHL \
--volume=$VOL \
--othresh=${folder}_thresh_zfstat1 \
-o ${folder}_cluster_mask_zfstat1 \
--connectivity=26  \
--olmax=${folder}_lmax_zfstat1.txt \
--scalarname=Z > ${folder}_cluster_zfstat1.txt


fslstats ${folder}_thresh_zstat1 -l 0.0001 -R 2>/dev/null

fslstats ${folder}_thresh_zfstat1 -l 0.0001 -R 2>/dev/null

overlay 1 0 ${folder}_example_func -a ${folder}_thresh_zstat1 2.300302 4.877862 ${folder}_rendered_thresh_zstat1

slicer ${folder}_rendered_thresh_zstat1 -A 750 ${folder}_rendered_thresh_zstat1.png

overlay 1 0 ${folder}_example_func -a ${folder}_thresh_zfstat1 2.300302 4.877862 ${folder}_rendered_thresh_zfstat1

slicer ${folder}_rendered_thresh_zfstat1 -A 750 ${folder}_rendered_thresh_zfstat1.png

eog ${folder}_rendered_thresh_zfstat1.png
 
