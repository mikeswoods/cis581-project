%%

addpath('final');
data      = load('final/face_p146_small.mat');
model     = data.model;
im        = im2double(imread('data/hard/14b999d49e77c6205a72ca87c2c2e5df.jpg'));
% im        = im2double(imread('data/hard/jennifer_xmen.jpg'));
% im        = im2double(imread('data/hard/0lliviaa.jpg'));
[X,Y,BOX] = detect_faces(im, model);

%%

imshow(im);
hold on;
% plot(X, Y, 'o', 'Color', 'g');

dialateAmount = 20;
bbox = [BOX(1)-dialateAmount, BOX(2)-dialateAmount, ...
    (BOX(3) - BOX(1))+2*dialateAmount, (BOX(4) - BOX(2))+2*dialateAmount];
rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);

dt = delaunayTriangulation(X,Y);
k = convexHull(dt);
% plot(dt.Points(:,1),dt.Points(:,2), '.', 'markersize',10); hold on;
plot(dt.Points(k,1),dt.Points(k,2), 'w'); hold off;

% m = ceil(bbox(3)-bbox(1))
% n = ceil(bbox(4)-bbox(2))
I2 = imcrop(im, bbox);

[m,n,~] = size(im);
mask = poly2mask(dt.Points(k,1),dt.Points(k,2),m,n);

% size(mask)
% figure; imshow(mask);

I3 = zeros(size(im));

im2 = bsxfun(@times, im, mask); % just the face
im3 = bsxfun(@minus, im, mask); % all the rest without the face

figure; imshow(im2);
figure; imshow(im3);


corners   = detectFASTFeatures(rgb2gray(im2));
strongest = selectStrongest(corners,20);

[hog2, validPoints, ptVis] = extractHOGFeatures(im2,strongest);
figure;
imshow(im2); hold on;
plot(ptVis,'Color','green');

% figure; imshow(I3);

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



