%%

addpath('final');
data      = load('final/face_p146_small.mat');
model     = data.model;
im        = im2double(imread('data/hard/0lliviaa.jpg'));
[X,Y,BOX] = detect_faces(im, model);

%%

imshow(im);
hold on;
plot(X, Y, 'o', 'Color', 'g');

bbox = [BOX(1), BOX(2), BOX(3) - BOX(1), BOX(4) - BOX(2)];
rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);
