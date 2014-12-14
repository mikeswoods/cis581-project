%% Processes all reference images listed in data/reference, builting
% a .mat file with the image data as well as data generated by
% detect_faces()

%% 
addpath('fitw_detect');
data  = load('fitw_detect/face_p146_small.mat');
model = data.model;

%%
