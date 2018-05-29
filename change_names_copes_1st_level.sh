#!/bin/bash
#this script is just to apply the python script change_runs_to_contain_gp_name.py
#to the first level data of the stimulation experiment instead of doing it
#from the shell one by one

#4 sec
python change_runs_to_contain_gp_name.py '/media/amr/HDD/Work/Stimulation/10Hz_higher_level_stats/copes' 
python change_runs_to_contain_gp_name.py '/media/amr/HDD/Work/Stimulation/10Hz_higher_level_stats/varcopes' 
python change_runs_to_contain_gp_name.py '/media/amr/HDD/Work/Stimulation/10Hz_higher_level_stats/tdof' 


python change_runs_to_contain_gp_name.py '/media/amr/HDD/Work/Stimulation/20Hz_higher_level_stats/copes' 
python change_runs_to_contain_gp_name.py '/media/amr/HDD/Work/Stimulation/20Hz_higher_level_stats/varcopes' 
python change_runs_to_contain_gp_name.py '/media/amr/HDD/Work/Stimulation/20Hz_higher_level_stats/tdof' 


python change_runs_to_contain_gp_name.py '/media/amr/HDD/Work/Stimulation/40Hz_higher_level_stats/copes' 
python change_runs_to_contain_gp_name.py '/media/amr/HDD/Work/Stimulation/40Hz_higher_level_stats/varcopes' 
python change_runs_to_contain_gp_name.py '/media/amr/HDD/Work/Stimulation/40Hz_higher_level_stats/tdof' 


#10 sec
python change_runs_to_contain_gp_name.py '/media/amr/HDD/Work/Stimulation/10Hz_10s_higher_level_stats/copes' 
python change_runs_to_contain_gp_name.py '/media/amr/HDD/Work/Stimulation/10Hz_10s_higher_level_stats/varcopes' 
python change_runs_to_contain_gp_name.py '/media/amr/HDD/Work/Stimulation/10Hz_10s_higher_level_stats/tdof' 


python change_runs_to_contain_gp_name.py '/media/amr/HDD/Work/Stimulation/20Hz_10s_higher_level_stats/copes' 
python change_runs_to_contain_gp_name.py '/media/amr/HDD/Work/Stimulation/20Hz_10s_higher_level_stats/varcopes' 
python change_runs_to_contain_gp_name.py '/media/amr/HDD/Work/Stimulation/20Hz_10s_higher_level_stats/tdof' 


python change_runs_to_contain_gp_name.py '/media/amr/HDD/Work/Stimulation/40Hz_10s_higher_level_stats/copes' 
python change_runs_to_contain_gp_name.py '/media/amr/HDD/Work/Stimulation/40Hz_10s_higher_level_stats/varcopes' 
python change_runs_to_contain_gp_name.py '/media/amr/HDD/Work/Stimulation/40Hz_10s_higher_level_stats/tdof' 
