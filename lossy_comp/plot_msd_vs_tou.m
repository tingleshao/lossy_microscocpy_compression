% this script is an example of reading tracking data from a .csv file, and 
%   compute the MSD based on the result, and plot the MSD curves.

addpath(genpath('/playpen/cshao/3dmfs/3dfmAnalysis/'));
addpath(genpath('/playpen/cshao/paper2_lossy_compression_code/'));
addpath(genpath('/playpen/cshao/paper2_lossy_compression_data/'));

% read the tracking data from .csv
msds = [];
box = [];
input_id = 4;
for i = 0:9
filemask = strcat('/playpen/cshao/paper2_lossy_compression_data/tracking_result/data_group3/noise', int2str(i), '/out_n', int2str(i),'.csv');
frame_rate = 30; % verify it from the csv 
xyzunits = 'pixels';
calib_um = 1; % default
absolute_pos = 'absolute';
tstamps = 'no';
table = 'struct'; 
[v, calout] = load_video_tracking(filemask, frame_rate, xyzunits, calib_um, absolute_pos, tstamps, table);

% retrieve the things inside v
id = v.id;
t = v.t;
frame = v.frame;
x = v.x;
y = v.y;
z = v.z;
roll = v.roll;
pitch = v.pitch;
yaw = v.yaw;
csvx = csvread(filemask,1,0);
% compute the MSD
t = 0:60/807:60-(60/807);
x1 = csvx(csvx(:,2)==input_id,3);
y1 = csvx(csvx(:,2)==input_id,4);
%y1 = zeros(size(x1));

x1(1)
data = [x1 y1]; % retrieve one bead data from many 
window = [1 2 5 10 20 50 100 200 1000]; % default
[tau,msd_data,count] = msd(t, data, window);
disp "out:" 
msd_data;
msds = [msds, msd_data];
save(strcat('/playpen/cshao/paper2_lossy_compression_data/msd/msd',int2str(i),'.mat'), 'msd_data');
end

loglog(tau,msds);
hold on ;
box = msds;
% add the curve from lossy compressed data 
% window size?
% threshold?

% ==========================================================
% ======================NOISE 1 COMPRESSION dil 3====================
filemask = strcat('/playpen/cshao/paper2_lossy_compression_data/tracking_result/data_group3/noise1_comp_dil3/out_n1_comp_dil3.csv');
frame_rate = 30; % verify it from the csv 
xyzunits = 'pixels';
calib_um = 1; % default
absolute_pos = 'absolute';
tstamps = 'no';
table = 'struct'; 
[v, calout] = load_video_tracking(filemask, frame_rate, xyzunits, calib_um, absolute_pos, tstamps, table);

% retrieve the things inside v
id = v.id;
t = v.t;
frame = v.frame;
x = v.x;
y = v.y;
z = v.z;
roll = v.roll;
pitch = v.pitch;
yaw = v.yaw;
csvx = csvread(filemask,1,0);
% compute the MSD
t = 0:60/807:60-(60/807);
x1 = csvx(csvx(:,2)==input_id,3);
y1 = csvx(csvx(:,2)==input_id,4);
%y1 = zeros(size(x1));
data = [x1 y1]; % retrieve one bead data from many 
window = [1 2 5 10 20 50 100 200 1000]; % default
[tau,msd_data_c,count] = msd(t, data, window);
disp "out:" 
msd_data_c;
%msds = [msds, msd_data];
%save(strcat('/playpen/cshao/paper2_lossy_compression_data/msd/msd',int2str(i),'.mat'), 'msd_data');

loglog(tau,msd_data_c,'b.');
box = [box,msd_data_c];

% ==========================================================
% ======================NOISE 1 COMPRESSION dil5====================
filemask = strcat('/playpen/cshao/paper2_lossy_compression_data/tracking_result/data_group3/noise1_comp_dil5/out_n1_comp_dil5.csv');
frame_rate = 30; % verify it from the csv 
xyzunits = 'pixels';
calib_um = 1; % default
absolute_pos = 'absolute';
tstamps = 'no';
table = 'struct'; 
[v, calout] = load_video_tracking(filemask, frame_rate, xyzunits, calib_um, absolute_pos, tstamps, table);

