% overlap quality wrapper for finite size scaling
% y = x^z * F(x / N^beta)
% => F(x / N^beta) = y / x^z
%
% here, z = nu / beta
% see overlapQuality() for more info
function S = overlapQualityWrapperSingleExponent(beta, nu, Ns, xs, ys, dys)

alpha = nu / beta;
S = overlapQualityWrapper([alpha, beta], Ns, xs, ys, dys);

% or use the most general wrapper with offsets:
%numDataSets = numel(xs);
%pin = [alpha, beta, zeros(1, 2*numDataSets)];
%S = overlapQualityWrapperOffsets(pin, Ns, xs, ys, dys);
