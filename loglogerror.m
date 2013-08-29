% This is a clone of loglogerr, but with *sensible* defaults, i.e. it does 
% not plot markers and it does not connect the data points.
%
% You can use it as:
% h = loglogerror(xs, ys, yerrs, color)
% h = loglogerror(xs, ys, xerrs, yerrs, color)
% In both cases, 'color' is optional.
function h = loglogerror(xs, ys, a, b, c)

if nargin == 3
	h = loglogerr(xs, ys, a);
	color = 'b';
elseif nargin == 4
	if ischar(b)
		h = loglogerr(xs, ys, a);
		color = b;
	else
		h = loglogerr(xs, ys, a, a, b, b, '~>');
		color = 'b';
	end
else
	h = loglogerr(xs, ys, a, a, b, b, '~>');
	color = c;
end

set(h, "color", color);
set(h, "marker", ".");
set(h, "linestyle", "none");
