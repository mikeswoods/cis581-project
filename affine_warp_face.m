%%
% Estimates the affine transformation for a face using the given 
% source and target face points:
%
% source_XY        = Source face (x,y) points
% target_XY        = Target face (x,y) points
% ransac_threshold = RANSAC threshold; default is 3.0. If -1, no RANSAC
%                    will be used
function [T] = affine_warp_face(source_XY, target_XY, ransac_threshold) 

    if nargin ~= 3
        ransac_threshold = 3.0;
    end

    % Run RANSAC to remove outliers if ransac_threshold > 0
    if ransac_threshold > 0
        fprintf(1, '> affine_warp_face: Using RANSAC threshold %f\n', ransac_threshold);
        addpath('ransac');
        [~,I] = ransac(source_XY(:,1), source_XY(:,2) ...
                      ,target_XY(:,1), target_XY(:,2) ...
                      ,ransac_threshold);
        SX = source_XY(I,1);
        SY = source_XY(I,2);
        TX = target_XY(I,1);
        TY = target_XY(I,2);
    else
        fprintf(1, '> affine_warp_face: NO RANSAC\n');
        SX = source_XY(:,1);
        SY = source_XY(:,2);
        TX = target_XY(:,1);
        TY = target_XY(:,2);
    end

    % Construct an affine transformation from the matched points:
    T = fitgeotrans([SX, SY], [TX, TY], 'affine');
end
