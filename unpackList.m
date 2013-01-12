% Return a regular array with the elements contained in the list.
%
% function list = unpackList(l)
function list = unpackList(l)
list = l.list(1:l.num, :);
