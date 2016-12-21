function [ output_args ] = call_compression_script( input_first_frame_name, dilate, threshold_in_percentage, window_size, hard_threshold, output_dir, debug_output_dir )
commandStr = ['/afs/cs.unc.edu/home/cshao/compression_project/dr_run/data_reduction/dr new_img -i ', input_first_frame_name, ' ', num2str(dilate), ' ', num2str(threshold_in_percentage), ' ', num2str(window_size), ' ', num2str(hard_threshold), ' ', output_dir, ' ', debug_output_dir]
[status, commandOut] = system(commandStr, '-echo');
end

