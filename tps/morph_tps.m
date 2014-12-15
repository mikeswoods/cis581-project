%% Morphing via thin plate splines
function [morphed_im] = morph_tps(im_source ...
                                 ,a1_x ...
                                 ,ax_x ...
                                 ,ay_x ...
                                 ,w_x ...
                                 ,a1_y ...
                                 ,ax_y ...
                                 ,ay_y ...
                                 ,w_y ...
                                 ,ctr_pts ...
                                 ,sz)
    r = sz(1);
    c = sz(2);  

    % Generate all (i,j) pixel coordinate pairs
    coords = combvec(1:c,1:r)';
    % We're using k control points
 
    k = size(ctr_pts,1);
    % and n (i,j) discrete pixels
    n = size(coords,1);
 
    % Compute kernerl matrix K
    K  = repmat(ctr_pts, n, 1) - reprow(coords, k);
    K  = U(reshape(sqrt(dot(K, K, 2)), k, n)');
    
    % And weights in the x & y directions
    WX = sum(K .* repmat(w_x', n, 1), 2);
    WY = sum(K .* repmat(w_y', n, 1), 2);

    % Find the remapped coordinates (i,j) in the intermediate image (i,j) 
    % to the coordinates (u,v) in the orignal image
    u  = a1_x + (ax_x .* coords(:,1)) + (ay_x .* coords(:,2)) + WX;
    v  = a1_y + (ax_y .* coords(:,1)) + (ay_y .* coords(:,2)) + WY;

    % Clamp u & v then round to get proper integer coordinates
    morphed_im = warp(im_source ...
                     ,coords(:,2) ...
                     ,coords(:,1) ...
                     ,round(v) ...
                     ,round(u));
end
