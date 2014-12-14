% Written by Michael O'Meara
function [ idx, b ] = findTri( im_pts, tri, tsize, x, y )

idx = NaN;

for i=1:tsize
    b = [im_pts(tri(i,:),:)'; ones(1,3)] \ [x y 1]';
    if b(1) >= 0 && b(2) >= 0 && b(3) >= 0
        idx = i;
        break;
    end
end

end

