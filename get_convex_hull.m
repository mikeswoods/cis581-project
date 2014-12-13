function [ bbox, dt, k ] = get_convex_hull( X, Y, BOX, dialateAmount )
%GET_CONVEX_HULL 

bbox = [BOX(1)-dialateAmount, BOX(2)-dialateAmount, ...
    (BOX(3) - BOX(1))+2*dialateAmount, (BOX(4) - BOX(2))+2*dialateAmount];


dt = delaunayTriangulation(X,Y);
k = convexHull(dt);

end

