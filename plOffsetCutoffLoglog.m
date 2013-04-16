% xs: still in real space, output: ys in loglog space
function ys = plOffsetCutoffLoglog(xs, exponent, x1, xOffset, yOffset, cutOff, cutOffWidth)

ys = plOffsetCutoff(xs, exponent, x1, xOffset, yOffset, cutOff, cutOffWidth);

ys = real(ys); % TODO justifyable? Better way?

% TODO: better way than this hack below?
problematic = ys <= 0;
good = ys(ys > 0);
if numel(good) > 0
	lowestGood = min(good);
	highestGood = max(good);
else
	% Yeah, ... this isn't good ....
	printf("plOffsetCutoffLoglog: All ys are negative!\n");
	lowestGood = 1e-100;
	highestGood = lowestGood;
end

% change the negative values to something very tiny (compared to the other values)
% -> will become samething very negative after the log
ys(problematic) = lowestGood / (highestGood / lowestGood);

ys = log(ys);
