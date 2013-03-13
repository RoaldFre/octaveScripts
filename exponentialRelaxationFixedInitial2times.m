% Fit the sum of two exponential relaxation functions
%   ys = offset +    amplFrac    * (yInitial - offset) * exp(-xs/tau1)
%               + (1 - amplFrac) * (yInitial - offset) * exp(-xs/tau2)
% for a fixed value of yInitial, and where tau1 >= tau2.
% function [tau1, tau2, offset, amplFrac, tau1Stddev, tau2Stddev, offsetStddev, amplFracStddev] = exponentialRelaxationFixedInitial2times(xs, ys, yInitial, guessTau1, guessTau2, guessOffset, guessAmplFrac, yerr)
function [tau1, tau2, offset, amplFrac, tau1Stddev, tau2Stddev, offsetStddev, amplFracStddev] = exponentialRelaxationFixedInitial2times(xs, ys, yInitial, guessTau1, guessTau2, guessOffset, guessAmplFrac, yerr)

if (nargin < 8)
       error("not enough required arguments!");
end


% Attempt at a better conditioning of the problem:
xfact = mean(xs);
yfact = mean(ys);
xs = xs / xfact;
ys = ys / yfact;
yInitial = yInitial / yfact;
yerr = yerr / yfact;
guessTau1 = guessTau1 / xfact;
guessTau2 = guessTau2 / xfact;
guessOffset = guessOffset / yfact;


[fr, p, pErr] = leasqrError(
               xs, ys, yerr, [guessTau1, guessTau2, guessOffset, guessAmplFrac],
               @(x,p)(p(3) +   p(4)  *(yInitial - p(3))*exp(-x/p(1)) ...
                           + (1-p(4))*(yInitial - p(3))*exp(-x/p(2))));

tau1 = p(1);
tau2 = p(2);
offset = p(3);
amplFrac = p(4);
tau1Stddev = pErr(1);
tau2Stddev = pErr(2);
offsetStddev = pErr(3);
amplFracStddev = pErr(4);

if tau1 < tau2
	temp = tau1;
	tau1 = tau2;
	tau2 = temp;
	temp = tau1Stddev;
	tau1Stddev = tau2Stddev;
	tau2Stddev = temp;
	amplFrac = 1 - amplFrac;
end



tau1 = tau1 * xfact;
tau2 = tau2 * xfact;
offset = offset * yfact;
tau1Stddev = tau1Stddev * xfact;
tau2Stddev = tau2Stddev * xfact;
offsetStddev = offsetStddev * yfact;
