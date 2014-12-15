%% 
% Clamps a value to the range [lo,hi]
function [out] = clamp(value, lo, hi)
    out = max(min(value, hi), lo);
end

