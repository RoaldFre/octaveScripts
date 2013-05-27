% Data: Cell of input matrices where each row of each matrix is one independent data set.
% Output: Cell of means and errors.
function [samples, errs] = bootstrapSampleMean(data)

numDataSets = numel(data);

samples = cell(numDataSets, 1);
errs = cell(numDataSets, 1);
for i = 1:numDataSets
	samples{i} = mean(data{i});
	errs{i} = std(data{i}) / sqrt(size(data{i},1) - 1);
end

