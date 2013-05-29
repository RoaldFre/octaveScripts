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

%profile on;
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
			%xs{ip}
			%xij
			jp = find(xs{ip} < xij, 1, 'last');
			if isempty(jp) || (jp+1 > numel(xs{ip}))
				continue
			end
			%[i j ip jp]
			%manually do subexpression elimination
			npp1 = numPrimed + 1;
			npp2 = numPrimed + 2;
			jpp1 = jp + 1;
			xsp(npp1)  = xs{ip}(jp);
			xsp(npp2)  = xs{ip}(jpp1);
			ysp(npp1)  = ys{ip}(jp);
			ysp(npp2)  = ys{ip}(jpp1);
			dysp(npp1) = dys{ip}(jp);
			dysp(npp2) = dys{ip}(jpp1);
			numPrimed += 2;
		end
		if numPrimed < 1
			continue
		end
		xspActive  = xsp(1:numPrimed);
		yspActive  = ysp(1:numPrimed);
		dyspActive = dysp(1:numPrimed);
		w = 1./(dyspActive'.^2);
		K = sum(w);
		Kx = xspActive * w;
		Ky = yspActive * w;
		Kxx = xspActive.^2 * w;
		Kxy = (xspActive .* yspActive) * w;
		D = K*Kxx - Kx^2;

		Yij = (Kxx*Ky - Kx*Kxy)/D + xij*(K*Kxy - Kx*Ky)/D;
		dYij2 = (Kxx - 2*xij*Kx + xij^2*K)/D;

		extraTerm = (yij - Yij)^2 / (dyij2 + dYij2);
		if isnan(extraTerm)
			warning "Ignoring a NaN term in the overlapQuality sum!"
			continue;
		end

		S += extraTerm;
		N++;
	end
end

%profile off
%profshow(profile('info'));

if N == 0
	disp("WARNING: No overlapping samples in overlapQuality!");
	%S = Inf;
	S = 1e3; % For numerical minimization that uses derivatives: can't 
		 % use inf. On the other hand: this creates a plateau where 
		 % the gradient is zero, so be careful not to get 'trapped' 
		 % here!
elseif isnan(S)
	disp("WARNING: S was NAN in overlapQuality!");
	S = 1e3;
else
	S = sqrt(S/N);
end

