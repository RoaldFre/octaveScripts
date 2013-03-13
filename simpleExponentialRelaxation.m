% Fit the function ys = exp(-xs/tau)
%
% function [tau, tauStddev] = simpleExponentialRelaxation(xs, ys, guessTau, yerr)
function [tau, tauStddev] = simpleExponentialRelaxation(xs, ys, guessTau, yerr)

if (nargin < 4)
       error("not enough required arguments!");
end


%Attempt at a better conditioning of the problem:
xfact = mean(xs);
yfact = mean(ys);
xs = xs / xfact;
ys = ys / yfact;
yerr = yerr / yfact;
guessTau = guessTau / xfact;


[fr, p, pErr] = leasqrError(
               xs, ys, yerr, [guessTau],
               @(x,p)(exp(-x/p(1))));

tau = p(1);
tauStddev = pErr(1);


tau = tau * xfact;
tauStddev = tauStddev * xfact;
