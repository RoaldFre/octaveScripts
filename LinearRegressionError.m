% useYerrForStddev: Use yErr to estimate the statistical error on the result.
%
% function [p, pErr, y_var, r] = LinearRegressionError(F,y,yErr,useYerrForStddev)
function [p, pErr, y_var, r] = LinearRegressionError(F,y,yErr,useYerrForStddev)

if nargin < 4
	useYerrForStddev = true;
end

if nargin < 3 || isempty(yErr)
	[p,y_var,r,p_var] = LinearRegression(F, y);
	pErr = [];
	return
end

weights = 1./yErr;

[p,y_var,r,p_var] = LinearRegression(F, y, weights);

if useYerrForStddev
	N = 50;
	y = y(:);
	yErr = yErr(:);
	ps = zeros(numel(p), N);
	for i = 1:N
		yPerturbed = y + randn(numel(y), 1) .* yErr;
		[_p] = LinearRegression(F, yPerturbed, weights);
		ps(:,i) = _p(:);
	end

	pErr = std(ps')';
else
	pErr = 0;
end
pErr = max(pErr, sqrt(p_var));
