%% Example Title
% Summary of example objective

% Define frame rate
NumberFrameDisplayPerSecond=10;
 
% Open figure
hFigure=figure(1);
 
% Set-up webcam video input
try
   % For windows
   vid = videoinput('winvideo', 1);
catch
   try
      % For macs.
      vid = videoinput('macvideo', 1);
   catch
      errordlg('No webcam available');
   end
end
 
% Set parameters for video
% Acquire only one frame each time
set(vid,'FramesPerTrigger',1);
% Go on forever until stopped
set(vid,'TriggerRepeat',Inf);
% Get a grayscale image
set(vid,'ReturnedColorSpace','grayscale');
triggerconfig(vid, 'Manual');
 
% set up timer object
TimerData=timer('TimerFcn', ...
    {@FrameRateDisplay,vid},'Period',1/NumberFrameDisplayPerSecond, ...
    'ExecutionMode','fixedRate','BusyMode','drop');
 
% Start video and timer object
start(vid);
start(TimerData);
 
% We go on until the figure is closed
uiwait(hFigure);
 
% Clean up everything
stop(TimerData);
delete(TimerData);
stop(vid);
delete(vid);


% % Create a cascade detector object.
% faceDetector = vision.CascadeObjectDetector();
% 
% % Read a video frame and run the face detector.
% videoFileReader = vision.VideoFileReader('tilted_face.avi');
% videoFrame      = step(videoFileReader);
% bbox            = step(faceDetector, videoFrame);
% 
% % Draw the returned bounding box around the detected face.
% videoFrame = insertShape(videoFrame, 'Rectangle', bbox);
% figure; imshow(videoFrame); title('Detected face');
% 
% % Convert the first box into a list of 4 points
% % This is needed to be able to visualize the rotation of the object.
% bboxPoints = bbox2points(bbox(1, :));
% 
% % Detect feature points in the face region.
% points = detectMinEigenFeatures(rgb2gray(videoFrame), 'ROI', bbox);
% 
% % Display the detected points.
% figure, imshow(videoFrame), hold on, title('Detected features');
% plot(points);
% 
% % Create a point tracker and enable the bidirectional error constraint to
% % make it more robust in the presence of noise and clutter.
% pointTracker = vision.PointTracker('MaxBidirectionalError', 2);
% 
% % Initialize the tracker with the initial point locations and the initial
% % video frame.
% points = points.Location;
% initialize(pointTracker, points, videoFrame);
% 
% videoPlayer  = vision.VideoPlayer('Position',...
%     [100 100 [size(videoFrame, 2), size(videoFrame, 1)]+30]);
% 
% % Make a copy of the points to be used for computing the geometric
% % transformation between the points in the previous and the current frames
% oldPoints = points;
% 
% while ~isDone(videoFileReader)
%     % get the next frame
%     videoFrame = step(videoFileReader);
% 
%     % Track the points. Note that some points may be lost.
%     [points, isFound] = step(pointTracker, videoFrame);
%     visiblePoints = points(isFound, :);
%     oldInliers = oldPoints(isFound, :);
% 
%     if size(visiblePoints, 1) >= 2 % need at least 2 points
% 
%         % Estimate the geometric transformation between the old points
%         % and the new points and eliminate outliers
%         [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
%             oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);
% 
%         % Apply the transformation to the bounding box points
%         bboxPoints = transformPointsForward(xform, bboxPoints);
% 
%         % Insert a bounding box around the object being tracked
%         bboxPolygon = reshape(bboxPoints', 1, []);
%         videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, ...
%             'LineWidth', 2);
% 
%         % Display tracked points
%         videoFrame = insertMarker(videoFrame, visiblePoints, '+', ...
%             'Color', 'white');
% 
%         % Reset the points
%         oldPoints = visiblePoints;
%         setPoints(pointTracker, oldPoints);
%     end
% 
%     % Display the annotated video frame using the video player object
%     step(videoPlayer, videoFrame);
% end
% 
% % Clean up
% release(videoFileReader);
% release(videoPlayer);
% release(pointTracker);

% This function is called by the timer to display one frame of the figure
% vid = realVideo();

