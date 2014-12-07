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
