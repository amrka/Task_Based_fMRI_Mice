# In[1]:

from nipype import config
cfg = dict(execution={'remove_unnecessary_outputs': False})
config.update_config(cfg)

import nipype.interfaces.fsl  as fsl
import nipype.interfaces.afni as afni
import nipype.interfaces.ants as ants
import nipype.interfaces.spm  as spm

from nipype.interfaces.utility import IdentityInterface, Function, Select, Merge
from os.path import join as opj
from nipype.interfaces.io import SelectFiles, DataSink
from nipype.pipeline.engine import Workflow, Node, MapNode

import numpy as np
import matplotlib.pyplot as plt
from nipype.interfaces.matlab import MatlabCommand
MatlabCommand.set_default_paths('/media/amr/HDD/Sofwares/spm12/')
MatlabCommand.set_default_matlab_cmd("matlab -nodesktop -nosplash")


# import nipype.interfaces.matlab as mlab
# mlab.MatlabCommand.set_default_matlab_cmd("matlab -nodesktop -nosplash")
# mlab.MatlabCommand.set_default_paths('/home/amr/Documents/MATLAB/toolbox/spm8')

#-----------------------------------------------------------------------------------------------------
# In[2]:
experiment_dir = '/media/amr/HDD/Work/Stimulation'  

subject_list = ['003','005','008','011','018','019','020', '059', '060','062','063','066']
session_list = ['run001', 'run002', 'run003']

                
output_dir  = '40Hz_10s_Task_Based_OutputDir'
working_dir = '40Hz_10s_Task_Based_WorkingDir'

preproc_task = Workflow(name = 'preproc_task')
preproc_task.base_dir = opj(experiment_dir, working_dir)

#-----------------------------------------------------------------------------------------------------
# In[20]:
# Infosource - a function free node to iterate over the list of subject names
infosource = Node(IdentityInterface(fields=['subject_id','session_id']),
                  name="infosource")
infosource.iterables = [('subject_id', subject_list),
                        ('session_id', session_list)]

#-----------------------------------------------------------------------------------------------------
# In[21]:

templates = {

 'Anat_Bias' : '/media/amr/HDD/Work/Stimulation/Registration_Stimulation_WorkingDir/Registration_Stimulation/_subject_id_{subject_id}/BiasFieldCorrection/Anat_{subject_id}_bet_corrected.nii.gz',
 'Anat_Mask' : 'Data/{subject_id}/Anat_{subject_id}_Mask.nii.gz',
 'Highres2Temp_Transformations' : '/media/amr/HDD/Work/Stimulation/Registration_Stimulation_WorkingDir/Registration_Stimulation/_subject_id_{subject_id}/HighresToTemplate/transformComposite.h5',


 'Stim_40Hz_10s' : 'Data/{subject_id}/Stim_{subject_id}_??_40Hz_10s_{session_id}.nii.gz',
 'EPI_Mask'  : 'Data/{subject_id}/EPI_{subject_id}_Mask.nii.gz'
             }

selectfiles = Node(SelectFiles(templates,
                               base_directory=experiment_dir),
                   name="selectfiles")
#-----------------------------------------------------------------------------------------------------

# In[17]:

# datasink = Node(DataSink(base_directory=experiment_dir,
#                          container=output_dir),
#                 name="datasink")
datasink = Node(DataSink(), name = 'datasink')
datasink.inputs.container = output_dir
datasink.inputs.base_directory = experiment_dir

substitutions = [('_subject_id_', ''),('_session_id_', '')]

datasink.inputs.substitutions = substitutions

#-----------------------------------------------------------------------------------------------------
# In[3]:

Study_Template = '/media/amr/HDD/Work/October_Acquistion/Anat_Template.nii.gz' 
Study_Template_Mask = '/media/amr/HDD/Work/October_Acquistion/Anat_Template_Mask.nii.gz'
#-----------------------------------------------------------------------------------------------------
# In[7]:
#I made a seperate pipeline just for biasfield correction and registration
#To avoid running it multiple times
# BiasFieldCorrection = Node(ants.N4BiasFieldCorrection(), name = 'BiasFieldCorrection')
# BiasFieldCorrection.inputs.save_bias = False
#-----------------------------------------------------------------------------------------------------
# In[14]:
#fslmaths  ${folder}_mcf_2highres.nii.gz -mas ${folder}_2highres_mask ${folder}_mcf_2highres_bet;
Bet_mcf = Node(fsl.ApplyMask(), name = 'Remove_Skull_EPI')
#Output the masked image in nifti format to pass it for spm for smoothing

