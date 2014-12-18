%%
% Given X and Y points that define the feature points of a face, this
% function will simply and refine the number of points comprising the face
% so TPS will produce a better morph
%
% im_face1 = Face 1 image
% X1       = X points for face 1
% Y1       = Y points for face 1
% im_face2 = Face 2 image
% X2       = X points for face 2
% Y2       = Y points for face 2
function [out_X1, out_Y1, out_X2, out_Y2] = ...
    refine_face_points(face1_im, face1_bbox, X1, Y1 ...
                      ,face2_im, face2_bbox, X2, Y2)

    if ~isequal(size(X1), size(X2)) || ~isequal(size(Y1), size(Y2))
        error('Dimensions for X1,Y1,X2,Y2 must be the same');
    end

    % Since the points are aligned and all have the same size, jsut take
    % the convex hull with a larger number of points and apply the same
    % indices to [X1,Y1] and [X2,Y2]
    [out_X1, out_Y1, out_X2, out_Y2] = find_min_convex_hull(X1, Y1, X2, Y2);
    
    % If there are additional features, add them:
    [XX1, YY1, XX2, YY2] = ...
       add_common_landmarks(face1_im, face1_bbox, face2_im, face2_bbox);
    
    % Concat:    
    out_X1 = [out_X1 ; XX1];
    out_Y1 = [out_Y1 ; YY1];
    out_X2 = [out_X2 ; XX2];
    out_Y2 = [out_Y2 ; YY2];
%     imshow(face1_im);
%     hold on;
%     plot(out_X1, out_Y1, 'o', 'Color', 'g');
end

%%
% face1_im   =
% face1_bbox =
% face2_im   =
% face2_bbox =
function [X1, Y1, X2, Y2] = ...
    add_common_landmarks(face1_im, face1_bbox, face2_im, face2_bbox)

    X1 = [];
    Y1 = [];
    X2 = [];
    Y2 = [];

    % Get the features for both faces 1 and 2:
    F1 = get_face_features(face1_im, face1_bbox);
    F2 = get_face_features(face2_im, face2_bbox);
    
    % For each face feature:
    fields = {'Nose', 'LeftEye', 'RightEye'};
    
    for i=1:numel(fields)

        f = fields{i};
    
        % See if the same features were identified on each face:
        if ~isempty(F1.(f)) && ~isempty(F2.(f)) 

            P = bbox_wh_to_xy(F1.(f));
            Q = bbox_wh_to_xy(F2.(f));

            % Add it for the first face:
            X1 = [X1 ; round((P(1) + P(3)) * 0.5)];
            Y1 = [Y1 ; round((P(2) + P(4)) * 0.5)];

            % and the second face:
            X2 = [X2 ; round((Q(1) + Q(3)) * 0.5)];
            Y2 = [Y2 ; round((Q(2) + Q(4)) * 0.5)];
        end
    end
end

%%
%
function [out_X1, out_Y1, out_X2, out_Y2] = align_to_edges(E1, XY1, E2, XY2, radius)

    S1     = snap_to_edges(E1, XY1, radius);
    out_X1 = S1(:,1);
    out_Y1 = S1(:,2);

    S2     = snap_to_edges(E2, XY2, radius);
    out_X2 = S2(:,1);
    out_Y2 = S2(:,2);
end

%%
%
function [out_X1, out_Y1, out_X2, out_Y2] = find_min_convex_hull(X1, Y1, X2, Y2)

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
end
