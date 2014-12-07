%% Simple side-by-side face matching comparison harness script

%im = im2double(imread('data/easy/iu.jpg'));
%im = im2double(imread('data/easy/jennifer.jpg'));
%im = im2double(imread('data/hard/jennifer_xmen.jpg'));
%im = im2double(imread('data/hard/mj.jpg'));
%im = im2double(imread('data/hard/0lliviaa.jpg'));
%im = im2double(imread('data/hard/0b4e3684ebff3455f471bb82a0173f48.jpg'));
%im = im2double(imread('data/hard/4b5d69173e608408ecf97df87563fd34.jpg'));
%im = im2double(imread('data/hard/14b999d49e77c6205a72ca87c2c2e5df.jpg'));
%im = im2double(imread('data/hard/53e34a746d54adb574ab169d624ccd0a.jpg'));
%im = im2double(imread('data/hard/69daf49a8beb63dc35bf65b4e408cde9.jpg'));
%im = im2double(imread('data/hard/314eeaedbe5732558841972afdbaf32f.jpg'));
%im = im2double(imread('data/hard/beard-champs4.jpg'));
im = im2double(imread('data/hard/star-trek-2009-sample-003.jpg'));

feature = 'LeftEye';
result  = get_face_features(im, feature);
N       = numel(result);

result

if N == 0
    fprintf(1, '*** Nothing found ***\n');
else
    imshow(im);
    hold on;
    for i=1:N
        % Show the face bounding box
        rectangle('Position', result(i).Face, 'EdgeColor', 'r', 'LineWidth', 2);
        % Show the nose bounding box
        rectangle('Position', result(i).(feature), 'EdgeColor', 'g', 'LineWidth', 2);
    end
    hold off;
end
