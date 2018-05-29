# In[1]:
#This script to Register the anatomical images from the stimulation study to the study-based template
#Using registration inside the processing pipeline induces registration per session rather than per 
#subject which is fucking annoying, time-wasting and utterly stupid
#So, I seperated the biasfield correction and the registration to this pipeline and later
#add the results to selecfiles
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


                
output_dir  = 'Registration_Stimulation_OutputDir'
working_dir = 'Registration_Stimulation_WorkingDir'

Registration_Stimulation = Workflow(name = 'Registration_Stimulation')
Registration_Stimulation.base_dir = opj(experiment_dir, working_dir)

#-----------------------------------------------------------------------------------------------------
# In[20]:
# Infosource - a function free node to iterate over the list of subject names
infosource = Node(IdentityInterface(fields=['subject_id']),
                  name="infosource")
infosource.iterables = [('subject_id', subject_list)]

#-----------------------------------------------------------------------------------------------------
# In[21]:

templates = {
             'Anat'      : 'Data/{subject_id}/Anat_{subject_id}_bet.nii.gz',
             'Anat_Mask' : 'Data/{subject_id}/Anat_{subject_id}_Mask.nii.gz',
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

BiasFieldCorrection = Node(ants.N4BiasFieldCorrection(), name = 'BiasFieldCorrection')
BiasFieldCorrection.inputs.save_bias = False

#-----------------------------------------------------------------------------------------------------
# In[8]:

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
HighresToTemplate = Node(ants.Registration(), name = 'HighresToTemplate')
HighresToTemplate.inputs.args='--float'
HighresToTemplate.inputs.collapse_output_transforms=True
HighresToTemplate.inputs.fixed_image=Study_Template
HighresToTemplate.inputs.initial_moving_transform_com=True
HighresToTemplate.inputs.num_threads=1
HighresToTemplate.inputs.output_inverse_warped_image=True
HighresToTemplate.inputs.output_warped_image=True
HighresToTemplate.inputs.sigma_units=['vox']*3
HighresToTemplate.inputs.transforms= ['Rigid', 'Affine', 'SyN']
# HighresToTemplate.inputs.terminal_output='file'
HighresToTemplate.inputs.winsorize_lower_quantile=0.005
HighresToTemplate.inputs.winsorize_upper_quantile=0.995
HighresToTemplate.inputs.convergence_threshold=[1e-06]
HighresToTemplate.inputs.convergence_window_size=[10]
HighresToTemplate.inputs.metric=['MI', 'MI', 'CC']
HighresToTemplate.inputs.metric_weight=[1.0]*3
HighresToTemplate.inputs.number_of_iterations=[[1000, 500, 250, 100],
                                                 [1000, 500, 250, 100],
                                                 [100, 70, 50, 20]]
HighresToTemplate.inputs.radius_or_number_of_bins=[32, 32, 4]
HighresToTemplate.inputs.sampling_percentage=[0.25, 0.25, 1]
HighresToTemplate.inputs.sampling_strategy=['Regular',
                                              'Regular',
                                              'None']
HighresToTemplate.inputs.shrink_factors=[[8, 4, 2, 1]]*3
HighresToTemplate.inputs.smoothing_sigmas=[[3, 2, 1, 0]]*3
HighresToTemplate.inputs.transform_parameters=[(0.1,),
                                                 (0.1,),
                                                 (0.1, 3.0, 0.0)]
HighresToTemplate.inputs.use_histogram_matching=True
HighresToTemplate.inputs.write_composite_transform=True
HighresToTemplate.inputs.verbose=True
HighresToTemplate.inputs.output_warped_image=True
HighresToTemplate.inputs.float=True

#-----------------------------------------------------------------------------------------------------
# In[15]:
Registration_Stimulation.connect([

              (infosource, selectfiles,[('subject_id','subject_id')]),
              (selectfiles, BiasFieldCorrection, [('Anat','input_image')]),

              (BiasFieldCorrection,HighresToTemplate,[('output_image','moving_image')]),

            ])


Registration_Stimulation.write_graph(graph2use='flat')

Registration_Stimulation.run('MultiProc', plugin_args={'n_procs': 8})



