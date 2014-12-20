%%
% Heavily borrowed from Merza Klaghstan's "Gradient Domain Imaging"
% blending implementation
%
% http://blog.merza-k.com/gdi
%
% imDest    = destination image
% imSrc     = source image
% imMask    = a black and white mask to indicate the irregular boundary
% imBlended = Final, blended output
function [imBlended] = gradient_blend_images(dest_im, src_im, mask)

    laplacian = [ 0  1 0  ...
                ; 1 -4 1  ...
                ; 0  1 0];

    [imDestR ,imDestG, imDestB] = split_rgb(dest_im);
    [imSrcR, imSrcG, imSrcB]    = split_rgb(src_im);

    % height and width of both the source image and the destination image
    [heightSrc, widthSrc]   = size(imSrcR);
    [heightDest, widthDest] = size(imDestR);
    [heightMask, widthMask] = size(mask);
    
    if (heightSrc ~= heightDest)  || ...
       (widthSrc ~= widthDest)    || ...
       (heightMask ~= heightSrc)  || ...
       (heightMask ~= heightDest) || ...
       (widthMask ~= widthSrc)    || ... 
       (widthMask ~= widthDest)
        error('Image source, destination, and mask must have the same dimensions');
    end
   
    % --------------------------------------------
    % calculate the number of pixels that are 0
    % for sparse matrix allocation
    % --------------------------------------------
    n = size(find(mask), 1);
    assignin('base', 'num', n);

    %---------------------------------------------
    % sparse matrix allocation
    %---------------------------------------------
    fprintf('> Gradient blend: number of unknowns = %d\n', n);
    A = spalloc(n, n, 5*n);

    % also the boundary condition
    b = zeros(3, n);

    % temperary matrix index holder
    % need to point the pixel position in the image to
    % the row index of the solution vector to
    imIndex = zeros(heightDest, widthDest);

    count = 0;
    % now fill in the 
    for y = 1:heightDest
        for x = 1:widthDest
            if mask(y, x) ~= 0
                count = count + 1;            
                imIndex(y, x) = count;
            end
        end
    end

    %---------------------------------------------
    % construct the matrix here
    %---------------------------------------------

    % construct the laplacian image.
    imLaplacianR = conv2(imSrcR, -laplacian, 'same');
    imLaplacianG = conv2(imSrcG, -laplacian, 'same');
    imLaplacianB = conv2(imSrcB, -laplacian, 'same');

    % matrix row count
    count = 0; % count is the row index
    for y = 2:heightDest-1
        for x = 2:widthDest-1

            % if the mask is not zero, then add to the matrix
            if mask(y, x) ~= 0

                % increase the counter
                count = count + 1;   

                % the corresponding position in the destination image
                yd = y;
                xd = x; 

                %------------------------------------------------------
                % gathering the coefficient for the matrix, checking Neighbours
                %------------------------------------------------------
                % if on the top
                if mask(y-1, x) ~= 0
                    % this pixel is already used
                    % get the diagonal position of the pixel
                    colIndex = imIndex(yd-1, xd);
                    A(count, colIndex) = -1;
                else % at the top boundary
                    b(1, count) = b(1, count) + imDestR(yd-1, xd);
                    b(2, count) = b(2, count) + imDestG(yd-1, xd);
                    b(3, count) = b(3, count) + imDestB(yd-1, xd);
                end

                % if on the left
                if mask(y, x-1) ~= 0
                    colIndex = imIndex(yd, xd-1);
                    A(count, colIndex) = -1;
                else % at the left boundary
                    b(1, count) = b(1, count) + imDestR(yd, xd-1);
                    b(2, count) = b(2, count) + imDestG(yd, xd-1);
                    b(3, count) = b(3, count) + imDestB(yd, xd-1);
                end

                % if on the bottom            
                if mask(y+1, x) ~= 0
                    colIndex = imIndex(yd+1, xd);
                    A(count, colIndex) = -1;
                else    % at the bottom boundary
                    b(1, count) = b(1, count) + imDestR(yd+1, xd);
                    b(2, count) = b(2, count) + imDestG(yd+1, xd);
                    b(3, count) = b(3, count) + imDestB(yd+1, xd);
                end

                % if on the right side
                if mask(y, x+1) ~= 0
                    colIndex = imIndex(yd, xd+1);
                    A(count, colIndex) = -1;
                else    % at the right boundary
                    b(1, count) = b(1, count) + imDestR(yd, xd+1);
                    b(2, count) = b(2, count) + imDestG(yd, xd+1);
                    b(3, count) = b(3, count) + imDestB(yd, xd+1);
                end       

                A(count, count) = 4;

                % construct the guidance field		
                b(1, count) = b(1, count) + imLaplacianR(y, x);
                b(2, count) = b(2, count) + imLaplacianG(y, x);
                b(3, count) = b(3, count) + imLaplacianB(y, x);
            end
        end
    end

    %---------------------------------------------
    % solve for the sparse matrix
    %---------------------------------------------
    xR = A \ ( b(1,:)' );
    xG = A \ ( b(2,:)' );
    xB = A \ ( b(3,:)' );
    %---------------------------------------------
    % now fill in the solved values
    %---------------------------------------------
    imNewR = imDestR;
    imNewG = imDestG;
    imNewB = imDestB;

    % now fill in the 
    for y1 = 1:heightDest
        for x1 = 1:widthDest
            if mask(y1, x1) ~= 0
                index = imIndex(y1, x1);
                imNewR(y1, x1) = xR(index);
                imNewG(y1, x1) = xG(index);
                imNewB(y1, x1) = xB(index);
            end
        end
    end

    imBlended = merge_rgb(imNewR, imNewG, imNewB);
end

%% Join RGB channels into a single image
function [canvas] = merge_rgb(imr, img, imb)

    [hr,wr] = size(imr);
    [hg,wg] = size(img);
    [hb,wb] = size(imb);

    if hr ~= hg || hr ~= hb || wr ~= wg || wr ~= wb
        fprintf('Error - mismatched RGB components');
    end

    canvas          = zeros(hr, wr, 3);
    canvas(:, :, 1) = imr;
    canvas(:, :, 2) = img;
    canvas(:, :, 3) = imb;
end

%% Decompose a color image (RGB) into its seperate RGB components
function [ imr, img, imb ] = split_rgb( im )
    imr = im(:, :, 1);
    img = im(:, :, 2);
    imb = im(:, :, 3);
end
