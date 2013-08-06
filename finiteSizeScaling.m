% Finite size scaling:
% y = x^alpha * F(x / N^beta)
%
% INPUT ARGUMENTS:
% opt: a structure that holds optional control arguments.
%      Depending on whether opt.bootstrapSamples is provided (and > 0) or 
%      not, the remaining input arguments are:
%
%      Input without bootstrapSamples:
%      Ns: 1D array of system sizes
%      xs:  cell where the i'th element is a 1D array of x values for system size Ns(i)
%      ys:  cell where the i'th element is a 1D array of y values for system size Ns(i)
%      dys: cell where the i'th element is a 1D array of errors on y values for system size Ns(i)
%
%      Input with bootstrapSamples:
%      Ns: 1D array of system sizes
%      xs:  cell where the i'th element is a 1D array of x values for system size Ns(i)
%      ys:  cell where the i'th element is a 2D array of y values for system size Ns(i), each row is one run
%      dys: ignored (errors get calculated from the full ys data sets)
%
% Furtheromre, the 'opt' variable is a struct that can contain the 
% following additional fields (for default values, check the code :P):
%    loglog:           Determine the quality of the collapse based on a 
%                      loglog plot (if true) or a linear plot (if false)
%    fixOffsetToZero:  don't fit an offset, fix it to zero
%    fixOffsetToZero:  Bool: fit without or with extra x,y offsets
%    delta:            Used if singleExponent == true, then alpha = delta/beta.
%                      If squaredDeviation is active, then alpha = 2*delta/beta.
%    squaredDeviation: Take squared deviation of the data samples?
%
%    ... TODO DOCUMENT FURTHER
%
%
% OUTPUT ARGUMENTS:
% opt: The options thet were used in the calculation. These are the 
%      provided options, supplemented with default values.
%
%    ... TODO DOCUMENT FURTHER
%
%
% function [exponentsAndOffsets, quality, exponentsAndOffsetsErr, qualityErr, opt] = finiteSizeScaling(Ns, xs, ys, dys, opt, plotopt)
function [exponentsAndOffsets, quality, exponentsAndOffsetsErr, qualityErr, opt] = finiteSizeScaling(Ns, xs, ys, dys, opt, plotopt)

if nargin < 5; opt = struct(); end
if nargin < 6; plotopt = struct(); end
if not(isstruct(opt)); error 'The optional arguments should be contained in a structure!'; end

% Define default values for the optional variables
def.delta = 1;
def.guessAlpha = 1;
def.guessAlpha2 = 1;
def.guessBeta = 1;
def.guessEta = 1;
def.guessCrossoverTime1 = -10;
def.fixOffsetToZero = false;
def.singleExponent = false;
def.squaredDeviation = false;
def.twoTimescales = false;
def.rescaleWithSize = false;
def.loglog = true;
def.simulatedAnnealing = false;
def.eps = 1e-6;
def.bootstrapSamples = 0;
%def.SAnt = 100; % iterations between temperature reductions (e.g. 20)
%def.SAns = 25; % iterations between bounds adjustments (e.g. 5)
%def.SArt = 0.95; % temperature reduction factor
def.SAnt = 20; % iterations between temperature reductions (e.g. 20)
def.SAns = 10; % iterations between bounds adjustments (e.g. 5)
def.SArt = 0.5; % temperature reduction factor

% Overwrite the defaults with the provided options
newOpt = def;
for [value, name] = opt
	newOpt.(name) = value;
end
opt = newOpt;

% Extract the struct contents to regular local variables.
%structToVars(opt) % TODO this is potentially dangerous!!!!!!
delta = opt.delta;
guessAlpha = opt.guessAlpha;
guessAlpha2 = opt.guessAlpha2;
guessBeta = opt.guessBeta;
guessEta = opt.guessEta;
guessCrossoverTime1 = opt.guessCrossoverTime1;
fixOffsetToZero = opt.fixOffsetToZero;
singleExponent = opt.singleExponent;
squaredDeviation = opt.squaredDeviation;
twoTimescales = opt.twoTimescales;
rescaleWithSize = opt.rescaleWithSize;
loglog = opt.loglog;
simulatedAnnealing = opt.simulatedAnnealing;
eps = opt.eps;
bootstrapSamples = opt.bootstrapSamples;
SAnt = opt.SAnt;
SAns = opt.SAns;
SArt = opt.SArt;


% Store some extra info in 'opt' for when we return it and archive it later on in the chain.
opt.Ns = Ns;


if rescaleWithSize
	if twoTimescales
		error 'rescale with size and 2 timescales not yet implemented'
	else
		scalingFunction = @finiteSizeRescaleWithSize;
	end
