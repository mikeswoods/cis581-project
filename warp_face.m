%%
% Warps the face using TPS, returning an image the same dimensions as the
% target image and a Nx2 matrix of points comprising the convex hull of
% the face
function [warp_im, face_outline] = warp_face(source_im, source_P, target_im, target_P)

    addpath('tps');
    [W,~,target_pad] = morph_tps_wrapper(source_im, target_im, source_P, target_P, 1.0, 0.0);
    
    % Crop W to the size of the original target image: [x1 y1 x2 y2]
    target_w  = size(target_im,2);
    target_h  = size(target_im,1);
    crop_rect = [target_pad.S, target_pad.W, target_w - 1, target_h - 1];    
    warp_im   = imcrop(W, crop_rect);

    % Take the points corresponding to the convex hull of the target faces
    % and use it to cut out the outline of the warped face:    
    K = convhull(target_P(:,1), target_P(:,2));
    face_outline = [target_P(K,1) , target_P(K,2) ];
end
