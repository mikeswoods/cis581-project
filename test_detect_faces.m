%%
clear all;
dialateAmount = 30;
addpath('fitw_detect');
data      = load('fitw_detect/face_p146_small.mat');
model     = data.model;

% im        = im2double(imread('data/hard/14b999d49e77c6205a72ca87c2c2e5df.jpg'));
%ime        = im2double(imread('data/easy/0013729928e6111451103c.jpg'));
ime        = im2double(imread('data/Mike/zero-degrees.jpg'));
% im        = im2double(imread('data/hard/14b999d49e77c6205a72ca87c2c2e5df.jpg'));
ime        = im2double(imread('data/easy/0013729928e6111451103c.jpg'));

% im        = im2double(imread('data/hard/jennifer_xmen.jpg'));
%im        = im2double(imread('data/hard/0lliviaa.jpg'));

% faceDetector = vision.CascadeObjectDetector();
% bbox         = step(faceDetector, ime);
% bbox = dialate_bbox( bbox, dialateAmount );
% ime          = imcrop(ime, bbox);
[X,Y,BOX,ORIENTATION] = detect_faces(im, model, 0.2);
ORIENTATION

%%

% faceDetector = vision.CascadeObjectDetector();
% bbox         = step(faceDetector, im);
% bbox = dialate_bbox( bbox, dialateAmount );
% im          = imcrop(im, bbox);
[X2,Y2,BOX2] = detect_faces(im, model, 0.2);

%%
% figure; imshow(ime);
% hold on;
% plot(X, Y, 'o', 'Color', 'g');


[bbox, dt, k] = get_convex_hull(X, Y, BOX, dialateAmount);
[bbox2, dt2, k2] = get_convex_hull(X2, Y2, BOX2, dialateAmount);

% rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);
% plot_points( dt, k );


% figure; imshow(im);
% hold on;
% rectangle('Position', bbox2, 'EdgeColor', 'r', 'LineWidth', 2);
% plot_points( dt2, k2 );

% dt2.Points(k2,:)
% disp('k2: ' + sum(k2));
% m = ceil(bbox(3)-bbox(1))
% n = ceil(bbox(4)-bbox(2))
[face_mask, im_mask] = get_mask(ime, dt, k);
[face_mask2, im_mask2] = get_mask(im, dt2, k2);


% face_mask = bbox            = step(faceDetector, videoFrame);


% figure; imshow(edge(rgb2gray(face_mask),'canny',0.3));
% figure; imshow(edge(rgb2gray(face_mask2), 'canny',0.3));


% corners   = detectMinEigenFeatures(rgb2gray(face_mask));
% strongest = selectStrongest(corners,10);

% dt = delaunayTriangulation(double(strongest.Location));
% k = convexHull(dt);
% 
% corners2   = detectSURFFeatures(rgb2gray(face_mask2));
% strongest2 = selectStrongest(corners2,10);
% 
% dt2 = delaunayTriangulation(double(strongest2.Location));
% k2 = convexHull(dt2);

% [bbox, dt, k] = get_convex_hull(double(strongest.Location(:,1)), ...
%      double(strongest.Location(:,2)), BOX, dialateAmount);
%  [bbox, dt2, k2] = get_convex_hull(double(strongest2.Location(:,1)), ...
%      double(strongest2.Location(:,2)), BOX2, dialateAmount);
% [face_mask, im_mask] = get_mask(ime, dt, k);
% [face_mask2, im_mask2] = get_mask(im, dt2, k2);

% [f1, vpts1] = extractHOGFeatures(face_mask);
% vpts1
% figure;
% imshow(face_mask); hold on;
% plot(vpts1);
% plot(vpts1.Location(:,1),vpts1.Location(:,2), 'w+');
% plot(strongest.Location(:,1),strongest.Location(:,2), 'w+');
% plot(ptVis,'Color','green');
% triplot(dt);

% [f2, vpts2, ptVis2] = extractHOGFeatures(face_mask2,[X2 Y2]);
% [f2, vpts2] = extractHOGFeatures(face_mask2);
% figure;
% imshow(face_mask2); hold on;
% plot(vpts2);
% plot(validPoints2.Location(:,1),validPoints2.Location(:,2), 'w+');
% plot(strongest2.Location(:,1),strongest2.Location(:,2), 'w+');
% plot(ptVis2,'Color','green');
% triplot(dt2);

% gface_mask = rgb2gray(face_mask);
% gface_mask2 = rgb2gray(face_mask2);
% 
% points1 = detectMinEigenFeatures(gface_mask);
% points2 = detectMinEigenFeatures(gface_mask2);
% 
% [f1, vpts1] = extractFeatures(gface_mask, points1);
% [f2, vpts2] = extractFeatures(gface_mask2, points2);
% 
% indexPairs = matchFeatures(f1, f2);
% matchedPoints1 = vpts1(indexPairs(:, 1));
% matchedPoints2 = vpts2(indexPairs(:, 2));
% figure; showMatchedFeatures(ime,im,matchedPoints1,matchedPoints2, 'montage');
% 
% figure; showMatchedFeatures(pI,I,mPoints1,mPoints2,'montage');

addpath('tps');

face_mask = imcrop(ime, bbox);
face_mask2 = imcrop(im, bbox2);

if size(dt.Points,1) > size(dt2.Points,1)
    dt.Points = dt.Points(1:size(dt2.Points,1),:);
else
    dt2.Points = dt2.Points(1:size(dt.Points,1),:);
end

face_mask = imresize(face_mask,[size(face_mask2,1),size(face_mask2,2)]);

gface_mask = rgb2gray(face_mask);
gface_mask2 = rgb2gray(face_mask2);

points1 = detectMinEigenFeatures(gface_mask);
points2 = detectMinEigenFeatures(gface_mask2);

[f1, vpts1] = extractFeatures(gface_mask, points1)
[f2, vpts2] = extractFeatures(gface_mask2, points2);

indexPairs = matchFeatures(f1, f2);
matchedPoints1 = vpts1(indexPairs(:, 1))
matchedPoints2 = vpts2(indexPairs(:, 2));

figure; showMatchedFeatures(face_mask,face_mask2,matchedPoints1,matchedPoints2, 'montage');

% figure; imshow(face_mask);
% hold on; plot(X,Y, 'r+');
% % figure; imshow(face_mask2);
% drawnow;

% img_morphed = morph_tps_wrapper(face_mask, face_mask2, dt.Points, dt2.Points, 0.5, 0.5);
% figure; imshow(img_morphed);

% d1 = rgb2gray(im2);  %# Load the image, scale from 0 to 1
% subplot(2,2,1); imshow(d1); title('d1');    %# Plot the original image
% d = edge(d1,'canny',0.9);                    %# Perform Canny edge detection
% subplot(2,2,2); imshow(d); title('d');      %# Plot the edges
% ds = bwareaopen(d,40);                      %# Remove small edge objects
% subplot(2,2,3); imshow(ds); title('ds');    %# Plot the remaining edges
% iout = d1;
% BW = ds;
% iout(:,:,1) = iout;                           %# Initialize red color plane
% iout(:,:,2) = iout(:,:,1);                    %# Initialize green color plane
% iout(:,:,3) = iout(:,:,1);                    %# Initialize blue color plane
% iout(:,:,2) = min(iout(:,:,2) + BW, 1.0);     %# Add edges to green color plane
% iout(:,:,3) = min(iout(:,:,3) + BW, 1.0);     %# Add edges to blue color plane
% subplot(2,2,4); imshow(iout); title('iout');  %# Plot the resulting image



