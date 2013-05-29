% rescale for a system with y = t^alpha F(t/N^beta)
function [xs, ys, dys] = finiteSizeRescaleWithTime(exponentsAndOffsets, Ns, xs, ys, dys)

if (numel(xs) != numel(ys)) || (numel(xs) != numel(dys))
	error "finiteSizeRescaleWithTime: Got cells of different size"
end

numDataSets = numel(xs);

alpha = exponentsAndOffsets(1);
beta = exponentsAndOffsets(2);

if numel(exponentsAndOffsets) == 2
	xOffsets = zeros(1, numDataSets);
	yOffsets = zeros(1, numDataSets);
else
	if numel(exponentsAndOffsets) != 2 + 2*numDataSets
		error(["Not the right number of offsets given! Got ",num2str(numel(exponentsAndOffsets)),", need ",num2str(2 + 2*numDataSets)]);
	end
	xOffsets = exponentsAndOffsets(3 : 2 + numDataSets) * 1e-12; % NOTE: *1e-12 to get input values of order one!
	yOffsets = exponentsAndOffsets(3 + numDataSets : 2 + 2*numDataSets);
end

for i = 1:numDataSets
	% Note the order of the operations! Can't rescale xs first!
	ys{i} = (ys{i} + yOffsets(i)) ./ (xs{i} + xOffsets(i)).^alpha;
	dys{i} = dys{i} ./ (xs{i} + xOffsets(i)).^alpha;
	xs{i} = (xs{i} + xOffsets(i)) / Ns(i)^beta;

	% Note: if xs{i} + xOffsets{i} <= 0, then we can have NANs! Filter them out:
	mask = xs{i} + xOffsets(i) > 0;
	ys{i} = ys{i}(mask);
	xs{i} = xs{i}(mask);
	dys{i} = dys{i}(mask);
end

disp(['alpha = ',num2str(alpha),', beta = ',num2str(beta)]);
[xOffsets(:) yOffsets(:)]
