% Drops the linear space input data into a logarithmic space. The output 
% will have ~log(n) elements.
%
% If the input is a 2D array, then only columns get dropped
%
% finalSizeFactor:
%   If this is 1, then return the ideally logarithmically sampled data, 
%   e.g. if the input has 2^n elements, then return the subset with indices 
%   2^(0:n).
%   In general: return a list with 'finalSizeFactor' times the ideal number 
%   of samples. Eg, if it is 10, then the returned list will have 10 times 
%   more samples, but the first samples will be duplicates because the 
%   input data is not dense enough there. See also 'dropDuplicates'.
%
%   Default: 1
% 
% dropDuplicates:
%   If finalSizeFactor > 1, there is the possibility of having duplicates 
%   at the start of the list. If you pass 'true' here, then those 
%   duplicates will be removed from the output. Otherwise they remain in 
%   the output.
%
%   Default: true
%
function ys = dropDataLogspace(xs, finalSizeFactor, dropDuplicates)

if nargin < 2; finalSizeFactor = 1; end
if nargin < 3; dropDuplicates = true; end

if finalSizeFactor <= 0
	ys = xs;
	return
end

if isvector(xs)
	inputSize = numel(xs);
	finalSize = ceil(log(inputSize + 1)/log(2) * finalSizeFactor);

	indices = round(mylogspace(1, inputSize, finalSize));
	if dropDuplicates; indices = unique(indices); end;
	ys = xs(indices);
else
	numSamples = size(xs, 2);
	finalSamples = ceil(log(numSamples + 1)/log(2) * finalSizeFactor);

	indices = round(mylogspace(1, numSamples, finalSamples));
	if dropDuplicates; indices = unique(indices); end;
	ys = xs(:, indices);
end

