% Average together blocks of approximately blockSize
function ys = blockAverage(xs, blockSize)

if blockSize == 1
	ys = xs;
	return
end

inputSize = numel(xs);
finalSize = round(inputSize / blockSize);

indices = round(linspace(1, inputSize+1, finalSize+1));

ys = zeros(1, finalSize);
for i = 1:finalSize
	ys(i) = mean(xs(indices(i) : indices(i+1) - 1));
end

