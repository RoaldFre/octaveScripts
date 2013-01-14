% Like roundsd, but returns a string and the input must be a number between 
% x where 1 <= abs(x) < 10. Appends with zeros when neccesary.
%
% You should roundsd the number first before calling this, because 
% otherwise the rounding may cause the number to get >= 10.
function str = roundMantissaSd(num, sd)

if sd > 5
	error("Can't handle sd>5. Rewrite myself to something less hacky.")
end

if abs(num) < 1 || abs(num) >= 10
	error("Need a number between 1 and 10!");
end

if sd < 0
	str = '0';
	return
end

num = roundsd(num, sd);

if abs(num) >= 10
	error("Rounding the number caused it to get abs(num) >= 10!");
end

str = num2str(num);
digits = sum(str != '.');

if digits == sd
	return
end

if digits == 1 && sd > 1
	str = [str, '.'];
end

str = [str, '0'*ones(1,sd - digits)];

