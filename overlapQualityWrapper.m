% overlap quality wrapper for finite size scaling
% y = x^alpha * F(x / N^beta)
% => F(x / N^beta) = y / x^alpha
% see overlapQuality() for more info
%
% exponentsAndOffsets:
%  [alpha, beta, xofsets, yoffsets]
%  if xOffsets and yOffsets are omitted, they are taken to be 0.
%
%  WARNING! The xOffsets are multiplied with 1e-12 to get them in the same 
%  range as the yOffsets for the minimizer that calls this wrapper!
function S = overlapQualityWrapper(exponentsAndOffsets, scalingFunction, Ns, xs, ys, dys)

[xs, ys, dys] = feval(scalingFunction, exponentsAndOffsets, Ns, xs, ys, dys);

S = overlapQuality(xs, ys, dys)

