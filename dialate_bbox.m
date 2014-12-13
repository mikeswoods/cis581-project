function [ bbox ] = dialate_bbox( BOX, amount )
%DIALATE_BBOX Summary of this function goes here
%   Detailed explanation goes here

BOX
bbox = [BOX(1)-amount, BOX(2)-amount, ...
    (BOX(3)+2*amount), (BOX(4)+2*amount)];
bbox

end

