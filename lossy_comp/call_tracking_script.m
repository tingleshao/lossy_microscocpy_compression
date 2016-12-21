function [ output_args ] = call_tracking_script( search_frame_name, first_frame_name, out_name )
commandStr = ['tracking_scripts/Run_VST4 ', search_frame_name, ' ',first_frame_name, ' ', out_name]
%disp(commandStr);
[status, commandOut] = system(commandStr,'-echo');
%copyfile(strcat(out_name,'.csv'),'tracking_data/');
%copyfile(strcat(out_name,'.vrpn'),'tracking_data/');
%copyfile(strcat(out_name,'lottanerve_tmp.csv'),'tracking_data/');
%copyfile(strcat(out_name,'lottanerve_tmp.vrpn'),'tracking_data/');
end

