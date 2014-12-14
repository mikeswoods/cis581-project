%% Scale a target image according to the dimensions of a source image
%
% source_im     = The image whose dimensions to rescale to
% target_face   = The face struct to rescale
% model         = FITW face detection model
% threshold     = FITW detection threshold
% rescaled_face = The rescaled version of target
function [rescaled_face] = rescale_face(source_im, target_face, model, threshold)
    [Rs,Cs,~]   = size(source_im); 

    rescaled_face               = target_face;
    im_new                      = imresize(target_face.image, [Rs,Cs]);
    [X_new, Y_new, bbox_new, ~] = detect_faces(im_new, model, threshold);
    
    rescaled_face.image = im_new;
    rescaled_face.x     = X_new;
    rescaled_face.y     = Y_new;
    rescaled_face.bbox  = bbox_new(1,:);
end
