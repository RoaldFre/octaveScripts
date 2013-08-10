% Performs a linear regression on the 'log-log' of the data.
%
% Here, ys can be a vector, or a matrix. If it is a matrix, then we will 
% treat the columns or rows that have an equal number of elements as the xs 
% vector as bootstrap resamples. (If ys is square, then the samples are 
% taken in the 'direction' of xs --- i.e. columns if xs is a column vector, 
% rows if xs is a row vector). The first sample is assumed to be the true 
% data, without having been bootstrap resampled.
% In the case of ys=matrix, the yerr need not be given: it will be 
% calculated from the bootstrap data.
%
% If xs is also a matrix, then the columns of both are used as bootstrap 
% resamples instead of only the columns of ys.
%
% function [cte, exponent, cteStddev, exponentStddev] = loglogRegression(xs, ys, guessCte, guessExponent, yerr, useYerrForStddev)
function [cte, exponent, cteStddev, exponentStddev] = loglogRegression(xs, ys, guessCte, guessExponent, yerr, useYerrForStddev)

if nargin < 6
	useYerrForStddev = true;
end


if isvector(ys) % no boostrapping
	if not(isvector(xs))
		error "Expected xs to be a vector"
	end

	xs = xs(:);
	ys = ys(:);

	logys = log(ys);
	logxs = log(xs);

	F = [ones(numel(logxs), 1), logxs];
	if (nargin < 5 || isempty(yerr))
		% no yerr given
		[p] = LinearRegressionError(F, logys);
		cteExponent = p(1);
		exponent = p(2);
		cte = exp(cteExponent);
	else
		yerr = yerr(:);
		logysErr = yerr ./ ys;

		[p, pErr] = LinearRegressionError(F, logys, logysErr, useYerrForStddev);
		cteExponent = p(1);
		cteExponentStddev = pErr(1);
		exponent = p(2);
		exponentStddev = pErr(2);

		cte = exp(cteExponent);
		cteStddev = cte * cteExponentStddev;
	end
else % the data has bootstrap resamples
	if isvector(xs)
		% transform xs to a column vector, and ys to corresponding columns
		if isrow(xs)
			xs = xs';
			ys = ys';
		end
		nr = size(ys,1);
		nc = size(ys,2);
		n = numel(xs);
		if not(issquare(ys))
			if nc == n
				ys = ys';
			elseif nr != n
				error "number of samples in xs and ys don't match!"
			end
		end
	else
		if not(isequal(size(xs), size(ys)))
			error "xs and ys have inconsistent sizes for bootstrap resampling of both x and y"
		end
	end

	% compute yerr
	yerr = std(ys, 0, 2);
	
	% compute individual exponents and errors
	numDatasets = size(ys, 2);
	ctes = zeros(1, numDatasets);
	exponents = zeros(1, numDatasets);
	cteErrs = zeros(1, numDatasets);
	exponentErrs = zeros(1, numDatasets);
	for i = 1:numDatasets
		if ismatrix(xs)
			x = xs(:,i);
		else
			x = xs;
		end
		[c, e, ce, ee] = loglogRegression(x, ys(:,i), guessCte, guessExponent, yerr, false);
		ctes(i) = c;
		exponents(i) = e;
		cteErrs(i) = ce;
		exponentErrs(i) = ee;
	end

	% Get optimal error from first data set
	cte = ctes(1);
	exponent = exponents(1);

	% Determine error as the maximum of the error on the fit, and the error from the bootstrap samples
	cteFitErr = cteErrs(1);
	exponentFitErr = exponentErrs(1);
	cteBootstrapErr = std(ctes);
	exponentBootstrapErr = std(exponents);
	cteStddev = max(cteFitErr, cteBootstrapErr);
	exponentStddev = max(exponentFitErr, exponentBootstrapErr);
end



