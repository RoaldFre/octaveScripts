% function decim = decimateSimple(data, factor)
%
% Decimate by taking a mean of 'factor' data points (in each dimension). 
% Works for 1D and 2D data.
function decim = decimateSimple(data, factor)

if (factor == 1)
	decim = data;
	return
end

dims = size(data);
if (dims(1) != 1 && mod(dims(1),factor) != 0)
	error "Invalid factor: not a divisor of dimensions"
end
if (dims(2) != 1 && mod(dims(2),factor) != 0)
	error "Invalid factor: not a divisor of dimensions"
end
newDims=max(1, dims/factor);

decim = zeros(newDims);

if dims(1) != 1
	delta_u = factor - 1;
else
	delta_u = 0;
end
if dims(2) != 1
	delta_v = factor - 1;
else
	delta_v = 0;
end
for i=1:newDims(1)
	for j=1:newDims(2)
		u = (i-1)*factor + 1;
		v = (j-1)*factor + 1;
		decim(i,j) = mean(mean(data(u:u+delta_u, v:v+delta_v)));
	end
end

