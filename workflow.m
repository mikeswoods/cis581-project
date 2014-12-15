%%

addpath('fitw_detect');
addpath('tps');

data  = load('fitw_detect/face_p146_small.mat');
model = data.model;

%im  = im2double(imread('data/hard/14b999d49e77c6205a72ca87c2c2e5df.jpg'));
%im  = im2double(imread('data/easy/0013729928e6111451103c.jpg'));
%im  = im2double(imread('data/hard/jennifer_xmen.jpg'));
im  = im2double(imread('data/hard/0lliviaa.jpg'));

[X,Y,BBOX,ORIENTATION] = detect_faces(im, model, 0.2);

%% Plot the raw points returned by detect_faces
%ref_face = rescale_face(im, find_reference_face(ORIENTATION), model, 0.2);
ref_face = find_reference_face(ORIENTATION);

%% Show the points on the reference face along with the bounding box:
imshow(ref_face.image);
hold on;
plot(ref_face.x, ref_face.y, 'o', 'Color', 'g');
rectangle('Position', bbox_wh_to_xy(ref_face.bbox, 50), 'EdgeColor', 'g', 'LineWidth', 2);

%% Show the points on the target face along with the bounding box:
imshow(im);
hold on;
P = [X, Y];
P = shuffle(P);
plot(P(:,1), P(:,2), 'o', 'Color', 'g');
rectangle('Position', bbox_wh_to_xy(BBOX, 50), 'EdgeColor', 'g', 'LineWidth', 2);

%% Match and plot feature points between faces:
P = [ref_face.x, ref_face.y];
Q = [X,Y];
M = shape_context_match(P, Q);
showMatchedFeatures(ref_face.image, im, P(M,:), Q, 'montage');

%%

warp_face(ref_face.image ...
         ,round(bbox_wh_to_xy(ref_face.bbox)) ...
         ,[ref_face.x, ref_face.y] ...
         ,im ...
         ,round(bbox_wh_to_xy(BBOX)) ...
         ,[X,Y]);

