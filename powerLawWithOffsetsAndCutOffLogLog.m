% xs: still in real space, output: ys in loglog space
function ys = powerLawWithOffsetsAndCutOffLogLog(xs, exponent, x1, xOffset, yOffset, cutOff, cutOffWidth)

% do the cut off as a transformation on the x variables TODO best way? Directly work on ys?
xTransformed = cutOff + (-cutOffWidth * log(1 + exp((cutOff - xs)/cutOffWidth)));

ys = yOffset + ((xTransformed + xOffset) / x1).^exponent;
ys = real(ys); % TODO justifyable? Better way?


% TODO: better way than this hack below?
problematic = ys <= 0;
good = ys(ys > 0);
if numel(good) > 0
	lowestGood = min(good);
	highestGood = max(good);
else
	% Yeah, ... this isn't good ....
	printf("powerLawWithOffsetsAndCutOffLogLog: All ys are negative!\n");
	lowestGood = 1e-100;
	highestGood = lowestGood;
end

% change the negative values to something very tiny (compared to the other values)
% -> will become samething very negative after the log
ys(problematic) = lowestGood / (highestGood / lowestGood);

ys = log(ys);
