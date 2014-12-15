%% Transform, rotating and translating as necessary
function [XPrime, YPrime] = xform_points(X, Y, rotate, translate)

    if nargin ~= 4
        translate = [0,0];
    end

    % Compute the centroid for each point component:
    n       = size(X,1);
    C       = repmat([mean(X), mean(Y)], n, 1);
    XY      = [X,Y];
    XYPrime = XY - C;
    theta   = degtorad(rotate);
    R       = [cos(theta) -sin(theta); 
               sin(theta) cos(theta)];
    for i=1:n
        XYPrime(i,:) = XYPrime(i,:) * R;
    end

    XYPrime = XYPrime + C;
    XYPrime = XYPrime  + repmat(translate, n, 1);
    
    XPrime = XYPrime(:,1);
    YPrime = XYPrime(:,2);
end

