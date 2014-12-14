%%

addpath('fitw_detect');
data  = load('fitw_detect/face_p146_small.mat');
model = data.model;

%im        = im2double(imread('data/hard/14b999d49e77c6205a72ca87c2c2e5df.jpg'));
%im        = im2double(imread('data/easy/0013729928e6111451103c.jpg'));
%im        = im2double(imread('data/hard/jennifer_xmen.jpg'));
im        = im2double(imread('data/hard/0lliviaa.jpg'));

[X,Y,FACE_BBOX,ORIENTATION] = detect_faces(im, model, 0.2);

%% Plot the raw points returned by detect_faces

BBOX = bbox_wh_to_xy(FACE_BBOX, 20);

imshow(im);
hold on;
plot(X, Y, 'o', 'Color', 'g');

rectangle('Position', BBOX(1,:), 'EdgeColor', 'g', 'LineWidth', 2);

%%

face_only = imcrop(im, BBOX);
face_features = get_face_features(face_only);

face_features
