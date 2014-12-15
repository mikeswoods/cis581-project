%% 
% Pads the given image with zeros according to the given width specifers
function [J] = zeropad(I, north, south, east, west)
    NS = max(north, south);
    WE = max(west, east);
    J  = padarray(I,[NS WE]);
    dN = NS - north; 
    dS = NS - south;
    dE = WE - east;
    dW = WE - west;
    if dN > 0
        J = J(dN+1:end,:,:); 
    end
    if dS > 0
        J = J(1:end-dS,:,:);
    end
    if dE > 0 
        J = J(:,1:end-dE,:);
    end
    if dW > 0
        J = J(:,dW+1:end,:); 
    end
end

