function ys = powerLaw2WithCutOff(xs, exp1, exp2, x1, xCrossOver, cutOff, cutOffWidth)

x1 = abs(x1);
xCrossOver = abs(xCrossOver);
cutOffWidth = abs(cutOffWidth);

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

c2 = xCrossOver^(exp1 - exp2) / x1^exp1;
ys = (xTransformed / x1).^exp1 + c2 * xTransformed.^exp2;

