% This is analogous to the built-in hist(), but this normalizes the 
% histogram to unit surface area. Furthermore, you can give lower and upper 
% limits for the x axis.
%
% function [freq, bins] = normalizedHist(data, nbins, xlow, xhigh)
function [freq, bins] = normalizedHist(data, nbins, xlow, xhigh)

if nargin < 3
	if nargin == 2
		[freq, bins] = hist(data, nbins);
	else
		[freq, bins] = hist(data);
	end
else
	if nargin == 3
		error "need to give both xlow and xhigh"
	end

	edges = linspace(xlow, xhigh, nbins+1);
	freq = histc(data, edges);
	freq = freq(1:end-1); % last one is numel(data == xhigh), see histc documentation
	bins = edges(1:end-1) + (xhigh - xlow)/(2*nbins);
end

freq = freq / trapz(bins(:), freq(:)); % normalize to unity surface area

% Like hist(): if no output arguments: plots the histogram
if nargout == 0
	bar(bins, freq, 1);
end
