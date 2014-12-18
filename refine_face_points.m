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
       add_common_landmarks(face1_im, face1_bbox, X1, Y1 ...
                           ,face2_im, face2_bbox, X2, Y2);
    
    % Concat:
    out_X1 = [out_X1 ; XX1];
    out_Y1 = [out_Y1 ; YY1];
    out_X2 = [out_X2 ; XX2];
    out_Y2 = [out_Y2 ; YY2];
end

%%
% face1_im   =
% face1_bbox =
% X1         =
% Y1         = 
% face2_im   =
% face2_bbox =
% X2         =
% Y1         = 
function [out_X1, out_Y1, out_X2, out_Y2] = ...
    add_common_landmarks(face1_im, face1_bbox, X1, Y1 ...
                        ,face2_im, face2_bbox, X2, Y2)
    out_X1 = [];
    out_Y1 = [];
    out_X2 = [];
    out_Y2 = [];

    % Get the features for both faces 1 and 2:
    F1 = get_face_features(face1_im, face1_bbox);
    F2 = get_face_features(face2_im, face2_bbox);
    
    % === Left Eye ===
    LeftEyeCenter_P = [];
    LeftEyeCenter_Q = [];

    if ~isempty(F1.LeftEye) && ~isempty(F2.LeftEye) 
        % Find the centroids of each bounding box and use them as
        % feature points:
        [CX1,CY1] = bbox_centroid(bbox_wh_to_xy(F1.LeftEye));
        [CX2,CY2] = bbox_centroid(bbox_wh_to_xy(F2.LeftEye));
        LeftEyeCenter_P = [CX1,CY1];
        LeftEyeCenter_Q = [CX2,CY2];
        
        % And add them to the faces:
        out_X1 = [out_X1 ; CX1];
        out_Y1 = [out_Y1 ; CY1];
        out_X2 = [out_X2 ; CX2];
        out_Y2 = [out_Y2 ; CY2];
    end
    
    % === Right Eye ===
    RightEyeCenter_P = [];
    RightEyeCenter_Q = [];

    if ~isempty(F1.RightEye) && ~isempty(F2.RightEye) 
        % Find the centroids of each bounding box and use them as
        % feature points:
        [CX1,CY1]  = bbox_centroid(bbox_wh_to_xy(F1.RightEye));
        [CX2,CY2]  = bbox_centroid(bbox_wh_to_xy(F2.RightEye));
        RightEyeCenter_P = [CX1,CY1];
        RightEyeCenter_Q = [CX2,CY2];

        % And add them to the faces:
        out_X1 = [out_X1 ; CX1];
        out_Y1 = [out_Y1 ; CY1];
        out_X2 = [out_X2 ; CX2];
        out_Y2 = [out_Y2 ; CY2];
    end
    
    % === Mouth ===
    MouthCenter_P = [];
    MouthCenter_Q = [];
    
    if ~isempty(F1.Mouth) && ~isempty(F2.Mouth) 
        % Find the centroids of each bounding box and use them as
        % feature points:
        [CX1,CY1] = bbox_centroid(bbox_wh_to_xy(F1.Mouth));
        [CX2,CY2] = bbox_centroid(bbox_wh_to_xy(F2.Mouth));
        MouthCenter_P = [CX1,CY1];
        MouthCenter_Q = [CX2,CY2];

        % And add them to the faces:
        out_X1 = [out_X1 ; CX1];
        out_Y1 = [out_Y1 ; CY1];
        out_X2 = [out_X2 ; CX2];
        out_Y2 = [out_Y2 ; CY2];

        % Do some additional stuff for the mouth:
        P_wh = F1.Mouth;
        Q_wh = F2.Mouth;
        % Add points equal to the width of the bounding box on
        % the same plane as the centroid:
        P_half_w = P_wh(3) ./ 2;
        Q_half_w = Q_wh(3) ./ 2;

        % Points to the left of the centroid:
        out_X1 = [out_X1 ; CX1 - (P_half_w * 0.66) ; CX1 + (P_half_w * 0.66)];
        out_X2 = [out_X2 ; CX2 - (Q_half_w * 0.66) ; CX2 + (Q_half_w * 0.66)];

        % Points to the right of the centroid:
        out_Y1 = [out_Y1 ; CY1 ; CY1];
        out_Y2 = [out_Y2 ; CY2 ; CY2];
    end
    
    % Using the centers from both eyes and the mouth, compute the 
    % relative face centroid:
    FaceCenter_P = mean([LeftEyeCenter_P ; RightEyeCenter_P ; MouthCenter_P], 1);
    FaceCenter_Q = mean([LeftEyeCenter_Q ; RightEyeCenter_Q ; MouthCenter_Q], 1);

    out_X1 = [out_X1 ; FaceCenter_P(1)];
    out_Y1 = [out_Y1 ; FaceCenter_P(2)];
    out_X2 = [out_X2 ; FaceCenter_Q(1)];
    out_Y2 = [out_Y2 ; FaceCenter_Q(2)];
    
    % Find two cheek points on each face:
    Leftmost_P                      = leftmost_point(X1, Y1);
    Rightmost_P                     = rightmost_point(X1, Y1);
    BetweenLeftEyeAndMouth_P        = mean([LeftEyeCenter_P; MouthCenter_P], 1);
    BetweenRightEyeAndMouth_P       = mean([RightEyeCenter_P; MouthCenter_P], 1);
    BetweenLeftMostAndFaceCenter_P  = mean([Leftmost_P ; FaceCenter_P], 1);
    BetweenRightMostAndFaceCenter_P = mean([Rightmost_P ; FaceCenter_P], 1);
    
    LeftCheekP = [BetweenLeftMostAndFaceCenter_P(1), BetweenLeftEyeAndMouth_P(2)];
    out_X1 = [out_X1 ; LeftCheekP(1)];
    out_Y1 = [out_Y1 ; LeftCheekP(2)];
    RightCheekP = [BetweenRightMostAndFaceCenter_P(1), BetweenRightEyeAndMouth_P(2)];
    out_X1 = [out_X1 ; RightCheekP(1)];
    out_Y1 = [out_Y1 ; RightCheekP(2)];
    
    Leftmost_Q                      = leftmost_point(X2, Y2);
    Rightmost_Q                     = rightmost_point(X2, Y2);
    BetweenLeftEyeAndMouth_Q        = mean([LeftEyeCenter_Q; MouthCenter_Q], 1);
    BetweenRightEyeAndMouth_Q       = mean([RightEyeCenter_Q; MouthCenter_Q], 1);
    BetweenLeftMostAndFaceCenter_Q  = mean([Leftmost_Q ; FaceCenter_Q], 1);
    BetweenRightMostAndFaceCenter_Q = mean([Rightmost_Q ; FaceCenter_Q], 1);
    
    LeftCheekQ = [BetweenLeftMostAndFaceCenter_Q(1), BetweenLeftEyeAndMouth_Q(2)];
    out_X2 = [out_X2 ; LeftCheekQ(1)];
    out_Y2 = [out_Y2 ; LeftCheekQ(2)];
    RightCheekQ = [BetweenRightMostAndFaceCenter_Q(1), BetweenRightEyeAndMouth_Q(2)];
    out_X2 = [out_X2 ; RightCheekQ(1)];
    out_Y2 = [out_Y2 ; RightCheekQ(2)];
end

%% Find the left most point in the face
function [L] = leftmost_point(X, Y)
    [~,I] = min(X);
    L     = [X(I), Y(I)];
end

%% Find the right most point in the face
function [L] = rightmost_point(X, Y)
    [~,I] = max(X);
    L     = [X(I), Y(I)];
end

%% Find the highest most point in the face
function [L] = highest_point(X, Y)
    [~,I] = min(Y);
    L     = [X(I), Y(I)];
end

%% Find the highest most point in the face
function [L] = lowest_point(X, Y)
    [~,I] = max(Y);
    L     = [X(I), Y(I)];
end

%%
% Get the centroid of a bounding box
function [cx,cy] = bbox_centroid(bbox)
    cx = floor((bbox(1) + bbox(3)) * 0.5);
    cy = floor((bbox(2) + bbox(4)) * 0.5);
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
