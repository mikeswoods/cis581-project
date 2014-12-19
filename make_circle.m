%%
% Given a point (x,y) and a radius r, this function will generate a 
% circle comprised of n points
%
% Adapted from http://www.mathworks.com/matlabcentral/answers/4633-how-to-draw-a-circle-on-specific-points-in-an-image
% by user "the cyclist"
%
% x  = x coordinate of the center
% y  = y coordinate of the center
% r  = radius of the circle
% n  = the number of points in the circle
% CX = the output circle's x coordinates
% CY = the output circle's y coordinates
function [C] = make_circle(x, y, r, n)  
    if nargin < 4
        n = 50;
    end
    theta = 0:2*pi/n:2*pi;
    cx    = r * cos(theta) + x;
    cy    = r * sin(theta) + y;
    C     = [cx', cy'];
end
