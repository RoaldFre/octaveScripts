% TODO: NOT PROPERLY TESTED YET!!
% Computes the mean of the squared deviation from the initial value. For 
% instance, a bunch of data runs y_i(t) (where i runs over the independent 
% runs) get transformed to
%    sqDev(t) = (y(t) - y(1)).^2
% In the error calculation, the covariance of the first time sample with 
% later samples is taken into account.
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
function [sqDev, errs] = meanSquaredDeviation(data)

if not(iscell(data))
	data = {data};
end

numDataSets = numel(data);

sqDev = cell(numDataSets, 1);
errs = cell(numDataSets, 1);
for i = 1:numDataSets
	% Mean of squared deviation:
	meanInitial = mean(data{i}(:,1));
	sqDev{i} = mean((data{i}(:,2:end) - meanInitial).^2);
	% Error propagation:
	%   var(f({x_i})) = (df/dx_i)^2 var(x_i)  +  2 (df/dx_i) (df/dx_j) cov(x_i, x_j)
	% sum over i and j implied at rhs.
	% 
	% In our case, this becomes:
	%   y_t = 1/N sum_r (x_rt - <x_0>)^2
	% with x_rt the data from run 'r' at time 't', N the number of 
	% runs, and <x_0> == sum_s x_s0. Here, 't' is the equivalent of 'i' 
	% and 'j' above, and the variance is taken over the 'r' indices.
	% then
	%   var(y_t) = sum_r 1/N^2 (2(x_rt - <x_0>))^2 (var(x_rt) - 2/N cov(x_rt, x_r0) + 1/N^2 sum_s(var(x_s0)))
	%            = sum_r 1/N^2 (2(x_rt - <x_0>))^2 (var(x_rt) - 2/N cov(x_rt, x_r0) + var(<x_0>))
	%            =          4y_t/N           sum_r (var(x_rt) - 2/N cov(x_rt, x_r0) + var(<x_0>))
	%            =          4y_t                   (var(x_t)  - 2/N cov(x_t,  x_0)  + var(<x_0>))
	%   transition to last line: variance of each run individual is 
	%   equal to the 'population' variance for that time
	covarWithInitial = cov(data{i}(:,2:end), data{i}(:,1))';
	varInitial = var(data{i}(:,1));
	varData = var(data{i}(:,2:end));
	N = size(data{i}, 1);
	errs{i} = 4*sqDev{i} .* (varData - 2/N*covarWithInitial + varInitial);
end

if numDataSets == 1
	sqDev = sqDev{1};
	errs = errs{1};
end

