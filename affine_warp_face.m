%
%
function [source_face, target_offset, T, HULL] = ...
    affine_warp_face(source_im, source_bbox, source_P, target_im, target_bbox, target_P)

    % Crop the source and target faces
    [source_face, src_crop_bbox]    = imcrop(source_im, bbox_xy_to_wh(source_bbox, 10));
    [target_face, target_crop_bbox] = imcrop(target_im, bbox_xy_to_wh(target_bbox, 10));
    
    scale_w = size(target_face, 2) ./ size(source_face, 2);
    scale_h = size(target_face, 1) ./ size(source_face, 1);
    
    % Rescale the source face to be the same size as the target:
    source_face = imresize(source_face, [size(target_face, 1), size(target_face, 2)]);
    
    % Recompute points:
    source_Q(:,1) = (source_P(:,1) - src_crop_bbox(1)) .* scale_w;
    source_Q(:,2) = (source_P(:,2) - src_crop_bbox(2)) .* scale_h;
    target_Q(:,1) = target_P(:,1) - target_crop_bbox(1);
    target_Q(:,2) = target_P(:,2) - target_crop_bbox(2);

    % Compute the convex hull of the scaled face:
    k    = convhull(source_Q(:,1), source_Q(:,2));
    HULL = [source_Q(k,1), source_Q(k,2)];
    
    % Run RANSAC to remove outliers:
    [~,I] = ransac(source_Q(:,1), source_Q(:,2), target_Q(:,1), target_Q(:,2), 4);
    
    % Construct a transformation from the matched points:
    T = fitgeotrans([source_Q(I,1), source_Q(I,2)], [target_Q(I,1), target_Q(I,2)] ,'affine');

    target_offset = target_crop_bbox;
end
