% Plots the collaps of the data sets with the given exponants (and possibly 
% offsets).
%
% exponentsAndOffsets: Offsets are optional
% function finiteSizeCollapse(exponentsAndOffsets, Ns, xs, ys, dys)
function finiteSizeCollapse(exponentsAndOffsets, scalingFunction, Ns, xs, ys, dys)
alpha = exponentsAndOffsets(1);
beta = exponentsAndOffsets(2);

[xs, ys, dys] = feval(scalingFunction, exponentsAndOffsets, Ns, xs, ys, dys);
S = overlapQuality(xs, ys, dys);

numDataSets = numel(xs);

plotColors = colormap;
plotLegend = cell(1, numDataSets);
clf; hold on;
for i = 1:numDataSets
	errFrac = 1 + dys{i} ./ ys{i};

	h = loglog(xs{i}, ys{i});
	%h = loglog(xs{i}, ys{i}, 'linewidth', 2,  xs{i}, ys{i}.*errFrac, xs{i}, ys{i}./errFrac);
	%h = loglog(xs{i}, ys{i});
	%h = loglog(xs{i}, ys{i}, xs{i}, ys{i}.*errFrac, '.', xs{i}, ys{i}./errFrac, '.');

	plotColorsI = round(size(plotColors, 1) * i / numDataSets);
	set(h ,'Color', plotColors(plotColorsI,:));
	plotLegend{i} = ["N = ",num2str(Ns(i))];
end
title(['alpha = ',num2str(alpha),', beta = ',num2str(beta),', S = ',num2str(S)]);
legend(plotLegend);
sleep(1e-9);
hold off;
