function [avgPs, errPs] = finiteSizeResultplot(clustNs, clustPs, clustPErrs, meanStartN, parameterLabels)

if nargin < 4; meanStartN = 0; end;
if nargin < 5; parameterLabels = {}; end;

if max(clustNs) < meanStartN
	error "finiteSizeResultplot: meanStartN is bigger than the largest clustN!"
end
meanStartIndex = find(clustNs >= meanStartN, 1);

avgPs = zeros(1, size(clustPs, 2));
errPs = zeros(1, size(clustPs, 2));

hold on;
plotColors = colormap;
handles = zeros(1, size(clustPs,2));
for i = 1:size(clustPs,2)
	plotColorsI = round(size(plotColors, 1) * i / size(clustPs,2));

	ys = clustPs(:,i);
	dys = clustPErrs(:,i);
	h = ploterror(clustNs, ys, dys);
	handles(i) = h;
	set(h ,'Color', plotColors(plotColorsI,:));

	ys  = ys (meanStartIndex:end);
	dys = dys(meanStartIndex:end);
	wts = 1./dys.^2;
	y = sum(ys .* wts) / sum(wts);
	dy = sqrt(1/sum(wts));
	xs = clustNs([meanStartIndex, end]);
	h = plot(xs, y * [1 1]);      set(h ,'Color', plotColors(plotColorsI,:));
	h = plot(xs, (y-dy) * [1 1]); set(h ,'Color', plotColors(plotColorsI,:));
	h = plot(xs, (y+dy) * [1 1]); set(h ,'Color', plotColors(plotColorsI,:));

	printf('Mean result: %f +- %f\n', y, dy);
	avgPs(i) = y;
	errPs(i) = dy;
end
hold off;

legend(handles, parameterLabels);
