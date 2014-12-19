%% Detect face features using the software written X. Zhu and D. Ramanan.
% 
function [X,Y,BOX,ORIENTATION] = detect_faces(inputImage, model, nms_threshold, interval)
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
% [X,Y]         = (x,y) feature points, where X and Y are both NxM,
%                 where M is the number of detected faces
% BOX           = Mx4 bounding box of the form :[x1 y1 x2 y2], where M
%                 is the number of detected faces
% ORIENTATION   = Mx1 orientation angles, where M is the number of 
%                 detected faces
    addpath('fitw_detect');
 
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
        data  = load('fitw_detect/face_p146_small.mat');
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
    
    if isempty(bs)
        fprintf(1, '> Could not locate a face!...\n');
        X           = [];
        Y           = [];
        BOX         = [];
        ORIENTATION = NaN;
        return;
    end

    % define the mapping from view-specific mixture id to viewpoint
    if length(model.components)==13 
        posemap = 90:-15:-90;
    elseif length(model.components)==18
        posemap = [90:-15:15 0 0 0 0 0 0 -15:-15:-90];
    else
        error('Can not recognize this model');
    end

    % Dimension everything:
    M           = numel(bs);
    num_pts     = size(bs(1).xy, 1);
    X           = zeros(num_pts, M);
    Y           = zeros(num_pts, M);
    BOX         = zeros(M, 4);
    ORIENTATION = zeros(M,1);
    for i=1:M
        X(:,i)           = (bs(i).xy(:,1) + bs(i).xy(:,3)) ./ 2;
        Y(:,i)           = (bs(i).xy(:,2) + bs(i).xy(:,4)) ./ 2;
        BOX(i,:)         = [min(X(:,i)), min(Y(:,i)), max(X(:,i)), max(Y(:,i))];
        ORIENTATION(i,:) = posemap(bs(i).c);
    end

%     % We can get multiple faces, but for now, keep only one:
%     X   = X(:,1);
%     Y   = Y(:,1);
%     BOX = BOX(1,:);
%     ORIENTATION = ORIENTATION(1,:);
end
