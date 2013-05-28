% Finite size scaling:
% y = x^alpha * F(x / N^beta)
%
% Depending on the number of input arguments (specifically, whether bootstrapSamples is provided or not), the input arguments are:
%
% Input without bootstrapSamples:
% Ns: 1D array of system sizes
% xs:  cell where the i'th element is a 1D array of x values for system size Ns(i)
% ys:  cell where the i'th element is a 1D array of y values for system size Ns(i)
% dys: cell where the i'th element is a 1D array of errors on y values for system size Ns(i)
%
% Input with bootstrapSamples:
% Ns: 1D array of system sizes
% xs:  cell where the i'th element is a 1D array of x values for system size Ns(i)
% ys:  cell where the i'th element is a 2D array of y values for system size Ns(i), each row is one run
% dys: ignored (errors get calculated from the full ys data sets)
%
% Last two input parameters:
%   - fixOffsetToZero: don't fit an offset, fix it to zero
%   - singleExponent: only fit one exponent, nuOrGuessAlpha is actually 'nu' and alpha = nu/beta.
%
% function [alpha, alphaErr, beta, betaErr, quality, xOffsets, xOffsetsErr, yOffsets, yOffsetsErr] = finiteSizeScaling(Ns, xs, ys, dys, nuOrGuessAlpha, guessBeta, eps, bootstrapSamples, fixOffsetToZero, singleExponent)
function [alpha, alphaErr, beta, betaErr, quality, xOffsets, xOffsetsErr, yOffsets, yOffsetsErr] = finiteSizeScaling(Ns, xs, ys, dys, nuOrGuessAlpha, guessBeta, eps, bootstrapSamples, fixOffsetToZero, singleExponent)

if nargin < 5; nuOrGuessAlpha = 1; end;
if nargin < 6; guessBeta = 1; end;
if nargin < 7; eps = 1e-6; end;
if nargin < 8;
	bootstrapSamples = 0;
	alphaErr = nan;
	betaErr = nan;
	xOffsetsErr = nan;
	yOffsetsErr = nan;
end;
if nargin < 9; fixOffsetToZero = false; end;
if nargin < 10; singleExponent = false; end;



numDataSets = numel(xs);


if fixOffsetToZero
	offsetParameters = [];
else
	offsetParameters = zeros(2*numDataSets, 1);
end

if singleExponent
	nu = nuOrGuessAlpha;
else
	guessAlpha = nuOrGuessAlpha;
end



if bootstrapSamples == 0
%WITHOUT BOOTSTRAPPING

	if singleExponent
		[p, quality, nev] = minimize("overlapQualityWrapperSingleExponent", {[guessBeta; offsetParameters], nu, Ns, xs, ys, dys}, 'ftol', eps, 'utol', eps);
		beta = p(1);
		p = [nu/thisBeta; p]
	else
		[p, quality, nev] = minimize("overlapQualityWrapperOffsets", {[guessAlpha; guessBeta; offsetParameters], Ns, xs, ys, dys}, 'ftol', eps, 'utol', eps);
	end

	if fixOffsetToZero
		xOffsetsErr = []; yOffsets = [];
	else
		xOffsets = p(3 : 2 + numDataSets);
		yOffsets = p(3 + numDataSets : 2 + 2*numDataSets);
	end

	alpha = p(1);
	beta = p(2);


else
%WITH BOOTSTRAPPING

	[meanYs, errYs] = meanOfSamples(ys);
	if singleExponent
		[p, quality, nev] = minimize("overlapQualityWrapperSingleExponent", {[guessBeta; offsetParameters], nu, Ns, xs, meanYs, errYs}, 'ftol', eps, 'utol', eps);
		thisBeta = p(1);
		p = [nu/thisBeta; p]
	else
		[p, quality, nev] = minimize("overlapQualityWrapperOffsets", {[guessAlpha; guessBeta; offsetParameters], Ns, xs, meanYs, errYs}, 'ftol', eps, 'utol', eps);
	end

	if fixOffsetToZero
		xOffsets = []; yOffsets = [];
	else
		xOffsets = p(3 : 2 + numDataSets);
		yOffsets = p(3 + numDataSets : 2 + 2*numDataSets);
	end

	alpha = p(1);
	beta = p(2);


	% Resample for error
	alphas = zeros(bootstrapSamples, 1);
	betas = zeros(bootstrapSamples, 1);
	xOffsetss = zeros(bootstrapSamples, numel(xOffsets));
	yOffsetss = zeros(bootstrapSamples, numel(yOffsets));
	quals = zeros(bootstrapSamples, 1);
	moreWasOn = page_screen_output;
	more off;
	for s = 1:bootstrapSamples
		printf("Bootstrap sample %d of %d\n", s, bootstrapSamples);
		[meanYs, errYs] = bootstrapSampleMeans(ys);
		if singleExponent
			[p, qual, nev] = minimize("overlapQualityWrapperSingleExponent", {[guessBeta; offsetParameters], nu, Ns, xs, meanYs, errYs}, 'ftol', eps, 'utol', eps);
			thisBeta = p(1);
			p = [nu/thisBeta; p]
		else
			[p, qual, nev] = minimize("overlapQualityWrapperOffsets", {[alpha; beta; offsetParameters], Ns, xs, meanYs, errYs}, 'ftol', eps, 'utol', eps);
		end
		alphas(s) = p(1);
		betas(s) = p(2);
		if not(fixOffsetToZero)
			xOffsetss(s, :) = p(3 : 2 + numDataSets);
			yOffsetss(s, :) = p(3 + numDataSets : 2 + 2*numDataSets);
		end
		quals(s) = qual;
	end
	printf("\n");
	if moreWasOn
		more on;
	end

	alphaErr = std(alphas);
	betaErr = std(betas);
	if not(fixOffsetToZero)
		xOffsetsErr = std(xOffsetss)';
		yOffsetsErr = std(yOffsetss)';
	end

	% standard deviation of standard deviation
	% http://stats.stackexchange.com/questions/631/standard-deviation-of-standard-deviation
	n = bootstrapSamples;
	stdOfStdFactor = gamma((n-1)/2)/gamma(n/2) * sqrt((n-1)/2 - (gamma(n/2)/gamma((n-1)/2))^2) % relative error of the error estimate!
end
