% Input: Matrix where each row is one independent data set, or a cell of 
% multiple such matrices.
%
% Output: means and errors (or cell of means and errors) of a bootstrap 
% sample of the data.
function [mean, err] = bootstrapSampleMean(data)

data = bootstrapResample(data);
[mean, err] = meanOfSamples(data);
