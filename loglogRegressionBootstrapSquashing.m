% Performs a linear regression on the 'log-log' of the data.
%
function [cte, exponent, cteStddev, exponentStddev] = loglogRegressionBootstrap(xs, ys, guessCte, guessExponent)



%TODO TODO uitmiddelen en dan log nemen, of log nemen en dan uitmiddelen om mean time te bekomen???????

if (nargin < 4)
	error("Not enough required arguments!");
end

xs = xs(:);
ys = ys(:);

logys = log(ys);
logxs = log(xs);

Nsamples = numel(xs);

[logxsSquashed, logysSquashed] = squashSamples(logxs, logys);
F = [ones(numel(logxsSquashed), 1), logxsSquashed];
[pDirectFit, y_var, r, pErrFit] = LinearRegression(F, logysSquashed);

Nresamples = 100;
ps = zeros(2, Nresamples);

moreWasOn = page_screen_output;
more off;
for i = 1:Nresamples
	printf("\rResampling: sample %d of %d", i, Nresamples);
	indices = randi(Nsamples, Nsamples);
	logxsResampled = logxs(indices);
	logysResampled = logys(indices);
	[logxsSquashed, logysSquashed] = squashSamples(logxsResampled, logysResampled);
	F = [ones(numel(logxsSquashed), 1), logxsSquashed];
	ps(:, i) = LinearRegression(F, logysSquashed);
end
printf("\n");
if moreWasOn
	more on;
end

%p = mean(ps')';
p = pDirectFit;
%[mean(ps')', pDirectFit]
pErrBootstrap = std(ps')';
%[pErrBootstrap, pErrFit]
pErr = sqrt(pErrBootstrap.^2 + pErrFit.^2); %correct? At least safer than 'max'...
cteExponent = p(1);
cteExponentStddev = pErr(1);
exponent = p(2);
exponentStddev = pErr(2);

cte = exp(cteExponent);
cteStddev = cte * cteExponentStddev;

printf("Cte bootstrap err / fit err: %f\n", pErrBootstrap(1) / pErrFit(1));
printf("Exp bootstrap err / fit err: %f\n", pErrBootstrap(2) / pErrFit(2));
