% Converts a bounding box of the form [x,y,w,h] to the form
% [x1,y1,y2,y2]
%
% BBOX_WH       = Input bounding boxes in the form [x,y,w,h]
% dilate_amount = Dilation amount. If omitted, defaults to 0
% BBOX_XY       = Output bounding boxes in the form [x1,y1,x2,y2]
function [BBOX_XY] = bbox_wh_to_xy(BBOX_WH, dilate_amount)
    if nargin == 1
        dilate_amount = 0;
    end
    
    N = size(BBOX_WH, 1);
    BBOX_XY = zeros(N, 4);
    
    BBOX_XY(:,1) = BBOX_WH(:,1) - (0.5 * dilate_amount); % X1
    BBOX_XY(:,2) = BBOX_WH(:,2) - (0.5 * dilate_amount); % Y1
    BBOX_XY(:,3) = (BBOX_WH(:,3) - BBOX_WH(:,1)) + dilate_amount; % X2
    BBOX_XY(:,4) = (BBOX_WH(:,4) - BBOX_WH(:,2)) + dilate_amount; % Y2
end
