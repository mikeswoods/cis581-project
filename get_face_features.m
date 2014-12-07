%% Given a face image, this function returns one or more struct instances
% for each "real" face detected. Each struct has the following fields:
%
% 'Face': face bounding box
% <feature>: feature bounding box
%
function [bboxStructs] = get_face_features(faceImage, feature)

    % Do some sharpening preprocessing:
    faceImage = imsharpen(faceImage);

    faceDetector = vision.CascadeObjectDetector('FrontalFaceCART', 'MergeThreshold', 2);
    faces        = faceDetector.step(faceImage);
    bboxStructs  = [];
    
    numFaces = size(faces,1);
    fprintf(1, 'get_face_features: Found %d face(s)\n', numFaces);
    
    for i=1:numFaces
 
        foundFeature = false;
 
        % Try different thresholds for finding the feature:
        for t=14:-1:2
            
            fprintf('-- face: %d/%d @ feature threshold: %d\n', i, numFaces, t);
            if foundFeature
                break;
            end
            
            featDetector = vision.CascadeObjectDetector(feature, 'MergeThreshold', t, 'MinSize', [25, 25]);
            features     = featDetector.step(faceImage);
            numFeatures  = size(features, 1);

            if numFeatures == 0
                continue;
            end
            
            for j=1:numFeatures
                if  containsBBox(faces(i,:), features(j,:))
                    s            = struct('Face', faces(i,:), feature, features(j,:));
                    bboxStructs  = [bboxStructs ; s];
                    foundFeature = true;
                    break;
                end
            end
        end
    end
end

function [result] = containsBBox(outer, inner)
    outX   = outer(1);
    outY   = outer(2);
    outW   = outer(3);
    outH   = outer(4);
    inX    = inner(1);
    inY    = inner(2);
    inW    = inner(3);
    inH    = inner(4);
    result = (inX > outX) && ...
             (inY > outY) && ...
             ((inX + inW) < (outX + outW)) && ...
             ((inY + inH) < (outY + outH));
end

