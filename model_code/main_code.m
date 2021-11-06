% main_code.m script called from "main.m" by user.
% 
% *** Do not modify this file. Normally the user should not need to adjust *** 
% *** anything in this script.                                             ***
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Authors : Jonas Gros and J. Samuel Arey.
% See license terms stated in file:
% LICENSE.txt
% 
% Please cite the following article when publishing any results obtained
% by use of this software. 
% 
% Wardlaw, G. D., Arey, J. S., Reddy, C. M., Nelson, R. K., Ventura, G. T., 
% Valentine, D. L., "Disentangling oil weathering at a marine seep using GCxGC: 
% Broad metabolic specificity accompanies subsurface petroleum biodegradation", 
% Environmental Science & Technology, 42, 19, 7166-7173, 2008.
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%


% Display some text for the user:

disp(' ')
disp(' ')
disp('---------------------------------------------------------')
disp(' ')
disp('Please cite the following article when publishing any results')
disp('obtained by use of this software:')
disp(' ')
disp('Wardlaw, G. D., Arey, J. S., Reddy, C. M., Nelson, R. K., Ventura, G. T., ')
disp('Valentine, D. L., "Disentangling oil weathering at a marine seep using GCxGC: ')
disp('Broad metabolic specificity accompanies subsurface petroleum biodegradation", ')
disp('Environmental Science & Technology, 42, 19, 7166-7173, 2008.')
disp('<a href = "https://pubs.acs.org/doi/10.1021/es8013908">(hyperlink)</a>');
disp(' ')
disp(' ')
disp('---------------------------------------------------------')
disp(' ')
disp(' ')

% A few error checks:
if ~exist(['../',input_path,template_peak_list_file],'file')
    error(['template peak list file (',['../',input_path,template_peak_list_file],' ) does not exist.'])
end
if ~exist(['../',input_path,target_peak_list_file],'file')
    error(['target peak list file (',['../',input_path,target_peak_list_file],' ) does not exist.'])
end
if ~exist(['../',output_path],'dir')
    warning(['Indicated output directory, ''',...
        output_path,''' does not exist... Creating it.'])
    mkdir(['../',output_path])
end
% Check if allowed to write to the output_path:
[stat,CcC] = fileattrib(['../',output_path]); 
if ~CcC.UserWrite
    error(['Matlab is not allowed to write to the output_path folder...',...
        ' Try displacing the folder! (e.g. to ''Desktop'' on a Windows computer)'])
end

% Import peak table:

template_peak_list = importdata([strrep(pwd,'model_code',''),input_path,...
    template_peak_list_file]);
target_peak_list = importdata([strrep(pwd,'model_code',''),input_path,...
    target_peak_list_file]);
	
% Check if the import succeeded:
if or(size(template_peak_list,2)~=3, size(target_peak_list,2)~=3)
    error('peak list format not understood. Please provide them as text file with three columns as described in the documentation')
end

[matched_template, matched_target, disappeared_peaks1] = analyzeblob_fctn(template_peak_list, ...
            target_peak_list, 'unit1D', 'min', 'searchdist', search_dist,...
			'plotflag', plot_flag, 'xydistort', x_to_y_ratio);
if match_disappeared_peaks==1 % (if we enable disappeared peaks)
    % Add the disappeared peaks to the matched peaks:
    matched_template =[matched_template;disappeared_peaks1];
    matched_target =[matched_target;[disappeared_peaks1(:,1:2),0*disappeared_peaks1(:,3) - 9999]];
end


%if strcmpi(prompt_output,'minimal')
    save_flag = 1;
%else
%    disp('Save matched peaks? (1 = yes, 0 = no)')
%    save_flag = input('');
%end

if save_flag
    
	if ~strcmpi(prompt_output,'minimal')
	    if exist(['../',output_path,Output_file_name],'file')
			choice_i = input('output file already exist. Replace? (1 for yes, 0 for no)');
			if choice_i==0
			    save_flag = 0;
			else
			    disp(' ')
                disp('Saving output file...')
			end
        end
    end
    if save_flag
        dlmwrite(['../',output_path, Output_file_name],[matched_template,matched_target(:,3)],'precision','%20.20f')
    end    
end

if ~strcmpi(prompt_output,'minimal')
    disp('minimum peak volume in the template peak list:')
    disp(min(template_peak_list(:,3)))
    disp('minimum peak volume in the target peak list:')
    disp(min(target_peak_list(:,3)))
end

