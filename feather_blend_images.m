%%
% Blends two images I, J, with feathering yielding K using the 
% binary mask mask
%
% I    = MxNx3 image 
% J    = MxNx3 image
% mask = MxN   binary mask
function [K] = feather_blend_images(I, J, mask)
    
    G = fspecial('gaussian', [25,25], 5);
    mask_feather     = imfilter(double(mask), G);
    not_mask_feather = imfilter(double(~mask), G);

    %imshow([face_only_feather, not_face_feather]);
    II = I;
    JJ = J;
    for i=1:3 % For each RGB channel
        II(:,:,i) = II(:,:,i) .* not_mask_feather;
        JJ(:,:,i) = JJ(:,:,i) .* mask_feather;
    end
%     figure; imshow(II);
%     figure; imshow(JJ);
%     drawnow;
    K = imadd(II, JJ);
    % K = max(II, JJ);
end