#-----------------------------------------------------------------------------------------------------
# In[8]:

#I made a seperate pipeline just for biasfield correction and registration
#To avoid running it multiple times

## normalizing the anatomical_bias_corrected image to the common anatomical template
## Here only we are calculating the paramters, we apply them later.
#You need a seperate pipeline for highres to temp
#If you do it here it will run it for every session
#>>> this is not the most elegant solution, but I am going to go on with performing the registration
#For each session. the other solution is to seperate two pipelines, one for registration iterating only
#over the subjects
#and the other for preprocessing, iteriting over sessions
#then connect them with a metaflow and combine the transformations
#But it is going to create a mess
#So, just go with easy less-elegant solution
#The elegant solution is in this file Mock_Script_Task_Based_Metaflow.py
# HighresToTemplate = Node(ants.Registration(), name = 'HighresToTemplate')
# HighresToTemplate.inputs.args='--float'
# HighresToTemplate.inputs.collapse_output_transforms=True
# HighresToTemplate.inputs.fixed_image=Study_Template
# HighresToTemplate.inputs.initial_moving_transform_com=True
# HighresToTemplate.inputs.num_threads=8
# HighresToTemplate.inputs.output_inverse_warped_image=True
# HighresToTemplate.inputs.output_warped_image=True
# HighresToTemplate.inputs.sigma_units=['vox']*3
# HighresToTemplate.inputs.transforms= ['Rigid', 'Affine', 'SyN']
# # HighresToTemplate.inputs.terminal_output='file'
# HighresToTemplate.inputs.winsorize_lower_quantile=0.005
# HighresToTemplate.inputs.winsorize_upper_quantile=0.995
# HighresToTemplate.inputs.convergence_threshold=[1e-06]
# HighresToTemplate.inputs.convergence_window_size=[10]
# HighresToTemplate.inputs.metric=['MI', 'MI', 'CC']
# HighresToTemplate.inputs.metric_weight=[1.0]*3
# HighresToTemplate.inputs.number_of_iterations=[[1000, 500, 250, 100],
#                                                  [1000, 500, 250, 100],
#                                                  [100, 70, 50, 20]]
# HighresToTemplate.inputs.radius_or_number_of_bins=[32, 32, 4]
# HighresToTemplate.inputs.sampling_percentage=[0.25, 0.25, 1]
# HighresToTemplate.inputs.sampling_strategy=['Regular',
#                                               'Regular',
#                                               'None']
# HighresToTemplate.inputs.shrink_factors=[[8, 4, 2, 1]]*3
# HighresToTemplate.inputs.smoothing_sigmas=[[3, 2, 1, 0]]*3
# HighresToTemplate.inputs.transform_parameters=[(0.1,),
#                                                  (0.1,),
#                                                  (0.1, 3.0, 0.0)]
# HighresToTemplate.inputs.use_histogram_matching=True
# HighresToTemplate.inputs.write_composite_transform=True
# HighresToTemplate.inputs.verbose=True
# HighresToTemplate.inputs.output_warped_image=True
# HighresToTemplate.inputs.float=True

#-----------------------------------------------------------------------------------------------------


# In[9]:
CoReg = Node(ants.Registration(), name = 'CoReg')
CoReg.inputs.args='--float'
CoReg.inputs.collapse_output_transforms=True
CoReg.inputs.initial_moving_transform_com=True
CoReg.inputs.num_threads=8
CoReg.inputs.output_inverse_warped_image=True
CoReg.inputs.output_warped_image=True
CoReg.inputs.sigma_units=['vox']*3
CoReg.inputs.transforms= ['Rigid']
CoReg.inputs.winsorize_lower_quantile=0.005
CoReg.inputs.winsorize_upper_quantile=0.995
CoReg.inputs.convergence_threshold=[1e-06]
CoReg.inputs.convergence_window_size=[10]
CoReg.inputs.metric=['MI', 'MI', 'CC']
CoReg.inputs.metric_weight=[1.0]*3
CoReg.inputs.number_of_iterations=[[1000, 500, 250, 100],
                                                 [1000, 500, 250, 100],
                                                 [100, 70, 50, 20]]
