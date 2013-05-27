% Data: Input matrix where each row is one independent data set.
% Output: the mean of a bootstrap sample generated from the data.
function [sample, err] = bootstrapSampleMean(data)

numRuns = size(data)(1);
numSamples = size(data)(2);

resampledIndices = ceil(rand(1, numRuns) * numRuns);

sample = mean(data(resampledIndices, :));
err = std(data(resampledIndices, :)) / sqrt(numRuns - 1);
