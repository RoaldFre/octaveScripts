% Smooth the given function by convolving it with a decaying exponential of 
% width tau. The first data points, however, don't get 'dragged downwards' 
% (compared to using a real lowpass filter).
%
% function y = smooth(x, tau)
function y = smooth(x, tau)
	alpha = 1/tau;
	y = zeros(size(x));
	y(1) = x(1);
	for i = 2:numel(x)
		y(i) = alpha * x(i) + (1 - alpha) * y(i-1);
	end
end
