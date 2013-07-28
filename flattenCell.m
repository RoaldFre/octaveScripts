% Flattens cells of cells of cells of ... etc
function data = flattenCell(data)

if not(iscell(data))
	return
end

if not(any(cellfun(@iscell, data)))
	return
end

data = cellfun(@flattenCell,data,'UniformOutput',false);

N = sum(cellfun(@numel, data));
newData = cell(N,1);
i = 1;
for j = 1:numel(data)
	c = data{j};
	n = numel(c);
	newData(i:i+n-1) = c;
	i = i + n;
end
data = newData;

