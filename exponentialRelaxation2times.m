% Fit the sum of two exponential relaxation functions
%   ys = offset + ampl1 * exp(-xs/tau1)
%               + ampl2 * exp(-xs/tau2)
% where tau1 >= tau2,
%
% function [tau1, tau2, offset, ampl1, ampl2, tau1Stddev, tau2Stddev, offsetStddev, ampl1Stddev, ampl2Stddev] = exponentialRelaxation2times(xs, ys, guessTau1, guessTau2, guessOffset, guessAmpl1, guessAmpl2, yerr)
function [tau1, tau2, offset, ampl1, ampl2, tau1Stddev, tau2Stddev, offsetStddev, ampl1Stddev, ampl2Stddev] = exponentialRelaxation2times(xs, ys, guessTau1, guessTau2, guessOffset, guessAmpl1, guessAmpl2, yerr)

if (nargin < 8)
       error("not enough required arguments!");
end

% Attempt at a better conditioning of the problem:
xfact = mean(xs);
yfact = mean(ys);
xs = xs / xfact;
ys = ys / yfact;
yerr = yerr / yfact;
guessTau1 = guessTau1 / xfact;
guessTau2 = guessTau2 / xfact;
guessAmpl1 = guessAmpl1 / yfact;
guessAmpl2 = guessAmpl2 / yfact;


[fr, p, pErr] = leasqrError(
               xs, ys, yerr, [guessTau1, guessTau2, guessOffset, guessAmpl1, guessAmpl2],
               @(x,p)(p(3) + p(4) * exp(-x/p(1)) ...
                           + p(5) * exp(-x/p(2))));

tau1 = p(1);
tau2 = p(2);
offset = p(3);
ampl1 = p(4);
ampl2 = p(5);
tau1Stddev = pErr(1);
tau2Stddev = pErr(2);
offsetStddev = pErr(3);
ampl1Stddev = pErr(4);
ampl2Stddev = pErr(5);

if tau1 < tau2
	temp = tau1;
	tau1 = tau2;
	tau2 = temp;
	temp = tau1Stddev;
	tau1Stddev = tau2Stddev;
	tau2Stddev = temp;
	temp = ampl1;
	ampl1 = ampl2;
	ampl2 = temp;
	temp = ampl1Stddev;
	ampl1Stddev = ampl2Stddev;
	ampl2Stddev = temp;
end



tau1 = tau1 * xfact;
tau2 = tau2 * xfact;
ampl1 = ampl1 * yfact;
ampl2 = ampl2 * yfact;
tau1Stddev = tau1Stddev * xfact;
tau2Stddev = tau2Stddev * xfact;
ampl1Stddev = ampl1Stddev * yfact;
ampl2Stddev = ampl2Stddev * yfact;
