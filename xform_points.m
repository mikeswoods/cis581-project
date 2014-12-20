%% Apply the affine transformation in T to all points (x,y) in XY
%
function [XYPrime] = xform_points(XY, T)
    n       = size(XY,1);
    XY_next = zeros(n, 3);
    for i=1:n
        XY_next(i,:) = [XY(i,:), 1.0] * T; 
    end
    XYPrime = [XY_next(:,1) ./ XY_next(:,3), XY_next(:,2) ./ XY_next(:,3)];  
end
