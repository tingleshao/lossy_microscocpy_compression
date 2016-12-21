function [ output_args ] = run_exp( sim_save_file_name, orig_frame_dir, orig_video_file_name, save_exp_data_dir )
% steps of the lossy compression experiment: 
%   1. use cribb's code to generate one simulation (bead positions) 
%   2. use my code to genrate video (frames and video?) from the simulation 
%   3. use my code to genrate noisy videos (frames and video?) from the
%       video
%   4. use my code to track the noisy videos and save the tracking result 
%   5. using my code to track the original video and save the tracking
%   result 
%   6. use my code to compress the noisy videos and save the compressed
%   videos (frames and video?) 
%   7. use my code to add back noise to the compressed noisy videos 
%   8. use my code to track the compressed noisy videos
%   9. use my code to track the compressed noisy videos with noise added
%   back
%   10. use cribb's code to compute msd on the trackings:
%      10.1 msd on the original video tracking
%      10.2 msd on the noisy video tracking 
%      10.3 msd on the compressed noisy video tracking
%      10.4 msd on the compressed noisy video with noise added back
%      tracking 
%   11. plot and save the msds


% directories
exp_data_dir = 'exp_data/';
tracking_data_dir = 'tracking_data/';
comp_data_dir = 'comp_data/';
noise_back_data_dir = 'noise_back_data/';

old_orig_frame_dir = orig_frame_dir;
orig_frame_dir = strcat(exp_data_dir,orig_frame_dir);
% numbers 
n_of_noisy_videos = 10;
n_of_frames = 1800;
n_of_beads = 10;

% step 1, use cribb's code to generate one simulation 
% TODO: may change it to variable number of beads 
if ~exist(sim_save_file_name,'file');
    disp('generating the bead position...');
    bead_pos = generate_simulation(sim_save_file_name);
else
    disp('bead position already generated, loading it...');
    load(sim_save_file_name);
end

% step 2, use my code to generate video (frames and / or video) from the
% simulation
if ~exist(orig_frame_dir,'dir')
    mkdir(orig_frame_dir);
end
if ~exist(orig_video_file_name)
    disp('generating original video...');
    generate_video_from_data(bead_pos, orig_frame_dir, orig_video_file_name);
else
    disp('original video already generated, do nothing at this step')
end 

% step 3, use my code to genrate noisy videos from the original video
for i = 1:n_of_noisy_videos
   save_exp_data_dir_full = strcat(exp_data_dir, save_exp_data_dir, num2str(i));
   if ~exist(save_exp_data_dir_full,'dir')
      disp(strcat('creating the folder: ', save_exp_data_dir_full,' and generating noisy video...'));
      mkdir(save_exp_data_dir_full);
      generate_noisy_video_from_video(strcat(orig_frame_dir,'/frame0001.png'), n_of_frames, save_exp_data_dir_full);
      % create folders for the search dir 
      search_dir_name = strcat(save_exp_data_dir_full, '_search');
      mkdir(search_dir_name);
      copyfile(strcat(save_exp_data_dir_full,'/nframe0001.png'), search_dir_name);
      copyfile(strcat(save_exp_data_dir_full,'/nframe0002.png'), search_dir_name);
      copyfile(strcat(save_exp_data_dir_full,'/nframe0003.png'), search_dir_name);
   else
      disp(strcat('folder ', save_exp_data_dir_full, ' has already been created.'));
   end
end

% step 4, use my code to track the noisy videos and save the tracking
% result
for i = 1:n_of_noisy_videos
    save_exp_data_dir_full = strcat(exp_data_dir,save_exp_data_dir, num2str(i));
    search_frame_name = strcat(exp_data_dir,save_exp_data_dir_full, '_search/nframe0001.png');
    first_frame_name = strcat(exp_data_dir,save_exp_data_dir_full, '/nframe0001.png');
    out_name = strcat(tracking_data_dir, 'out_',save_exp_data_dir, num2str(i));
    if ~exist([out_name,'.csv'], 'file')
       disp(strcat('tracking from ', first_frame_name, '...'));
       call_tracking_script(search_frame_name, first_frame_name, out_name);
    else
       disp(strcat('the tracking result file for ', out_name, ' has already been created. do nothing'));
    end
end

% step 5, use my code to track the original video and save the tracking
% result 
search_dir = strcat(orig_frame_dir, '_search');
if ~exist(search_dir, 'dir')
    disp(strcat('making original video search frame dir: ', exp_data_dir,search_dir));
    mkdir(search_dir);
    % copy the frames for searching before tracking 
    copyfile(strcat(orig_frame_dir,'/frame0001.png'), search_dir);
    copyfile(strcat(orig_frame_dir,'/frame0001.png'), search_dir);
    copyfile(strcat(orig_frame_dir,'/frame0001.png'), search_dir);
    search_frame_name = strcat(search_dir, '/frame0001.png');
    first_frame_name = strcat(orig_frame_dir, '/frame0001.png');
    out_name = strcat(tracking_data_dir,'out_', old_orig_frame_dir);
    disp(strcat('tracking from ', first_frame_name, '...'));
    call_tracking_script(search_frame_name, first_frame_name, out_name);
