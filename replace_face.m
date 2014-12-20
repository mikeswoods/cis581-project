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

    % Pitch rotation threshold in degrees:
    pitch_threshold = 10;
    
    % Add working paths for TPS and the FITW face detection code:
    addpath('fitw_detect');

    % FITW training data:
    data  = load('fitw_detect/face_p146_small.mat');
    model = data.model;
    
    % Detect the face in the target image:
    fprintf(1, '> Detecting face in target image...\n');
    [target_X, target_Y, ~, target_orientation] = detect_faces(target_im, model);
    
%     figure; imshow(target_im); hold on;
%     labels = cellstr( num2str([1:68]') );
%     plot(target_X, target_Y, 'rx')
%     text(target_X, target_Y, labels, 'VerticalAlignment','bottom', ...
%                              'HorizontalAlignment','right')
%     hold off;

    num_faces = numel(target_orientation);
    fprintf(1, '> Found %d faces', num_faces);
    
    num_faces = min([num_faces, max_faces]);
    fprintf(1, '> Replacing %d faces (max=%d)', num_faces, max_faces);
    
    % Dimension everything:
    ref_faces = cell(num_faces, 1);

    source_XX = cell(num_faces, 1);
    source_YY = cell(num_faces, 1);
    source_features = cell(num_faces, 1);

    target_XX = cell(num_faces, 1);
    target_YY = cell(num_faces, 1);
    target_features = cell(num_faces, 1);

    T         = cell(num_faces, 1);
    warp_face = cell(num_faces, 1);
    warp_mask = cell(num_faces, 1);
    
    % Default parameterization
    radius         = 10;
    edge_threshold = 0.2;
 
    % Find the target image's dimensions so we can define the limits of 
    % source image after it is warped
    [m,n,~]     = size(target_im);
    output_view = imref2d([m,n], [1,n], [1,m]);
    
    im_out = target_im;
    
    fprintf(1, '> Output size after warp: %dx%d\n', m, n);
    
    for i=1:num_faces
    
        fprintf(1, '> Processing face (%d)...\n', i);
        
        % Find the reference face with the closest orientation:
        fprintf(1, '> Finding reference face for orientation=%d...\n', target_orientation);
        ref_faces{i} = find_reference_face(target_orientation);

        % Compute each feature for matching in source and target:
        [source_XX{i}, source_YY{i}, source_features{i}] = ...
            circle_face_features(ref_faces{i}.x, ref_faces{i}.y);
 
        [target_XX{i}, target_YY{i}, target_features{i}] = ...
            circle_face_features(target_X(:,i), target_Y(:,i));

        % Find the minimum convex hull for each face so as to allow all of the
        % points on the convex hull of the reference face to match against the
        % points on the target face--NOTE: This assumes that all points are
        % aligned to begin with!!!
        [source_XX{i}, source_YY{i}, target_XX{i}, target_YY{i}] = ...
            find_min_convex_hull(source_XX{i}, source_YY{i}, target_XX{i}, target_YY{i});

        % Snap the points in the outline to the countours of the face
        % via edge detection to get a cleaner fit
        source_EM = edge(rgb2gray(ref_faces{i}.image), 'canny', edge_threshold);
        target_EM = edge(rgb2gray(target_im), 'canny', edge_threshold);

        [source_XX{i}, source_YY{i}] = ...
            snap_to_edges(source_EM, [source_XX{i}, source_YY{i}], radius);
 
        [target_XX{i}, target_YY{i}] = ...
            snap_to_edges(target_EM, [target_XX{i}, target_YY{i}], radius);

        fprintf(1, '> Generating transformation for face (%d)...\n', i); 
        T{i} = affine_warp_face([source_XX{i}, source_YY{i}], [target_XX{i}, target_YY{i}], 8);

        % Find the center of the target face region:
        target_center = mean([target_XX{i}, target_YY{i}]);
        pitch_angle   = estimate_pitch(target_features{i}.LeftEyeCenter, target_features{i}.RightEyeCenter);
        fprintf(1, '> Estimated pitch of target %d: %f\n', i, pitch_angle);
        
        % Create a mask the based on the raw points of the source face:
        [fn,fm,~] = size(ref_faces{i}.image);
        
        % Warp face and the mask:
        fprintf(1, '> Affine warping face (%d)...\n', i);
        warp_face{i} = imwarp(ref_faces{i}.image, T{i}, 'OutputView', output_view);
        warp_mask{i} = imwarp(create_circle_mask(source_features{i}, fn, fm), T{i}, 'OutputView', output_view);

        if abs(pitch_angle) > pitch_threshold
            fprintf('> Target pitch |%f| over threshold (%f deg.) ; rotating...\n', pitch_angle, pitch_threshold);
        
            warp_face{i} = rotate_around(warp_face{i}, target_center(2), target_center(1), pitch_angle, 'bicubic');
            warp_mask{i} = rotate_around(warp_mask{i}, target_center(2), target_center(1), pitch_angle, 'bicubic');
        
        else
            fprintf('> Target pitch under threshold (%f deg.) ; no rotation needed\n', pitch_threshold);
        end
        
        % Create the target mask, however, only look at the points on the
        % target face region that are part of the convex hull:
        fprintf(1, '> Generating target mask...\n');
        k = convhull(target_X(:,i), target_Y(:,i));
        target_mask = create_target_mask(target_im, target_X(k,i), target_Y(k,i), 0.2, 10);

        % Generate the final mask as the binary intersection of the 
        % target mask and the warped source face mask:
        final_mask = target_mask & warp_mask{i};
        
        % Composite everything:
        fprintf(1, '> Compositing...\n');
        im_out = feather_blend_images(im_out, warp_face{i}, final_mask);
        %im_out = gradient_blend_images(im_out, warp_face{i}, final_mask);
    end
        
    fprintf(1, '> Done\n');
end

%%
% Creates a mask over the target face
function [mask] = create_target_mask(im, X, Y, threshold, radius)
    E        = edge(rgb2gray(im), 'canny', threshold);
    k        = convhull(X(:,1), Y(:,1));
    [TX, TY] = snap_to_edges(E, [X(k,1), Y(k,1)], radius);
    mask     = poly2mask(TX, TY, size(im, 1), size(im, 2));
end
