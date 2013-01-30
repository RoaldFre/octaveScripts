% tMax: Optional parameter to limit the extend of the autocorrelation 
% function (otherwise it's the maximum that can be get from the data, 
% assuming NONperiodic boundary in the data)
%
% returs: chi(t=0 ... t=tMax)
%
% function chi = autocorrelation(xs, tMax)
function chi = autocorrelation(xs, tMax)

if nargin < 2
	tMax = floor(numel(xs) / 2) - 1;
end

if tMax > floor(numel(xs) / 2) - 1;
	error "Not enouh data fur such a long autocorrelation time"
end

%remove bias
xs = xs - mean(xs);

%make sure that xs is a column vector
if size(xs)(2) != 1
	xs = xs';
end

chi = zeros(tMax + 1, 1);

for t = 0:tMax
	chi(t+1) = xs(1 : tMax+1)' * xs(1+t : tMax+1+t);
end

chi = chi / chi(1);
