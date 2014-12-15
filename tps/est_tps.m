%% Thin-plate parameter estimation
% where pts is the point positions (x and y) in the image (B) (px2), 
% and target value is the corresponding point x or y position (px1) in 
% image (A).
function [a1,ax,ay,w] = est_tps(ctr_pts, target_value, lambda)
    if nargin ~= 3
        lambda = 1;
    end
    n      = size(ctr_pts,1);
    P      = [ones(n,1), ctr_pts];
    Z      = zeros(3,3);
    v      = [target_value ; 0 ; 0 ; 0];
    [X,Y]  = meshgrid(1:n,1:n);
    k      = arrayfun(@(i,j) U(K(ctr_pts(i,:), ctr_pts(j,:))), X, Y);
    M      = [k P ; P' Z];
    I      = eye(n + 3);
    R      = inv(M + (lambda .* I)) * v;
    w      = R(1:n);
    a1     = R(n+1);
    ax     = R(n+2);
    ay     = R(n+3);
end 

%% Kernel distance function
% p = nx2 matrix of (i,j) coordinates
% q = nx2 matrix of (s,t) coordinates
function [out] = K(p,q)
    X   = bsxfun(@minus, p, q);
    out = sqrt(dot(X, X, 2));
end
