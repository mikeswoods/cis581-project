%%

addpath('fitw_detect');
addpath('tps');

data  = load('fitw_detect/face_p146_small.mat');
%data  = load('fitw_detect/multipie_independent.mat');
model = data.model;

%im  = im2double(imread('data/hard/14b999d49e77c6205a72ca87c2c2e5df.jpg'));
%im  = im2double(imread('data/easy/0013729928e6111451103c.jpg'));
%im  = im2double(imread('data/me-small.jpg'));
%im  = im2double(imread('data/hard/jennifer_xmen.jpg'));
im  = im2double(imread('data/hard/0lliviaa.jpg'));
%im = im2double(imread('data/testset/blending/Official_portrait_of_Barack_Obama.jpg'));
%im = im2double(imread('data/testset/blending/b1.jpg'));
%im = im2double(imread('data/testset/blending/bc.jpg'));
%im = im2double(imread('data/testset/pose/Michael_Jordan_Net_Worth.jpg'));
%im = im2double(imread('data/testset/pose/star-trek-2009-sample-003.jpg'));
[X,Y,BBOX,ORIENTATION] = detect_faces(im, model);

%%

F = get_face_features(im, bbox_xy_to_wh(BBOX));
%rectangle('Position', bbox_xy_to_wh(BBOX), 'EdgeColor', 'y', 'LineWidth', 2);
plot_face_features(im, F);

%% Plot the raw points returned by detect_faces
%ref_face = rescale_face(im, find_reference_face(ORIENTATION), model, 0.2);
ref_face = find_reference_face(ORIENTATION);
CHK = convhull(ref_face.x, ref_face.y);

%% Show the points on the reference face along with the bounding box:
imshow(ref_face.image);
hold on;
plot(ref_face.x, ref_face.y, 'o', 'Color', 'g');
rectangle('Position', bbox_xy_to_wh(ref_face.bbox, 50), 'EdgeColor', 'g', 'LineWidth', 2);

%% Match and plot feature points between faces:

addpath('ransac');

[X1,Y1,X2,Y2,H] = ...
    refine_face_points(ref_face.image, ref_face.bbox, ref_face.x, ref_face.y ...
                      ,im, BBOX, X, Y);

% [~,inliers] = ransac(Y1, X1, Y2, X2, 5);
% inliers
showMatchedFeatures(ref_face.image, im, [X1,Y1], [X2,Y2], 'montage');

%%

[X1,Y1,X2,Y2,~] = ...
    refine_face_points(ref_face.image, ref_face.bbox, ref_face.x, ref_face.y ...
                      ,im, BBOX, X, Y);

[source_face, target_offset, T] = ...
    affine_warp_face(ref_face.image, ref_face.bbox, [X1,Y1] ...
                    ,im, BBOX, [X2,Y2]);

warp_face = imwarp(source_face, T);
J = paste(warp_face, im, [1,1]);
    
imshow(J);

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

%%
mask = poly2mask(ref_face.x(CHK), ref_face.y(CHK), size(ref_face.image, 1), size(ref_face.image, 2));
T = fitgeotrans([X1,Y1], [X2,Y2] ,'Affine');

size(mask)
size(imwarp(mask, T))
imshow(imwarp(ref_face.image, T));


%% Mask
mask = poly2mask(ref_face.x(CHK), ref_face.y(CHK), size(ref_face.image, 1), size(ref_face.image, 2));
T = projective2d(H');
%imshow(mask);
imshow(imwarp(ref_face.image, T));