% retrieve the things inside v
id = v.id;
t = v.t;
frame = v.frame;
x = v.x;
y = v.y;
z = v.z;
roll = v.roll;
pitch = v.pitch;
yaw = v.yaw;
csvx = csvread(filemask,1,0);
% compute the MSD
t = 0:60/807:60-(60/807);
xc = csvx(csvx(:,2)==input_id,3);
yc = csvx(csvx(:,2)==input_id,4);
%y1 = zeros(size(x1));
data = [xc yc]; % retrieve one bead data from many 
window = [1 2 5 10 20 50 100 200 1000]; % default
[tau,msd_data_c,count] = msd(t, data, window);
disp "out:" 
msd_data_c;
%msds = [msds, msd_data];
%save(strcat('/playpen/cshao/paper2_lossy_compression_data/msd/msd',int2str(i),'.mat'), 'msd_data');

loglog(tau,msd_data_c,'k.');
box = [box,msd_data_c];

% ==========================================================
% ======================NOISE 1 COMPRESSION NOISE BACK====================
filemask = strcat('/playpen/cshao/paper2_lossy_compression_data/tracking_result/data_group3/noise1_comp_dil5_noiseback/out_n1_comp_dil5_noiseback.csv');
frame_rate = 30; % verify it from the csv 
xyzunits = 'pixels';
calib_um = 1; % default
absolute_pos = 'absolute';
tstamps = 'no';
table = 'struct'; 
[v, calout] = load_video_tracking(filemask, frame_rate, xyzunits, calib_um, absolute_pos, tstamps, table);

% retrieve the things inside v
id = v.id;
t = v.t;
frame = v.frame;
x = v.x;
y = v.y;
z = v.z;
roll = v.roll;
pitch = v.pitch;
yaw = v.yaw;
csvx = csvread(filemask,1,0);
% compute the MSD
t = 0:60/807:60-(60/807);
xc = csvx(csvx(:,2)==input_id,3);
yc = csvx(csvx(:,2)==input_id,4);
%y1 = zeros(size(x1));
data = [xc yc]; % retrieve one bead data from many 
window = [1 2 5 10 20 50 100 200 1000]; % default
[tau,msd_data_c,count] = msd(t, data, window);
disp "out:" 
msd_data_c;
%msds = [msds, msd_data];
%save(strcat('/playpen/cshao/paper2_lossy_compression_data/msd/msd',int2str(i),'.mat'), 'msd_data');
loglog(tau,msd_data_c,'kx','linewidth',1);

% ==========================================================
% ======================NOISE 11 COMPRESSION NOISE BACK ( smaller noise) ====================
% filemask = strcat('/playpen/cshao/paper2_lossy_compression_data/tracking_result/data_group2/noise0_comp_back/out_n0_comp_dil3_noiseback.csv');
% frame_rate = 30; % verify it from the csv 
% xyzunits = 'pixels';
% calib_um = 1; % default
% absolute_pos = 'absolute';
% tstamps = 'no';
% table = 'struct'; 
% [v, calout] = load_video_tracking(filemask, frame_rate, xyzunits, calib_um, absolute_pos, tstamps, table);
% 
% % retrieve the things inside v
% id = v.id;
% t = v.t;
% frame = v.frame;
% x = v.x;
% y = v.y;
% z = v.z;
% roll = v.roll;
% pitch = v.pitch;
% yaw = v.yaw;
% 
% % compute the MSD
% t = 0:60/807:60-(60/807);
% x1 = x(id==input_id);
% y1 = y(id==input_id);
% %y1 = zeros(size(x1));
% data = [x1 y1]; % retrieve one bead data from many 
% window = [1 2 5 10 20 50 100 200 1000]; % default
% [tau,msd_data_c,count] = msd(t, data, window);
% disp "out:" 
% msd_data_c;
% %msds = [msds, msd_data];
% %save(strcat('/playpen/cshao/paper2_lossy_compression_data/msd/msd',int2str(i),'.mat'), 'msd_data');
% 
% loglog(tau,msd_data_c,'go','linewidth',4);


