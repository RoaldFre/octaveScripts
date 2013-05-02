% Returns ~=1 for good overlap within error bars. Returns >>1 for bad overlap.
% Algorithm described in the Apendix of "Low-temperature behavior of two-dimensional Gaussian Ising spin glasses" by Houdayer and Hartmann
%
% xs:  cell of 1D arrays of x values, in sorted order
% ys:  cell of 1D arrays of y values that correspond to xs
% dys: cell of 1D arrays of y value standard errors
function S = overlapQuality(xs, ys, dys)

if (numel(xs) != numel(ys)) || (numel(xs) != numel(dys))
	error "overlapQuality: Got cells of different size"
end

S = 0;
N = 0; % Number of terms in sum for S

% 'primed' numbers, called (x_l, y_l, dy_l) in paper
xsp  = zeros(1, 2*numel(xs));
ysp  = zeros(1, 2*numel(xs));
dysp = zeros(1, 2*numel(xs));

for i = 1:numel(xs)
	if (numel(xs{i}) != numel(ys{i}) || numel(ys{i}) != numel(dys{i}))
		error "xs, ys and dys have inconsistent sizes"
	end
	for j = 1:numel(xs{i})
		numPrimed = 0;
		xij = xs{i}(j);
		yij = ys{i}(j);
		dyij2 = dys{i}(j)^2;
		for ip = 1:numel(xs) % i' in paper
			if i == ip
				continue
			end
			% The find below is slow and O(n), can use the fact 
			% that xs are sorted to do it in 'constant' 
			% (amortized) time, but this works for now:
			jp = find(xs{ip} < xij, 1, 'last');
			if isempty(jp) || (jp+1 > numel(xs{ip}))
				continue
			end
			xsp(numPrimed + 1)  = xs{ip}(jp);
			xsp(numPrimed + 2)  = xs{ip}(jp + 1);
			ysp(numPrimed + 1)  = ys{ip}(jp);
			ysp(numPrimed + 2)  = ys{ip}(jp + 1);
			dysp(numPrimed + 1) = dys{ip}(jp);
			dysp(numPrimed + 2) = dys{ip}(jp + 1);
			numPrimed += 2;
		end
		if numPrimed < 1
			continue
		end
		xsp  = xsp(1:numPrimed);
		ysp  = ysp(1:numPrimed);
		dysp = dysp(1:numPrimed);
		w = 1./(dysp.^2);
		K = sum(w);
		Kx = sum(w .* xsp);
		Ky = sum(w .* ysp);
		Kxx = sum(w .* xsp.^2);
		Kxy = sum(w .* xsp .* ysp);
		D = K*Kxx - Kx^2;

		Yij = (Kxx*Ky - Kx*Kxy)/D + xij*(K*Kxy - Kx*Ky)/D;
		dYij2 = (Kxx - 2*xij*Kx + xij^2*K)/D;

		S += (yij - Yij)^2 / (dyij2 + dYij2);
		N++;
	end
end

%N

if N == 0
	S = Inf;
else
	S = S/N;
end

