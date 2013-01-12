% Fit the function ys = amplitude * exp(-xs/tau)
%
% function [tau, amplitude, tauStddev, amplitudeStddev] = exponentialRelaxationNoOffset(xs, ys, guessTau, guessAmplitude, yerr)
function [tau, amplitude, tauStddev, amplitudeStddev] = exponentialRelaxationNoOffset(xs, ys, guessTau, guessAmplitude, yerr)

if (nargin < 4)
       error("not enough required arguments!");
end
if (nargin < 5)
       yerr = ones(length(ys), 1);
end


weights = yerr.^(-1);

acceptedError = 1e-10;
maxIterations = 1000;

[fr, p, kvg, iter, corp, covp, covr, stdresid, Z, r2] = leasqr(
               xs, ys, [guessTau, guessAmplitude],
               @(x,p)(p(2)*exp(-x/p(1))),
               acceptedError,
               maxIterations,
               weights);

tau = p(1);
amplitude = p(2);
disp("This should be +/- diagonal:")
disp(covp);
errs = sqrt(diag(covp));
tauStddev = errs(1);
amplitudeStddev = errs(2);

