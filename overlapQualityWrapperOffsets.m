% overlap quality wrapper for finite size scaling
% y = x^alpha * F(x / N^beta)
% => F(x / N^beta) = y / x^alpha
% see overlapQuality() for more info
%
% exponentsAndOffsets:
%  [alpha, beta, xofsets, yoffsets]
%  if xOffsets and yOffsets are omitted, they are taken to be 0.
%
%  WARNING! The xOffsets are multiplied with 1e-12 to get them in the same 
%  range as the yOffsets for the minimizer that calls this wrapper!
function S = overlapQualityWrapperOffsets(exponentsAndOffsets, Ns, xs, ys, dys)

numDataSets = numel(xs);
if (numel(xs) != numel(ys)) || (numel(xs) != numel(dys))
	error "overlapQualityWrapper: Got cells of different size"
end

if numel(exponentsAndOffsets) == 2
	xOffsets = zeros(1, numDataSets);
	yOffsets = zeros(1, numDataSets);
else
	if numel(exponentsAndOffsets) != 2 + 2*numDataSets
		error(["Not the right number of initial guesses for the parameters! Got ",num2str(numel(exponentsAndOffsets)),", need ",num2str(2 + 2*numDataSets)]);
	end
	xOffsets = exponentsAndOffsets(3 : 2 + numDataSets) * 1e-12; % NOTE: *1e-12 to get input values of order one!
	yOffsets = exponentsAndOffsets(3 + numDataSets : 2 + 2*numDataSets);
end

alpha = exponentsAndOffsets(1);
beta = exponentsAndOffsets(2);


%finiteSizeCollapse(exponents, Ns, xs, ys, dys)

for i = 1:numDataSets
	if (numel(xs{i}) != numel(ys{i}) || numel(ys{i}) != numel(dys{i}))
		error "xs, ys and dys have inconsistent sizes"
	end

	% Note the order! Can't rescale xs first
	ys{i} = (ys{i} + yOffsets(i)) ./ (xs{i} + xOffsets(i)).^alpha;
	dys{i} = dys{i} ./ (xs{i} + xOffsets(i)).^alpha;
	xs{i} = (xs{i} + xOffsets(i)) / Ns(i)^beta;
end


S = overlapQuality(xs, ys, dys)
disp(['alpha = ',num2str(alpha),', beta = ',num2str(beta),', S = ',num2str(S)]);

[xOffsets(:) yOffsets(:)]
