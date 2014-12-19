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

    % FITW training data:
    data  = load('fitw_detect/face_p146_small.mat');
    model = data.model;
    
    % Detect the face in the target image:
    fprintf(1, '> Detecting face in target image...\n');
    [target_X, target_Y, target_bbox, target_orientation] = detect_faces(target_im, model);
    
    
    figure; imshow(target_im); hold on;
    labels = cellstr( num2str([1:68]') );
    plot(target_X, target_Y, 'rx')
    text(target_X, target_Y, labels, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','right')
    hold off;
    num_faces = numel(target_orientation);
    fprintf(1, '> Found %d faces', num_faces);
    
    num_faces = min([num_faces, max_faces]);
    fprintf(1, '> Replacing %d faces (max=%d)', num_faces, max_faces);
    
    % Dimension everything:
    ref_faces = cell(num_faces, 1);
    source_XX = cell(num_faces, 1);
    source_YY = cell(num_faces, 1);
    source_circles = cell(num_faces, 1);
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

        % Better, more recent aproach:
        [source_XX{i}, source_YY{i}, source_circles{i}, target_XX{i}, target_YY{i}] = ...
            match_with_feature_circles(ref_faces{i}.image, ref_faces{i}.x, ref_faces{i}.y ...
                                     ,target_im, target_X(:,i), target_Y(:,i));
 
%       Older approach that doesn't work as well
%         [source_XX{i}, source_YY{i}, target_XX{i}, target_YY{i}] = ...
%             match_with_convex_hull(ref_faces{i}.image, ref_faces{i}.bbox, ref_faces{i}.x, ref_faces{i}.y ...
%                                   ,target_im, target_bbox, target_X(:,i), target_Y(:,i));

        fprintf(1, '> Generating transformation for face (%d)...\n', i); 
        T{i} = affine_warp_face([source_XX{i}, source_YY{i}], [target_XX{i}, target_YY{i}]);

        % Create a mask the based on the raw points of the source face:
        [fn,fm,~] = size(ref_faces{i}.image);
        %mask{i} = poly2mask(HULL{i}(:,1), HULL{i}(:,2), fn, fm);
        mask{i} = create_circle_mask(source_circles{i}, fn, fm);
        
        % Warp the scaled face and the mask:
        fprintf(1, '> Affine warping face (%d)...\n', i);
        warp_face{i} = imwarp(ref_faces{i}.image, T{i}, 'OutputView', output_view);
        warp_mask{i} = imwarp(mask{i}, T{i}, 'OutputView', output_view);

        % Composite everything:
        fprintf(1, '> Compositing...\n');
        
        %im_out = feather_blend_images(im_out, warp_face{i}, warp_mask{i});
        im_out = gradient_blend(warp_face{i}, im_out, warp_mask{i});
    end
        
    fprintf(1, '> Done\n');
end

%% Matches the face features on the basis of the convex hull determined by
% circles generated about the points for the eyes, nose, and mouth
% 
% Generally, this approach produces better results
%
function [source_XX, source_YY, source_circles, target_XX, target_YY] = ...
    match_with_feature_circles(ref_face_im, ref_face_X, ref_face_Y ...
                             ,target_im, target_X, target_Y)

    % Compute the circles over each feature for matching:
    [source_XX,source_YY,source_circles] = ...
        circle_face_features(ref_face_X, ref_face_Y);

    [target_XX,target_YY,~] = ...
        circle_face_features(target_X, target_Y);

    % Find the minimum convex hull for each face so as to allow all of the
    % points on the convex hull of the reference face to match against the
    % points on the target face--NOTE: This assumes that all points are
    % aligned to begin with!!!
    [source_XX, source_YY, target_XX, target_YY] = ...
        find_min_convex_hull(source_XX, source_YY, target_XX, target_YY);
    
    % Default parameterization
    radius         = 10;
    edge_threshold = 0.1;
    
    % Snap the points in the outline to the countours of the face
    % via edge detection to get a cleaner fit
    E1 = edge(rgb2gray(ref_face_im), 'canny', edge_threshold);
    E2 = edge(rgb2gray(target_im), 'canny', edge_threshold);
    
    [source_XX, source_YY] = snap_to_edges(E1, [source_XX, source_YY], radius);
    [target_XX, target_YY] = snap_to_edges(E2, [target_XX, target_YY], radius);
end

%% Match face points ising the convex hull and other facial landmark
% features
function [source_XX, source_YY, target_XX, target_YY] = ...
    match_with_convex_hull(ref_face_im, ref_face_bbox, ref_faces_X, ref_faces_Y ...
                          ,target_im, target_bbox, target_X, target_Y)

    [source_XX, source_YY, target_XX, target_YY] = ...
        refine_face_points(ref_face_im, ref_face_bbox, ref_faces_X, ref_faces_Y ...
                          ,target_im, target_bbox, target_X, target_Y);
end
