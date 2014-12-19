%%
% Generate circles around each of the face features
% based on the indices returned from the FITW detector 
%
% The following indices correspond to eyes, nose, and mouth:
%
% Left Eye: [11, 12, 13, 14]
% Right eye: [22, 23, 24, 25]
% Nose: [1, 6, 7]
% Mouth: [38, 43, 46, 51]
%
function [face_out_X, face_out_Y] = circle_face_features(face_in_X, face_in_Y)
    
    LEFT_EYE_INDEX  = [11, 12, 13, 14];
    RIGHT_EYE_INDEX = [22, 23, 24, 25];
    NOSE_INDEX      = [1, 6, 7];
    MOUTH_INDEX     = [38, 43, 46, 51];
    
    N = 25;

    left_eye  = centroid(face_in_X(LEFT_EYE_INDEX,:), face_in_Y(LEFT_EYE_INDEX,:));
    right_eye = centroid(face_in_X(RIGHT_EYE_INDEX,:), face_in_Y(RIGHT_EYE_INDEX,:));
    nose      = centroid(face_in_X(NOSE_INDEX,:), face_in_Y(NOSE_INDEX,:));
    mouth     = centroid(face_in_X(MOUTH_INDEX,:), face_in_Y(MOUTH_INDEX,:));

    % Comompute the distance between the eye points to determine the
    % radius for each circle over the eyes: 
    
    eye_radius   = euclidean_dist([left_eye ; right_eye]);
    
    nose_radius  = min([euclidean_dist([left_eye ; nose]), euclidean_dist([right_eye ; nose])]);
    mouth_radius = euclidean_dist([nose ; mouth]);
    
    left_eye_circle  = floor(make_circle(left_eye(1), left_eye(2), eye_radius * 0.5, N));
    right_eye_circle = floor(make_circle(right_eye(1), right_eye(2), eye_radius * 0.5, N));
    nose_circle      = floor(make_circle(nose(1), nose(2), nose_radius, N));
    mouth_circle     = floor(make_circle(mouth(1), mouth(2), mouth_radius, N));
   
    X = [left_eye_circle(:,1), right_eye_circle(:,1), nose_circle(:,1), mouth_circle(:,1)];
    Y = [left_eye_circle(:,2), right_eye_circle(:,2), nose_circle(:,2), mouth_circle(:,2)];
    
    %X = [left_eye_circle(:,1), right_eye_circle(:,1), nose_circle(:,1), mouth_circle(:,1)];
    %Y = [left_eye_circle(:,2), right_eye_circle(:,2), nose_circle(:,2), mouth_circle(:,2)];

    %X = [left_eye(:,1), right_eye(:,1)];
    %Y = [left_eye(:,2), right_eye(:,2)];
    
    face_out_X = X;
    face_out_Y = Y;
end

%%
function [d] = euclidean_dist(P)
    d = pdist(P, 'euclidean', 'Smallest', 1);
end

%%
function [C] = centroid(X,Y)
    C = mean([X,Y]);
end
