
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Authors : J. Samuel Arey and Jonas Gros.
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
% 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

% -----------------------------------------------------------------------------
% ALL PROGRAM PARAMETERS THAT SHOULD BE SET BY THE USER ARE SHOWN HERE.
	
% ALGORITHM PARAMETERS
	
	% choose the search distance along the first dimension for the search oval:
	search_dist = 0.15; % (min)
    
	% the x-to-y ratio of the size of the search oval; unit (min/s).:
	x_to_y_ratio = 2;
	
	% decide whether to enable peaks to disappear. If set to a value of 1, an absence of any
	% peak in the target peak list within the search oval of a peak in the template chromatogram
	% is considered a successful match for a disappeared peak. This option should only be set to 1
	% if peak disappearance is expected. Also, please consider that the search oval size
	% must be chosen with care to avoid generating "false" disappeared peaks.
	match_disappeared_peaks = 1;

% INPUT/OUTPUT PARAMETERS

    % Set plot_flag to a value of 0 to suppress plots.
    % Set to a value of 1 to see "normal" level of plotting (DEFAULT).
    plot_flag = 1;

    % Set the output file path
    output_path = 'users/output/';

    % Set the input file path
    input_path = 'users/input/';

    % Name of reference peak list input file (first, reference peak table):
    reference_peak_list_file = 'file1.csv';
	
	% Name of target peak list input file (second peak table):
    target_peak_list_file = 'file2.csv';
	
	% Name of output file:
	Output_file_name = 'tracked_peaks.csv';

    % Set Matlab console output level. Choose: 'minimal', 'normal', or 'verbose'.
    prompt_output = 'normal';

% -----------------------------------------------------------------------------
% Do not modify the lines below.

cd('..');

addpath model_code

cd('model_code')

run main_code;

cd('../users');



