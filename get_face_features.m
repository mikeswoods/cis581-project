%% Returns a struct of detected facial feature bounding boxes 
% for the image.
% 
% face_image = The image to find the feature bounding boxes of
% F.Nose     = 4x1 matrix bounding box for the nose ([x, y, w, h])
% F.Mouth    = 4x1 matrix bounding box for the mouth ([x, y, w, h])
% F.LeftEye  = 4x1 matrix bounding box for the left eye ([x, y, w, h])
% F.RightEye = 4x1 matrix bounding box for the right eye ([x, y, w, h])
%
function [F] = get_face_features(face_image)

    addpath('detect_face_parts');
    detector          = buildDetector();
    [bboxes, ~, ~, ~] = detectFaceParts(detector, face_image);

    F = struct('Nose', bboxes(:, 17:20) ...
              ,'Mouth', bboxes(:, 13:16) ...
              ,'LeftEye', bboxes(:, 5: 8) ...
              ,'RightEye', bboxes(:, 9:12));
end
