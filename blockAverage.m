function ys = blockAverage(xs, blockSize)

inputSize = numel(xs);
finalSize = ceil(inputSize / blockSize);

ys = zeros(1, finalSize);

for i = 1:finalSize-1
	ys(i) = mean(xs((i-1)*blockSize + 1 : i*blockSize));
end

ys(finalSize) = mean(xs((finalSize-1)*blockSize + 1 : inputSize));
	
