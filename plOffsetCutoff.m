function ys = plOffsetCutoff(xs, exponent, x1, xOffset, yOffset, cutOff, cutOffWidth)

% do the cut off as a transformation on the x variables TODO best way? Directly work on ys?
xTransformed = cutOff + (-cutOffWidth * log(1 + exp((cutOff - xs)/cutOffWidth)));

% for small values of x, the correction is negligible and there should be 
% no effect of this cut off. However, if x -> 0, even the tinyest 
% contribution from the cut off will show significantly on a loglog scale. 
% Hence, sufficiently far away from the cut off, we use the exact input 
% values of xs.
% TODO: smoother transition?
untouchedMask = xTransformed < cutOff - 4*cutOffWidth;
xTransformed(untouchedMask) = xs(untouchedMask);

ys = yOffset + ((xTransformed + xOffset) / x1).^exponent;

