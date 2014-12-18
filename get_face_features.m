%% Returns a struct of detected facial feature bounding boxes 
% for the image.
% 
% Note: face_image is expected to contain a SINGLE face to run feature 
% 
% face_image = The image to find the feature bounding boxes of
% face_bbox  = If given, the bounding box of a single face
% F          = A struct of the following form:
% F.Nose     = 4x1 matrix bounding box for the nose ([x, y, w, h])
% F.Mouth    = 4x1 matrix bounding box for the mouth ([x, y, w, h])
% F.LeftEye  = 4x1 matrix bounding box for the left eye ([x, y, w, h])
% F.RightEye = 4x1 matrix bounding box for the right eye ([x, y, w, h])
%
function [F] = get_face_features(face_image, face_bbox)

    addpath('detect_face_parts');
    detector          = buildDetector();
    [bboxes, ~, ~, ~] = detectFaceParts(detector, face_image);

    F = struct('Nose', bboxes(:, 17:20) ...
              ,'Mouth', bboxes(:, 13:16) ...
              ,'LeftEye', bboxes(:, 5: 8) ...
              ,'RightEye', bboxes(:, 9:12));
    
%     if nargin ~= 2
%         face_bbox = [1, 1, size(face_image, 2), size(face_image, 1)];
%     end
%     
%     [I, crop_bbox] = imcrop(face_image, face_bbox);
%     
%     nose = [];
%     mouth = [];
%     left_eye = [];
%     right_eye = [];
%     
%     % First, try to find the nose the initial landmarks:
%     nose = get_single_feature(I, 'Nose');
%     if ~isempty(nose)
% 
%         [nose_x, nose_y] = bbox_centroid_wh(nose);
%         nose_centroid    = [nose_x, nose_y];
% 
%         % Find all mouth candidates:
%         mouth              = get_any_feature(I, 'Mouth');
%         [mouth_x, mouth_y] = bbox_centroid_wh(mouth);
%         mouth = prune_mouth_candidates(nose_centroid, mouth, [mouth_x, mouth_y]);
% 
%         % Find all left eye candidates:
%         left_eye = get_any_feature(I, 'LeftEye');
%         if size(left_eye, 1) > 0
%             [left_eye_x, left_eye_y] = bbox_centroid_wh(left_eye);
%             left_eye = prune_left_eye_candidates(nose_centroid, left_eye, [left_eye_x, left_eye_y]);
%         end
% 
%         % Find all right eye candidates:
%         right_eye  = get_any_feature(I, 'RightEye');
%         if size(left_eye, 1) > 0
%             [right_eye_x, right_eye_y] = bbox_centroid_wh(right_eye);
%             right_eye = prune_right_eye_candidates(nose_centroid, right_eye, [right_eye_x, right_eye_y]);
%         end
% 
%         % ---------------------------------------------------------------------
% 
%         % Finally, prune any boxes that are fully contained in other boxes:
%         mouth_temp     = mouth;
%         left_eye_temp  = left_eye;
%         right_eye_temp = right_eye;
% 
%         mouth     = prune_enclosed(mouth, [nose ; left_eye_temp; right_eye_temp]);
%         left_eye  = prune_enclosed(left_eye, [nose ; mouth_temp; right_eye_temp]);
%         right_eye = prune_enclosed(right_eye, [nose ; mouth_temp; left_eye_temp]);
% 
%         % ---------------------------------------------------------------------
% 
%         % Build a struct to hold all of our stuff:
% 
%         % Add the offsets:
%         if size(nose, 1) > 0
%             nose(:,1) = nose(:,1) + crop_bbox(1);
%             nose(:,2) = nose(:,2) + crop_bbox(2);
%         end
%         if size(mouth, 1) > 0
%             mouth(:,1) = mouth(:,1) + crop_bbox(1);
%             mouth(:,2) = mouth(:,2) + crop_bbox(2);
%         end
%         if size(left_eye, 1) > 0
%             left_eye(:,1) = left_eye(:,1) + crop_bbox(1);
%             left_eye(:,2) = left_eye(:,2) + crop_bbox(2);
%         end
%         if size(right_eye, 1) > 0
%             right_eye(:,1) = right_eye(:,1) + crop_bbox(1);
%             right_eye(:,2) = right_eye(:,2) + crop_bbox(2);
%         end
%     end
%     
%     F = struct('Nose', nose, 'Mouth', mouth, 'LeftEye', left_eye, 'RightEye', right_eye);
end

%%
% Prune mouth candidate bounding boxes using simple rules
function [mouthsPassing] = prune_mouth_candidates(nose_centroid, mouths, mouth_centroid)
    if size(mouths, 1) == 1
        mouthsPassing = mouths;
    else
        % Only keep mouths with a y coordinate greater than that of the nose:
        % This indicates that the mouth should be below the nose.
        % Note this assumes the face is in an upright position!!!
        mouthsPassing = mouths(find(mouth_centroid(:,2) > nose_centroid(:,2)),:);
    end
end

%%
% Prune left eye candidate bounding boxes using simple rules
function [eyesPassing] = prune_left_eye_candidates(nose_centroid, eyes, eyes_centroid)
    if size(eyes, 1) == 1
        eyesPassing = eyes;
    else
        % Only keep eyes with a y coordinate less than that of the nose
        % This indicates that the eyes should be above the nose.
        % Note this assumes the face is in an upright position!!!
        INDEX         = find(eyes_centroid(:,2) < nose_centroid(:,2));
        eyes          = eyes(INDEX,:);
        eyes_centroid = eyes_centroid(INDEX,:);
        
        % Now, pick the eye with the x cooridate to the left of the nose
        % nose centroid
        eyesPassing = eyes(find(eyes_centroid(:,1) < nose_centroid(:,1)),:);
    end
