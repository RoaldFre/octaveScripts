% if period == 3, only return the 3st, 6rd, 9th, 12th, ... data sample.
function ys = dropEarlyData(xs, period)

if period == 1
	ys = xs;
	return
end

inputSize = numel(xs);
finalSize = floor(inputSize / period);

indices = period*(1:finalSize);
ys = xs(indices);


