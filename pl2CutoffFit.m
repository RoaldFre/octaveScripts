% This does a regression in 'real' space (not log-log). As a result, the 
% initial situation (where the ys are small) is allowed to have high 
% relative error.
% A regression in log-log space is probably more appropriate for power 
% laws!
function [exp1, exp2, x1, xCrossOver, cutOff, cutOffWidth, exp1err, exp2err, x1err, xCrossOverErr, cutOffErr, cutOffWidthErr, f] = pl2CutoffFit(xs, ys, yErrs, guessExp1, guessExp2, guessX1, guessXcrossOver, guessCutOff, guessCutOffWidth)

if nargin < 8
	guessCutOff = max(xs) * 0.8;
end
if nargin < 9
	guessCutOffWidth = 0.2 * guessCutOff;
end


%Attempt at a better conditioning of the problem:
xfact = mean(xs);
yfact = mean(ys);
xs = xs / xfact;
ys = ys / yfact;
yErrs = yErrs / yfact;
guessX1 = guessX1 / xfact;
guessXcrossOver = guessXcrossOver / xfact;
guessCutOff = guessCutOff / xfact;
guessCutOffWidth = guessCutOffWidth / xfact;

[f, p, pErr] = leasqrError(
		xs, ys, yErrs, [guessExp1, guessExp2, guessX1, guessXcrossOver, guessCutOff, guessCutOffWidth],
		@(x,p)(real(pl2Cutoff(x, p(1), p(2), p(3), p(4), p(5), p(6)))),
		2);

f = f * yfact;

exp1 = p(1);
exp2 = p(2);
x1 = p(3) * xfact / yfact^(1/exp1);
xCrossOver = p(4) * xfact;
cutOff = p(5) * xfact;
cutOffWidth = p(6) * xfact;

exp1err = pErr(1);
exp2err = pErr(2);
x1err = pErr(3) * xfact / yfact^(1/exp1);
xCrossOverErr = pErr(4) * xfact;
cutOffErr = pErr(5) * xfact;
cutOffWidthErr = pErr(6) * xfact;



