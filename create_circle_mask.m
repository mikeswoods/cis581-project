%%
% Given a circles struct returned from circle_face_features(), this
% function creates a binary mask of solid, overlapping circles
%
% circles = circles struct returned from circle_face_features()
% n       = mask rows
% m       = mask columns
% mask    = output mask
function [mask] = create_circle_mask(circles, n, m)

    mask = zeros(n, m);
    f    = fieldnames(circles);
    for i=1:numel(f)
        circle = circles.(char(f(i)));
        mask = max(mask, imfill(poly2mask(circle(:,1), circle(:,2), n, m), 'holes'));
    end    
end
