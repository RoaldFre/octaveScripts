function [p, pErr, y_var, r] = LinearRegressionError(F,y,yErr)

weights = 1./yErr;

[p,y_var,r,p_var] = LinearRegression(F, y, weights);


N = 50;
y = y(:);
yErr = yErr(:);
ps = zeros(numel(p), N);
for i = 1:N
	yPerturbed = y + randn(numel(y), 1) .* yErr;
	[_p] = LinearRegression(F, yPerturbed, weights);
	ps(:,i) = _p(:);
end

pErr = std(ps')';
pErr = max(pErr, sqrt(p_var));