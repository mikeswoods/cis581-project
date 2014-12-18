% Converts a bounding box of the form [x1,y1,x2,y2] to the form
% [x,y,w,h]
%
% BBOX_WH       = Input bounding boxes in the form [x,y,w,h]
% dilate_amount = Dilation amount. If omitted, defaults to 0
% BBOX_XY       = Output bounding boxes in the form [x1,y1,x2,y2]
function [BBOX_XY] = bbox_xy_to_wh(bbox, dilate_amount)
    if nargin == 1
        dilate_amount = 0;
    end
    
    N       = size(bbox, 1);
    BBOX_XY = zeros(N, 4);
    
    BBOX_XY(:,1) = bbox(:,1) - (0.5 * dilate_amount); % X1
    BBOX_XY(:,2) = bbox(:,2) - (0.5 * dilate_amount); % Y1
    BBOX_XY(:,3) = (bbox(:,3) - bbox(:,1)) + dilate_amount; % X2
    BBOX_XY(:,4) = (bbox(:,4) - bbox(:,2)) + dilate_amount; % Y2
end
