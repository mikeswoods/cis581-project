%%
% Estimates the affine transformation for a face using the given 
% source and target face points:
%
% source_XY        = Source face (x,y) points
% target_XY        = Target face (x,y) points
% ransac_threshold = RANSAC threshold; default is 3.0
function [T, HULL] = affine_warp_face(source_XY, target_XY, ransac_threshold) 

    if nargin ~= 3
        ransac_threshold = 3.0;
    end

    % Compute the convex hull of the scaled face:
    k    = convhull(source_XY(:,1), source_XY(:,2));
    HULL = [source_XY(k,1), source_XY(k,2)];
    
    % Run RANSAC to remove outliers:
    addpath('ransac');
    [~,I] = ransac(source_XY(:,1), source_XY(:,2) ...
                  ,target_XY(:,1), target_XY(:,2) ...
                  ,ransac_threshold);
    
    % Construct a transformation from the matched points:
    T = fitgeotrans([source_XY(I,1), source_XY(I,2)] ...
                   ,[target_XY(I,1), target_XY(I,2)] ...
                   ,'affine');
end
