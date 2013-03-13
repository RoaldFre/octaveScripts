% Fit the sum of two exponential relaxation functions, with fixed amplitude 
% at x=0 (=1) and fixed offset (=0).
%   ys =     (amplFrac)   * exp(-xs/tau1)
%        + (1 - amplFrac) * exp(-xs/tau2)
% where tau1 >= tau2,
%
% function [tau1, tau2, amplFrac, tau1Stddev, tau2Stddev, amplFracStddev] = simpleExponentialRelaxation2times(xs, ys, guessTau1, guessTau2, guessAmplFrac, yerr)
function [tau1, tau2, amplFrac, tau1Stddev, tau2Stddev, amplFracStddev] = simpleExponentialRelaxation2times(xs, ys, guessTau1, guessTau2, guessAmplFrac, yerr)

if (nargin < 6)
       error("not enough required arguments!");
end


%Attempt at a better conditioning of the problem:
xfact = mean(xs);
yfact = mean(ys);
xs = xs / xfact;
ys = ys / yfact;
yerr = yerr / yfact;
guessTau1 = guessTau1 / xfact;
guessTau2 = guessTau2 / xfact;
guessAmplFrac = guessAmplFrac / yfact;


[fr, p, pErr] = leasqrError(
               xs, ys, yerr, [guessTau1, guessTau2, guessAmplFrac],
               @(x,p)(    p(3)   * exp(-x/p(1)) ...
		      + (1-p(3)) * exp(-x/p(2))));

tau1 = p(1);
tau2 = p(2);
amplFrac = p(3);
tau1Stddev = pErr(1);
tau2Stddev = pErr(2);
amplFracStddev = pErr(3);

if tau1 < tau2
	temp = tau1;
	tau1 = tau2;
	tau2 = temp;
	amplFrac = 1-amplFrac;
end




tau1 = tau1 * xfact;
tau2 = tau2 * xfact;
tau1Stddev = tau1Stddev * xfact;
tau2Stddev = tau2Stddev * xfact;
