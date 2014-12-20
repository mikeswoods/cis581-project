% Enhances the contrast of the image
% Adapted from http://imageprocessingblog.com/histogram-adjustments-in-matlab-part-i/
function [out] = enhance_contrast(im)
    hsvimg = rgb2hsv(im);
    for ch=2:3
          hsvimg(:,:,ch) = imadjust(hsvimg(:,:,ch), ...
          stretchlim(hsvimg(:,:,ch), 0.01));
    end
    out = hsv2rgb(hsvimg);
end