else
	if twoTimescales
		scalingFunction = @finiteSizeRescaleWithTwoTimes;
	else
		scalingFunction = @finiteSizeRescaleWithTime;
	end
end




numDataSets = numel(xs);

if fixOffsetToZero
	offsetParameters = [];
else
	offsetParameters = zeros(2*numDataSets, 1);
end

if singleExponent % making sure we error down below if we do something wrong
	guessAlpha = nan;
else
	delta = nan;
end

if squaredDeviation; delta = 2*delta; end






if bootstrapSamples == 0
	%WITHOUT BOOTSTRAPPING

	if singleExponent
		func = 'overlapQualityWrapperSingleExponent';
		args = {[guessBeta; offsetParameters], ...
				scalingFunction, delta, Ns, xs, ys, dys, loglog};
		wrappedFunc = @(x) (feval(func, x, args{2}, args{3}, args{4}, args{5}, args{6}, args{7}, args{8}));
	elseif twoTimescales
        	func = 'overlapQualityWrapper';
		args = {[guessAlpha; guessAlpha2; guessEta; guessCrossoverTime1; guessBeta; offsetParameters], ...
				scalingFunction, Ns, xs, ys, dys, loglog};
		wrappedFunc = @(x) (feval(func, x, args{2}, args{3}, args{4}, args{5}, args{6}, args{7}));
	else
		func = 'overlapQualityWrapper';
		args = {[guessAlpha; guessBeta; offsetParameters], ...
				scalingFunction, Ns, xs, ys, dys, loglog};
		wrappedFunc = @(x) (feval(func, x, args{2}, args{3}, args{4}, args{5}, args{6}, args{7}));
	end

	%TODO DEBUG TESTING
	%finiteSizeCollapse([0.688746; 0.050032; 1.057242; -9.768953; 1.541707], scalingFunction, Ns, xs, ys, dys);
	%return

	if simulatedAnnealing
		maxevals = 1e12;
		neps = 5; % number of values final result is compared to to determine convergence
		functol = 1e-2; % required tolerance level for function value comparisons
		paramtol = 2e-3; % required tolerance level for parameters
		verbosity = 2; % 0: no screen output, 1: final results, 2: summary every temperature change
		minarg = 1; % number of the argument-to-be-minimized

			% TODO QUICK HACK:
			%bounds = [args{1} * 10, args{1} / 10]
			%lowerBound = min(bounds')';
			%upperBound = max(bounds')';
			%
			%% EXTRA HACK om exponenten symmetrisch rond nul te hebben (i.e. ook negatief)
			%% TODO TODO TODO hardcoded for 2times
			%% TODO TODO TODO hardcoded for 2times
			%% TODO TODO TODO hardcoded for 2times
			%% TODO TODO TODO hardcoded for 2times
			%%lowerBound(1) = -upperBound(1);
			%%lowerBound(2) = -upperBound(2);
			%% TODO TODO TODO hardcoded for 2times
			%% TODO TODO TODO hardcoded for 2times
			%% TODO TODO TODO hardcoded for 2times
			%% TODO TODO TODO hardcoded for 2times
			%% TODO TODO TODO hardcoded for 2times


			%% rescale for a system with
			%%    y = (t^alpha1 + c*t^alpha2)/(1+c) F(t/N^beta)
			%% where
			%%    c = t_x^(alpha1 - alpha2)
			%% with t_x the crossover time, scaling with exponent eta:
			%%    t_x = t_x1 * N^eta
			%% where t_x1 is the crossover time for N=1.
			%%
			%% alpha1 = exponentsAndOffsets(1);
			%% alpha2 = exponentsAndOffsets(2);
			%% eta = exponentsAndOffsets(3);
			%% crossoverTime1 = 10^(exponentsAndOffsets(4));
			%% beta = exponentsAndOffsets(5);
			%bounds = [-1, 1;
			%          0.01, 2;
			%	  0.01, 2;
			%	  -14, -9;
			%	  1.0, 2.2];
			%lowerBound = bounds(:,1)
			%upperBound = bounds(:,2)
			%args{1}

			% Hardcoded for positive exponents only!
			lowerBound = 0 * ones(size(args{1}))
			upperBound = 30 * ones(size(args{1}))


		% XXX
		% get fast estimate from local descent to compare
		noSaOpt = opt;
		noSaOpt.simulatedAnnealing = false;
		[pLoc, qualLoc] = finiteSizeScaling(Ns, xs, ys, dys, noSaOpt, plotopt)

			
		control = { lowerBound, upperBound, SAnt, SAns, SArt, maxevals, neps, functol, paramtol, verbosity, minarg};
# do sa
		t = cputime();
		[p, quality, convergence, details] = samin(func, args, control);
		t = cputime() - t;
		details
		printf('Samin elapsed time = %f\n',t);
		printf('Samin (Q = %f):\n', quality);
		p
		printf('Local (Q = %f):\n', qualLoc);
		pLoc
		if convergence != 1
			error "samin: bad convergence!"
		end
	else
		%[p, quality, nev] = minimize(func, args, 'ftol', eps, 'utol', eps);
		[p, quality, nev] = nelder_mead_min(func, args, 'ftol', eps, 'utol', eps, 'isz', 2, 'rst', 10);
%
%        		% TODO QUICK HACK:
%			factor = 5
%        		bounds = [args{1} * factor, args{1} / factor]
%        		lowerBound = min(bounds')'
%        		upperBound = max(bounds')'
%
%        	control.XVmin = lowerBound';
%        	control.XVmax = upperBound';
%        	control.constr = false;
%        	control.CR = 0.95;
%        	control.NP = 20*numel(args{1});
%        	[p, quality, nev, convergence] = de_min(wrappedFunc, control)
%        	p = p(:);
	end

	exponentsAndOffsets = p
	exponentsAndOffsetsErr = nan;
	qualityErr = nan;

else
	%WITH BOOTSTRAPPING
	
	% Determine fit for all data before resampling for error
	if squaredDeviation
		[meanYs, errYs, xs] = squaredMeanDeviation(ys, xs); % NOTE, this changes xs to a 'mean squared mode'!
	else
		[meanYs, errYs] = meanOfSamples(ys);
	end
	% recursive call with bootstrapSamples = 0
	newOpt = opt;
	newOpt.bootstrapSamples = 0;
	[exponentsAndOffsets, quality] = finiteSizeScaling(Ns, xs, meanYs, errYs, newOpt, plotopt);

	% TODO this shouldn't have to be here explicitly -- wrap things up some more to avoid duplication
	if singleExponent
		% HACK
		beta = exponentsAndOffsets;
		if rescaleWithSize
			finiteSizeCollapse([delta; beta], scalingFunction, Ns, xs, meanYs, errYs)
		else
			finiteSizeCollapse([delta/beta; beta], scalingFunction, Ns, xs, meanYs, errYs)
		end
	else
		finiteSizeCollapse(exponentsAndOffsets, scalingFunction, Ns, xs, meanYs, errYs)
	end
	sleep(1);



	% Useful if you want to temporarily disable bootstrapping, but you 
	% want to keep feeding in 2D arrays with the data of all runs.
	if bootstrapSamples < 0
		exponentsAndOffsetsErr = nan
		qualityErr = nan
		return
	end



	% Resample for error
	ps = zeros(bootstrapSamples, numel(exponentsAndOffsets));
	quals = zeros(bootstrapSamples, 1);
	moreWasOn = page_screen_output;
	more off;
	for s = 1:bootstrapSamples
		printf('Bootstrap sample %d of %d\n', s, bootstrapSamples);

		if squaredDeviation
			[meanYs, errYs] = bootstrapSampleSquaredDeviation(ys); %xs already were adjusted above
		else
			[meanYs, errYs] = bootstrapSampleMean(ys);
		end

		% recursive call with bootstrapSamples = 0
		[thisp, qual] = finiteSizeScaling(Ns, xs, meanYs, errYs, newOpt, plotopt);

		ps(s, :) = thisp';
		quals(s) = qual;
	end
	printf('\n');
	if moreWasOn
		more on;
	end

	exponentsAndOffsetsErr = std(ps, 0, 1);
	qualityErr = std(quals);

	% standard deviation of standard deviation
	% http://stats.stackexchange.com/questions/631/standard-deviation-of-standard-deviation
	n = bootstrapSamples;
	stdOfStdFactor = gamma((n-1)/2)/gamma(n/2) * sqrt((n-1)/2 - (gamma(n/2)/gamma((n-1)/2))^2) % relative error of the error estimate!



	if not(isempty(plotopt))
		% Determine fit for all data before resampling for error
		if squaredDeviation
			[meanYs, errYs] = squaredMeanDeviation(ys);
		else
			[meanYs, errYs] = meanOfSamples(ys);
		end
		makeFiniteSizeCollapsePlot(exponentsAndOffsets, exponentsAndOffsetsErr, quality, qualityErr, scalingFunction, Ns, xs, meanYs, errYs, opt, plotopt)
	end

end

