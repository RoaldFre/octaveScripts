% Performs a linear regression on the 'log-log' of the data.
% xs must be a column vector
%
% function [cte, exponent, cteStddev, exponentStddev] = loglogRegression(xs, ys, guessCte, guessExponent, yerr)
function [cte, exponent, cteStddev, exponentStddev] = loglogRegression(xs, ys, guessCte, guessExponent, yerr)

if (nargin < 5)
	error("Not enough required arguments!");
end


logys = log(ys);
logxs = log(xs);
logysErr = yerr ./ ys;

%figure
%errorbar(logxs/log(10), logys/log(10), logysErr);

F = [ones(numel(logxs), 1), logxs];

[p, pErr] = LinearRegressionError(F, logys, logysErr);
cteExponent = p(1);
cteExponentStddev = pErr(1);
exponent = p(2);
exponentStddev = pErr(2);

cte = exp(cteExponent);
cteStddev = cte * cteExponentStddev;

