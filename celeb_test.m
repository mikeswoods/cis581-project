
%% 

% getNumOutputs()



% Create the face detector object.
faceDetector = vision.CascadeObjectDetector();
noseDetector = vision.CascadeObjectDetector('Nose');
leftEyeDetector = vision.CascadeObjectDetector('LeftEye');
rightEyeDetector = vision.CascadeObjectDetector('RightEye');
mouthDetector = vision.CascadeObjectDetector('Mouth');


% I = imread('0b4e3684ebff3455f471bb82a0173f48.jpg');
%I = imread('4b5d69173e608408ecf97df87563fd34.jpg');  % several people
% I = imread('star-trek-2009-sample-003.jpg');
I = imread('jennifer_xmen.jpg');

grayImage = rgb2gray(I);

% runLoop = true;
% f = 1;
% while(runLoop)
%    bbox_faces(f) = faceDetector.step(grayImage);
%    f = f + 1;
% end
bbox_faces = faceDetector.step(grayImage);

% bboxes = step(noseDetector, I)
nose_bbox = step(noseDetector, grayImage);
lefteye_bbox = leftEyeDetector.step(grayImage);
righteye_bbox = rightEyeDetector.step(grayImage);
mouth_bbox = mouthDetector.step(grayImage);

% [lefteye_bbox, ~] = selectStrongestBbox(lefteye_bbox, lscore);
% [righteye_bbox, ~] = selectStrongestBbox(righteye_bbox, rscore);

nose_points = detectMinEigenFeatures(grayImage, 'ROI', nose_bbox(1, :));
lefteye_points = detectMinEigenFeatures(grayImage, 'ROI', lefteye_bbox(1, :));
righteye_points = detectMinEigenFeatures(grayImage, 'ROI', righteye_bbox(2, :));
mouth_points = detectMinEigenFeatures(grayImage, 'ROI', mouth_bbox(3, :));

nose_xyPoints = nose_points.Location;
lefteye_xyPoints = lefteye_points.Location;
righteye_xyPoints = righteye_points.Location;
mouth_xyPoints = mouth_points.Location;

% nose_bboxPoints = bbox2points(nose_bbox(1, :));
% lefteye_bboxPoints = bbox2points(lefteye_bbox(1, :));

% bboxPolygon = reshape(lefteye_bboxPoints', 1, []);

% Display a bounding box around the detected face.
% I = insertShape(I, 'Polygon', bboxPolygon, 'LineWidth', 3);

% Display detected corners.
I = insertMarker(I, nose_xyPoints, '+', 'Color', 'white');
I = insertMarker(I, lefteye_xyPoints, '+', 'Color', 'red');
I = insertMarker(I, righteye_xyPoints, '+', 'Color', 'red');
I = insertMarker(I, mouth_xyPoints, '+', 'Color', 'red');


imshow(I);
hold on;
% plot(nose_xyPoints, 'w+');

for i = 1:size(bbox_faces)*2
    if numel(bbox_faces(:,1)) >= i
        rectangle('Position', bbox_faces(i,:), 'EdgeColor', 'r', 'LineWidth', 2);
    end
    if numel(nose_bbox(:,1)) >= i
        rectangle('Position', nose_bbox(i,:), 'EdgeColor', 'r', 'LineWidth', 2);
    end
    if numel(lefteye_bbox(:,1)) >= i
        rectangle('Position', lefteye_bbox(i,:), 'EdgeColor', 'r', 'LineWidth', 2);
    end
    if numel(righteye_bbox(:,1)) >= i
        rectangle('Position', righteye_bbox(i,:), 'EdgeColor', 'r', 'LineWidth', 2);
    end
    if numel(mouth_bbox(:,1)) >= i
        rectangle('Position', mouth_bbox(i,:), 'EdgeColor', 'r', 'LineWidth', 2);
    end
end




