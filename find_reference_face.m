%% Given a target image, this function returns the closest matching
% reference face with the same angle orientation in the range [-90,90]
%
% model     = The detection model, as used by detect_faces()
% target_im =
% ref_image =
function [ref_image] = find_reference_face(model, target_im, threshold)

    if nargin ~= 3
        threshold = 0.2;
    end

    [X,Y,bbox,orientation] = detect_faces(target_im, model, threshold);

    if orientation == -90
        1
    elseif orientation == -75
        1
    elseif orientation == -60
        1
    elseif orientation == -45
        1
    elseif orientation == -30
        1
    elseif orientation == -15
        1
    elseif orientation == 0
        1
    elseif orientation == 15
        1
     elseif orientation == 30
        1
    elseif orientation == 45
        1
    elseif orientation == 60
        1
    elseif orientation == 75
        1
    elseif orientation == 90
        1
    else
        error('Non-quantized orientation: %f', orientation);
    end
    
end

