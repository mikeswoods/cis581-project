%% 
% Returns 4x2 matrix of top, right, bottom, left padding values for the
% described matrix based on the given dimensions [r c] in dims
function [M] = borders(dims, n)
    r      = dims(1);
    c      = dims(2);
    alongR = linspace(1, r, n);
    alongC = linspace(1, c, n);
    TOP    = [alongC ; repmat(1,1,n)]';
    BOTTOM = [alongC ; repmat(r,1,n)]';
    LEFT   = [repmat(1,1,n) ; alongR]';
    RIGHT  = [repmat(c,1,n) ; alongR]';
    M      = [TOP ; RIGHT ; BOTTOM ; LEFT];
end