CoReg.inputs.radius_or_number_of_bins=[32, 32, 4]
CoReg.inputs.sampling_percentage=[0.25, 0.25, 1]
CoReg.inputs.sampling_strategy=['Regular',
                                'Regular',
                                'None']
CoReg.inputs.shrink_factors=[[8, 4, 2, 1]]*3
CoReg.inputs.smoothing_sigmas=[[3, 2, 1, 0]]*3
CoReg.inputs.transform_parameters=[(0.1,),
                                   (0.1,),
                                   (0.1, 3.0, 0.0)]
CoReg.inputs.use_histogram_matching=True
CoReg.inputs.write_composite_transform=True
CoReg.inputs.verbose=True
CoReg.inputs.output_warped_image=True
CoReg.inputs.float=True
#-----------------------------------------------------------------------------------------------------
# In[10]:
Merge_Transformations = Node(Merge(2), name = 'Merge_Transformations')


#----------------------------------------------------------------------------------------------------
# In[10]:
# fslroi ${folder} example_func 450 1;
FslRoi = Node(fsl.ExtractROI(), name = 'FslRoi')
FslRoi.inputs.t_min = 75
FslRoi.inputs.t_size = 1

#-----------------------------------------------------------------------------------------------------
# In[11]:

# mcflirt -in ${folder} -out ${folder}_mcf  -refvol example_func -plots -mats  -report;

McFlirt = Node(fsl.MCFLIRT(), name = 'McFlirt')
McFlirt.inputs.save_plots = True
McFlirt.inputs.save_mats = True
McFlirt.inputs.save_rms = True
McFlirt.inputs.output_type = 'NIFTI'

#-----------------------------------------------------------------------------------------------------
#Getting motion parameters from Mcflirt and plotting them
Get_Abs_Displacement = Node(Select(), name = 'Get_Absolute_Displacement')
Get_Abs_Displacement.inputs.index = [0]


Get_Rel_Displacement = Node(Select(), name = 'Get_Relative_Displacement')
Get_Rel_Displacement.inputs.index = [1]


def Plot_Motion(motion_par, abs_disp, rel_disp):

    import numpy as np
    import matplotlib.pyplot as plt 

    movement = np.loadtxt(motion_par)
    abs_disp = np.loadtxt(abs_disp)
    rel_disp = np.loadtxt(rel_disp)
    plt.figure(figsize=(8,10), dpi=300)

    plt.subplot(311)
    plt.title('Translations in mm')
    plt.plot(movement[:,:3])
    plt.legend(['x','y','z'])

    plt.subplot(312)
    plt.title('Rotations in radians')
    plt.plot(movement[:,3:])
    plt.legend(['x','y','z'])
    
    plt.subplot(313)
    plt.title('Displacement in mm')
    plt.plot(abs_disp)
    plt.plot(rel_disp)
    plt.legend(['abs', 'rel'])

    plt.savefig('Motion')


Plot_Motion = Node(name = 'Plot_Motion',
                  interface = Function(input_names = ['motion_par','abs_disp','rel_disp'],
                  function = Plot_Motion))

# In[12]:

#-----------------------------------------------------------------------------------------------------
#Use spm smoothin, because, as you know, fsl does not support anisotropic smoothing
Spm_Smoothing = Node(spm.Smooth(), name = 'Smoothing')
#I tried all these kernels and this one is most reasonable one
Spm_Smoothing.inputs.fwhm = [5.75, 5.75, 8]
#Spm_Smoothing.iterables = ('fwhm', [[5,5,8],[5.75,5.75,8],[5.75,5.75,10], [5.75,5.75,16]])

