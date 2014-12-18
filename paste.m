%%
% Pastes image src in to target at offset in target
function [out] = paste(src, dest, offset)

    [sm,sn,~] = size(src);
    [dm,dn,~] = size(dest);
    
    out    = zeros(size(dest));
    out(:) = dest(:);

    % Find the index range to do the paste within:
    i_range = floor(max(1,offset(2)):min(offset(2)+sm-1,dm));
    j_range = floor(max(1,offset(1)):min(offset(1)+sn-1,dn));

    % Paste the face into a blank image: 
    out(i_range,j_range,:) = src;
end

