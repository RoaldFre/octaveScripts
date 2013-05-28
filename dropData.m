% if period == 3, only return the 1st, 4rd, 7th, 10th, ... data sample.
%
% If the input is a 2D array, then only columns get dropped
function ys = dropData(xs, period)

if period == 1
	ys = xs;
	return
end

if isvector(xs)
	inputSize = numel(xs);
	finalSize = floor(inputSize / period);

	indices = 1 + period*(0:(finalSize-1));
	ys = xs(indices);
else
	numSamples = size(xs, 2);
	finalSamples = floor(numSamples / period);

	indices = 1 + period*(0:(finalSamples-1));
	ys = xs(:, indices);
end

