% This is a clone of errorbar, but with *sensible* defaults, i.e. it does 
% not plot markers and it does not connect the data points.
function h = ploterror(xs, ys, yerrs, color)
if nargin < 4
	color = 'b';
end

h = errorbar(xs, ys, yerrs, color);
set(h, "marker", ".");
set(h, "linestyle", "none");

