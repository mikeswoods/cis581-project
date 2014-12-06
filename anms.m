function [y, x, rmax] = anms(cimg, max_pts)
%ANMS Filter out corners

cimg(cimg<0.002*max(max(cimg))) = 0;
corner_peaks = imregionalmax(cimg);
cImg = cimg .* corner_peaks;
[Y,X,V] = find(cImg);
corners = zeros(size(Y,1),3);

p = 1;

for i = 1:size(Y)
    [a,b] = find(cImg > V(i));
    try 
        [k,d] = dsearchn([a,b],[Y(i),X(i)]);
        if d ~= 0
            corners(p,:) = [d,Y(i),X(i)];
            p = p + 1;
        end
    catch    
    end
    
end

[~,S] = sort( corners,1,'descend');
x = corners(S(1:max_pts),3);
y = corners(S(1:max_pts),2);
rmax = corners(S(max_pts),1);


end

