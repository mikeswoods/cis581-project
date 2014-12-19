%%
% Master face replacement function based on the workflow outlined in 
% workflow.m
%
% target_im = The target image to replace the face in
% max_faces = The maximum number of faces to replace in the target image
% im_out    = The output image with the same dimensions as target_im
function [im_out] = replace_face(target_im, max_faces)

    if nargin ~= 2
        max_faces = 99;
    end

    % Add working paths for TPS and the FITW face detection code:
    addpath('fitw_detect');
    addpath('tps');

    % FITW training data:
    data  = load('fitw_detect/face_p146_small.mat');
    model = data.model;
    
    % Detect the face in the target image:
    fprintf(1, '> Detecting face in target image...\n');
    [target_X, target_Y, target_bbox, target_orientation] = detect_faces(target_im, model);
    
    num_faces = numel(target_orientation);
    fprintf(1, '> Found %d faces', num_faces);
    
    num_faces = min([num_faces, max_faces]);
    fprintf(1, '> Replacing %d faces (max=%d)', num_faces, max_faces);
    
    % Dimension everything:
    ref_faces = cell(num_faces, 1);
    source_XX = cell(num_faces, 1);
    source_YY = cell(num_faces, 1);
    target_XX = cell(num_faces, 1);
    target_YY = cell(num_faces, 1);
    T         = cell(num_faces, 1);
    HULL      = cell(num_faces, 1);
    mask      = cell(num_faces, 1);
    warp_face = cell(num_faces, 1);
    warp_mask = cell(num_faces, 1);
    
    % Find the target image's dimensions so we can define the limits of 
    % source image after it is warped
    [m,n,~]     = size(target_im);
    output_view = imref2d([m,n], [1,n], [1,m]);
    
    im_out = target_im;
    
    fprintf(1, '> Output size after warp: %dx%d\n', m, n);
    
    for i=1:num_faces
    
        fprintf(1, '> Processing face (%d)...\n', i);
        
        % Find the reference face with the closest orientation:
        ref_faces{i} = find_reference_face(target_orientation);

        [source_XX{i}, source_YY{i}, target_XX{i}, target_YY{i}] = ...
            refine_face_points(ref_faces{i}.image, ref_faces{i}.bbox, ref_faces{i}.x, ref_faces{i}.y ...
                              ,target_im, target_bbox, target_X(:,i), target_Y(:,i));

        fprintf(1, '> Generating transformation for face (%d)...\n', i); 
        [T{i}, HULL{i}] = affine_warp_face([source_XX{i}, source_YY{i}], [target_XX{i}, target_YY{i}]);

        % Create a mask the size of the scaled face:
        [fn,fm,~] = size(ref_faces{i}.image);
        mask{i} = poly2mask(HULL{i}(:,1), HULL{i}(:,2), fn, fm);

        % Warp the scaled face and the mask:
        fprintf(1, '> Affine warping face (%d)...\n', i);
        warp_face{i} = imwarp(ref_faces{i}.image, T{i}, 'OutputView', output_view);
        warp_mask{i} = imwarp(mask{i}, T{i}, 'OutputView', output_view);

        % Composite everything:
        fprintf(1, '> Compositing...\n');
        im_out = feather_blend_images(im_out, warp_face{i}, warp_mask{i});
        %im_out = gradient_blend(warp_face{i}, im_out, warp_mask{i});
    end
        
    fprintf(1, '> Done\n');
end
