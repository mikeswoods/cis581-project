%%
% Given an edge map, a list of points in [X,Y], and a search radius, this
% Function will "snap" all of the points in X and Y vectors to the closest
% edge point
%
% edge_map = an MxN edge map to snap points to
% XY       = an Kx2 matrix of points to snap
% radius   = the search radius to use for each (i,j) point in XY
% X_Prime  = a Kx1 matrix of snapped points for the x-component
% Y_Prime  = a Kx1 matrix of snapped points for the x-component
function [X_Prime, Y_Prime] = snap_to_edges(edge_map, XY, radius)

    edge_map = double(edge_map');
    XY       = floor(XY);
    K        = size(XY, 1);
    XY_Prime = zeros(K, 2);
    bbox     = search_area(edge_map, XY, radius);

    for k=1:K

        xy = XY(k,:);
        BB = floor(bbox(k,:));
        edge_points = [];
        
        for i=BB(1):BB(3)
            for j=BB(2):BB(4)
                if edge_map(i,j)
                    edge_points = [edge_points ; [i, j]];
                end
            end
        end

        % No edge points found in the given radius, so use the original XY
        % position
        if isempty(edge_points)
            XY_Prime(k,:) = xy;
        else 
            % yes, compute the pointwise distance between each (i,j) in
            % edge_points and select the one with the minimum distance
            [~,I] = pdist2(edge_points, xy, 'euclidean', 'Smallest', 1);
            XY_Prime(k,:) = edge_points(I,:);
        end
    end
    
    X_Prime = XY_Prime(:,1);
    Y_Prime = XY_Prime(:,2);
end

function [bbox] = search_area(edge_map, XY, radius)
    [m,n] = size(edge_map);
    K     = size(XY, 1);
    bbox  = zeros(K, 4);
    for i=1:K
       r = XY(i,1);
       c = XY(i,2);
       bbox(i,:) = [max(1, r - radius), max(1, c - radius), min(r + radius, m), min(c + radius, n)];
    end
end