#-----------------------------------------------------------------------------------------------------
#Getting median intensity
Median_Intensity = Node(fsl.ImageStats(), name = 'Median_Intensity')
#Put -k before -p 50
Median_Intensity.inputs.op_string = '-k %s -p 50'

#Scale median intensity 
def Scale_Median_Intensity (median_intensity):
    scaling = 10000/median_intensity
    return scaling

Scale_Median_Intensity = Node(name = 'Scale_Median_Intensity',
                      interface = Function(input_names = ['median_intensity'],
                                           output_names = ['scaling'],
                                           function = Scale_Median_Intensity))

#-----------------------------------------------------------------------------------------------------
#Global Intensity Normalization by multiplying by the scaling value
#the grand-mean intensity normalisation factor ( to give a median brain intensity of 10000 )
#grand mean scaling
Intensity_Normalization = Node(fsl.BinaryMaths(), name = 'Intensity_Normalization')
Intensity_Normalization.inputs.operation = 'mul'


#-----------------------------------------------------------------------------------------------------
#   fslmaths ${folder}_mcf_2highres_intnorm -bptf 25 -1 -add tempMean ${folder}_mcf_2highres_tempfilt;
High_Pass_Filter = Node(fsl.TemporalFilter(), name = 'High_Pass_Filter')
High_Pass_Filter.inputs.highpass_sigma = 22.5 

#-----------------------------------------------------------------------------------------------------
#Get the mean image
Get_Mean_Image = Node(fsl.MeanImage(), name = 'Get_Mean_Image')
Get_Mean_Image.inputs.dimension = 'T'

#Add the mean image to the filtered image
Add_Mean_Image = Node(fsl.BinaryMaths(), name = 'Add_Mean_Image')
Add_Mean_Image.inputs.operation = 'add'


#-----------------------------------------------------------------------------------------------------
# In[15]:
#Fit the design to the voxels time-series
design = '/media/amr/HDD/Work/Stimulation/1st_Level_Designs/10s_Stimulation_design.mat'
t_contrast = '/media/amr/HDD/Work/Stimulation/1st_Level_Designs/10s_Stimulation_design.con'
f_contrast = '/media/amr/HDD/Work/Stimulation/1st_Level_Designs/10s_Stimulation_design.fts'

Film_Gls = Node(fsl.FILMGLS(), name = 'Fit_Design_to_Timeseries')
Film_Gls.inputs.design_file = design
Film_Gls.inputs.tcon_file = t_contrast
Film_Gls.inputs.fcon_file = f_contrast
Film_Gls.inputs.threshold = 1000.0
Film_Gls.inputs.smooth_autocorr = True

#-----------------------------------------------------------------------------------------------------
# In[15]:
#Estimate smootheness of the image
Smooth_Est = Node(fsl.SmoothEstimate(), name = 'Smooth_Estimation')
Smooth_Est.inputs.dof = 148 #150 volumes and only one regressor

#-----------------------------------------------------------------------------------------------------
# In[15]:
#Clusterin on the statistical output of t-contrasts
Clustering_t = Node(fsl.Cluster(), name = 'Clustering_t_Contrast')
Clustering_t.inputs.threshold = 2.3
Clustering_t.inputs.pthreshold = 0.05
Clustering_t.inputs.out_threshold_file = 'thresh_zstat1.nii.gz'
# Clustering_t.inputs.out_index_file = 'mask_zstat1'
# Clustering_t.inputs.out_localmax_txt_file = 'localmax'



#-----------------------------------------------------------------------------------------------------
# In[15]:
#Clusterin on the statistical output of f-contrast
Clustering_f = Node(fsl.Cluster(), name = 'Clustering_f_Contrast')
Clustering_f.inputs.threshold = 2.3
Clustering_f.inputs.pthreshold = 0.05
Clustering_f.inputs.out_threshold_file = 'thresh_zfstat1.nii.gz'

#-----------------------------------------------------------------------------------------------------
# In[15]:
#Overlay t contrast
Overlay_t_Contrast = Node(fsl.Overlay(), name = 'Overlay_t_Contrast')
Overlay_t_Contrast.inputs.auto_thresh_bg = True
Overlay_t_Contrast.inputs.stat_thresh = (2.300302,4.877862)
Overlay_t_Contrast.inputs.transparency = True


