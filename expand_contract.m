%%
% Given a list of (i,j) points defining a convex hull, this function will
% contract the shape towards its centroid by some given percentage amount
%
% X     = Coordinate x-components
% Y     = Coordinate y-components
% scale = Scaling factor, +/-
function [out_X, out_Y] = expand_contract(X, Y, scale)
    cx    = mean(X); % Centroid x-component
    cy    = mean(Y); % Centroid y-component
    vx    = cx - X;  % Vector x-component
    vy    = cy - Y;  % Vector y-component
    V     = [vx, vy];
    for i=1:size(V,1)
        V(i,:) = V(i,:) ./ norm(V(i,:));
    end
    out_X = X + (V(:,1) .* scale);
    out_Y = Y + (V(:,2) .* scale);
end
