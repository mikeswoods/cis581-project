%% 
% Warp image I to image J by mapping the pixel at (x,y) to (u,v)
function [J] = warp(I, x, y, u, v)
    [r,c,d] = size(I);
    J       = zeros(r,c,d);
    u       = clamp(u,1,r);
    v       = clamp(v,1,c);
    C       = [x, y, u, v];
    for k=1:size(C,1)
        c_k = C(k,:);
        xi  = c_k(1);
        yi  = c_k(2);
        U   = c_k(3);
        V   = c_k(4);
        uLo = floor(U);
        uHi = ceil(U);
        uW  = U - uLo;
        vLo = floor(V);
        vHi = ceil(V);
        vW  = V - vLo; 
        % Binlinearly interpolate:
        J(xi,yi,:) = (1.0 - uW) .* (((1.0 - vW) .* I(uLo,vLo,:)) + (vW .* I(uLo,vHi,:))) + ...
                     uW .* (((1.0 - vW) .* I(uHi,vLo,:)) + (vW .* I(uHi,vHi,:)));
    end
end
