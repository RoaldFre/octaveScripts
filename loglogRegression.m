% Performs a linear regression on the 'log-log' of the data.
%
% function [cte, exponent, cteStddev, exponentStddev] = loglogRegression(xs, ys, guessCte, guessExponent, yerr)
function [cte, exponent, cteStddev, exponentStddev] = loglogRegression(xs, ys, guessCte, guessExponent, yerr)

xs = xs(:);
ys = ys(:);

logys = log(ys);
logxs = log(xs);

%figure
%errorbar(logxs/log(10), logys/log(10), logysErr);

F = [ones(numel(logxs), 1), logxs];
if (nargin < 5 || isempty(yerr))
	% no yerr given
	[p] = LinearRegressionError(F, logys);
	cteExponent = p(1);
	exponent = p(2);
	cte = exp(cteExponent);
else
	yerr = yerr(:);
	logysErr = yerr ./ ys;

	[p, pErr] = LinearRegressionError(F, logys, logysErr);
	cteExponent = p(1);
	cteExponentStddev = pErr(1);
	exponent = p(2);
	exponentStddev = pErr(2);

	cte = exp(cteExponent);
	cteStddev = cte * cteExponentStddev;
end

