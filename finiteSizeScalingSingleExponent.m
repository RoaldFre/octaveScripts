% Finite size scaling:
% y = x^z * F(x / N^beta)
%
% where z = nu / beta   (with nu fixed)
%
% Input:
% Ns: 1D array of system sizes
% xs:  cell where the i'th element is a 1D array of x values for system size Ns(i)
% ys:  cell where the i'th element is a 1D array of y values for system size Ns(i)
% dxs: cell where the i'th element is a 1D array of errors on y values for system size Ns(i)
function [beta, quality] = finiteSizeScalingSingleExponent(Ns, xs, ys, dys, nu, guessBeta, eps)

if nargin < 6; guessBeta = 1; end;
if nargin < 7; eps = 1e-6; end;

[p, quality, nev] = minimize("overlapQualityWrapperSingleExponent", {guessBeta, nu, Ns, xs, ys, dys}, 'ftol', eps, 'utol', eps);

beta = p;
