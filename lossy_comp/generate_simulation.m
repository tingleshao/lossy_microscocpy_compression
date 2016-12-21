function [bead_pos] = generate_simulation( sim_save_filename )

addpath(genpath('/playpen/cshao/lossy_comp/'));
addpath(genpath('/playpen/cshao/3dmfs/3dfmAnalysis/specific/modeling/'));
addpath(genpath('/playpen/cshao/3dmfs/3dfmAnalysis/'));


a = struct();
bead_pos = sim_video_diff_expt([],a);
save(sim_save_filename,'bead_pos');
%generate_video_from_data(bead_pos);
