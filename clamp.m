% function clamped = clamp(x,lo,hi)
function clamped = clamp(x,lo,hi)

% This way instead of min/max in order to keep NaNs etc intact
clamped = hi*(x>hi) + lo*(x<lo) + x.*(x >= lo & x <= hi);
