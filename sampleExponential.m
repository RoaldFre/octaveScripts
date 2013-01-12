% sample with: f(x) = exp(-x/tau) / tau
% cdf: F(x) = (1 - exp(-x/tau))
% inv: F^-1(y) = -tau * ln(1 - y)
%
% function s = sampleExponential(tau, n)
%
% 'n' is an optional argument, indicating the number of requested samples 
% (default: 1)
function s = sampleExponential(tau, n)

if nargin < 2
	n = 1;
end

s = -tau * log(1 - rand(1,n));

