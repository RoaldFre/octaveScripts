% function s = weightedSample(w, n)
% w = list of weights (need not be normalized)
% n = optional number of samples to return
% s = returned (list of) samples: indices in the given w array
function s = weightedSample(w, n)


if nargin < 2
	edges = cumsum(w);
	edges = edges/edges(end);
	[s, _] = find(cumsum(rand() < edges') == 1);
else
	edges = [0 cumsum(w)];
	edges = edges/edges(end);
	[_,s] = histc(rand(1,n), edges);
end
