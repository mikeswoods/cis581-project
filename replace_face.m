%%
% Master face replacement function based on the workflow outlined in 
% workflow.m
%
% target_im = The target image to replace the face in
% out       = The output image with the same dimensions as target_im
function [out] = replace_face(target_im)

    % Add working paths for TPS and the FITW face detection code:
    addpath('fitw_detect');
    addpath('tps');

    % FITW training data:
    data  = load('fitw_detect/face_p146_small.mat');
    model = data.model;
    
    % Detect the face in the target image:
    fprintf(1, '> Detecting face in target image...\n');
    [target_X, target_Y, target_bbox, target_orientation] = ...
        detect_faces(target_im, model, 0.2);

    % Find the reference face with the closest orientation:
    ref_face = find_reference_face(target_orientation);

    source_X = ref_face.x;
    source_Y = ref_face.y;
    
    % Simply both faces:
%     [source_X, source_Y, target_X, target_Y] = ...
%         simply_face_points(ref_face.x, ref_face.y, target_X, target_Y);
    
    % Warp the source face toward the target face using TPS:
    fprintf(1, '> Running TPS...\n');
    [warp_im, face_outline, target_offset] = ...
        warp_face(ref_face.image ...
                 ,ref_face.bbox ...
                 ,[source_X, source_Y] ...
                 ,target_im ...
                 ,target_bbox ...
                 ,[target_X,target_Y]);

    % Overlay the face:
    target_size = size(target_im);
    warp_size   = size(warp_im);

    I = target_im;
    J = zeros(target_size(1), target_size(2),3);

    % Find the index range to do the paste within:
    i_range = round(target_offset(2):target_offset(2)+warp_size(1)-1);
    j_range = round(target_offset(1):target_offset(1)+warp_size(2)-1);

    % Paste the face into a blank image: 
    J(i_range,j_range,:) = warp_im;

    % Compute the offset of the source faces convex hull:
    FX = face_outline(:,1) + target_offset(1);
    FY = face_outline(:,2) + target_offset(2);

    % Create the blending mask:
    mask = poly2mask(FX, FY, target_size(1), target_size(2));
    out  = feather_blend_images(I, J, mask);
    
    imshow(out);
    hold on;
    plot(FX, FY, 'o', 'Color', 'r');
end