end

%%
% Prune right eye candidate bounding boxes using simple rules
function [eyesPassing] = prune_right_eye_candidates(nose_centroid, eyes, eyes_centroid)
    if size(eyes, 1) == 1
        eyesPassing = eyes;
    else
        % Only keep eyes with a y coordinate less than that of the nose
        % This indicates that the eyes should be above the nose.
        % Note this assumes the face is in an upright position!!!
        INDEX         = find(eyes_centroid(:,2) < nose_centroid(:,2));
        eyes          = eyes(INDEX, :);
        eyes_centroid = eyes_centroid(INDEX, :);
        
        % Now, pick the eye with the x cooridate to the left of the nose
        % nose centroid
        eyesPassing = eyes(find(eyes_centroid(:,1) > nose_centroid(:,1)),:);
    end
end

%% Prune enclosed
% Test to see if any one of target_bboxes is entirely enclosed
% within any of the other bounding boxes in other_bboxes
function [BBOX] = prune_enclosed(target_bboxes, other_bboxes)

    BBOX = [];
    M    = size(other_bboxes, 1);

    for i=1:size(target_bboxes, 1)

        T = target_bboxes(i,:);

        if ~any(contains_box_wh(other_bboxes, repmat(T, M, 1)))
            BBOX = [BBOX ; T];
        end
    end
end

%%
% Computes the centroid defined by the bounding box in the form:
% [x, y, w, h]
function [x,y] = bbox_centroid_wh(bbox)

    x1 = bbox(:,1);
    y1 = bbox(:,2);
    x2 = x1 + bbox(:,3);
    y2 = y1 + bbox(:,4);
    x = (x1 + x2) ./ 2;
    y = (y1 + y2) ./ 2;
end

%%
% Computes the centroid defined by the bounding box in the form:
% [x1, y1, x2, y2]
function [x,y] = bbox_centroid_xy(bbox)
    x = (bbox(:,1) + bbox(:,3)) ./ 2;
    y = (bbox(:,2) + bbox(:,4)) ./ 2;
end

%%
% Given a feature type like 'Nose' or 'Mouth' or any type detected by
% Matlab's vision.CascaseObjectDetector, returns all bounding boxes found
% as soon as the number of bounding boxes for a given threshold is greater
% than zero.
%
% I = image
% feature_type = 'Nose', 'Mouth', 'LeftEye', etc...
% hi = High starting threshold value for CascaseObjectDetector's
%      'MergeThreshold' parameter
% lo  = Low ending threshold value for CascaseObjectDetector's
%      'MergeThreshold' parameter
function [BBOX] = get_any_feature(I, feature_type, hi, lo)

    BBOX = [];

    if nargin ~= 4
        lo = 3;
    end
    if nargin ~= 3
        hi = 15;
    end
    
    for threshold=hi:-1:lo
        detector = vision.CascadeObjectDetector(feature_type, 'MergeThreshold', threshold);
        bboxes   = detector.step(I);
        if size(bboxes, 1) > 0
            BBOX = bboxes;
            break;
        end
    end
end

%%
% Given a feature type like 'Nose' or 'Mouth' or any type detected by
% Matlab's vision.CascaseObjectDetector, returns a single bounding box
% found when exclusively one bounding is detected for a given threshold 
%
% I = image
% feature_type = 'Nose', 'Mouth', 'LeftEye', etc...
% hi = High starting threshold value for CascaseObjectDetector's
%      'MergeThreshold' parameter
% lo  = Low ending threshold value for CascaseObjectDetector's
%      'MergeThreshold' parameter
function [BBOX] = get_single_feature(I, feature_type, hi, lo)

    BBOX = [];
    
    if nargin ~= 4
        lo = 3;
    end
    if nargin ~= 3
        hi = 15;
    end
    
    for threshold=hi:-1:lo
        detector = vision.CascadeObjectDetector(feature_type, 'MergeThreshold', threshold);
        bboxes   = detector.step(I);
        if size(bboxes, 1) == 1
            BBOX = bboxes;
            break;
        end
    end
end

%%
% Tests if the bounding box defined by inner is fully contained by outer
% Note: Assumes all boxes have the form [x1, y1, x2, y2] 
function [result] = contains_box_xy(outer, inner)
    result = outer(:,1) <= inner(:,1) & ... % outer.x1 <= inner.x1
             outer(:,2) <= inner(:,2) & ... % outer.y1 <= inner.y1
             outer(:,3) >= inner(:,3) & ... % outer.x2 >= inner.x2
             outer(:,4) >= inner(:,4);       % outer.y2 >= inner.y2
end

%%
% Tests if the bounding box defined by inner is fully contained by outer
% Note: Assumes all boxes have the form [x, y, w, h]
function [result] = contains_box_wh(outer, inner)

    result = outer(:,1) <= inner(:,1) & ...
             outer(:,2) <= inner(:,2) & ...
             (outer(:,1) + outer(:,3)) >= (inner(:,1) + inner(:,3)) & ...
             (outer(:,2) + outer(:,4)) >= (inner(:,2) + inner(:,4));
end
