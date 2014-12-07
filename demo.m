%% Example Title
% Summary of example objective

peopleDetector = vision.PeopleDetector('ClassificationThreshold',0,'MergeDetections',false);

I = imread('4b5d69173e608408ecf97df87563fd34.jpg');
[bbox, score] = step(peopleDetector, I);
I1 = insertObjectAnnotation(I, 'rectangle', bbox, cellstr(num2str(score)), 'Color', 'r');

% run the non-maximal suppression on bounding boxes
[selectedBbox, selectedScore] = selectStrongestBbox(bbox, score);
I2 = insertObjectAnnotation(I, 'rectangle', selectedBbox, cellstr(num2str(selectedScore)), 'Color', 'r');

figure, imshow(I1); title('Detected people and detection scores before suppression'); 
figure, imshow(I2); title('Detected people and detection scores after suppression');
 
   
%% Section 1 Title
% Description of first code block
a=1;

%% Section 2 Title
% Description of second code block
a=2;
