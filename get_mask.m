function [ face_mask, im_mask ] = get_mask( im, dt, k )
%GET_MASK 

% I = imcrop(im, bbox);
[m,n,~] = size(im);
mask = poly2mask(dt.Points(k,1),dt.Points(k,2),m,n);

% size(mask)
% figure; imshow(mask);
% I3 = zeros(size(im));

face_mask = bsxfun(@times, im, mask); % just the face
im_mask = bsxfun(@minus, im, mask); % all the rest without the face


end

