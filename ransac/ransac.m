%% RANSAC
% y1,x1,y2,x2 = corresponding point coordinate vectors N x 1 such that 
%               (x1i,y1i) matches (x2i,y2i) after a preliminary matching. 
%               (Blue points in example image)
% thresh      = the threshold on distance used to determine if transformed 
%               points agree
% H           = the 3 x 3 matrix computed in final step of RANSAC.
% inlier_ind  = n x 1 vector with indices of points in the arrays 
%               x1, y1, x2, y2 that were found to be the inliers.
function [H,inlier_ind] = ransac(y1, x1, y2, x2, thresh)

    % By default, the predicted location of a pixel can be no further than
    % thresh pixels away from its actual location in order to be considered
    % a match
    if nargin < 5 || thresh <= 0
        thresh = 3;
    end

    if numel(y1) ~= numel(x1) && numel(y2) ~= numel(x2)
        error('numel(y1) ~= numel(x1) && numel(y2) ~= numel(x2)');
    end
    
    N = 7500;
    k = numel(x1);
    mostPassing = 0;
    
    for i=1:N

        % Pick 4 indices at random
        PICK = randi([1, k], 1, 4);

        % Construct a homographic matrix from the sampled set
        maybeH = est_homography(x2(PICK), y2(PICK), x1(PICK), y1(PICK));

        % Apply H to all points 
        [xPred,yPred] = apply_homography(maybeH, x1, y1);

        % Compute the SSD between the predicted destination points and the
        % actual destination points
        P = [yPred, xPred];
        Q = [y2, x2];
        
        SSD    = sum((Q - P) .^ 2, 2);
        good   = SSD < thresh;
        passed = nnz(good);
        
        if passed > mostPassing
            mostPassing = passed;
            inlier_ind  = good;
        end
    end

    fprintf(1, 'Estimated homography: threshold=%d, passing features = %d\n' ...
             , thresh, mostPassing);
    inlier_ind = find(inlier_ind);
    
    % Finally, compute a more accurate homography using all of the inliers:
    H = est_homography(x2(inlier_ind), y2(inlier_ind), x1(inlier_ind), y1(inlier_ind));
end
