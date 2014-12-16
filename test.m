%% Master test file

im = im2double(imread('data/easy/iu.jpg'));
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
%im = im2double(imread('data/hard/star-trek-2009-sample-003.jpg'));

out = replace_face(im);
%imshow(out);
