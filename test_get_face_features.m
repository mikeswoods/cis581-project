%%

%im = im2double(imread('data/easy/iu.jpg'));
%im = im2double(imread('data/easy/jennifer.jpg'));
%im = im2double(imread('data/hard/jennifer_xmen.jpg'));
%im = im2double(imread('data/hard/mj.jpg'));
%im = im2double(imread('data/hard/0lliviaa.jpg'));
%im = im2double(imread('data/hard/0b4e3684ebff3455f471bb82a0173f48.jpg'));
im = im2double(imread('data/hard/4b5d69173e608408ecf97df87563fd34.jpg'));
%im = im2double(imread('data/hard/14b999d49e77c6205a72ca87c2c2e5df.jpg'));
%im = im2double(imread('data/hard/53e34a746d54adb574ab169d624ccd0a.jpg'));
%im = im2double(imread('data/hard/69daf49a8beb63dc35bf65b4e408cde9.jpg'));
%im = im2double(imread('data/hard/314eeaedbe5732558841972afdbaf32f.jpg'));
%im = im2double(imread('data/hard/beard-champs4.jpg'));
%im = im2double(imread('data/hard/star-trek-2009-sample-003.jpg'));

%%

addpath('fitw_detect');
data      = load('fitw_detect/face_p146_small.mat');
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

expand_by_px  = 30;
[cropped_im, crop_rect] = imcrop(im, [bbox(1:2) - expand_by_px, bbox(3:4) + (expand_by_px .* 2)]);
F = get_face_features(cropped_im);

%% Finally, show everything found:

imshow(im);
hold on;

% Add the crop offsets back in the get the original positions:

for i=1:size(F.Nose, 1)
    R      = F.Nose(i,:);
    R(1:2) = R(1:2) + crop_rect(1:2);
    rectangle('Position', R, 'EdgeColor', 'r', 'LineWidth', 2);
end

for i=1:size(F.Mouth, 1)
    R      = F.Mouth(i,:);
    R(1:2) = R(1:2) + crop_rect(1:2);
    rectangle('Position', R, 'EdgeColor', 'b', 'LineWidth', 2);
end

for i=1:size(F.LeftEye, 1)
    R      = F.LeftEye(i,:);
    R(1:2) = R(1:2) + crop_rect(1:2);
    rectangle('Position', R, 'EdgeColor', 'g', 'LineWidth', 2);
end

for i=1:size(F.RightEye, 1)
    R      = F.RightEye(i,:);
    R(1:2) = R(1:2) + crop_rect(1:2);
    rectangle('Position', R, 'EdgeColor', 'y', 'LineWidth', 2);
end

hold off;
