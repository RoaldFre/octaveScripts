% leasqrError: version of leasqr that does crude error propagation of the input
% pErr: errors on p due to input errors in y (yErr = stdDev of y)
function [f,p,pErr,cvg,iter,corp,covp,covr,stdresid,Z,r2] = ...
      leasqrError(x,y,yErr,pin,F,stol,niter)

if (nargin < 6) stol = 1e-5; end
if (nargin < 7) niter = 1000; end

wt = 1./yErr;

[f,p,cvg,iter,corp,covp,covr,stdresid,Z,r2] = leasqr(x,y,pin,F,stol,niter,wt);
pErrFit = sqrt(diag(covp));

N = 50; % number of perturbed y values
pin = pin(:); % make it a column vector
y = y(:);
yErr = yErr(:);
ps = zeros(numel(pin), N);
for i = 1:N
	yPerturbed = y + randn(numel(y), 1) .* yErr;
	%plot(x,yPerturbed); sleep(1);
	[_f,_p] = leasqr(x,yPerturbed,pin,F,stol,niter,wt);
	ps(:,i) = _p;
end

pErr = std(ps')';
pErr = max(pErr, pErrFit);
