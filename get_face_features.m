%% 
%
function [Z] = get_face_features(faceImage)
    
    % Do some initial preprocessing of the image
    %I = imsharpen(imadjust(rgb2gray(faceImage)));
    %I = imadjust(rgb2gray(faceImage));
    I = faceImage;
    
    % First, try to find the nose the initial landmarks:
    nose             = get_single_feature(I, 'Nose');
    [nose_x, nose_y] = bbox_centroid_wh(nose);
    nose_centroid    = [nose_x, nose_y];
    
    % Find all mouth candidates:
    mouth              = get_any_feature(I, 'Mouth');
    [mouth_x, mouth_y] = bbox_centroid_wh(mouth);
    mouth = prune_mouth_candidates(nose_centroid, mouth, [mouth_x, mouth_y]);
    
    % Find all left eye candidates:
    left_eye = get_any_feature(I, 'LeftEye');
    if size(left_eye, 1) > 0
        [left_eye_x, left_eye_y] = bbox_centroid_wh(left_eye);
        left_eye = prune_left_eye_candidates(nose_centroid, left_eye, [left_eye_x, left_eye_y]);
    end
        
    % Find all right eye candidates:
    right_eye  = get_any_feature(I, 'RightEye');
    if size(left_eye, 1) > 0
        [right_eye_x, right_eye_y] = bbox_centroid_wh(right_eye);
        right_eye = prune_right_eye_candidates(nose_centroid, right_eye, [right_eye_x, right_eye_y]);
    end

    %%%
    
    imshow(I);
    hold on;
    rectangle('Position', nose, 'EdgeColor', 'r', 'LineWidth', 2);
    plot(nose_x, nose_y, 'o', 'Color', 'g');
    
    for i=1:size(mouth, 1)
        rectangle('Position', mouth(i,:), 'EdgeColor', 'b', 'LineWidth', 2);
    end
    plot(mouth_x, mouth_y, 'o', 'Color', 'g');

    N = size(left_eye, 1);
    for i=1:N
        rectangle('Position', left_eye(i,:), 'EdgeColor', 'g', 'LineWidth', 2);
    end
    if N > 0
        plot(left_eye_x, left_eye_y, 'o', 'Color', 'g');
    end
    
    N = size(right_eye, 1);
    for i=1:size(right_eye, 1)
        rectangle('Position', right_eye(i,:), 'EdgeColor', 'y', 'LineWidth', 2);
    end
    if N > 0
        plot(right_eye_x, right_eye_y, 'o', 'Color', 'g');
    end

    hold off;
end

%%
%
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
%
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
%
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

%%
%
function [x,y] = bbox_centroid_wh(bbox)

    x1 = bbox(:,1);
    y1 = bbox(:,2);
    x2 = x1 + bbox(:,3);
    y2 = y1 + bbox(:,4);
    x = (x1 + x2) ./ 2;
    y = (y1 + y2) ./ 2;
end

%%
%
function [x,y] = bbox_centroid_xy(bbox)
    x = (bbox(:,1) + bbox(:,3)) ./ 2;
    y = (bbox(:,2) + bbox(:,4)) ./ 2;
end

%%
%
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
%
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
%
function [result] = contains_box(outer, inner)
    outX   = outer(1);
    outY   = outer(2);
    outW   = outer(3);
    outH   = outer(4);
    inX    = inner(1);
    inY    = inner(2);
    inW    = inner(3);
    inH    = inner(4);
    result = (inX > outX) && ...
             (inY > outY) && ...
             ((inX + inW) < (outX + outW)) && ...
             ((inY + inH) < (outY + outH));
end

