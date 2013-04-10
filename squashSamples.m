% eg: xs = [1,   1,   1,   1,   2,   2,   2,   2  ]
%     ys = [1.1, 0.8, 1.0, 1.2, 4.8, 3.6, 3.9, 4.1]
% becomes:
%     squashedXs    = [1,     2    ]
%     squashedYs    = [1.025, 4.100] -> mean for all equal xs
%     squashedYsErr = [0.085, 0.255] -> stddev/sqrn(n-1) for all n equal xs
% Third output parameter is optional. Can only be used if each xs value has 
% at least two ys samples.
function [squashedXs, squashedYs, squashedYsErr] = squashSamples(xs, ys)

xs = xs(:);
ys = ys(:);

% sort xs:
[xs, I] = sort(xs);
ys = ys(I);


[squashedXs, I] = unique(xs);
N = numel(squashedXs);

I = [0; I];

for i = 1:N
	squashedYs(i) = mean(ys(I(i)+1 : I(i+1)));
end

if nargout >= 3
	for i = 1:N
		squashedYsErr(i) = std(ys(I(i)+1 : I(i+1))) / sqrt(I(i+1) - I(i) - 1);
	end
	squashedYsErr = squashedYsErr(:);
end

squashedXs = squashedXs(:);
squashedYs = squashedYs(:);
