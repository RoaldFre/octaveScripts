% n is the dimension of the elements of the list. The list can contain 
% n-vectors (ROW vectors of n elements each) or scalars (n=1, default)
%
% function l = emptyList(n)
function l = emptyList(n)
if nargin < 1
	n = 1;
end

l = struct("list", zeros(1, n), "num", 0);
