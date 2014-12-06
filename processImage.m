function processImage( I )
%PROCESSIMAGE Summary of this function goes here
%   Detailed explanation goes here

grayImage = im2double(rgb2gray(I));
cornerImage = cornermetric(grayImage);

[y,x,rmax] = anms(cornerImage, 85);
hold on;
plot(x,y,'ro');

end

