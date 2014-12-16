%%
% Given X and Y points that define the feature points of a face, this
% function will "simplify" the number of points comprising the face
%
% X1 = X points for face 1
% Y1 = Y points for face 1
% X2 = X points for face 2
% Y2 = Y points for face 2
function [out_X1, out_Y1, out_X2, out_Y2] = simply_face_points(X1, Y1, X2, Y2)

    % For now, just return the points that comprise the convex hull:
    k = convhull(X, Y);
    X_Prime = X(k);
    Y_Prime = Y(k);
end
