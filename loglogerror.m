% This is a clone of loglogerr, but with *sensible* defaults, i.e. it does 
% not plot markers and it does not connect the data points.
function h = loglogerror(xs, ys, yerrs, color)
if nargin < 4
	color = 'b';
end

h = loglogerr(xs, ys, yerrs)
set(h, "color", color);
set(h, "marker", ".");
set(h, "linestyle", "none");
