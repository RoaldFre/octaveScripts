% Fit the sum of two exponential relaxation functions
%   ys = offset + ampl1 * exp(-xs/tau1)
%               + ampl2 * exp(-xs/tau2)
% where tau1 >= tau2,
%
% function [tau1, tau2, offset, ampl1, ampl2, tau1Stddev, tau2Stddev, offsetStddev, ampl1Stddev, ampl2Stddev] = exponentialRelaxation2times(xs, ys, guessTau1, guessTau2, guessOffset, guessAmpl1, guessAmpl2, yerr)
function [tau1, tau2, offset, ampl1, ampl2, tau1Stddev, tau2Stddev, offsetStddev, ampl1Stddev, ampl2Stddev] = exponentialRelaxation2times(xs, ys, guessTau1, guessTau2, guessOffset, guessAmpl1, guessAmpl2, yerr)

if (nargin < 7)
       error("not enough required arguments!");
end
if (nargin < 8)
       yerr = ones(length(ys), 1);
end


weights = yerr.^(-1);

acceptedError = 1e-10;
maxIterations = 1000;


[fr, p, kvg, iter, corp, covp, covr, stdresid, Z, r2] = leasqr(
               xs, ys, [guessTau1, guessTau2, guessOffset, guessAmpl1, guessAmpl2],
               @(x,p)(p(3) + p(4) * exp(-x/p(1)) ...
                           + p(5) * exp(-x/p(2))),
               acceptedError,
               maxIterations,
               weights);

tau1 = p(1);
tau2 = p(2);
offset = p(3);
ampl1 = p(4);
ampl2 = p(5);
disp("This should be +/- diagonal:")
disp(covp);
errs = sqrt(diag(covp));
tau1Stddev = errs(1);
tau2Stddev = errs(2);
offsetStddev = errs(3);
ampl1Stddev = errs(4);
ampl2Stddev = errs(5);

if tau1 < tau2
	temp = tau1;
	tau1 = tau2;
	tau2 = temp;
	temp = tau1Stddev;
	tau1Stddev = tau2Stddev;
	tau2Stddev = temp;
	temp = ampl1;
	ampl1 = ampl2;
	ampl2 = temp;
	temp = ampl1Stddev;
	ampl1Stddev = ampl2Stddev;
	ampl2Stddev = temp;
end
