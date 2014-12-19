%%
% Given two sets of matched face points, this function returns the 
% the convex hull for each face, ensuring that each convex hull consists
% of the same number of points
function [out_X1, out_Y1, out_X2, out_Y2] = find_min_convex_hull(X1, Y1, X2, Y2)

    k1 = convhull(X1, Y1);
    k2 = convhull(X2, Y2);
    
    if numel(k1) < numel(k2)
        out_X1 = X1(k1);
        out_Y1 = Y1(k1);
        out_X2 = X2(k1);
        out_Y2 = Y2(k1);
    else
        out_X1 = X1(k2);
        out_Y1 = Y1(k2);
        out_X2 = X2(k2);
        out_Y2 = Y2(k2);
    end
end
