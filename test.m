%% Master test file

basic = load('data/basicset.mat');

%% 

% im = im2double(imread('data/hard/53e34a746d54adb574ab169d624ccd0a.jpg'));
% im = im2double(imread('data/testset/blending/Michael-Jordan.jpg'));
im = im2double(imread('data/testset/blending/Official_portrait_of_Barack_Obama.jpg'));


%% 

[I, t_out] = replace_face(basic.easy{6});

%%

[I, t_out] = replace_face(im);

%%
imshow(I);

%%
imshow(I);
hold on;
plot(t_out(:,1), t_out(:,2), 'g-');
hold off;
