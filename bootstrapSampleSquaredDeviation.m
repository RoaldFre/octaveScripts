% Input: Matrix where each row is one independent data set, or a cell of 
% multiple such matrices.
%
% Output: means and errors (or cell of means and errors) of the squared 
% deviation of a bootstrap sample of the data.
function [sqDev, err, newTime] = bootstrapSampleSquaredDeviation(data, time, includeInsignificantData, includeNumericallyInstableData)

if nargin < 2; time = {}; end
if nargin < 3; includeInsignificantData = true; end
if nargin < 4; includeNumericallyInstableData = true; end

data = bootstrapResample(data);
[sqDev, err, newTime] = squaredMeanDeviation(data, time, includeInsignificantData, includeNumericallyInstableData);

