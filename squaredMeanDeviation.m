% Computes the square of the mean deviation from the initial value. For 
% instance, a bunch of data runs y_i(t) (where i runs over the independent 
% runs) get transformed to
%    sqDev(t) = (y(t) - y(1)).^2,
% where y(t) = mean(y_i(t))
% In the error calculation, the covariance of the first time sample with 
% later samples is taken into account.
%
% Note that the first sample (which is always 0 with error 0) is omitted!
% For convenience, you can pass a cell of time vectors, and the returned 
% time will be
%     newTime(t) = time(t) - time(1)
% where the first element (always 0) is also omitted.
%
% Input:
% data: Cell of input matrices where each row of each matrix is one 
%       independent data set.
%       Alternatively:
%       Single 2D input matrix
%
% Output: Cell of mean squared deviations and errors thereof.
%         In the case of a single 2D input matrix instead of a cell, the 
%         output will be simple vectors instead of cells of vectors.
function [sqDev, errs, newTime] = squaredMeanDeviation(data, time)

if nargin < 2
	time = {};
end

if not(iscell(data))
	data = {data};
	if not(isempty(time)) && not(iscell(time))
		time = {time};
	end
end

numDataSets = numel(data);

sqDev = cell(numDataSets, 1);
errs = cell(numDataSets, 1);
for i = 1:numDataSets
	meanData = mean(data{i});
	sqDev{i} = (meanData(2:end) - meanData(1)).^2;
	% For error propagation:
	%   |d((x - y)^2)| = 2 |x - y| |d(x - y)|
	%   for the error on (x - y):
	%   var(x - y) = var(x) + var(y) - 2*covar(x, y)
	% here x = meanData(t)
	%      y = meanData(1)
	varData = var(data{i});
	covarWithInitial = cov(data{i}(:, 2:end), data{i}(:, 1))';
	errs{i} = 2 * abs(meanData(2:end) - meanData(1)) ...
	           .* sqrt(max(0, varData(2:end) + varData(1) - 2*covarWithInitial)) ...
		    / sqrt(size(data{i},1) - 1);
end

newTime = cellfun(@(x) x(2:end) - x(1), time, 'UniformOutput', false);

if numDataSets == 1
	sqDev = sqDev{1};
	errs = errs{1};
	if not(isempty(time))
		newTime = newTime{1};
	end
end


