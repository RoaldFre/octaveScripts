% Fit the function ys = offset + (yInitial - offset) * exp(-xs/tau)
%
% function [tau, offset, tauStddev, offsetStddev] = exponentialRelaxation(xs, ys, yInitial, guessTau, guessOffset, yerr)
function [tau, offset, tauStddev, offsetStddev] = exponentialRelaxation(xs, ys, yInitial, guessTau, guessOffset, yerr)

if (nargin < 5)
       error("not enough required arguments!");
end


% Attempt at a better conditioning of the problem:
xfact = mean(xs);
yfact = mean(ys);
xs = xs / xfact;
ys = ys / yfact;
yerr = yerr / yfact;
yInitial = yInitial / yfact;
guessTau = guessTau / xfact;
guessOffset = guessOffset / yfact;


[fr, p, pErr] = leasqrError(
               xs, ys, yerr, [guessTau, guessOffset],
               @(x,p)(p(2) + (yInitial - p(2))*exp(-x/p(1))));

tau = p(1);
offset = p(2);
tauStddev = pErr(1);
offsetStddev = pErr(2);


tau = tau * xfact;
offset = offset * yfact;
tauStddev = tauStddev * xfact;
offsetStddev = offsetStddev * yfact;
