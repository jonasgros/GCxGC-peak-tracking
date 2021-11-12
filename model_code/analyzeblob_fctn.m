
function [Peak_matched_1, Peak_matched_2, disappeared_peaks] = analyzeblob_fctn(Peak_Table_1, Peak_Table_2, varargin)

% This function matches peaks between two peak lists based on the method
% of Wardlaw et al. 2008, as updated. 
% 
% INPUTS:
% 
% - 'Peak_Table_1': a first peak table (3 columns:
% retention time in 1st D (min); rentention time in 2nd D (s); integrated
% FID signal. This is the template peak list
% 
% - 'Peak_Table_2': a second peak table (3 columns:
% retention time in 1st D (min); rentention time in 2nd D (s); integrated
% FID signal. This is the target peak list.
% 
% OPTIONAL INPUTS:
% 
% - 'searchdist': the search distance. Unit: minutes.
% 
% - 'plotflag': 1 for plots, 0 for no plots.
% 
% - 'unit1D': either 's' or 'min'. Default is 'min'. Use 's' if you want to
% provide the first dimension retention times in units of seconds.
% 
% OUTPUTS:
% 
% - 'Peak_matched_1': matched peaks in Peak_Table_1. (Same structure, just
% the matched lines are kept).
% 
% - 'Peak_matched_2': matched peaks in Peak_Table_2. (Same structure, just
% the matched lines are kept).
% Authors : J. Samuel Arey and Jonas Gros.

% DEFAULTS:
% clear;
plotflag = 1;
searchdist = 0.28;
unit1D = 'min';
xydistort = 2.;

% First, if ever the user used some options, give their values to the
% corresponding variables:
for i=1:2:length(varargin)
    if strcmpi(varargin{i},'searchdist') % search distance
        searchdist=varargin{i+1};
    elseif strcmpi(varargin{i},'plotflag')
        plotflag = varargin{i+1}; % plot flag
    elseif strcmpi(varargin{i},'unit1D')
        unit1D = varargin{i+1}; % plot flag
	elseif strcmpi(varargin{i},'xydistort')
        xydistort = varargin{i+1}; % plot flag
    else
        error(['The option ''' varargin{i} ''' is unknown'])
    end
end


X1 = Peak_Table_1; 
X2 = Peak_Table_2; 

if strcmpi(unit1D, 's')
    X1(:,1) = X1(:,1)/60;
    X2(:,1) = X2(:,1)/60;
end


i1 = find(X1(:,3)>0);
i2 = find(X2(:,3)>0);

% find matched peaks
[x1, x2, c1, c2, disappeared_peaks] = track_peaks( X1(i1,:), X2(i2,:), searchdist, plotflag, xydistort); 

if plotflag
    figure; plot(x1(:,1),x1(:,2),'*');
    hold on; plot(x2(:,1),x2(:,2),'g^');
 for i_C = 1:length(x1)
    plot([x1(i_C,1) x2(i_C,1)], [x1(i_C,2) x2(i_C,2)]);
 end
 hold off;
 title('tracked peaks');
 xlabel('1st dimension'); ylabel('2nd dimension');
 legend('sample 1','sample 2');
end

Peak_matched_1 = x1;
Peak_matched_2 = x2;

if strcmpi(unit1D, 's') % Go back to the unit of seconds used in the input.
    Peak_matched_1(:,1) = Peak_matched_1(:,1)*60;
    Peak_matched_2(:,1) = Peak_matched_2(:,1)*60;
    disappeared_peaks(:,1) = disappeared_peaks(:,1)*60;
end


