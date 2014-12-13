% Written by Michael O'Meara
function [ a1,ax,ay,w ] = est_tps( ctr_pts, target_value )
%EST_TPS Estimate Thin-plate spline

lambda = realmin; % realmin is equal to 2.2251e-308

p = size(ctr_pts,1);

Xp = repmat(ctr_pts(:,1), 1, p);
Yp = repmat(ctr_pts(:,2), 1, p);

K = U(sqrt((Xp-Xp').^2 + (Yp-Yp').^2));
P = [ctr_pts(:,:) ones(p,1)];
A = [K P; P' zeros(3)];
W = (A + lambda * eye(p+3)) \ [target_value; zeros(3,1)];

w = W(1:p);
ax = W(p+1);
ay = W(p+2);
a1 = W(p+3);


end

