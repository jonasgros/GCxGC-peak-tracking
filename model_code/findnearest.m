% function [ind1, ind2, pass_flag] = findnearest(X1, X2, searchdist, xydistort);
%
% X1, an Nx3 array, corresponding to vectors of [x position, y position, z value]
% X2, an Mx3 array, corresponding to vectors of [x position, y position, z value]
% searchdist, a scalar
% xydistort, a scalar
%
% Given inputs X1 and X2, returns indices ind1 and ind2 which correspond to the
% set of nearest peaks between the sets. The index ind1 is the sorted index for
% X1, and the ind2 maps the peaks in X2 to the matches in X1. pass_flag is the
% vector which indicates whether a peak forms a match (pass_flag=1) or not (0).
% Hence X1(ind1(find(pass_flag))) matches X2(ind2(find(passflag)))
%
% The input term searchdist determines the radius of the search oval in the
% 1st dimension (x direction).
% 
% The input term xydistort determines the shape of the search oval in
% the 1st and 2nd dimensions. When xydistort = 1, the search oval is a circle.
% For xydistort = 2, the oval 2nd dimension diameter is half that of the 
% 1st dimension.
% 
% In practice, we have found that xydistort = 6 is a good setting.

function [ind1, ind2, pass_flag, disappeared_peaks] = findnearest(X1, X2, searchdist, xydistort); 
% New output: "diappeared_peaks", the peaks in the ref but not in the 
% target (same format as pass_flag).

N = length(X1);
pass_flag = zeros(N,1);
disappeared_peaks = zeros(N,1); % disappeared peaks, in X1.

for i_n = 1:N
dist = sqrt( (X1(i_n,1)-X2(:,1)).^2 + (xydistort*(X1(i_n,2)-X2(:,2))).^2 );
 mindist = min(dist);
 if (mindist < searchdist)
  pass_flag(i_n) = 1;
 else
     disappeared_peaks(i_n) = 1;
 end
 ind1(i_n) = i_n;
 ind2(i_n) = find(dist==mindist,1);
end

%sum(pass_flag)

% here, we check that multiple target peaks are not matches are not found 
% inside the search oval of the template
stat_1 = 0; % this is a counter how many times this happened
for i_n = 1:N
 if and(length(find(ind2==ind2(i_n))) > 1,sum(pass_flag(find(ind2==ind2(i_n))))>1)
  for i_f = find(ind2==ind2(i_n))
  pass_flag(i_f) = 0;
  stat_1 = stat_1 + 1;
  end
 end
end
% disp(['multiple target peaks within search oval leading to exclusion of (# peaks): ', num2str(stat_1)])

%sum(pass_flag)

% THIS PART IS NOW OBSELETE 
% for i_n = 1:N
% %  if (length(find(ind2==ind2(i_n))) > 1) && (pass_flag(i_n))
%   disp('WARNING. Duplicate peak found.'); 
%  end
% end

% remove template points too close to each other
stat_2 = 0;
for i_n = 1:N
 dist = sqrt( (X1(i_n,1)-X1(:,1)).^2 + (xydistort*(X1(i_n,2)-X1(:,2))).^2 ); 
 mindist = min(dist(find(1:N~=i_n)));
 if (mindist < 1.01*searchdist)
  pass_flag(i_n) = 0;
  stat_2 = stat_2 + 1;
 end
end
% disp(['template peaks too close to each other (within search oval leading to exclusion of (# peaks)): ', num2str(stat_2)])



%sum(pass_flag)


