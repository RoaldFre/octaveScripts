% overlap quality wrapper for finite size scaling
% y = x^alpha * F(x / N^beta)
% => F(x / N^beta) = y / x^alpha
% see overlapQuality() for more info
function S = overlapQualityWrapper(exponents, Ns, xs, ys, dys)
alpha = exponents(1);
beta = exponents(2);

if (numel(xs) != numel(ys)) || (numel(xs) != numel(dys))
	error "overlapQualityWrapper: Got cells of different size"
end

%clf; hold on;
for i = 1:numel(xs)
	if (numel(xs{i}) != numel(ys{i}) || numel(ys{i}) != numel(dys{i}))
		error "xs, ys and dys have inconsistent sizes"
	end

	% Note the order! Can't rescale xs first
	ys{i} = ys{i} ./ xs{i}.^alpha;
	dys{i} = dys{i} ./ xs{i}.^alpha;
	xs{i} = xs{i} / Ns(i)^beta;

	%loglog(xs{i}, ys{i})
	%plot(xs{i}, ys{i})
end
%title(['alpha = ',num2str(alpha),', beta = ',num2str(beta)]);
%sleep(1e-9);
disp(['alpha = ',num2str(alpha),', beta = ',num2str(beta)]);


S = overlapQuality(xs, ys, dys);