%%
% Given two points, this function estimates pitch from the horizon
% in degrees
%
% P     = (x1,y1) point #1
% Q     = (x2,y2) point #2
% pitch = estimated pitch angle in degrees
function [pitch] = estimate_pitch(P, Q)

    % 1. Normalized vector from P -> Q
    v1 = P - Q;
    v1 = v1 ./ norm(v1, 2);

    % 2. Normalized vector from Q to P projected onto the horizon:
    v2 = P - [Q(1), P(2)];
    
    if any(v2)
        v2 = v2 ./ norm(v2, 2);
    end

    pitch = radtodeg(acos(dot(v1, v2)));
    
    N = atan2(v2, v1);
    if N(2) > 0
        pitch = -pitch;
    end
end
