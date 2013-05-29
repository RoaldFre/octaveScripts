% Input:
% data: Cell of input matrices where each row of each matrix is one 
%       independent data set.
%       Alternatively:
%       Single 2D input matrix
%
% Output: Cell of means and errors.
%         In the case of a single 2D input matrix instead of a cell, the 
%         output will be simple vectors instead of cells of vectors.
function [samples, errs] = meanOfSamples(data)

if not(iscell(data))
	data = {data};
end

numDataSets = numel(data);

samples = cell(numDataSets, 1);
errs = cell(numDataSets, 1);
for i = 1:numDataSets
	samples{i} = mean(data{i});
	errs{i} = std(data{i}) / sqrt(size(data{i},1) - 1);
end

if numDataSets == 1
	samples = samples{1};
	errs = errs{1};
end

