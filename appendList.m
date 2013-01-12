% Append to list in amortized contstant time
% vals can be a single element (scalar or row vector)
% or
% vals can be a list of elements (column vector (n=1) or matrix where every 
% row is an entry (a row vector with n components))
%
% function l = appendList(l, vals)
function l = appendList(l, vals)

list = l.list;
num = l.num;
capacity = size(list)(1);
n = size(list)(2);
numNew = size(vals)(1);
if n != size(vals)(2)
	error "Can't append things with different dimensionality!";
end
if capacity < num + numNew
	list = [list; zeros(max(num, numNew - num), n)];
end
list(num+1 : num+numNew, :) = vals;
l.num = num + numNew;
l.list = list;

