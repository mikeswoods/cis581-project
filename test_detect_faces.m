%%

%im = im2double(imread('data/easy/iu.jpg'));
%im = im2double(imread('data/easy/jennifer.jpg'));
%im = im2double(imread('data/hard/jennifer_xmen.jpg'));
%im = im2double(imread('data/hard/mj.jpg'));
%im = im2double(imread('data/hard/0lliviaa.jpg'));
%im = im2double(imread('data/hard/0b4e3684ebff3455f471bb82a0173f48.jpg'));
%im = im2double(imread('data/hard/4b5d69173e608408ecf97df87563fd34.jpg'));
im = im2double(imread('data/hard/14b999d49e77c6205a72ca87c2c2e5df.jpg'));
%im = im2double(imread('data/hard/53e34a746d54adb574ab169d624ccd0a.jpg'));
%im = im2double(imread('data/hard/69daf49a8beb63dc35bf65b4e408cde9.jpg'));
%im = im2double(imread('data/hard/314eeaedbe5732558841972afdbaf32f.jpg'));
%im = im2double(imread('data/hard/beard-champs4.jpg'));
%im = im2double(imread('data/hard/star-trek-2009-sample-003.jpg'));

%%

addpath('final');
data      = load('final/face_p146_small.mat');
model     = data.model;
[X,Y,BOX] = detect_faces(im, model);
bbox      = [BOX(1), BOX(2), BOX(3) - BOX(1), BOX(4) - BOX(2)];

%%

imshow(im);
hold on;
plot(X, Y, 'o', 'Color', 'g');
rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);
hold off;

%% 

expand_by = 30;
I = imcrop(im, [bbox(1:2) - (expand_by .* 0.5), bbox(3:4) + (expand_by .* 1)]);
get_face_features(I);

%%

detector = vision.CascadeObjectDetector('Mouth', 'MergeThreshold', 6);
bboxes   = detector.step(imsharpen(imadjust(rgb2gray(I))));

imshow(I);
hold on;
for i=1:size(bboxes, 1)
    % Show the face bounding box
    rectangle('Position', bboxes(i,:), 'EdgeColor', 'r', 'LineWidth', 2);
end
hold off;

