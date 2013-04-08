function ys = powerLawWithOffsetsAndCutOff(xs, exponent, x1, xOffset, yOffset, cutOff, cutOffWidth)

% do the cut off as a transformation on the x variables TODO best way? Directly work on ys?
xTransformed = cutOff + (-cutOffWidth * log(1 + exp((cutOff - xs)/cutOffWidth)));

ys = yOffset + ((xTransformed + xOffset) / x1).^exponent;

