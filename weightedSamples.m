% function s = weightedSample(w, n)
% w = matrix where every column is a set of weights
% s = returned list of samples: row indices in the given w array
function s = weightedSamples(w)

%warning ("off", "Octave:broadcast");

n = numel(w(1,:)); % number of 'sets of weights'

edges = cumsum(w);
edges = edges ./ edges(end, :);

% hack to keep everything vectorized: need cumsum to only select the 
% *first* occurence of the <= condition per column
[s, _] = find(cumsum(rand(1,n) <= edges) == 1);
