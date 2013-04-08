% This does a regression in 'real' space (not log-log). As a result, the 
% initial situation (where the ys are small) is allowed to have high 
% relative error.
% A regression in log-log space is probably more appropriate for power 
% laws!
function [cte, exponent, xOffset, yOffset, cutOff, cutOffWidth, cteErr, exponentErr, xOffsetErr, yOffsetErr, cutOffErr, cutOffWidthErr, f] = powerLawWithOffsetsAndCutOffRegression(xs, ys, yErrs, guessCte, guessExponent, guessCutOff, guessCutOffWidth, guessXoffset, guessYoffset)

if nargin < 6
	guessCutOff = max(xs) * 0.8;
end
if nargin < 7
	guessCutOffWidth = 0.2 * guessCutOff;
end
if nargin < 8
	guessXoffset = 0;
	guessYoffset = 0;
end



%Attempt at a better conditioning of the problem:
xfact = mean(xs);
yfact = mean(ys);
xs = xs / xfact;
ys = ys / yfact;
guessCte = guessCte / yfact;
guessCutOff = guessCutOff / xfact;
guessCutOffWidth = guessCutOffWidth / xfact;
guessXoffset = guessXoffset / xfact;
guessYoffset = guessYoffset / yfact;


[f, p, pErr] = leasqrError(
		xs, ys, yErrs, [guessCte, guessExponent, guessXoffset, guessYoffset, guessCutOff, guessCutOffWidth],
		@(x,p)(real(powerLawWithOffsetsAndCutOff(x, p(1), p(2), p(3), p(4), p(5), p(6)))),
		10);

f = f * yfact;

cte = p(1) * yfact;
exponent = p(2);
xOffset = p(3) * xfact;
yOffset = p(4) * yfact;
cutOff = p(5) * xfact;
cutOffWidth = p(6) * xfact;

cteErr = pErr(1) * yfact;
exponentErr = pErr(2);
xOffsetErr = pErr(3) * xfact;
yOffsetErr = pErr(4) * yfact;
cutOffErr = pErr(5) * xfact;
cutOffWidthErr = pErr(6) * xfact;


