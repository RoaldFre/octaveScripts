% This is a clone of semilogxerr, but with *sensible* defaults, i.e. it does 
% not plot markers and it does not connect the data points.
function h = semilogxerror(xs, ys, yerrs, color)
if nargin < 4
	color = 'b';
end

h = semilogxerr(xs, ys, yerrs)
set(h, "color", color);
set(h, "marker", ".");
set(h, "linestyle", "none");
