%%
% Master face replacement function based on the workflow outlined in 
% workflow.m
%
% target_im = The target image to replace the face in
% target_outline = 
% im_out    = The output image with the same dimensions as target_im
function [im_out] = replace_face(target_im)

    % Add working paths for TPS and the FITW face detection code:
    addpath('fitw_detect');
    addpath('tps');

    % FITW training data:
    data  = load('fitw_detect/face_p146_small.mat');
    model = data.model;
    
    % Detect the face in the target image:
    fprintf(1, '> Detecting face in target image...\n');
    [target_X, target_Y, target_bbox, target_orientation] = detect_faces(target_im, model, 0.2);

    % Find the reference face with the closest orientation:
    ref_face = find_reference_face(target_orientation);

    [source_X, source_Y, target_X, target_Y] = ...
        refine_face_points(ref_face.image, ref_face.bbox, ref_face.x, ref_face.y ...
                          ,target_im, target_bbox, target_X, target_Y ...
                          ,2);

    [T, HULL] = affine_warp_face([source_X, source_Y], [target_X, target_Y]);
    
    % Find the target image's dimensions so we can define the limits of 
    % source image after it is warped
    [m,n,~]     = size(target_im);
    output_view = imref2d([m,n], [1,n], [1,m]);

    fprintf(1, '> Output size after warp: %dx%d\n', m, n);
    
    % Create a mask the size of the scaled face:
    [fn,fm,~] = size(ref_face.image);
    mask = poly2mask(HULL(:,1), HULL(:,2), fn, fm);

    % Warp the scaled face and the mask:
    warp_face = imwarp(ref_face.image, T, 'OutputView', output_view);
    warp_mask = imwarp(mask, T, 'OutputView', output_view);

    % Composite everything:
    fprintf(1, '> Compositing...\n');
    %im_out = feather_blend_images(target_im, warp_face, warp_mask);
    im_out = gradient_blend(warp_face, target_im, warp_mask);
    
    fprintf(1, '> Done\n');
end
