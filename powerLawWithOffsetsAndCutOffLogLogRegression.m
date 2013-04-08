% This does a regression in log-log space
function [exponent, x1, xOffset, yOffset, cutOff, cutOffWidth, exponentErr, x1err, xOffsetErr, yOffsetErr, cutOffErr, cutOffWidthErr, f] = powerLawWithOffsetsAndCutOffLogLogRegression(xs, ys, yerr, guessExponent, guessX1, guessCutOff, guessCutOffWidth, guessXoffset, guessYoffset)

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
guessX1 = guessX1 / xfact;
guessCutOff = guessCutOff / xfact;
guessCutOffWidth = guessCutOffWidth / xfact;
guessXoffset = guessXoffset / xfact;
guessYoffset = guessYoffset / yfact;


logys = log(ys);
logysErr = yerr ./ ys;

[f, p, pErr] = leasqrError(
		xs, logys, logysErr, [guessExponent, guessX1, guessXoffset, guessYoffset, guessCutOff, guessCutOffWidth],
		@(x,p)(real(powerLawWithOffsetsAndCutOffLogLog(x, p(1), p(2), p(3), p(4), p(5), p(6)))),
		10);

f = f + log(yfact);

exponent = p(1);
x1 = p(2) * xfact / yfact^(1/exponent);
xOffset = p(3) * xfact;
yOffset = p(4) * yfact;
cutOff = p(5) * xfact;
cutOffWidth = p(6) * xfact;

exponentErr = pErr(1);
x1err = pErr(2) * xfact / yfact^(1/exponent);
xOffsetErr = pErr(3) * xfact;
yOffsetErr = pErr(4) * yfact;
cutOffErr = pErr(5) * xfact;
cutOffWidthErr = pErr(6) * xfact;


