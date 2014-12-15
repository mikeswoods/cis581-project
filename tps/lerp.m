%% Simple linear interpolation routine betweem 2 equal size values, X & Y
function [Z] = lerp(X, Y, amount)
    amt = clamp(amount, 0.0, 1.0);
    Z   = ((1.0 - amt) .* X) + (amt .* Y);
end
