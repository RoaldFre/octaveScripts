% Plots the collaps of the data sets with the given exponants (and possibly 
% offsets).
%
% exponentsAndOffsets: Offsets are optional
% function finiteSizeCollapse(exponentsAndOffsets, Ns, xs, ys, dys)
function finiteSizeCollapse(exponentsAndOffsets, scalingFunction, Ns, xs, ys, dys)

[xs, ys, dys] = feval(scalingFunction, exponentsAndOffsets, Ns, xs, ys, dys);

numDataSets = numel(xs);

colors = plotColors(numDataSets);
plotLegend = cell(1, numDataSets);
clf; hold on;
for i = 1:numDataSets
	errFrac = 1 + dys{i} ./ ys{i};

	h = loglog(xs{i}, ys{i});
	%h = loglog(xs{i}, ys{i}, 'linewidth', 2,  xs{i}, ys{i}.*errFrac, xs{i}, ys{i}./errFrac);
	%h = loglog(xs{i}, ys{i});
	%h = loglog(xs{i}, ys{i}, xs{i}, ys{i}.*errFrac, '.', xs{i}, ys{i}./errFrac, '.');

	set(h ,'Color', colors(i,:));
	plotLegend{i} = ["$N$ = ",num2str(Ns(i))];
end
%S = overlapQuality(xs, ys, dys);
%title(['parameters = ',num2str(exponentsAndOffsets'),', S = ',num2str(S)]);
legend(plotLegend, 'location', 'northwest');
sleep(1e-9);
hold off;
