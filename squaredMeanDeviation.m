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
%
% Extra flags (default true):
% includeInsignificantData:
%     Include data where the squared mean deviation is not significantly 
%     different from zero (You don't want this if making plots with 
%     logarithmic y axes!)
%     In this case, ALL data from the initial time, up until the time where 
%     the LAST non-significantly-zero data point is found is DROPPED! This 
%     can delete intermediate portions that *are* significantly non-zero, 
%     but it avoids problems with doing linear interpolation between data 
%     points.
%     Note that this will probably imply that all points that are 
%     numerically unstable will get dropped as well (see flag below), 
%     unless you have enormous statistics on your data.
% includeNumericallyInstableData:
%     Include data that is nonsense :P (differences smaller than machine 
%     precision)
function [sqDev, errs, newTime] = squaredMeanDeviation(data, time, includeInsignificantData, includeNumericallyInstableData)

if nargin < 2; time = {}; end
if nargin < 3; includeInsignificantData = true; end
if nargin < 4; includeNumericallyInstableData = true; end

epsilon = 1e-7; % single precision has 7.22 decimal digits of precision, doubles have 15.95 decimal digits
significanceSigma = 2;

if not(iscell(data))
	data = {data};
	if not(isempty(time)) && not(iscell(time))
		time = {time};
	end
end

numDataSets = numel(data);

sqDev = cell(numDataSets, 1);
errs = cell(numDataSets, 1);
mask = cell(numDataSets, 1);
oldBroadcastWarningState = warning("query", "Octave:broadcast").state;
warning("off", "Octave:broadcast");
for i = 1:numDataSets
	% WE NEED TO BE VERY CAREFUL FOR NUMERICAL INSTABILITIES DUE TO MASSIVE CANCELLATION!
	% We need all precision we can get in the mean, especially if the data we get is in single precision format!
	% -> Two-pass trick to calculate mean with high precision: first subtract an initial estimate of the mean
	meanEstimate = mean(data{i});
	% Then average the residuals, which will be somewhere around zero
	meanResiduals = mean(data{i} - meanEstimate); % this will have cancellation errors, but they are expected to (1) not be too excessive due to variance of data, which then (2) gets averaged out below to recover extra useful data that would otherwise be lost.
	meanData = double(meanEstimate) + double(meanResiduals); % make sure we have double precision here!
	% Note: initial tests have shown that this isn't more accurate than just using the built-in mean(). It probably already does some trick like this (It's open source, but I haven't checked :P)
	

	%sqDev{i} = (meanData(2:end) - meanData(1)).^2; % Massive cancellation expected to happen here!
	deviation = mean((double(data{i}(:,2:end)) - double(data{i}(:,1)))); % This is (slightly) better because the mean will average out some of the cancellation
	sqDev{i} = deviation.^2; % This is (slightly) better because the mean will average out some of the cancellation

	% For error propagation:
	%   |d((x - y)^2)| = 2 |x - y| |d(x - y)|
	%   for the error on (x - y):
	%   var(x - y) = var(x) + var(y) - 2*covar(x, y)
	% here x = meanData(t)
	%      y = meanData(1)
	varData = var(data{i});
	covarWithInitial = cov(data{i}(:, 2:end), data{i}(:, 1))';
	errs{i} = 2 * abs(deviation) ...
	           .* sqrt(max(0, varData(2:end) + varData(1) - 2*covarWithInitial)) ...
		    / sqrt(size(data{i},1) - 1);
	
	% Numerically safe indices:
	numericalMask = abs(deviation ./ (meanData(2:end) + meanData(1))) > epsilon/2;
	% Last not-significantly-nonzero index:
	significanceIndex = find(sqDev{i} - significanceSigma * errs{i} <= 0, 1, 'last');
	if isempty(significanceIndex);
		significanceIndex = 1;
	end
	significanceMask = (1:numel(sqDev{i})) >= significanceIndex;

	mask{i} = true(size(sqDev{i}));
	if not(includeNumericallyInstableData); mask{i} &= numericalMask; end
	if not(includeInsignificantData);       mask{i} &= significanceMask; end
end
warning(oldBroadcastWarningState, "Octave:broadcast");

newTime = cellfun(@(x) x(2:end) - x(1), time, 'UniformOutput', false);

sqDev = cellfun(@(x, m) x(m), sqDev, mask, 'UniformOutput', false);
errs = cellfun(@(x, m) x(m), errs, mask, 'UniformOutput', false);
newTime = cellfun(@(x, m) x(m), newTime, mask, 'UniformOutput', false);

if numDataSets == 1
	sqDev = sqDev{1};
	errs = errs{1};
	if not(isempty(time))
		newTime = newTime{1};
	end
end


