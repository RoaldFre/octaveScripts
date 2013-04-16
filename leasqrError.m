% leasqrError: version of leasqr that does a *very crude* error propagation 
% of the input uncertainties (assuming no correlation between data points).
% pErr: errors on p due to input errors in y (yErr = stdDev of y)
function [f,p,pErr,cvg,iter,corp,covp,covr,stdresid,Z,r2] = ...
      leasqrError(x,y,yErr,pin,F,numPerturbed,bounds,stol,niter)

if (nargin < 6) numPerturbed = 50; end
if (nargin < 7 || isempty(bounds)) bounds = ones(numel(pin), 1) * [-Inf Inf]; end
if (nargin < 8) stol = 1e-5; end
if (nargin < 9) niter = 1000; end

options.bounds = bounds;

pin = pin(:); % make it a column vector
x = x(:);
y = y(:);
yErr = yErr(:);

wt = 1./yErr;
dp = 0.001 * ones(size(pin));
dFdp = "dfdp";

[f,p,cvg,iter,corp,covp,covr,stdresid,Z,r2] = leasqr(x,y,pin,F,stol,niter,wt,dp,dFdp,options);
pErrFit = sqrt(diag(covp));
if (cvg != 1)
	printf("\nCONVERGENCE NOT ACHIEVED!\n\n");
end

ps = zeros(numel(pin), numPerturbed);
moreWasOn = page_screen_output;
more off;
for i = 1:numPerturbed
	printf("\rPerturbing: sample %d of %d", i, numPerturbed);
	yPerturbed = y + randn(size(y)) .* yErr;
	%plot(x,yPerturbed); sleep(1);
	[_f,_p, _cvg] = leasqr(x,yPerturbed,pin,F,stol,niter,wt,dp,dFdp,options);
	if (_cvg != 1)
		printf("\nCONVERGENCE NOT ACHIEVED!\n\n");
	end
	ps(:,i) = _p;
end
printf("\n");
if moreWasOn
	more on;
end

pErr = std(ps')';
pErr = max(pErr, pErrFit);
