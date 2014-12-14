%%

addpath('fitw_detect');
data  = load('fitw_detect/face_p146_small.mat');
model = data.model;

im  = im2double(imread('data/hard/14b999d49e77c6205a72ca87c2c2e5df.jpg'));
%im  = im2double(imread('data/easy/0013729928e6111451103c.jpg'));
%im  = im2double(imread('data/hard/jennifer_xmen.jpg'));
%im  = im2double(imread('data/hard/0lliviaa.jpg'));

[X,Y,FACE_BBOX,ORIENTATION] = detect_faces(im, model, 0.2);

%% Plot the raw points returned by detect_faces
ref_face = rescale_face(im, find_reference_face(ORIENTATION), model, 0.2);

imshow(ref_face.image);
hold on;
plot(ref_face.x, ref_face.y, 'o', 'Color', 'g');

%%

%get_face_features(face_image)
imshow(imcrop(ref_face.image, ref_face.bbox));

%rectangle('Position', BBOX(1,:), 'EdgeColor', 'g', 'LineWidth', 2);

%%

%matchFeatures([X,Y], [ref_face.x, ref_face.y]);

M1 = [X,Y];
M2 = [ref_face.x, ref_face.y];

showMatchedFeatures(im, ref_face.image, M1(1:10,:), M2(1:10,:), 'montage')

%%

%imshow([imresize(im, 0.5), imresize(ref_face, 0.5)]);


%ORIENTATION
%ref_face = find_reference_face(ORIENTATION);
%ref_face

%%

%imshow(ref_face.image);

%BBOX = bbox_wh_to_xy(FACE_BBOX, 20);

%imshow(im);
%hold on;
%plot(X, Y, 'o', 'Color', 'g');

%rectangle('Position', BBOX(1,:), 'EdgeColor', 'g', 'LineWidth', 2);

%%

%face_only = imcrop(im, BBOX);
%face_features = get_face_features(face_only);
%face_features
