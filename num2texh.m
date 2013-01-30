% This does a num2str, but with latex format and 'human-readable' power 
% indicators, e.g. instead of 1.23e10, we return 12.3\,G 
%
% mili is only used between 0.009999.. and 0.001
%
% function num2texh(num, sd)
% sd = optional: the number of significant digits requested
function str = num2texh(num, sd)

if num == 0
	str = '0';
	return
end

if nargin >= 2
	num = roundsd(num, sd);
end

prefixes = {'\,y','\,z','\,a','\,f','\,p','\,n','\,\mu','\,m','','\,k','\,M','\,G','\,T','\,P','\,E','\,Z','\,Y'};

exponent = floor(log10(abs(num)));
powerBy3 = floor(exponent/3);
prefix = prefixes{powerBy3 + 9};
mantissa = num / 10^(3*powerBy3);

%This can be commented to allow for mili to be used form 0.999 downwards
if -2 <= exponent && exponent <= 0
	str = num2str(num);
else
	str = [num2str(mantissa), prefix];
end
