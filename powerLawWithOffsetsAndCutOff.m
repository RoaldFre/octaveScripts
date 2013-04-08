function ys = powerLawWithOffsetsAndCutOff(xs, cte, exponent, xOffset, yOffset, cutOff, cutOffWidth)

%above this: ignore cutoff because no effect anyway and it will only 
%degrade numerical precision!
%maxCutOff = max(xs) * 10;

% do the cut off as a transformation on the x variables TODO best way? Directly work on ys?
xTransformed = cutOff + (-cutOffWidth * log(1 + exp((cutOff - xs)/cutOffWidth)));

ys = yOffset + cte * (xTransformed + xOffset).^exponent;



