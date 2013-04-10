% leasqrBootstrap: version of leasqr that does error propagation of the 
% input uncertainties via the bootstap method. Note: this uses 'full' 
% resampling, which implicitly assumes that there is an uncertainty on the 
% 'x' values as well. The alternative (residual resampling) assumes an 
% independent and identical distribution of errors of the 'y' values, which 
% is much less appropriate in general.
%
% Input: the i'th data sample corresponds to (xs(i), ys(i)).
% eg: xs = [1,   1,   1,   1,   2,   2,   2,   2  ]
%     ys = [1.1, 0.8, 1.0, 1.2, 4.8, 3.6, 3.9, 4.1]
function [f,p,pErr] = leasqrBootstrap(xs,ys,pin,F,stol,niter)

if numel(xs) != numel(ys)
	error "xs and ys must have the same length!"
end

if (nargin < 6) stol = 1e-5; end
if (nargin < 7) niter = 1000; end


[x, y, yerr] = squashSamples(xs, ys);
wt = 1./yerr;
[f,pDirectFit,cvg,iter,corp,covp] = leasqr(x,y,pin,F,stol,niter,wt);
pErrFit = sqrt(diag(covp));

Nsamples = numel(xs);
Nresamples = 200; % number of resamples

%TODO continue till relative error of error is low enough (central limit thm...)

ps = zeros(numel(pin), Nresamples);
for i = 1:Nresamples
	indices = randi(Nsamples, Nsamples);
	[resampledXs, resampledYs] = squashSamples(xs(indices), ys(indices));
	[_f,_p] = leasqr(resampledXs,resampledYs,pin,F,stol,niter);
	ps(:,i) = _p;
end

pErr = std(ps')';
[pErr, pErrFit]
pErr = max(pErrFit, pErr);
%p = mean(ps')'; % Averaging should not give the ideal result! Because 
%can't assume that they are independent/linear/... Still use the least 
%squares result from the initial 'regular' fit!
%Only use bootstrapping for error estimate!

%[p, pDirectFit]
p = pDirectFit;
