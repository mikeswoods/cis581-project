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
    
    % Warp the source face toward the target face using TPS:
%     fprintf(1, '> Running TPS...\n');
%     [warp_im, target_offset] = ...
%         tps_warp_face(ref_face.image ...
%                      ,ref_face.bbox ...
%                      ,[source_X, source_Y] ...
%                      ,target_im ...
%                      ,target_bbox ...
%                      ,[target_X,target_Y]);

    [source_X, source_Y, target_X, target_Y] = ...
        refine_face_points(ref_face.image, ref_face.bbox, ref_face.x, ref_face.y ...
                          ,target_im, target_bbox, target_X, target_Y ...
                          ,2);

    [scaled_face, target_offset, T, HULL] = ...
        affine_warp_face(ref_face.image, ref_face.bbox, [source_X, source_Y] ...
                        ,target_im, target_bbox, [target_X, target_Y]);
    
    % Create a mask the size of the scaled face:
    mask = poly2mask(HULL(:,1), HULL(:,2), size(scaled_face, 1), size(scaled_face, 2));
                    
    % Warp the scaled face and the mask:
    warp_scaled_face = imwarp(scaled_face, T);
    warp_mask        = imwarp(mask, T);
            
    % Paste the warped mask into the target image:
    [m,n,~]   = size(target_im);
    full_mask = paste(warp_mask, zeros(m,n), target_offset);
    
    % Add the warped, scaled face to a blank frame also with the same
    % dimensions and offset:
    full_face = paste(warp_scaled_face, zeros(size(target_im)), target_offset);
    
    % Composite everything:
    fprintf(1, '> Compositing...\n');
    im_out = feather_blend_images(target_im, full_face, full_mask);
    %im_out = gradient_blend(full_face, target_im, full_mask);
    
    fprintf(1, '> Done\n');
end
