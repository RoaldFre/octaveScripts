% leasqrBootstrap: version of leasqr that does error propagation of the 
% input uncertainties via the bootstap method. 
%
% Input:
%   xs: row vector of x values
%   ys: matrix where each row consist of y values of a single run
function [f,p,pErr] = leasqrBootstrap(xs,ys,pin,F,stol,niter)

if size(xs)(2) != size(ys)(2)
	error "xs and ys must have the same number of columns!"
end

if (nargin < 6) stol = 1e-5; end
if (nargin < 7) niter = 1000; end

nRuns = size(ys)(2);

ysMean = mean(ys);
%TODO use weight?
%ysErr = std(ys')' / sqrt(nRuns - 1);
[f,pDirectFit,cvg,iter,corp,covp] = leasqr(xs,ysMean,pin,F,stol,niter);
pErrFit = sqrt(diag(covp));

Nresamples = 100; % number of resamples

%TODO continue till relative error of error is low enough (central limit thm...)

ps = zeros(numel(pin), Nresamples);
for i = 1:Nresamples
	indices = randi(nRuns, nRuns);
	resampledYs = mean(ys(indices, :));
	%TODO use weight? Or only for direct fit?
	[_f,_p] = leasqr(xs,resampledYs,pin,F,stol,niter);
	ps(:,i) = _p;
end

pErr = std(ps')';
[pErr, pErrFit]

p = pDirectFit;
