%% Given a face and a struct returned from get_face_features(), this
% function will plot boudning boxes around all located features in the
% image
% 
% face_im       =
% face_features =
function plot_face_features(face_im, face_features)
    imshow(face_im);
    hold on;
    % Nose
    if face_features.Nose
        rectangle('Position', face_features.Nose, 'EdgeColor', 'r', 'LineWidth', 2);
    end
    % Eyes
    if face_features.LeftEye
        rectangle('Position', face_features.LeftEye, 'EdgeColor', 'y', 'LineWidth', 2);
    end
    if face_features.RightEye
        rectangle('Position', face_features.RightEye, 'EdgeColor', 'g', 'LineWidth', 2);
    end
    % Mouth
    if face_features.Mouth
        rectangle('Position', face_features.Mouth, 'EdgeColor', 'b', 'LineWidth', 2);
    end
end

