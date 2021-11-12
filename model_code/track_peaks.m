% function [x1, x2, c1, c2] = track_peaks(X1, X2, search_rad, plotflag, xydistort)
%
% X1, an Nx3 array, corresponding to vectors of [x position, y position, z value]
% X2, an Mx3 array, corresponding to vectors of [x position, y position, z value]
% searchdist, a scalar
% xydistort, a scalar
%
% Given inputs X1 and X2, returns sub-arrays x1 and x2, which are the matched peaks
% in the same format as X1 and X2, such that x1(i,:) is matched to x2(i,:). 
% Indices c1 and c2 are also returned, which correspond to x1 = X1(c1) and 
% x2 = X2(c2). The index c1 is the sorted index for X1, and the c2 maps the peaks 
% in X2 to the matches in X1. 
%
% The input term searchdist determines the radius of the search oval in the
% 1st dimension (x direction).
% Authors : J. Samuel Arey and Jonas Gros.

function [x1, x2, c1, c2, disappeared_peaks] = track_peaks(X1, X2, searchdist, plotflag, xydistort);

% run search to find matches using the findnearest() function

% forward search 
[i11,i12,pf1, disappeared_peaks1] = findnearest(X1,X2,searchdist,xydistort); 

% backward search
[i21,i22,pf2, disappeared_peaks2] = findnearest(X2,X1,searchdist,xydistort);

% global index of accepted points
ired11 = i11(pf1==1);   % sample 1, run 1
ired12 = i12(pf1==1);   % sample 2, run 1
ired21 = i21(pf2==1);   % sample 1, run 2
ired22 = i22(pf2==1);   % sample 2, run 2

% For disappeared peaks, we consider just pass 1, because the reference is
% the one that can disappear, not the other way round:
disappeared_peaks = X1(disappeared_peaks1==1, :);

% tabulate rank shift of tracked peaks
shift1 = ired11-ired12;   % run 1; shift of going from sample 1 to sample 2
shift2 = ired22-ired21;   % run 2; shift of going from sample 2 to sample 1

% Find the intersection of accepted sets in the forward and backward runs
% in three steps (A,B,C)

% A. find intersection of template pts in run 1 (11), target pts in run 2 (22)
[C1,IA1,IB1] = intersect(ired11,ired22);

% B. find intersection of target pts in run 1 (12), template pts in run 2 (21)
[C2,IA2,IB2] = intersect(ired21,ired12);

% C. make sure that both intersections correspond to the same matches.
% If both the forward and backward runs produce the same matches, then we
% should find that shift1(i) = shift2(i).
mismatchcount1 = 0;
for i_C1 = 1:length(C1)
 if shift1(ired11==C1(i_C1)) ~= shift2(ired22==C1(i_C1))
  mismatchcount1 = mismatchcount1+1;
  mismatches1(mismatchcount1) = C1(i_C1);
 end
end
if mismatchcount1
 for i_C1 = 1:mismatchcount1
  C1 = C1(C1~=mismatches1(i_C1));
 end
end

mismatchcount2 = 0;
for i_C2 = 1:length(C2)
 if shift1(ired12==C2(i_C2)) ~= shift2(ired21==C2(i_C2))
  mismatchcount2 = mismatchcount2+1;
  mismatches2(mismatchcount2) = C2(i_C2);
 end
end
if mismatchcount2
 for i_C2 = 1:mismatchcount2
  C2 = C2(C2~=mismatches2(i_C2));
 end
end

% A confirmation test that C1 and C2 now contain redundant information:
% They should be the same length.
if length(C1) ~= length(C2)
 disp('ERROR. UNRESOLVABLE MISMATCH FOUND. (ERROR TYPE 1)');
end

% A better confirmation test that C1 and C2 now contain redundant information:
% We should find exactly one match in C2 for every element i_C in the vector
% ired12(find(C1(i_C)==ired11))
for i_C = 1:length(C2)
 if length( find(C2 == ired12(find(C1(i_C)==ired11))) ) ~= 1
  disp('ERROR. UNRESOLVABLE MISMATCH FOUND. (ERROR TYPE II)');
 end
end

% Hence we need only the index C1 to set the final accepted match set x1 x2, 
% from the original match set X1 X2
for i_C = 1:length(C1)
 c1(i_C) = C1(i_C);
 c2(i_C) = ired12(find(C1(i_C)==ired11));
 x1(i_C,:) = X1(c1(i_C),:);
 x2(i_C,:) = X2(c2(i_C),:);
end

sum_of_passes = length(C1);

[error_hist1, dx1] = hist(x1(:,1)-x2(:,1),100);
[error_hist2, dx2] = hist(x1(:,2)-x2(:,2),100);

if plotflag
 figure; plot(dx1, error_hist1); grid; 
 xlabel('distance'); ylabel('number of points');
 title('histogram of peak shifting, 1st dim');

 figure; plot(dx2, error_hist2); grid;
 xlabel('distance'); ylabel('number of points');
 title('histogram of peak shifting, 2nd dim');
end


