function str = roundsdStr(num, sd)

if sd <= 0
	str = '0';
	return
end

num = roundsd(num, sd);


if abs(num) < 1
	% Leading 0.0*
	% Can just plop trailing 0's at the back
	leadingZerosAfterPoint = floor(-log10(abs(num)));
	if (log10(abs(num)) == round(log10(abs(num))));
		% We are a perfect power of 10, in that case, we are off by one
		leadingZerosAfterPoint -= 1;
	end
	totalDigitsAfterPoint = leadingZerosAfterPoint + sd;
	str = sprintf(['%.',num2str(totalDigitsAfterPoint),'f'],num);
	return
end



numExponent = floor(log10(abs(num)));

if numExponent < 0
	error("This should never happen");
end

digitsAfterDecimalPoint = sd - numExponent - 1;

if digitsAfterDecimalPoint < 0
	error("More digits in number than requested significant digits. Use scientific notation!");
end

str = sprintf(['%.',num2str(digitsAfterDecimalPoint),'f'], num);
