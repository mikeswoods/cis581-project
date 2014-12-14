function [ morphed_im ] = morph( im1, im2, im1_pts, im2_pts, tri, ...
    warp_frac, dissolve_frac )

[h,w,~] = size(im1);
[h2,w2,~] = size(im2);

if h >= h2
    h = h2;
end
if w >= w2
    w = w2;
end

impoints = (1-warp_frac)*im1_pts + warp_frac*im2_pts;

morphed_im1 = zeros(h,w,3);
morphed_im2 = zeros(h,w,3);

% [p,q] = meshgrid(1:w, 1:h);
% pairs = [p(:) q(:)];
 
% [t1, B1] = tsearchn(impoints, tri, pairs);
% t2 = tsearchn(im2_pts, tri, pairs);

px = zeros(h,w);
py = zeros(h,w);
px2 = zeros(h,w);
py2 = zeros(h,w);
tsize = size(tri,1);


for j=1:w
    for i=1:h
        % t1 = tsearchn(impoints, tri, [i j]);
        [t1, b] = findTri(impoints, tri, tsize, j, i);
        if isnan(t1)
            continue;
        end
        % b = [impoints(tri(t1,:),:)'; ones(1,3)] \ [i j 1]';
        pts = ([im1_pts(tri(t1,:),:)'; ones(1,3)] * b);
        pts2 = ([im2_pts(tri(t1,:),:)'; ones(1,3)] * b);
        
        px(i,j) = pts(1);
        py(i,j) = pts(2);
        px2(i,j) = pts2(1);
        py2(i,j) = pts2(2);        
        
    end
end

for i=1:3
    morphed_im1(:,:,i) = interp2(double(im1(:,:,i)), px, py);
    morphed_im2(:,:,i) = interp2(double(im2(:,:,i)), px2, py2);
end

morphed_im = uint8((1-dissolve_frac)*morphed_im1 + dissolve_frac*morphed_im2);


end

