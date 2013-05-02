% Finite size scaling:
% y = x^alpha * F(x / N^beta)
%
% Input:
% Ns: 1D array of system sizes
% xs:  cell where the i'th element is a 1D array of x values for system size Ns(i)
% ys:  cell where the i'th element is a 1D array of y values for system size Ns(i)
% dxs: cell where the i'th element is a 1D array of errors on y values for system size Ns(i)
function [alpha, beta] = finiteSizeScaling(Ns, xs, ys, dys, guessAlpha, guessBeta)

if nargin < 5; guessAlpha = 1; end;
if nargin < 6; guessBeta = 1; end;


maxiters = -1;
verbosity = 0; %1: summary every iteration, 2: only final summary
criterion = 1; %1: strict ronvergence, 2: weak convergence
minarg = 1; % argument to minimize
control = {maxiters, verbosity, criterion, minarg};
[p, rse, convergence] = bfgsmin("overlapQualityWrapper", {[guessAlpha, guessBeta], Ns, xs, ys, dys}, control);

alpha = p(1);
beta = p(2);
