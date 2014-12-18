%%

addpath('fitw_detect');
addpath('tps');

data  = load('fitw_detect/face_p146_small.mat');
model = data.model;

%im  = im2double(imread('data/hard/14b999d49e77c6205a72ca87c2c2e5df.jpg'));
%im  = im2double(imread('data/easy/0013729928e6111451103c.jpg'));
%im  = im2double(imread('data/me-small.jpg'));
%im  = im2double(imread('data/hard/jennifer_xmen.jpg'));
%im  = im2double(imread('data/hard/0lliviaa.jpg'));
%im = im2double(imread('data/testset/blending/Official_portrait_of_Barack_Obama.jpg'));
%im = im2double(imread('data/testset/blending/b1.jpg'));
im = im2double(imread('data/testset/blending/bc.jpg'));
 im = im2double(imread('data/testset/pose/Michael_Jordan_Net_Worth.jpg'));
[X,Y,BBOX,ORIENTATION] = detect_faces(im, model);

%%

F = get_face_features(im, bbox_xy_to_wh(BBOX));
%rectangle('Position', bbox_xy_to_wh(BBOX), 'EdgeColor', 'y', 'LineWidth', 2);
plot_face_features(im, F);

%% Plot the raw points returned by detect_faces
%ref_face = rescale_face(im, find_reference_face(ORIENTATION), model, 0.2);
ref_face = find_reference_face(ORIENTATION);

%% Show the points on the reference face along with the bounding box:
imshow(ref_face.image);
hold on;
plot(ref_face.x, ref_face.y, 'o', 'Color', 'g');
rectangle('Position', bbox_xy_to_wh(ref_face.bbox, 50), 'EdgeColor', 'g', 'LineWidth', 2);

%% Match and plot feature points between faces:

[X1,Y1,X2,Y2] = ...
    refine_face_points(ref_face.image, ref_face.bbox, ref_face.x, ref_face.y ...
                      ,im, BBOX, X, Y);

showMatchedFeatures(ref_face.image, im, [X1,Y1], [X2,Y2], 'montage');

%% Test point snapping:

E = edge(rgb2gray(ref_face.image), 'canny');
imshow(E);
CHK = convhull(ref_face.x, ref_face.y);
[EXY] = snap_to_edges(E, [ref_face.x(CHK), ref_face.y(CHK)], 15);
% 
hold on;
plot(EXY(:,1), EXY(:,2), 'o', 'Color', 'g');

%% Warp the source face toward the target face using TPS:

[warp_im, face_outline, target_offset] = ...
    warp_face(ref_face.image, ref_face.bbox, [ref_face.x, ref_face.y], im, BBOX, [X,Y]);

%% Show the warped image and the outline of the face:

imshow(warp_im);
hold on;
plot(face_outline(:,1), face_outline(:,2), 'g-');

%% Overlay the face:

target_size = size(im);
warp_size   = size(warp_im);

I = im;
J = zeros(target_size(1), target_size(2),3);

i_range = round(target_offset(2):target_offset(2)+warp_size(1)-1);
j_range = round(target_offset(1):target_offset(1)+warp_size(2)-1);

%Paste the face into a blank image:
%I(i_range,j_range,:) = warp_im;
J(i_range,j_range,:) = warp_im;

FX = face_outline(:,1) + target_offset(1);
FY = face_outline(:,2) + target_offset(2);

%% Visualize:
imshow(I)
hold on;
plot(FX, FY, 'g-');
%rectangle('Position', bbox_xy_to_wh(BBOX), 'EdgeColor', 'g', 'LineWidth', 2);

%% Mask
mask = poly2mask(FX, FY, target_size(1), target_size(2));

out = gradient_blend(J, I, mask);

imshow(out)
