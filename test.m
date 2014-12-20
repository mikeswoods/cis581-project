%% == Easy set ===

% im = im2double(imread('data/easy/1d198487f39d9981c514f968619e9c91.jpg'));
% im = im2double(imread('data/easy/0013729928e6111451103c.jpg'));
% im = im2double(imread('data/easy/1407162060_59511.jpg'));
% im = im2double(imread('data/easy/bc.jpg'));
im = im2double(imread('data/easy/celebrity-couples-01082011-lead.jpg'));
% im = im2double(imread('data/easy/inception-shared-dreaming.jpg'));
% im = im2double(imread('data/easy/Iron-Man-Tony-Stark-the-avengers-29489238-2124-2560.jpg'));
% im = im2double(imread('data/easy/iu.jpg'));
% im = im2double(imread('data/easy/jennifer.jpg'));
% im = im2double(imread('data/easy/yao.jpg'));

%% == Hard set ===

im = im2double(imread('data/hard/0b4e3684ebff3455f471bb82a0173f48.jpg'));
im = im2double(imread('data/hard/0lliviaa.jpg'));
%im = im2double(imread('data/hard/4b5d69173e608408ecf97df87563fd34.jpg'));
%im = im2double(imread('data/hard/14b999d49e77c6205a72ca87c2c2e5df.jpg'));
%im = im2double(imread('data/hard/53e34a746d54adb574ab169d624ccd0a.jpg'));
%im = im2double(imread('data/hard/69daf49a8beb63dc35bf65b4e408cde9.jpg'));
%im = im2double(imread('data/hard/314eeaedbe5732558841972afdbaf32f.jpg'));
%im = im2double(imread('data/hard/beard-champs4.jpg'));
%im = im2double(imread('data/hard/jennifer_xmen.jpg'));
%im = im2double(imread('data/hard/mj.jpg'));
%im = im2double(imread('data/hard/star-trek-2009-sample-003.jpg'));

%% === Blending set ===

im = im2double(imread('data/testset/blending/Official_portrait_of_Barack_Obama.jpg'));
%im = im2double(imread('data/testset/blending/060610-beard-championships-bend-stroomer-0002.jpg'));
%im = im2double(imread('data/testset/blending/b1.jpg'));
%im = im2double(imread('data/testset/blending/bc.jpg'));
%im = im2double(imread('data/testset/blending/Jennifer_lawrence_as_katniss-wide.jpg'));
%im = im2double(imread('data/testset/blending/jennifer-lawrences-mystique-new-x-men-spin-off-movie.jpg'));
%im = im2double(imread('data/testset/blending/Michael-Jordan.jpg'));
%im = im2double(imread('data/testset/blending/Official_portrait_of_Barack_Obama.jpg'));
%im = im2double(imread('data/testset/pose/Michael_Jordan_Net_Worth.jpg'));
%im = im2double(imread('data/hard/0b4e3684ebff3455f471bb82a0173f48.jpg'));
%im = im2double(imread('data/hard/14b999d49e77c6205a72ca87c2c2e5df.jpg'));

%% === Pose set ===
% im = im2double(imread('data/testset/pose/golden-globes-jennifer-lawrence-0.jpg'));
 im = im2double(imread('data/testset/pose/Michael_Jordan_Net_Worth.jpg'));
% im = im2double(imread('data/testset/pose/p1.jpg'));
% im = im2double(imread('data/testset/pose/p2.jpg'));
%im = im2double(imread('data/testset/pose/Pepper-and-Tony-tony-stark-and-pepper-potts-9679158-1238-668.jpg'));
%im = im2double(imread('data/testset/pose/robert-downey-jr-5a.jpg'));
%im = im2double(imread('data/testset/pose/star-trek-2009-sample-003.jpg'));

%% === More set ===
%im = im2double(imread('data/testset/more/real_madrid_2-wallpaper-960x600.jpg'));
%im = im2double(imread('data/testset/more/marvels-the-avengers-wallpapers-01-700x466.jpg'));
%im = im2double(imread('data/testset/more/jkweddingdance-jill_and_kevin_wedding_party.jpg'));
%im = im2double(imread('data/testset/more/burn-marvel-s-the-avengers.jpg'));

im = imresize(im, 2);

%% Run it
I = replace_face(im);
imshow(I);
