% Fit the sum of two exponential relaxation functions, with fixed amplitude 
% at x=0 (=1) and fixed offset (=0).
%   ys =     (amplFrac)   * exp(-xs/tau1)
%        + (1 - amplFrac) * exp(-xs/tau2)
% where tau1 >= tau2,
%
% function [tau1, tau2, amplFrac, tau1Stddev, tau2Stddev, amplFracStddev] = simpleExponentialRelaxation2times(xs, ys, guessTau1, guessTau2, guessAmplFrac, yerr)
function [tau1, tau2, amplFrac, tau1Stddev, tau2Stddev, amplFracStddev] = simpleExponentialRelaxation2times(xs, ys, guessTau1, guessTau2, guessAmplFrac, yerr)

if (nargin < 5)
       error("not enough required arguments!");
end
if (nargin < 6)
       yerr = ones(length(ys), 1);
end


weights = yerr.^(-1);

acceptedError = 1e-10;
maxIterations = 1000;


[fr, p, kvg, iter, corp, covp, covr, stdresid, Z, r2] = leasqr(
               xs, ys, [guessTau1, guessTau2, guessAmplFrac],
               @(x,p)(    p(3)   * exp(-x/p(1)) ...
		      + (1-p(3)) * exp(-x/p(2))),
               acceptedError,
               maxIterations,
               weights);

tau1 = p(1);
tau2 = p(2);
amplFrac = p(3);
disp("This should be +/- diagonal:")
disp(covp);
errs = sqrt(diag(covp));
tau1Stddev = errs(1);
tau2Stddev = errs(2);
amplFracStddev = errs(3);

if tau1 < tau2
	temp = tau1;
	tau1 = tau2;
	tau2 = temp;
	amplFrac = 1-amplFrac;
end
