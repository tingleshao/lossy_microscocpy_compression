function [] = add_noise_back( first_frame_name, first_mask_name, n_of_frames, saved_frame_dir, windowed, use_float_point)
%
% this function does the following:
% for the given first frame name, and number of frames, it reads the
% frame name and add noise and save the new frame into the given dir.

% assume the frame file name format is xxx%04d.png

% noise consists of:
%                   Gaussian noise with mean 0 and std dev xxx 
%                   Posssion noise with lambda xxx 

%J = imnoise(I,'gaussian',m,v) adds Gaussian white noise of mean m and
%   variance v to the image I. The default is zero mean noise with 0.01 variance.

%J = imnoise(I,'poisson') generates Poisson noise from the data instead
%   of adding artificial noise to the data. If I is double precision, 
%   then input pixel values are interpreted as means of Poisson distributions
%   scaled up by 1e12. For example, if an input pixel has the value 5.5e-12, 
%   then the corresponding output pixel will be generated from a Poisson distribution
%   with mean of 5.5 and then scaled back down by 1e12. If I is single precision, the 
%   scale factor used is 1e6. If I is uint8 or uint16, then input pixel values are used 
%   directly without scaling. For example, if a pixel in a uint8 input has the value 10, 
%    then the corresponding output pixel will be generated from a Poisson distribution with mean 10.


if ~use_float_point
    frame_header = [first_frame_name,'compressed_'];
    mask_header = [first_mask_name, 'bin_diff_img.pgm'];
    mask_name = mask_header;
    for i = 0:n_of_frames-1
        frame_name = strcat(frame_header, sprintf('%04d',i), '.pgm');
        if windowed
            mask_name = strcat(mask_header, sprintf('%04d',i), '.pgm');
        end
        curr_img = imread(frame_name);
        curr_mask = imread(mask_name);
        
        % add noise
        noiseG = imnoise(curr_img,'gaussian');
        noiseP = imnoise(curr_img,'poisson');
        
        pureP = int16(noiseP) - int16(curr_img);
        pureG = int16(noiseG) - int16(curr_img);
        pureGP = (pureP + pureG);
        
        % only places with mask will have the noise added back.
        noiseGP = uint8(int16(curr_img) + int16(pureGP) .* int16((255-curr_mask)/255));
        
        imwrite(noiseGP,strcat(saved_frame_dir,'/cframe_noise',sprintf('%04d',i),'.pgm'));
    end
else
    % if we use the float point number image, we know the file name is:
    %   frame_f_xxxx.dat
    % in the same directory there should also be a assiciated sample in
    % window variance file:
    %   variance_f_xxxx.dat
    frame_header = first_frame_name(1:size(first_frame_name,2)-8);
    mask_header = first_mask_name(1:size(first_mask_name,2)-8);
    variance_header = strcat(first_frame_name(1:size(first_frame_name,2)-16), 'variance_f_');
    
    for i = 0:n_of_frames-1
        frame_name = strcat(frame_header, sprintf('%04d',i), '.dat');
        mask_name = strcat(mask_header, sprintf('%04d',i), '.pgm');
        variance_name = strcat(variance_header, sprintf('%04d',i), '.dat');
        
        curr_mask = imread(mask_name);
        % depending on the mask image size, we know the dimension of the
        % video frame and the variance image.
        w = size(curr_mask,2);
        h = size(curr_mask,1);
        curr_img = zeros(w,h);
        variance_img = zeros(w,h);
        
        curr_img_fid = fopen(frame_name,'r');
        variance_img_fid = fopen(variance_name, 'r');
        for j = 1:h
            for k = 1:w
                if curr_mask(j,k) == 0
                    curr_img(j,k) = fread(curr_img_fid,1,'*double');
                else
                    curr_img(j,k) = fread(curr_img_fid,1,'*uint8');
                end
                variance_img(j,k) = fread(variance_img_fid,1,'*double');
            end
        end
        % TODO: generate the noise based on the sample variance.
        % add noise
        noise = normrnd(0,sqrt(variance_img),[w,h]);
        
        % only places with mask will have the noise added back.
        noiseGP = uint8(int16(curr_img + noise) .* int16((255-curr_mask)/255));
        
        imwrite(noiseGP,strcat(saved_frame_dir,'/cframe_noise',sprintf('%04d',i),'.pgm'));
    end
end
end
