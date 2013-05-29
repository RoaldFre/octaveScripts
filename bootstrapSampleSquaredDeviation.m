% Input: Matrix where each row is one independent data set, or a cell of 
% multiple such matrices.
%
% Output: means and errors (or cell of means and errors) of the squared 
% deviation of a bootstrap sample of the data.
function [sqDev, err] = bootstrapSampleSquaredDeviation(data)

data = bootstrapResample(data);
[sqDev, err] = meanSquaredDeviation(data);

