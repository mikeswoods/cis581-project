% Written by Michael O'Meara
function [ k ] = U( r )

r1 = r;
% realmin is matlab's way of getting really close to zero
r1(r==0)=realmin;
k = 2*r.^2.*log(r1);

end

