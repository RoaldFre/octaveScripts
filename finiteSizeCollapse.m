% Plots the collaps of the data sets with the given exponants (and possibly 
% offsets).
%
% exponentsAndOffsets: Offsets are optional
% function finiteSizeCollapse(exponentsAndOffsets, Ns, xs, ys, dys)
function finiteSizeCollapse(exponentsAndOffsets, Ns, xs, ys, dys)
alpha = exponentsAndOffsets(1);
beta = exponentsAndOffsets(2);

if (numel(xs) != numel(ys)) || (numel(xs) != numel(dys))
	error "overlapQualityWrapper: Got cells of different size"
end

numDataSets = numel(xs);
if numel(exponentsAndOffsets) == 2
	xOffsets = zeros(1, numDataSets);
	yOffsets = zeros(1, numDataSets);
else
	if numel(exponentsAndOffsets) != 2 + 2*numDataSets
		error(["Not the right number of offsets given! Got ",num2str(numel(exponentsAndOffsets)),", need ",num2str(2 + 2*numDataSets)]);
	end
	xOffsets = exponentsAndOffsets(3 : 2 + numDataSets);
	yOffsets = exponentsAndOffsets(3 + numDataSets : 2 + 2*numDataSets);
end



plotColors = colormap;
plotLegend = cell(1, numDataSets);
clf; hold on;
for i = 1:numDataSets
	if (numel(xs{i}) != numel(ys{i}) || numel(ys{i}) != numel(dys{i}))
		error "xs, ys and dys have inconsistent sizes"
	end

	% Note the order of the operations! Can't rescale xs first!
	ys{i} = (ys{i} + yOffsets(i)) ./ (xs{i} + xOffsets(i)).^alpha;
	dys{i} = dys{i} ./ (xs{i} + xOffsets(i)).^alpha;
	xs{i} = (xs{i} + xOffsets(i)) / Ns(i)^beta;

	errFrac = 1 + dys{i} ./ (ys{i} + yOffsets(i));

	h = loglog(xs{i}, ys{i});
	%h = loglog(xs{i}, ys{i}, 'linewidth', 2,  xs{i}, ys{i}.*errFrac, xs{i}, ys{i}./errFrac);
	%h = loglog(xs{i}, ys{i});
	%h = loglog(xs{i}, ys{i}, xs{i}, ys{i}.*errFrac, '.', xs{i}, ys{i}./errFrac, '.');

	plotColorsI = round(size(plotColors, 1) * i / numDataSets);
	set(h ,'Color', plotColors(plotColorsI,:));
	plotLegend{i} = ["N = ",num2str(Ns(i))];
end
title(['alpha = ',num2str(alpha),', beta = ',num2str(beta)]);
legend(plotLegend);
sleep(1e-9);
hold off;
