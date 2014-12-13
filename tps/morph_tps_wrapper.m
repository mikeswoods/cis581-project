% Written by Michael O'Meara
function [ morphed_im ] = morph_tps_wrapper( img_source, img_dest, ...
    p_source, p_dest, warp_frac, dissolve_frac )

ctr_pts = (1-warp_frac)*p_source + warp_frac*p_dest;

[h,w,~] = size(img_dest);

[a1_x,ax_x,ay_x,w_x] = est_tps(ctr_pts, p_source(:,1));
[a1_y,ax_y,ay_y,w_y] = est_tps(ctr_pts, p_source(:,2));
morphed_im1 = morph_tps(img_source, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, ctr_pts, [h,w]);

[a1_x,ax_x,ay_x,w_x] = est_tps(ctr_pts, p_dest(:,1));
[a1_y,ax_y,ay_y,w_y] = est_tps(ctr_pts, p_dest(:,2));
morphed_im2 = morph_tps(img_dest, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, ctr_pts, [h,w]);

morphed_im = uint8((1-dissolve_frac)*morphed_im1 + dissolve_frac*morphed_im2);

end

