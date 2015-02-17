% Imagesc with a logarithmic color bar and optional limits
% tickLabels: cell eg {'10', '100', '1k'}
function imagescLog(data, tickPositions, tickLabels)

logData = log10(data);

colormap(jet(256));
imagesc(logData);
colorbar
if (nargin > 1)
	% source: http://cresspahl.blogspot.be/2012/04/octave-quickies-customizing-colorbar.html
	cbh = findobj( gcf(), 'tag', 'colorbar'); % color bar handle
	set(cbh,
		%'linewidth', 2,
		'tickdir', 'out',
		'ticklength',[0.005,0.005],
		'ytick', log10(tickPositions),
		'yticklabel', tickLabels)
end
