% This is an implementation of logspace that actually makes sense, instead 
% of the default implementation which uses exponents of base 10 as input.
%
% It returns a vector of n elements that starts with a, ends with b and 
% logarithmically interpolates the elements in-between.
function x = mylogspace(a, b, n)

if a <= 0 || b <= 0
	error "Can't make a log space with non-positive boundaries!"
end

x = logspace(log10(a), log10(b), n);
