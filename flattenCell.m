% Flattens cells of cells of cells of ... etc
function data = flattenCell(data)

% Based on decellify from http://blogs.mathworks.com/loren/2006/06/21/cell-arrays-and-their-contents/

if not(iscell(data))
	return
end

data = cellfun(@flattenCell,data,'UniformOutput',false);
if any(cellfun(@iscell,data))
	data = [data{:}];
end


