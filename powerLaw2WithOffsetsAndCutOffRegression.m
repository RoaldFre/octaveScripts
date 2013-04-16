% This does a regression in 'real' space (not log-log). As a result, the 
% initial situation (where the ys are small) is allowed to have high 
% relative error.
% A regression in log-log space is probably more appropriate for power 
% laws!
function [exp1, x1, exp2, x2, xOffset, yOffset, cutOff, cutOffWidth, exp1err, x1err, exp2err, x2err, xOffsetErr, yOffsetErr, cutOffErr, cutOffWidthErr, f] = powerLaw2WithOffsetsAndCutOffRegression(xs, ys, yErrs, guessExp1, guessX1, guessExp2, guessX2, guessCutOff, guessCutOffWidth, guessXoffset, guessYoffset)

if nargin < 8
	guessCutOff = max(xs) * 0.8;
end
if nargin < 9
	guessCutOffWidth = 0.2 * guessCutOff;
end
if nargin < 10
	guessXoffset = 0;
	guessYoffset = 0;
end



%Attempt at a better conditioning of the problem:
xfact = mean(xs);
yfact = mean(ys);
xs = xs / xfact;
ys = ys / yfact;
yErrs = yErrs / yfact;
guessX1 = guessX1 / xfact;
guessX2 = guessX2 / xfact;
guessCutOff = guessCutOff / xfact;
guessCutOffWidth = guessCutOffWidth / xfact;
guessXoffset = guessXoffset / xfact;
guessYoffset = guessYoffset / yfact;


[f, p, pErr] = leasqrError(
		xs, ys, yErrs, [guessExp1, guessX1, guessExp2, guessX2, guessXoffset, guessYoffset, guessCutOff, guessCutOffWidth],
		@(x,p)(real(powerLaw2WithOffsetsAndCutOff(x, p(1), p(2), p(3), p(4), p(5), p(6), p(7), p(8)))),
		10);

f = f * yfact;

exp1 = p(1);
x1 = p(2) * xfact / yfact^(1/exp1);
exp2 = p(2);
x2 = p(4) * xfact / yfact^(1/exp2);
xOffset = p(5) * xfact;
yOffset = p(6) * yfact;
cutOff = p(7) * xfact;
cutOffWidth = p(8) * xfact;

exp1err = pErr(1);
x1err = pErr(2) * xfact / yfact^(1/exp1);
exp2err = pErr(3);
x2err = pErr(4) * xfact / yfact^(1/exp2);
xOffsetErr = pErr(5) * xfact;
yOffsetErr = pErr(6) * yfact;
cutOffErr = pErr(7) * xfact;
cutOffWidthErr = pErr(8) * xfact;


