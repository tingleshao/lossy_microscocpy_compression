function [ msd ] = compute_msd(tracking_name_header, bead_id, save_msd_dir)
% this function reads the tracking data from: 
%   1. original tracking csv
%   2. noisy video tracking csv
%   3. compressed noisy video trackding csv
%   4. compressed noisy video with noise added back csv
% and also the beads true position
% 
% it then computes msd from these tracking values with different window
% sizes 
% and plots it 
% and saves the image

% probably it also does some error bar analysis. (later) 



addpath(genpath('/playpen/cshao/3dmfs/3dfmAnalysis/'));
addpath(genpath('/playpen/cshao/paper2_lossy_compression_code/'));
addpath(genpath('/playpen/cshao/paper2_lossy_compression_data/'));

% read the tracking data from .csv
msds = [];

tracking_dir = '/playpen/cshao/lossy_comp/tracking_data/';
msd_dir = save_msd_dir;
tracking_name = ['out_', tracking_name_header];

% =======================ORIGINAL NO COMPRESSION=======================
filemask = [tracking_dir, tracking_name, '_orig_video.csv'];

csvx = csvread(filemask,1,0);
% compute the MSD
t = 0:60/807:60-(60/807);
xo = csvx(csvx(:,2)==bead_id,3);
yo = csvx(csvx(:,2)==bead_id,4);
%y1 = zeros(size(x1));
data = [xo yo]; % retrieve one bead data from many 
window = [1 2 5 10 20 50 100 200 1000]; % default
[tau,msd_data_o,count] = msd(t, data, window);
disp "out:" 
msd_data_o;
%msds = [msds, msd_data];
%save(strcat('/playpen/cshao/paper2_lossy_compression_data/msd/msd',int2str(i),'.mat'), 'msd_data');

loglog(tau,msd_data_o,'ro','linewidth',4);
hold on ;

%box = [box, msd_data_o];

% ======================msd for tracking result on noisy data====================
for i = 1:n_of_noisy_videos
    filemask = [tracking_dir, tracking_name, '_', num2str(i), '.csv'];

    csvx = csvread(filemask,1,0);
    % compute the MSD
    t = 0:60/807:60-(60/807);
    x1 = csvx(csvx(:,2)==bead_id,3);
    y1 = csvx(csvx(:,2)==bead_id,4);

    x1(1)
    data = [x1 y1]; % retrieve one bead data from many 
    window = [1 2 5 10 20 50 100 200 1000]; % default
    [tau,msd_data,count] = msd(t, data, window);
   % disp 'out:' 
    %msd_data
    msds = [msds, msd_data];
    %save(strcat(save_msd_dir, '/msd',int2str(i),'.mat'), 'msd_data');

    loglog(tau,msds);
    %box = msds;
end

% add the curve from lossy compressed data 
% window size?
% threshold?

msds = [];
% ======================msd for tracking result on compressed data====================
for i = 1:n_of_noisy_videos
    filemask = [tracking_dir, tracking_name, '_', num2str(i), '_comp.csv'];

csvx = csvread(filemask,1,0);
% compute the MSD
t = 0:60/807:60-(60/807);
x1 = csvx(csvx(:,2)==bead_id,3);
y1 = csvx(csvx(:,2)==bead_id,4);
%y1 = zeros(size(x1));
data = [x1 y1]; % retrieve one bead data from many 
window = [1 2 5 10 20 50 100 200 1000]; % default
[tau,msd_data_c,count] = msd(t, data, window);
%disp "out:" 
%msd_data_c;
msds = [msds, msd_data_c];
%save(strcat('/playpen/cshao/paper2_lossy_compression_data/msd/msd',int2str(i),'.mat'), 'msd_data');
end
loglog(tau,msds,'b.');
% box = [box,msd_data_c];

msds = [];
% ======================msd for tracking result on compressed data with noise added back====================
for i = 1:n_of_noisy_videos
filemask = [tracking_dir, tracking_name, '_', num2str(i), '_noiseback.csv'];

csvx = csvread(filemask,1,0);
% compute the MSD
t = 0:60/807:60-(60/807);
xc = csvx(csvx(:,2)==bead_id,3);
yc = csvx(csvx(:,2)==bead_id,4);
%y1 = zeros(size(x1));
data = [xc yc]; % retrieve one bead data from many 
window = [1 2 5 10 20 50 100 200 1000]; % default
[tau,msd_data_c,count] = msd(t, data, window);
disp "out:" 
msds = [msds, msd_data_c];
%save(strcat('/playpen/cshao/paper2_lossy_compression_data/msd/msd',int2str(i),'.mat'), 'msd_data');
loglog(tau,msd_data_c,'kx','linewidth',1);
%box = [box,msd_data_c];

msds = [];
% ==================== TRUE VALUE =====================
true_value_file_name = [tracking_name,'.mat'];
load(true_value_file_name);
% compute the MSD
t = 0:60/807:60-(60/807);
% we must know the bead_id mapping, this can be computed or hardcoded 
true_value_bead_id = bead_id_map(bead_id);
x1 = csvx(csvx(:,2)==true_value_bead_id,4);
y1 = csvx(csvx(:,2)==true_value_bead_id,5);
%y1 = zeros(size(x1));
data = [x1 y1]; % retrieve one bead data from many 
window = [1 2 5 10 20 50 100 200 1000]; % default
[tau,msd_data_o,count] = msd(t, data, window);
disp "out:" 
msd_data_o;
%msds = [msds, msd_data];
%save(strcat('/playpen/cshao/paper2_lossy_compression_data/msd/msd',int2str(i),'.mat'), 'msd_data');

loglog(tau,msd_data_o,'go','linewidth',3);
%box = [box, msd_data_o];

hold off;
%figure;
%boxplot(log10(box(1:3,:)'),'notch','off');
%figure
%boxplot(log10(box(7:9,:)'),'notch','off');
% saveas(h,'test_h4.png','png');
end

