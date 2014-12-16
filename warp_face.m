%
%
function [warp_im, outline, target_offset] = warp_face(source_im, source_bbox, source_P, target_im, target_bbox, target_P)
    
    addpath('tps');

    % Crop the source and target faces
    [source_face, src_crop_bbox]    = imcrop(source_im, bbox_wh_to_xy(source_bbox, 10));
    [target_face, target_crop_bbox] = imcrop(target_im, bbox_wh_to_xy(target_bbox, 10));
    
    scale_w = size(target_face, 2) ./ size(source_face, 2);
    scale_h = size(target_face, 1) ./ size(source_face, 1);
    
    % Rescale the source face to be the same size as the target:
    source_face = imresize(source_face, [size(target_face, 1), size(target_face, 2)]);
    
    % Recompute points:
    source_Q(:,1) = (source_P(:,1) - src_crop_bbox(1)) .* scale_w;
    source_Q(:,2) = (source_P(:,2) - src_crop_bbox(2)) .* scale_h;
    target_Q(:,1) = target_P(:,1) - target_crop_bbox(1);
    target_Q(:,2) = target_P(:,2) - target_crop_bbox(2);

%     imshow(source_face);
%     hold on;
%     plot(source_Q(:,1), source_Q(:,2), 'o', 'Color', 'g');
%     
%     imshow(target_face);
%     hold on;
%     plot(target_Q(:,1), target_Q(:,2), 'o', 'Color', 'g');

    target_offset = target_crop_bbox;

    [warp_im, ~, padding] = ...
        morph_tps_wrapper(source_face, target_face, source_Q, target_Q, 1.0, 0.0);

    % Take the points corresponding to the convex hull of the target faces
    % and use it to cut out the outline of the warped face:    
    K       = convhull(target_Q(:,1), target_Q(:,2));
    outline = [target_Q(K,1) + padding.W, target_Q(K,2) + padding.S];
end
