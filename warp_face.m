%
%
function [W] = warp_face(source_im, source_bbox, source_P, target_im, target_bbox, target_P)
    
    % Crop the source and target faces
    [source_face, src_crop_bbox]    = imcrop(source_im, source_bbox);
    [target_face, target_crop_bbox] = imcrop(target_im, target_bbox);
    
    % Recompute points:
    source_Q(:,1) = source_P(:,1) - src_crop_bbox(1);
    source_Q(:,2) = source_P(:,2) - src_crop_bbox(2);
    target_Q(:,1) = target_P(:,1) - target_crop_bbox(1);
    target_Q(:,2) = target_P(:,2) - target_crop_bbox(2);
  
    % Take the points corresponding to the convex hull of the source
    % and target faces:
    ks = convhull(source_Q(:,1), source_Q(:,2));
    source_face_outline = [source_Q(ks,1), source_Q(ks,2)];
    
    kt = convhull(target_Q(:,1), target_Q(:,2));
    target_face_outline = [target_Q(kt,1), target_Q(kt,2)];

    addpath('tps');
    W = morph_tps_wrapper(source_face, target_face, source_Q, target_Q, 1.0, 0.0);
    
    imshow(W);
    
    % Compute the transformation:
%     tform = estimateGeometricTransform(source_Q, target_Q, 'affine');
% 
%     imshow(source_face);
%     hold on;
%     plot(source_face_outline(:,1), source_face_outline(:,2), 'r-');
%     plot(target_face_outline(:,1), target_face_outline(:,2), 'g-'); 
%     plot(Q(:,1), Q(:,2), 'b-'); 
end

function [Q] = xform_points(T,P)
    n    = size(P,1);
    PH = [P, ones(n, 1)]; 
    PT = zeros(n, 3);
    
    for i=1:n
        PT(i,:) = PH(i,:) * T;
    end
    
    w = PT(:,3);
    Q = [PT(:,1) ./ w, PT(:,2) ./ w];
end

