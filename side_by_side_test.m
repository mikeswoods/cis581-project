%% Simple side-by-side face matching comparison harness script

im1 = im2double(imread('data/easy/iu.jpg'));
%im2 = im2double(imread('data/easy/jennifer.jpg'));
%im2 = im2double(imread('data/hard/jennifer_xmen.jpg'));

im1 = im2double(imread('data/hard/mj.jpg'));

im2 = im2double(imread('data/hard/0lliviaa.jpg'));

%%

% Create the face detector object.
faceDetector = vision.CascadeObjectDetector('Nose', 'MergeThreshold', 10);

bbox1 = faceDetector.step(im1);
bbox2 = faceDetector.step(im2);

% Create the point tracker object.
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);

%%

num_bbox1 = size(bbox1, 1);
num_bbox2 = size(bbox2, 1);

points1 = cell(num_bbox1, 1);
points2 = cell(num_bbox2, 1);

for i=1:num_bbox1
    points1{i} = detectMinEigenFeatures(rgb2gray(im1), 'ROI', bbox1(i,:));
end

for i=1:num_bbox2
    points2{i} = detectMinEigenFeatures(rgb2gray(im2), 'ROI', bbox2(i,:));
end

%%

% matches = matchFeatures(points1, points2);
% mp1     = points1(matches(:,1),:);
% mp2     = points2(matches(:,2),:);

%[~,inliers] = ransac_est_homography(mp1(:,2), mp1(:,1), mp2(:,2), mp2(:,1), 4);

side_by_side(im1, im2, bbox1, bbox2, {}, {});

%hold on;
%rectangle('Position', bbox1(1,:), 'EdgeColor', 'r', 'LineWidth', 2);
%showMatchedFeatures(im1, im2, mp1(inliers,:), mp2(inliers,:), 'montage');
