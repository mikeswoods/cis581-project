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
                      ,face2_im, face2_bbox, X2, Y2 ...
                      ,contract_amt)

    snap_radius = 10;
    edge_threshold = 0.1;
                  
    if nargin ~= 9
        contract_amt = 5.0;
    end
                      
    if ~isequal(size(X1), size(X2)) || ~isequal(size(Y1), size(Y2))
        error('Dimensions for X1,Y1,X2,Y2 must be the same');
    end

    % Since the points are aligned and all have the same size, jsut take
    % the convex hull with a larger number of points and apply the same
    % indices to [X1,Y1] and [X2,Y2]
    [out_X1, out_Y1, out_X2, out_Y2] = find_min_convex_hull(X1, Y1, X2, Y2);
    
    % Contract the convex hull of each face by 25% to get a tighter fit
%     [out_X1, out_Y1] = expand_contract_convex_hull(out_X1, out_Y1, -5.0);
%     [out_X2, out_Y2] = expand_contract_convex_hull(out_X2, out_Y2, -5.0);
%     
%     % Next, snap the face points to the closest edge:
%     E1 = edge(rgb2gray(face1_im), 'canny', edge_threshold);
%     [out_X1, out_Y1] = snap_to_edges(E1, [out_X1, out_Y1], snap_radius);
%     
%     E2 = edge(rgb2gray(face2_im), 'canny', edge_threshold);
%     [out_X2, out_Y2] = snap_to_edges(E2, [out_X2, out_Y2], snap_radius);
    
    % Contract the convex hull of each face by 25% to get a tighter fit
    [out_X1, out_Y1] = expand_contract_convex_hull(out_X1, out_Y1, contract_amt);
    [out_X2, out_Y2] = expand_contract_convex_hull(out_X2, out_Y2, contract_amt);
    
    % If there are additional features, add them:
    [XX1, YY1, XX2, YY2] = ...
       add_common_landmarks(face1_im, face1_bbox, face2_im, face2_bbox);
    
    % Concat:    
%     out_X1 = XX1;
%     out_Y1 = YY1;
%     out_X2 = XX2;
%     out_Y2 = YY2;
    out_X1 = [out_X1 ; XX1];
    out_Y1 = [out_Y1 ; YY1];
    out_X2 = [out_X2 ; XX2];
    out_Y2 = [out_Y2 ; YY2];
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
    fields = {'LeftEye', 'RightEye', 'Mouth'};
    
    for i=1:numel(fields)

        f = fields{i};
    
        % See if the same features were identified on each face:
        if ~isempty(F1.(f)) && ~isempty(F2.(f)) 

            P_wh = F1.(f);
            Q_wh = F2.(f);
            P_xy = bbox_wh_to_xy(F1.(f));
            Q_xy = bbox_wh_to_xy(F2.(f));

            % Find the centroids of each bounding box and use them as
            % feature points:
            CX1 = round((P_xy(1) + P_xy(3)) * 0.5);
            CY1 = round((P_xy(2) + P_xy(4)) * 0.5);
            CX2 = round((Q_xy(1) + Q_xy(3)) * 0.5);
            CY2 = round((Q_xy(2) + Q_xy(4)) * 0.5);
            
            % And add them to the faces:
            X1 = [X1 ; CX1];
            Y1 = [Y1 ; CY1];
            X2 = [X2 ; CX2];
            Y2 = [Y2 ; CY2];
            
            % Do some additional stuff for the mouth:
            if isequal(f, 'Mouth')
                % Add points equal to the width of the bounding box on
                % the same plane as the centroid:
                P_half_w = P_wh(3) * 0.5;
                Q_half_w = Q_wh(3) * 0.5;
                
                % Points to the left of the centroid:
                X1 = [X1 ; CX1 - (P_half_w * 0.66) ; CX1 + (P_half_w * 0.66)];
                X2 = [X2 ; CX2 - (Q_half_w * 0.66) ; CX2 + (Q_half_w * 0.66)];
                
                % Points to the right of the centroid:
                Y1 = [Y1 ; CY1 ; CY1];
                Y2 = [Y2 ; CY2 ; CY2];
            end
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

% Given a list of (i,j) points defining a convex hull, this function will
% contract the shape towards its centroid by some given percentage amount
%
% X     =
% Y     =
% scale =
function [out_X, out_Y] = expand_contract_convex_hull(X, Y, scale)
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

%%
% Given two sets of matched face points, this function returns the 
% the convex hull for each face, ensuring that each convex hull consists
% of the same number of points
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
