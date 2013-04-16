function ys = pl2OffsetCutoff(xs, exp1, x1, exp2, x2, xOffset, yOffset, cutOff, cutOffWidth)

% XXX TODO DEBUG DEBUG
%xOffset = 0;
%yOffset = 0;

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

ys = yOffset + ((xTransformed + xOffset) / x1).^exp1 + ((xTransformed + xOffset) / x2).^exp2;

