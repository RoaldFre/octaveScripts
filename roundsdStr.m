function str = roundsdStr(num, sd)

% I'm using num2str all over the place, and that only fives 5 significant digits
if sd > 5
	error("Can't handle sd>5. Rewrite myself to something less hacky.")
end

if sd <= 0
	str = '0';
	return
end

num = roundsd(num, sd);


if abs(num) < 1
	% Leading 0.0*
	% Can just plop trailing 0's at the back
	rawstr = num2str(num);
	digits = numel(rawstr) - find(rawstr == '.');
	str = [rawstr,'0'*ones(1, sd - digits)];
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

str = num2str(num);

if digitsAfterDecimalPoint == 0
	return
end

digits = sum(str != '.');

if digits == sd
	return
end

% need to append zeros
if digits == (numExponent + 1)
	str = [str, '.'];
end

str = [str,'0'*ones(1, sd - digits)];
