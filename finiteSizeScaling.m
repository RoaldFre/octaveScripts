% Finite size scaling:
% y = x^alpha * F(x / N^beta)
%
% Input:
% Ns: 1D array of system sizes
% xs:  cell where the i'th element is a 1D array of x values for system size Ns(i)
% ys:  cell where the i'th element is a 1D array of y values for system size Ns(i)
% dxs: cell where the i'th element is a 1D array of errors on y values for system size Ns(i)
function [alpha, beta, quality] = finiteSizeScaling(Ns, xs, ys, dys, guessAlpha, guessBeta, eps)

if nargin < 5; guessAlpha = 1; end;
if nargin < 6; guessBeta = 1; end;
if nargin < 7; eps = 1e-6; end;

[p, quality, nev] = minimize("overlapQualityWrapper", {[guessAlpha; guessBeta], Ns, xs, ys, dys}, 'ftol', eps, 'utol', eps);

alpha = p(1);
beta = p(2);
