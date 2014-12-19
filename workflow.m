%% (0)

%target_im  = im2double(imread('data/hard/14b999d49e77c6205a72ca87c2c2e5df.jpg'));
%target_im  = im2double(imread('data/easy/0013729928e6111451103c.jpg'));
%target_im  = im2double(imread('data/me-small.jpg'));
target_im  = im2double(imread('data/hard/jennifer_xmen.jpg'));
%target_im  = im2double(imread('data/hard/0lliviaa.jpg'));
%target_im = im2double(imread('data/testset/blending/Official_portrait_of_Barack_Obama.jpg'));
%target_im = im2double(imread('data/testset/pose/golden-globes-jennifer-lawrence-0.jpg'));
%target_im = im2double(imread('data/testset/blending/b1.jpg'));
%target_im = im2double(imread('data/testset/blending/bc.jpg'));
target_im = im2double(imread('data/testset/pose/Michael_Jordan_Net_Worth.jpg'));
%target_im = im2double(imread('data/testset/pose/star-trek-2009-sample-003.jpg'));

%% (1)

% Add working paths for TPS and the FITW face detection code:
addpath('fitw_detect');
addpath('tps');

% FITW training data:
data  = load('fitw_detect/face_p146_small.mat');
model = data.model;

% Detect the face in the target image:
[target_X, target_Y, target_bbox, target_orientation] = detect_faces(target_im, model);

num_faces = numel(target_orientation);

%% (2)

% Find the reference faces with the closest orientation:
ref_faces = cell(num_faces, 1);
for i=1:num_faces
    ref_faces{i} = find_reference_face(target_orientation(i,:));
end

%% (3.0)

source_XX = cell(num_faces,1);
source_YY = cell(num_faces,1);
target_XX = cell(num_faces,1);
target_YY = cell(num_faces,1);

for i=1:num_faces
    [source_XX{1},source_YY{1}] = circle_face_features(ref_faces{i}.x, ref_faces{i}.y);
    [target_XX{1},target_YY{1}] = circle_face_features(target_X(:,1), target_Y(:,1));
    [source_XX{i}, source_YY{i}, target_XX{i}, target_YY{i}] = ...
       find_min_convex_hull(source_XX{i}, source_YY{i}, target_XX{i}, target_YY{i});
end

%% (3.1)

source_XX = cell(num_faces,1);
source_YY = cell(num_faces,1);
target_XX = cell(num_faces,1);
target_YY = cell(num_faces,1);

for i=1:num_faces
    [source_XX{i}, source_YY{i}, target_XX{i}, target_YY{i}] = ...
        refine_face_points(ref_faces{i}.image, ref_faces{i}.bbox, ref_faces{i}.x, ref_faces{i}.y ...
                          ,target_im, target_bbox, target_X(:,i), target_Y(:,i));
end

%% Visualize (3)

i = 1;

imshow(ref_faces{i}.image);
hold on;
plot(ref_faces{i}.x, ref_faces{i}.y, 'o', 'Color', 'r');
plot(source_XX{i}, source_YY{i}, 'o', 'Color', 'g');

%%

i = 1;

imshow(target_im);
hold on;
plot(target_X(:,1), target_Y(:,1), 'o', 'Color', 'r');
plot(target_XX{i}, target_YY{i}, 'o', 'Color', 'g');

%% (4)

T    = cell(num_faces, 1);
HULL = cell(num_faces, 1);

for i=1:num_faces
    [T{i}, HULL{i}] = ...
        affine_warp_face([source_XX{i}, source_YY{i}], [target_XX{i}, target_YY{i}], -1);
end

%% (5)

% Find the target image's dimensions so we can define the limits of 
% source image after it is warped
[m,n,~]     = size(target_im);
output_view = imref2d([m,n], [1,n], [1,m]);

mask      = cell(num_faces, 1);
warp_face = cell(num_faces, 1);
warp_mask = cell(num_faces, 1);

for i=1:num_faces
    % Create a mask the size of the scaled face:
    [fn,fm,~] = size(ref_faces{i}.image);
    mask{i} = poly2mask(HULL{i}(:,1), HULL{i}(:,2), fn, fm);

    % Warp the scaled face and the mask:
    warp_face{i} = imwarp(ref_faces{i}.image, T{i}, 'OutputView', output_view);
    warp_mask{i} = imwarp(mask{i}, T{i}, 'OutputView', output_view);
end

%% Visualize (5)
[m,n] = size(warp_mask{1});
WARP_MASK = zeros(m, n, 3);
WARP_MASK(:,:,1) = warp_mask{1};
WARP_MASK(:,:,2) = warp_mask{1};
WARP_MASK(:,:,3) = warp_mask{1};

imshow([warp_face{1}, WARP_MASK]);

%% (6)
 
im_out = target_im;
for i=1:num_faces
    im_out = feather_blend_images(im_out, warp_face{i}, warp_mask{i});
end

imshow(im_out)

%% Show the points on the reference face along with the bounding box:
imshow(ref_face.image);
hold on;
plot(ref_face.x, ref_face.y, 'o', 'Color', 'g');
rectangle('Position', bbox_xy_to_wh(ref_face.bbox, 50), 'EdgeColor', 'g', 'LineWidth', 2);

%% Match and plot feature points between faces:

addpath('ransac');

[X1,Y1,X2,Y2] = ...
    refine_face_points(ref_face.image, ref_face.x, ref_face.y, im, X, Y);

[~,inliers] = ransac(Y1, X1, Y2, X2, 1);

showMatchedFeatures(ref_face.image, im, [X1(inliers),Y1(inliers)], [X2(inliers),Y2(inliers)], 'montage');
%showMatchedFeatures(ref_face.image, im, [X1,Y1], [X2,Y2], 'montage');

%% Test point snapping:

E = edge(rgb2gray(ref_face.image), 'canny');
imshow(E);
CHK = convhull(ref_face.x, ref_face.y);
[EXY] = snap_to_edges(E, [ref_face.x(CHK), ref_face.y(CHK)], 15);
% 
hold on;
plot(ref_face.x(CHK), ref_face.y(CHK), 'o', 'Color', 'g');
