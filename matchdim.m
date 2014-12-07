%% 
% Match the dimensions of the given imput and return padding info
function [U, V, padU, padV] = matchdim(P, Q, padder)
    [r1,c1,~] = size(P);
    [r2,c2,~] = size(Q);
    rMax      = max(r1,r2);
    cMax      = max(c1,c2);
    % Pad the images so they have matching dimensions:
    nsP  = (rMax - r1) ./ 2;
    weP  = (cMax - c1) ./ 2;
    padU = struct('N', floor(nsP) ...
                 ,'S', ceil(nsP) ...
                 ,'E', floor(weP) ...
                 ,'W', ceil(weP));
    U = padder(P, padU.N, padU.S, padU.E, padU.W);    
    nsQ  = (rMax - r2) ./ 2;
    weQ  = (cMax - c2) ./ 2;
    padV = struct('N', floor(nsQ) ...
                 ,'S', ceil(nsQ) ...
                 ,'E', floor(weQ) ...
                 ,'W', ceil(weQ));
    V = padder(Q, padV.N, padV.S, padV.E, padV.W);
end
