%% Master test file

basic = load('data/basicset.mat');

%% === Blending set ===

%im = im2double(imread('data/testset/blending/Official_portrait_of_Barack_Obama.jpg'));
% im = im2double(imread('data/testset/blending/060610-beard-championships-bend-stroomer-0002.jpg'));
% im = im2double(imread('data/testset/blending/b1.jpg'));
im = im2double(imread('data/testset/blending/bc.jpg'));
% im = im2double(imread('data/testset/blending/Jennifer_lawrence_as_katniss-wide.jpg'));
%im = im2double(imread('data/testset/blending/jennifer-lawrences-mystique-new-x-men-spin-off-movie.jpg'));
%im = im2double(imread('data/testset/blending/Michael-Jordan.jpg'));
%im = im2double(imread('data/testset/blending/Official_portrait_of_Barack_Obama.jpg'));
%im = im2double(imread('data/testset/pose/Michael_Jordan_Net_Worth.jpg'));

%% === Pose set ===
% im = im2double(imread('data/testset/pose/golden-globes-jennifer-lawrence-0.jpg'));
% im = im2double(imread('data/testset/pose/Michael_Jordan_Net_Worth.jpg'));
% im = im2double(imread('data/testset/pose/p1.jpg'));
% im = im2double(imread('data/testset/pose/p2.jpg'));
%im = im2double(imread('data/testset/pose/Pepper-and-Tony-tony-stark-and-pepper-potts-9679158-1238-668.jpg'));
%im = im2double(imread('data/testset/pose/robert-downey-jr-5a.jpg'));
im = im2double(imread('data/testset/pose/star-trek-2009-sample-003.jpg'));

%% === More set ===
%im = im2double(imread('data/testset/more/real_madrid_2-wallpaper-960x600.jpg'));
%im = im2double(imread('data/testset/more/marvels-the-avengers-wallpapers-01-700x466.jpg'));
im = im2double(imread('data/testset/more/jkweddingdance-jill_and_kevin_wedding_party.jpg'));
%im = im2double(imread('data/testset/more/burn-marvel-s-the-avengers.jpg'));

im = imresize(im, 2);

%%
I = replace_face(im);

figure;
imshow(I);


