% overlap quality wrapper for finite size scaling
% y = x^z * F(x / N^beta)
% => F(x / N^beta) = y / x^z
%
% here, z = nu / beta
% see overlapQuality() for more info
function S = overlapQualityWrapperSingleExponent(betaWithPossiblyOffsets, scalingFunction, nu, Ns, xs, ys, dys)

beta = betaWithPossiblyOffsets(1);
alpha = nu / beta;

if numel(betaWithPossiblyOffsets) == 1
	offsetParameters = [];
else
	offsetParameters = betaWithPossiblyOffsets(2:end)(:)';
end

S = overlapQualityWrapper([alpha, beta, offsetParameters], scalingFunction, Ns, xs, ys, dys);

