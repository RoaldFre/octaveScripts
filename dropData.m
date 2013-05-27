% if period == 3, only return the 1st, 4rd, 7th, 10th, ... data sample.
function ys = dropData(xs, period)

if period == 1
	ys = xs;
	return
end

inputSize = numel(xs);
finalSize = floor(inputSize / period);

indices = 1 + period*(0:(finalSize-1));
ys = xs(indices);

