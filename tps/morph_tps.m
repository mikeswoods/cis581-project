% Written by Michael O'Meara
function [ morphed_im ] = morph_tps( im_source, a1_x, ax_x, ay_x, w_x, ...
    a1_y, ax_y, ay_y, w_y, ctr_pts, sz )

imgSz = size(im_source);
f_x = zeros(imgSz(1),imgSz(2));
f_y = zeros(imgSz(1),imgSz(2));
p = size(ctr_pts,1);

K = zeros(p,1);

for h=1:sz(1)
    for w=1:sz(2)
%         X = repmat(w, p, 1);
%         Y = repmat(h, p, 1);
%         K = U(sqrt((ctr_pts(:,1)-X).^2 + (ctr_pts(:,2)-Y).^2));
        for i=1:p
            K(i) = U(norm(ctr_pts(i,:) - [w,h],2));
        end

        px = a1_x + ax_x*w + ay_x*h + K'*w_x;
        if px > imgSz(2)
            px = imgSz(2);
        end
        if px < 1
            px = 1;
        end
        f_x(h,w) = px;
        py = a1_y + ax_y*w + ay_y*h + K'*w_y;
        if py > imgSz(1)
            py = imgSz(1);
        end
        if py < 1
            py = 1;
        end
        f_y(h,w) = py;
    end
end

% fx = round(f_x);
% fy = round(f_y);

morphed_im = zeros(sz(1),sz(2), 3);
for i=1:3
    morphed_im(:,:,i) = interp2(double(im_source(:,:,i)), f_x, f_y);
    % morphed_im(:,:,i) = im_source(uint8(f_x), uint8(f_y), i); 
end



end