% ==========================================================
% ====================ORIGINAL NO COMPRESSION==========================
filemask = strcat('/playpen/cshao/paper2_lossy_compression_data/tracking_result/data_group3/orig/out_orig.csv');
frame_rate = 30; % verify it from the csv 
xyzunits = 'pixels';
calib_um = 1; % default
absolute_pos = 'absolute';
tstamps = 'no';
table = 'struct'; 
[v, calout] = load_video_tracking(filemask, frame_rate, xyzunits, calib_um, absolute_pos, tstamps, table);

% retrieve the things inside v
id = v.id;
t = v.t;
frame = v.frame;
x = v.x;
y = v.y;
z = v.z;
roll = v.roll;
pitch = v.pitch;
yaw = v.yaw;
csvx = csvread(filemask,1,0);
% compute the MSD
t = 0:60/807:60-(60/807);
xo = csvx(csvx(:,2)==input_id,3);
yo = csvx(csvx(:,2)==input_id,4);
%y1 = zeros(size(x1));
data = [xo yo]; % retrieve one bead data from many 
window = [1 2 5 10 20 50 100 200 1000]; % default
[tau,msd_data_o,count] = msd(t, data, window);
disp "out:" 
msd_data_o;
%msds = [msds, msd_data];
%save(strcat('/playpen/cshao/paper2_lossy_compression_data/msd/msd',int2str(i),'.mat'), 'msd_data');

loglog(tau,msd_data_o,'ro','linewidth',4);
%box = [box, msd_data_o];

% ==================== TRUE VALUE =====================
filemask = strcat('sim3.csv');
frame_rate = 30; % verify it from the csv 
xyzunits = 'pixels';
calib_um = 1; % default
absolute_pos = 'absolute';
tstamps = 'no';
table = 'struct'; 
[v, calout] = load_video_tracking(filemask, frame_rate, xyzunits, calib_um, absolute_pos, tstamps, table);

% retrieve the things inside v
id = v.id;
t = v.t;
frame = v.frame;
x = v.x;
y = v.y;
z = v.z;
roll = v.roll;
pitch = v.pitch;
yaw = v.yaw;
csvx = csvread(filemask,0,0);
% compute the MSD
t = 0:60/807:60-(60/807);
input_id = 10;
x1 = csvx(csvx(:,2)==input_id,3);
y1 = csvx(csvx(:,2)==input_id,4);
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

% ==========================================================
% ====================ORIGINAL COMPRESSION==========================
% filemask = strcat('/playpen/cshao/paper2_lossy_compression_data/tracking_result/data_group2/orig_comp/out_dil3.csv');
% frame_rate = 30; % verify it from the csv 
% xyzunits = 'pixels';
% calib_um = 1; % default
% absolute_pos = 'absolute';
% tstamps = 'no';
% table = 'struct'; 
% [v, calout] = load_video_tracking(filemask, frame_rate, xyzunits, calib_um, absolute_pos, tstamps, table);
% 
% % retrieve the things inside v
% id = v.id;
% t = v.t;
% frame = v.frame;
% x = v.x;
% y = v.y;
% z = v.z;
% roll = v.roll;
% pitch = v.pitch;
% yaw = v.yaw;
% 
% % compute the MSD
% t = 0:60/807:60-(60/807);
% x1 = x(id==input_id);
% y1 = y(id==input_id);
% %y1 = zeros(size(x1));
% data = [x1 y1]; % retrieve one bead data from many 
% window = [1 2 5 10 20 50 100 200 1000]; % default
% [tau,msd_data_oc,count] = msd(t, data, window);
% disp "out:" 
% msd_data_oc;
% %msds = [msds, msd_data];
% %save(strcat('/playpen/cshao/paper2_lossy_compression_data/msd/msd',int2str(i),'.mat'), 'msd_data');
% 
% h = loglog(tau,msd_data_oc,'g.');
hold off;
figure;
boxplot(log10(box(1:3,:)'),'notch','off');
figure
boxplot(log10(box(7:9,:)'),'notch','off');
% saveas(h,'test_h4.png','png');

