%% Detect face features using the software written X. Zhu and D. Ramanan.
% 
function [X,Y,BOX] = detect_faces(inputImage, model, nms_threshold, interval)
%
% This function makes use of the face detection software presented in
%
% "Face detection, pose estimation and landmark localization in the wild" 
% by X. Zhu, D. Ramanan. 
% Computer Vision and Pattern Recognition (CVPR) Providence, Rhode Island, June 2012. 
% http://www.ics.uci.edu/~xzhu/face/
%
% inputImage    = input image
% model         = model, as loaded by face_p146_small.mat, etc. If not
%                 specified, face_p146_small.mat is loaded and used
% nms_threshold = non-maximal suppression threshold. Default is 0.3.
% interval      = Model interval (? not sure what this does)
%
% [X,Y]         = (x,y) feature points
% BOX           = Bounding box of the form :[x1 y1 x2 y2]
    addpath('final');
 
    if nargin ~= 4
        % Used by demo.m ("5 levels for each octave")
        interval = 5;
    end
    
    % non-maxmimal suppresion threshold used after detection to prune
    % the number of points
    if nargin ~= 3
        nms_threshold = 0.3;
    end
    
    % Use the pre-trained model with 146 parts if model is not explictly
    % specified
    if nargin ~= 2
        data  = load('final/face_p146_small.mat');
        model = data.model;
    end
    
    % 5 levels for each octave
    model.interval = interval;

    % Set up the threshold:
    model.thresh = min(-0.65, model.thresh);

    sharpenedImage = imsharpen(inputImage, 'Radius', 2, 'Amount', 3);
    
    tic;
    fprintf(1, '> Detecting...');
    bs = detect(sharpenedImage, model, model.thresh);
    detectTime = toc;

    fprintf(1, 'done in %f seconds\n> Clipping...\n', detectTime);
    bs = clipboxes(inputImage, bs);

    fprintf(1, '> Suppressing...\n');
    bs = nms_face(bs, nms_threshold);
 
    %bs.xy is a Nx4 matrix, where each row is bounding box of the form:
    % [x1, y1, x2, y2]

    X   = (bs.xy(:,1) + bs.xy(:,3)) ./ 2;
    Y   = (bs.xy(:,2) + bs.xy(:,4)) ./ 2;
    BOX = [min(X), min(Y), max(X), max(Y)];
end
