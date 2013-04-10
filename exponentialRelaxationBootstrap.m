% Fit the function ys = offset + amplitude * exp(-xs/tau)
%
% function [tau, offset, amplitude, tauStddev, offsetStddev, amplitudeStddev] = exponentialRelaxation(xs, ys, guessTau, guessOffset, guessAmplitude)
function [tau, offset, amplitude, tauStddev, offsetStddev, amplitudeStddev] = exponentialRelaxationBootstrap(xs, ys, guessTau, guessOffset, guessAmplitude)

if (nargin < 5)
       error("not enough required arguments!");
end


%Attempt at a better conditioning of the problem:
xfact = mean(xs);
yfact = mean(ys);
xs = xs / xfact;
ys = ys / yfact;
guessTau = guessTau / xfact;
guessOffset = guessOffset / yfact;
guessAmplitude = guessAmplitude / yfact;


[fr, p, pErr] = leasqrBootstrap(
               xs, ys, [guessTau, guessOffset, guessAmplitude],
               @(x,p)(p(2) + p(3)*exp(-x/p(1))));

tau = p(1);
offset = p(2);
amplitude = p(3);
tauStddev = pErr(1);
offsetStddev = pErr(2);
amplitudeStddev = pErr(3);


tau = tau * xfact;
offset = offset * yfact;
amplitude = amplitude * yfact;
tauStddev = tauStddev * xfact;
offsetStddev = offsetStddev * yfact;
amplitudeStddev = amplitudeStddev * yfact;