#-----------------------------------------------------------------------------------------------------
# In[15]:
#Overlay f contrast
Overlay_f_Contrast = Node(fsl.Overlay(), name = 'Overlay_f_Contrast')
Overlay_f_Contrast.inputs.auto_thresh_bg = True
Overlay_f_Contrast.inputs.stat_thresh = (2.300302,4.877862)
Overlay_f_Contrast.inputs.transparency = True


#-----------------------------------------------------------------------------------------------------
# In[15]:
#slicer 
Slicer_t_Contrast = Node(fsl.Slicer(), name = 'Generate_t_Contrast_Image')
Slicer_t_Contrast.inputs.all_axial = True
Slicer_t_Contrast.inputs.image_width = 750
#-----------------------------------------------------------------------------------------------------
# In[15]:
#slicer 
Slicer_f_Contrast = Node(fsl.Slicer(), name = 'Generate_f_Contrast_Image')
Slicer_f_Contrast.inputs.all_axial = True
Slicer_f_Contrast.inputs.image_width = 750

#-----------------------------------------------------------------------------------------------------
# In[15]:
#Calculate dofs of freedom for second level analysis
#N.B the number of runs have to be equal for each subject
dof = 150 - (len(subject_list) * len(session_list)) #No of volumes
#-----------------------------------------------------------------------------------------------------
# In[15]:
#Generate dof file for each cope1, spoiler alert, I have only one
FEtdof_t1 = Node(fsl.ImageMaths(), name = 'Generate_FEtdof_t1')
FEtdof_t1.inputs.op_string = '-mul 0 -add %f' % (dof)
FEtdof_t1.inputs.out_file = 'FEtdof_t1.nii.gz'

#-----------------------------------------------------------------------------------------------------
# apply the trasnfromation to cope1, varcope1, FEtdof_t1

# In[16]:
Apply_Transformations_cope1 = Node(ants.ApplyTransforms(), name = 'Apply_Transformations_cope1')
Apply_Transformations_cope1.inputs.dimension = 3

Apply_Transformations_cope1.inputs.input_image_type = 3
Apply_Transformations_cope1.inputs.num_threads = 1
Apply_Transformations_cope1.inputs.float = True
Apply_Transformations_cope1.inputs.reference_image = Study_Template



# In[16]:
Apply_Transformations_varcope1 = Node(ants.ApplyTransforms(), name = 'Apply_Transformations_varcope1')
Apply_Transformations_varcope1.inputs.dimension = 3

Apply_Transformations_varcope1.inputs.input_image_type = 3
Apply_Transformations_varcope1.inputs.num_threads = 1
Apply_Transformations_varcope1.inputs.float = True
Apply_Transformations_varcope1.inputs.reference_image = Study_Template



# In[16]:
Apply_Transformations_FEtdof_t1 = Node(ants.ApplyTransforms(), name = 'Apply_Transformations_FEtdof_t1')
Apply_Transformations_FEtdof_t1.inputs.dimension = 3

Apply_Transformations_FEtdof_t1.inputs.input_image_type = 3
Apply_Transformations_FEtdof_t1.inputs.num_threads = 1
Apply_Transformations_FEtdof_t1.inputs.float = True
Apply_Transformations_FEtdof_t1.inputs.reference_image = Study_Template
#----------------------------------------------------------------------------------------------------
# IN[17]
#Mask FETdof after applyinh the transformations to the study template
Mask_FEtdof = Node(fsl.ApplyMask(), name = 'Mask_FEtdof')
Mask_FEtdof.inputs.mask_file = Study_Template_Mask

