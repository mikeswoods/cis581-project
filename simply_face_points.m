%%
% Given X and Y points that define the feature points of a face, this
% function will "simplify" the number of points comprising the face
%
% X1 = X points for face 1
% Y1 = Y points for face 1
% X2 = X points for face 2
% Y2 = Y points for face 2
function [out_X1, out_Y1, out_X2, out_Y2] = simply_face_points(X1, Y1, X2, Y2)

    if ~isequal(size(X1), size(X2)) || ~isequal(size(Y1), size(Y2))
        error('Dimensions for X1,Y1,X2,Y2 must be the same');
    end

    % Since the points are aligned and all have the same size, jsut take
    % the convex hull with a larger number of points and apply the same
    % indices to [X1,Y1] and [X2,Y2]

    k1 = convhull(X1, Y1);
    k2 = convhull(X2, Y2);
    
    if numel(k1) > numel(k2)
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


%     k = convhull(X, Y);
%     X_Prime = X(k);
%     Y_Prime = Y(k);
end
