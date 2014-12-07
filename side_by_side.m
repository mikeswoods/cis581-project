%% Display two images side-by-side with matching correspondences
%
function side_by_side(im1, im2, bbox1, bbox2, points1, points2)

    [im1,im2,Ppad,Qpad]  = matchdim(im1, im2, @zeropad);
    [~, im1Cols,~]       = size(im1);
    
    num_bbox1 = size(bbox1, 1);
    num_bbox2 = size(bbox2, 1);
    
    % Compute the bounding box offsets: bbox format: [x,y,w,h]
    if num_bbox1 > 0
        bbox1(:,1) = bbox1(:,1) + Ppad.W; % x-coordinate (not rows)
        bbox1(:,2) = bbox1(:,2) + Ppad.N; % y-coordinate (not cols)
    end
    
    if num_bbox2 > 0
        bbox2(:,1) = bbox2(:,1) + Qpad.W + im1Cols;
        bbox2(:,2) = bbox2(:,2) + Qpad.N;
    end

    % Update the points with offsets:
    N = numel(points1);
    for i=1:N
        points1{i}      = points1{i}.Location;
        points1{i}(:,1) = points1{i}(:,1) + Ppad.W;
        points1{i}(:,2) = points1{i}(:,2) + Ppad.N;
    end

%     N = numel(points2);
%     for i=1:N
%         points2{i}      = points2{i}.Location;
%         points2{i}(:,1) = points2{i}(:,1) + Qpad.W + im1Cols;
%         points2{i}(:,2) = points2{i}(:,2) + Qpad.N;
%     end

    % PLot the bounding boxes and the the match point correspondences
    % (TODO)
    imshow([im1, im2]);
    hold on;
    
    % Image 1 (left) bounding box and points:
    for i=1:num_bbox1
        rectangle('Position', bbox1(i,:), 'EdgeColor', 'r', 'LineWidth', 2);
    end
    %plot(points1(:,1), points1(:,2), 'o', 'Color', 'r');
    
    % Image 2 (right) bounding box and points:
    for i=num_bbox2
       rectangle('Position', bbox2(i,:), 'EdgeColor', 'g', 'LineWidth', 2);
    end
   % plot(points2(:,1), points2(:,2), 'o', 'Color', 'g');
  
end

%% 
% Returns 4x2 matrix of top, right, bottom, left padding values for the
% described matrix based on the given dimensions [r c] in dims
function [M] = borders(dims, n)
    r      = dims(1);
    c      = dims(2);
    alongR = linspace(1, r, n);
    alongC = linspace(1, c, n);
    TOP    = [alongC ; repmat(1,1,n)]';
    BOTTOM = [alongC ; repmat(r,1,n)]';
    LEFT   = [repmat(1,1,n) ; alongR]';
    RIGHT  = [repmat(c,1,n) ; alongR]';
    M      = [TOP ; RIGHT ; BOTTOM ; LEFT];
end

%% 
% Pads the given image with zeros according to the given width specifers
function [J] = zeropad(I, north, south, east, west)
    NS = max(north, south);
    WE = max(west, east);
    J  = padarray(I,[NS WE]);
    dN = NS - north; 
    dS = NS - south;
    dE = WE - east;
    dW = WE - west;
    if dN > 0
        J = J(dN+1:end,:,:); 
    end
    if dS > 0
        J = J(1:end-dS,:,:);
    end
    if dE > 0 
        J = J(:,1:end-dE,:);
    end
    if dW > 0
        J = J(:,dW+1:end,:); 
    end
end

%% 
% Match the dimensions of the given imput and return padding info
function [U, V, padU, padV] = matchdim(P, Q, padder)
    [r1,c1,~] = size(P);
    [r2,c2,~] = size(Q);
    rMax      = max(r1,r2);
    cMax      = max(c1,c2);
    % Pad the images so they have matching dimensions:
    nsP  = (rMax - r1) ./ 2;
    weP  = (cMax - c1) ./ 2;
    padU = struct('N', floor(nsP) ...
                 ,'S', ceil(nsP) ...
                 ,'E', floor(weP) ...
                 ,'W', ceil(weP));
    U = padder(P, padU.N, padU.S, padU.E, padU.W);    
    nsQ  = (rMax - r2) ./ 2;
    weQ  = (cMax - c2) ./ 2;
    padV = struct('N', floor(nsQ) ...
                 ,'S', ceil(nsQ) ...
                 ,'E', floor(weQ) ...
                 ,'W', ceil(weQ));
    V = padder(Q, padV.N, padV.S, padV.E, padV.W);
end

