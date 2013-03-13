% Fit the function ys = amplitude * exp(-xs/tau)
%
% function [tau, amplitude, tauStddev, amplitudeStddev] = exponentialRelaxationNoOffset(xs, ys, guessTau, guessAmplitude, yerr)
function [tau, amplitude, tauStddev, amplitudeStddev] = exponentialRelaxationNoOffset(xs, ys, guessTau, guessAmplitude, yerr)

if (nargin < 5)
       error("not enough required arguments!");
end

%Attempt at a better conditioning of the problem:
xfact = mean(xs);
yfact = mean(ys);
xs = xs / xfact;
ys = ys / yfact;
yerr = yerr / yfact;
guessTau = guessTau / xfact;
guessAmplitude = guessAmplitude / yfact;


[fr, p, pErr] = leasqrError(
               xs, ys, yerr, [guessTau, guessAmplitude],
               @(x,p)(p(2)*exp(-x/p(1))));

tau = p(1);
amplitude = p(2);
tauStddev = pErr(1);
amplitudeStddev = pErr(2);



tau = tau * xfact;
amplitude = amplitude * yfact;
tauStddev = tauStddev * xfact;
amplitudeStddev = amplitudeStddev * yfact;
