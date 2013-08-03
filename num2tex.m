% This does a num2str, but with latex format and instead of 1.23e42 we 
% return 1.23 \cdot 10^{42}
%
% Exponent notation is used for numbers outside the range 1e-4 to 1e4 (non inclusive).
% 
% function num2tex(num, sd)
% sd = optional: the number of significant digits requested
function str = num2tex(num, sd)

if num == 0
	str = '0';
	return
end

if nargin >= 2
	num = roundsd(num, sd);
end

exponent = floor(log10(abs(num)));
mantissa = num / 10^exponent;

if -3 <= exponent && exponent <= 3
	str = num2str(num);
else
	if mantissa == 1
		str = ['10^{',num2str(exponent),'}'];
	else
		str = [num2str(mantissa),' \cdot 10^{',num2str(exponent),'}'];
	end
end
