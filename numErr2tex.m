% Documentation by example:
%   '123 \pm 5' = numErr2tex(123.456, 5.52)
% 
% function str = numErr2tex(num, err)
function str = numErr2tex(num, err)

if err == 0
	printf("numErr2tex: warning: given error was zero!\n");
	str = num2tex(num);
	return
end

if num == 0
	str = '0';
	return
end

err = roundsd(abs(err), 1);
errExponent = floor(log10(err));
errMantissa = err / 10^errExponent;


% If error has bigger exponent than number -> 0
if errExponent > floor(log10(abs(num)))
	str = ['(0 \pm ',num2str(errMantissa),') \cdot 10^',num2str(errExponent)];
	return
end

% round the number to the correct place
numShifted = round(num / 10^errExponent);
num = numShifted * 10^errExponent;
sd = floor(log10(abs(numShifted))) + 1; %significant digits

numExponent = floor(log10(abs(num)));
numMantissa = num / 10^numExponent;


% Don't use scientific notation for errors between X and 0.00X
if -3 <= errExponent && errExponent < 1
	numstr = roundsdStr(roundsd(num,sd), sd);
	str = [numstr,' \pm ',num2str(err)];
	return;
end


% Scientific notation
mantissaStr = roundMantissaSd(numMantissa, sd);
errLeadingZeros = numExponent - errExponent;
errStr = sprintf(['%.',num2str(errLeadingZeros),'f'], err/10^numExponent);
str = ['(',mantissaStr,' \pm ',errStr,') \cdot 10^{',num2str(numExponent),'}'];