#-----------------------------------------------------------------------------------------------------
# In[15]:
preproc_task.connect([

              (infosource, selectfiles,[('subject_id','subject_id'),
                                        ('session_id', 'session_id')]),
              # (selectfiles, BiasFieldCorrection, [('Anat_Bias','input_image')]),

              # (BiasFieldCorrection,HighresToTemplate,[('output_image','moving_image')]),
              (selectfiles, Bet_mcf, [('Stim_40Hz_10s','in_file')]),
              (selectfiles, Bet_mcf, [('EPI_Mask','mask_file')]),

              (Bet_mcf, FslRoi, [('out_file','in_file')]),


              (selectfiles, CoReg, [('Anat_Bias','fixed_image')]),
              (FslRoi, CoReg, [('roi_file','moving_image')]),

              (selectfiles, Merge_Transformations, [('Highres2Temp_Transformations','in1')]),
              (CoReg, Merge_Transformations, [('composite_transform','in2')]),

              (FslRoi, McFlirt, [('roi_file','ref_file')]),
              (Bet_mcf, McFlirt, [('out_file','in_file')]),
              
              (McFlirt, Get_Abs_Displacement, [('rms_files','inlist')]),
              (McFlirt, Get_Rel_Displacement, [('rms_files','inlist')]),
              
              (McFlirt, Plot_Motion, [('par_file','motion_par')]),
              (Get_Abs_Displacement, Plot_Motion, [('out','abs_disp')]),
              (Get_Rel_Displacement, Plot_Motion, [('out','rel_disp')]),


              (McFlirt, Median_Intensity, [('out_file','in_file')]),
              (selectfiles, Median_Intensity, [('EPI_Mask','mask_file')]),
              (Median_Intensity, Scale_Median_Intensity, [('out_stat','median_intensity')]),

              (McFlirt, Spm_Smoothing, [('out_file','in_files')]),


              (Spm_Smoothing, Intensity_Normalization, [('smoothed_files','in_file')]),
              (Scale_Median_Intensity, Intensity_Normalization, [('scaling','operand_value')]),

              (Intensity_Normalization, Get_Mean_Image, [('out_file','in_file')]),

              (Intensity_Normalization, High_Pass_Filter, [('out_file','in_file')]),

              (High_Pass_Filter, Add_Mean_Image, [('out_file','in_file')]),
              (Get_Mean_Image, Add_Mean_Image, [('out_file','operand_file')]),

              (Add_Mean_Image, Film_Gls, [('out_file','in_file')]),

              (selectfiles, Smooth_Est, [('EPI_Mask','mask_file')]),
              (Film_Gls, Smooth_Est, [('residual4d','residual_fit_file')]),

              (Film_Gls, Clustering_t, [('zstats','in_file')]),
              (Film_Gls, Clustering_t, [('copes','cope_file')]),
              (Smooth_Est, Clustering_t, [('dlh','dlh'),
                                          ('volume','volume')]),



              (Film_Gls, Clustering_f, [('zfstats','in_file')]),
              (Smooth_Est, Clustering_f, [('dlh','dlh'),
                                          ('volume', 'volume')]),


              (FslRoi, Overlay_t_Contrast, [('roi_file','background_image')]),
              (Clustering_t, Overlay_t_Contrast, [('threshold_file','stat_image')]),


              (FslRoi, Overlay_f_Contrast, [('roi_file','background_image')]),
              (Clustering_f, Overlay_f_Contrast, [('threshold_file','stat_image')]),

              (Overlay_t_Contrast, Slicer_t_Contrast, [('out_file','in_file')]),
              (Overlay_f_Contrast, Slicer_f_Contrast, [('out_file','in_file')]),

              (Film_Gls, FEtdof_t1, [('copes','in_file')]),

              (Film_Gls, Apply_Transformations_cope1, [('copes','input_image')]),
              (Merge_Transformations, Apply_Transformations_cope1, [('out','transforms')]),


              (Film_Gls, Apply_Transformations_varcope1, [('varcopes','input_image')]),
              (Merge_Transformations, Apply_Transformations_varcope1, [('out','transforms')]),


              (FEtdof_t1, Apply_Transformations_FEtdof_t1, [('out_file','input_image')]),
              (Merge_Transformations, Apply_Transformations_FEtdof_t1, [('out','transforms')]),

              (Apply_Transformations_FEtdof_t1, Mask_FEtdof, [('output_image','in_file')]),

              ])


preproc_task.write_graph(graph2use='flat')

preproc_task.run('MultiProc', plugin_args={'n_procs': 8})



