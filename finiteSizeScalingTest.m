alpha = 1.5;
beta = 4;

%Ns = [10, 14, 20, 28, 40];
Ns = [10, 14, 20];
errFrac = 0.01;
numUs = 50;


% f(u) is the scaling function
u = linspace(1,10,numUs);
%f = u.^2 + u.^3 / 100;
f = sin(u/max(u) * pi/2);

numNs = numel(Ns);
xs =  cell(numNs, 1);
ys =  cell(numNs, 1);
dys = cell(numNs, 1);

for i = 1:numNs
	xs{i} = u * Ns(i)^beta;
	ys{i} = f .* xs{i}.^alpha;
	dys{i} = ys{i} * errFrac;
	ys{i} = ys{i} + dys{i} .* randn(size(ys{i}));
end

[fitAlpha, fitBeta] = finiteSizeScaling(Ns, xs, ys, dys)
%[fitAlpha, fitBeta] = finiteSizeScaling(Ns, xs, ys, dys, alpha, beta)
