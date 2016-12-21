addpath(genpath('/playpen/cshao/paper2_lossy_compression_code/'));
addpath(genpath('/playpen/cshao/3dmfs/3dfmAnalysis/specific/modeling/'));
addpath(genpath('/playpen/cshao/3dmfs/3dfmAnalysis/'));

data_dir = '/playpen/cshao/paper2_lossy_compression_data/pgm_data/';

save_data_dir = '/playpen/cshao/paper2_lossy_compression_data/';

path = '/playpen/cshao/paper2_lossy_compression_data/';
gen_orig_video = 1;
gen_noisy_video_from_video = 0;
add_noise =0;

if gen_orig_video + gen_noisy_video_from_video + add_noise > 1
    disp 'not valid option' ;
    quit();
end 

if gen_orig_video
    a = struct();
    xxx = sim_video_diff_expt([],a);
    save('sim1.mat','xxx');
    generate_video_from_data(xxx);
end

if gen_noisy_video_from_video
    for k=0:9
        generate_noisy_video_from_video(strcat(path, 'video_data3/frame0001.png'), 1800, strcat(path,'video_data3_noise',int2str(k)));
    end
end

if add_noise
    add_noise_back(strcat(path,'pgm_data/data_group_3/video_data_comp_noise2_dil5_debug_imgs/frame_f_0000.dat'), ...
    '/playpen/cshao/paper2_lossy_compression_data/pgm_data/data_group_3/video_data_comp_noise2_dil5_debug_imgs/bin_map_0000.pgm', ...
    1800, strcat(path,'pgm_data/data_group_3/video_data_comp_noise2_dil5_noiseback/'),1);
end
