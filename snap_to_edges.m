%%
% Given an edge map, a list of points in [X,Y], and a search radius, this
% Function will "snap" all of the points in X and Y vectors to the closest
% edge point
%
% edge_map = an MxN edge map to snap points to
% XY       = an Kx2 matrix of points to snap
% radius   = the search radius to use for each (i,j) point in XY
% XY_Prime = an Kx2 matrix of snapped points
function [XY_Prime] = snap_to_edges(edge_map, XY, radius)
    
    N        = size(XY, 1);
    XY_Prime = zeros(N, 2);

    % For all edge pixels at (i,j) in [I,J]
    [Ei,Ej]    = ind2sub(size(edge_map), find(edge_map));
    
    [INDEX, ~] = rangesearch([Ei,Ej], XY, radius, 'Distance', 'cityblock', 'NSMethod', 'exhaustive');

    for i=1:N
        IDX = INDEX{i};
        % Find the edge pixel at the minimum distance for the i-th point
        if isempty(IDX)
            XY_Prime(i,:) = XY(i,:);
        else
            % Otherwise, take the first index, as they're sorted by 
            % distance in ascending order:
            k             = IDX(1);
            XY_Prime(i,1) = Ei(k);
            XY_Prime(i,2) = Ej(k);
        end
    end
end

