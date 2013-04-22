% This does a regression in 'real' space (not log-log). As a result, the 
% initial situation (where the ys are small) is allowed to have high 
% relative error.
% A regression in log-log space is probably more appropriate for power 
% laws!
function [exp1, exp2, x1, xCrossOver, cutOff, cutOffWidth, xOffset, yOffset, exp1err, exp2err, x1err, xCrossOverErr, cutOffErr, cutOffWidthErr, xOffsetErr, yOffsetErr, f] = pl2OffsetCutoffFit(xs, ys, yErrs, guessExp1, guessExp2, guessX1, guessXcrossOver, guessCutOff, guessCutOffWidth, guessXoffset, guessYoffset)



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
guessXcrossOver = guessXcrossOver / xfact;
guessCutOff = guessCutOff / xfact;
guessCutOffWidth = guessCutOffWidth / xfact;
guessXoffset = guessXoffset / xfact;
guessYoffset = guessYoffset / yfact;


% TODO hardcoded for now!!
bounds = [
	0.1, 10;
	0.1, 10;
	1e-13/xfact, 1e-7/xfact;
	1e-13/xfact, 1e-7/xfact;
	1e-13/xfact, 1e-7/xfact;
	1e-13/xfact, 1e-7/xfact;
	%-1e-20,1e-20;
	%-1e-20,1e-20;
	%-Inf, Inf;
	%-Inf, Inf;
	-1e-7/xfact, 1e-7/xfact;
	-20/yfact, 20/yfact;
	];


%[f, p, pErr] = leasqrError(
		%xs, ys, yErrs, [guessExp1, guessExp2, guessX1, guessXcrossOver, guessCutOff, guessCutOffWidth, guessXoffset, guessYoffset],
		%@(x,p)(p(8) + real(pl2Cutoff(x + p(7), p(1), p(2), p(3), p(4), p(5), p(6)))),
		%2, bounds);

[p, f] = safit(xs, ys,
		@(x,p)(p(8) + real(pl2Cutoff(x + p(7), p(1), p(2), p(3), p(4), p(5), p(6)))),
		[guessExp1, guessExp2, guessX1, guessXcrossOver, guessCutOff, guessCutOffWidth, guessXoffset, guessYoffset]',
		bounds);

f = f * yfact;

exp1 = p(1);
exp2 = p(2);
x1 = p(3) * xfact / yfact^(1/exp1);
xCrossOver = p(4) * xfact;
cutOff = p(5) * xfact;
cutOffWidth = p(6) * xfact;
xOffset = p(7) * xfact;
yOffset = p(8) * yfact;

%exp1err = pErr(1);
%exp2err = pErr(2);
%x1err = pErr(3) * xfact / yfact^(1/exp1);
%xCrossOverErr = pErr(4) * xfact;
%cutOffErr = pErr(5) * xfact;
%cutOffWidthErr = pErr(6) * xfact;
%xOffsetErr = pErr(7) * xfact;
%yOffsetErr = pErr(8) * yfact;

