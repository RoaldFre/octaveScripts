% Input: Matrix where each row is one independent data set, or a cell of 
% multiple such matrices.
%
% Output: bootstrap resampled matrix (or cell of matrices) of the same size.
function resampled = bootstrapResample(data)

if not(iscell(data))
	data = {data};
end

resampled = cell(numel(data), 1);

for i = 1:numel(data)
	numRuns = size(data{i})(1);
	resampledIndices = ceil(rand(1, numRuns) * numRuns);
	resampled{i} = data{i}(resampledIndices, :);
end

if numel(data) == 1
	resampled = resampled{i};
end
