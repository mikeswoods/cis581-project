%% U(r) = r^2 * log(r^2)
function [out] = U(r)
    r2  = r.^2;
    out = r2 .* log(r2);
    % Convert all NaNs to zeros before returning
    out(isnan(out)) = 0.0;
end