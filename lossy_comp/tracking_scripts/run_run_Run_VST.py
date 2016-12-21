# this script runs run_Run_VST.py

import sys
import os

generate_frames_cmd = '''python run_experiment.py -v 17 -l 7'''

data_out_frames_dir = '''/afs/cs.unc.edu/home/cshao/compression_project/data_reduction_project/misc/Data_out/*'''

cp_data_out_cmd = '''cp ''' + data_out_frames_dir + ''' /playpen/cshao/tracking_test_set/beads_diffusing_out_of_focus_low_visc_200nm/compressed_dilate_7/'''
 
clear_data_out_cmd = '''rm -r ''' + data_out_frames_dir

cmd1 = '''python run_Run_VST.py -t /playpen/cshao/lossy_compression/search.pgm -u /playpen/cshao/3dmfs/3dfmAnalysis/pgm_data/video_data/frame0001.pgm -c /playpen/cshao/3dmfs/3dfmAnalysis/pgm_data/video_data_noise0/nframe0001.pgm -o out'''

# only for the case that you have the uncompressed video tracking data already
cmd2 = '''Run_VST_CompressCompare4 /playpen/cshao/lossy_compression/search.pgm /playpen/cshao/3dmfs/3dfmAnalysis/pgm_data/video_data_noise9/nframe0001.pgm out
'''
os.system(cmd2)



