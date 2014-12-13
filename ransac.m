
function [ H,inlier_ind ] = ransac( y1, x1, y2, x2, thresh )
%RANSAC_EST_HOMOGRAPHY Randomly sample matching points
%   then see how much of a match is found

numPts = size(y1,1);
last = 0;

for i = 1:200
    idx = randsample(numPts,4);
    mH = est_homography(x2(idx),y2(idx),x1(idx),y1(idx));
    [X, Y] = apply_homography(mH, x1, y1);
    
    dist = sqrt((X - x2).^2 + (Y - y2).^2);
    
    inliers = (dist<thresh);
    if (sum(inliers) > last)
        last = sum(inliers);
        % fprintf('sum: %d\n', last);
        inlier_ind = inliers;
    end
    
end

% H = est_homography(x2(inlier_ind),y2(inlier_ind),x1(inlier_ind),y1(inlier_ind));
% 
% end

end

