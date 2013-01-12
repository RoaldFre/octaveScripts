% This is analogous to the built-in hist(), but this normalizes the 
% histogram to unit surface area.
%
% function [freq, bins] = normalizedHist(data, nbins)
function [freq, bins] = normalizedHist(data, nbins)

if nargin >= 2
	[freq, bins] = hist(data, nbins);
else
	[freq, bins] = hist(data);
end

freq = freq / trapz(bins, freq); % normalize to unity surface area

% Like hist(): if no output arguments: plots the histogram
if nargout == 0
	bar(bins, freq, 1);
end
