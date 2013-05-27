% Data: Cell of input matrices where each row of each matrix is one independent data set.
% Output: Cell of bootstrap samples generated from the data.
function [samples, errs] = bootstrapSampleMean(data)

numDataSets = numel(data);

samples = cell(numDataSets, 1);
errs = cell(numDataSets, 1);
for i = 1:numDataSets
	[sample, err] = bootstrapSampleMean(data{i});
	samples{i} = sample;
	errs{i} = err;
end

