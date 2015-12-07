% input: array with several columns
% output: array where the rows that have the same value in the initial column are averaged together
% eg:
%   1 1 2 3
%   1 3 4 5
%   2 1 1 1
%   2 1 3 5
% becomes:
%   1 2 3 4
%   2 1 2 3
function result = averageDuplicates(data);

keys = unique(data(:,1));
N = numel(keys);
result = zeros(N, size(data)(2));
for i = 1:N
	key = keys(i);
	mask = data(:,1) == key;
	result(i,:) = mean(data(mask,:));
end