else
    disp('seems like the tracking for the original frames has been done before, do nothing...');
end

% step 6, use my code to compress the noisy videos and save the compressed
% videos (frames and / or video)
for i = 1:n_of_noisy_videos
    save_exp_data_dir_full = strcat(save_exp_data_dir, num2str(i));
    input_first_frame_name = strcat(exp_data_dir, save_exp_data_dir_full, '/nframe0001.png');
    dilate = 5;
    threshold_in_percentage = 10;
    window_size = 1;
    hard_threshold = 70;
    output_dir = strcat(comp_data_dir,save_exp_data_dir_full, '_comp/');
    output_debug_dir = strcat(comp_data_dir,save_exp_data_dir_full, '_comp_debug/');
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
        mkdir(output_debug_dir);
        disp(strcat('compressing the data: ', save_exp_data_dir_full));
        call_compression_script( input_first_frame_name, dilate, threshold_in_percentage, window_size, hard_threshold, output_dir, output_debug_dir );
    else
        disp(strcat('data: ', save_exp_data_dir_full, 'has already been compressed, do nothing...'));
    end
end

% step 7, add back noise to the compressed noisy videos 
for i = 1:n_of_noisy_videos
    save_exp_data_dir_full = strcat(noise_back_data_dir, save_exp_data_dir, num2str(i));
    output_dir = strcat(comp_data_dir, save_exp_data_dir, num2str(i), '_comp/');
    output_debug_dir = strcat(comp_data_dir, save_exp_data_dir, num2str(i), '_comp_debug/');
    saved_comp_noiseback_frame_dir = strcat(save_exp_data_dir_full, '_noiseback');
    windowed = 0;
    use_float_point = 0;
    if ~exist(saved_comp_noiseback_frame_dir,'dir')
        mkdir(saved_comp_noiseback_frame_dir);
        disp(strcat('adding noise back, store at: ', saved_comp_noiseback_frame_dir));
        add_noise_back(output_dir, output_debug_dir, n_of_frames, saved_comp_noiseback_frame_dir, windowed, use_float_point); 
    else
        disp(strcat('the data with noise added back at ', saved_comp_noiseback_frame_dir, ' has already been created. Do nothing...'));
    end
end

% step 8, use my code to track the compressed noisy videos 
for i = 1:n_of_noisy_videos
    save_exp_data_dir_full = strcat(comp_data_dir, save_exp_data_dir, num2str(i));
    output_dir = strcat(save_exp_data_dir_full, '_comp');
    search_frame_name = strcat(save_exp_data_dir_full, '_comp_search/compressed_0000.pgm');
    first_frame_name = strcat(output_dir, '/compressed_0000.pgm');
    out_name = strcat(tracking_data_dir, 'out_',save_exp_data_dir, num2str(i),'_comp');
    if ~exist(search_frame_name, 'file')
       search_dir = strcat(save_exp_data_dir_full, '_comp_search/');
       mkdir(search_dir);
       copyfile([output_dir,'/compressed_0000.pgm'],search_dir);
       copyfile([output_dir,'/compressed_0001.pgm'],search_dir);
       copyfile([output_dir,'/compressed_0002.pgm'],search_dir);
       disp(['tracking from ', first_frame_name, '...']);
       call_tracking_script(search_frame_name, first_frame_name, out_name);
    else
       disp(['the tracking result file for ', out_name, ' has already been created. do nothing']);
    end
end

% step 9, use my code to track the comprssed noisy videos with noise added
% back 
for i = 1:n_of_noisy_videos
    save_exp_data_dir_full = strcat(noise_back_data_dir, save_exp_data_dir, num2str(i));
    saved_comp_noiseback_frame_dir = strcat(save_exp_data_dir_full, '_noiseback');
    search_frame_name = strcat(save_exp_data_dir_full, '_noiseback_search/cframe_noise0000.pgm');
    first_frame_name = strcat(saved_comp_noiseback_frame_dir, '/cframe_noise0000.pgm');
    out_name = strcat(tracking_data_dir, 'out_', save_exp_data_dir, num2str(i),'_noiseback');
    if ~exist(search_frame_name, 'file')
       search_dir = strcat(save_exp_data_dir_full, '_noiseback_search/');
       mkdir(search_dir);
       copyfile([saved_comp_noiseback_frame_dir,'/cframe_noise0000.pgm'],search_dir);
       copyfile([saved_comp_noiseback_frame_dir,'/cframe_noise0001.pgm'],search_dir);
       copyfile([saved_comp_noiseback_frame_dir,'/cframe_noise0002.pgm'],search_dir);
       disp(strcat('tracking from ', first_frame_name, '...'));
       call_tracking_script(search_frame_name, first_frame_name, out_name);
    else
       disp(strcat('the tracking result file for ', out_name, ' has already been created. do nothing'));
    end
end

% step 10, use cribb's code to compute msd on the trackings 
msd = compute_msd(tracking);

% step 11. plot and save the msds
plot_msd_vs_tou( msd );

end

