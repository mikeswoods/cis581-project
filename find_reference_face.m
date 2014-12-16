%% Given a target image, this function returns the closest matching
% reference face with the same angle orientation in the range [-90,90]
%
% orientation = The orientation to use for finding a reference image
% ref_image   = struct
function [ref_face] = find_reference_face(orientation)

    reference_face = load('data/reference_face.mat');

    % Make sure orientation is an integer:
    orientation = round(orientation);
    
    if orientation == -90
        ref_face = reference_face.minus_90;
    elseif orientation == -75
        ref_face = reference_face.minus_75;
    elseif orientation == -60
        ref_face = reference_face.minus_60;
    elseif orientation == -45
        ref_face = reference_face.minus_45;
    elseif orientation == -30
        ref_face = reference_face.minus_30;
    elseif orientation == -15
        ref_face = reference_face.minus_15;
    elseif orientation == 0
        ref_face = reference_face.zero;
    elseif orientation == 15
        ref_face = reference_face.plus_15;
     elseif orientation == 30
        ref_face = reference_face.plus_30;
    elseif orientation == 45
        ref_face = reference_face.plus_45;
    elseif orientation == 60
        ref_face = reference_face.plus_60;
    elseif orientation == 75
        ref_face = reference_face.plus_75;
    elseif orientation == 90
        ref_face = reference_face.plus_90;
    else
        % Otherwise, just use 0
        ref_face = reference_face.zero;
        %error('Non-quantized orientation: %f', orientation);
    end
end

