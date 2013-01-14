% Fit the function ys = exp(-xs/tau)
%
% function [tau, tauStddev] = simpleExponentialRelaxation(xs, ys, guessTau, yerr)
function [tau, tauStddev] = simpleExponentialRelaxation(xs, ys, guessTau, yerr)

if (nargin < 3)
       error("not enough required arguments!");
end
if (nargin < 4)
       yerr = ones(length(ys), 1);
end


weights = yerr.^(-1);

acceptedError = 1e-10;
maxIterations = 1000;

[fr, p, kvg, iter, corp, covp, covr, stdresid, Z, r2] = leasqr(
               xs, ys, [guessTau],
               @(x,p)(exp(-x/p(1))),
               acceptedError,
               maxIterations,
               weights);

tau = p(1);
%Only one parameter: hence covp is just a number, not a matrix
%disp("This should be +/- diagonal:")
%disp(covp);
errs = sqrt(diag(covp));
tauStddev = errs(1);
