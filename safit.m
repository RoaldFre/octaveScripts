% Fitting with simulated annealing rms error minimization
% Depends on the optim package from octave-forge.
function [p, f] = safit(x, y, F, pin, bounds)


if (ischar(F)) F = str2func(F); end

# SA controls
lowerBound = bounds(:,1);
upperBound = bounds(:,2);

nt = 20; % iterations between temperature reductions (e.g. 20)
ns = 10; % iterations between bounds adjustments (e.g. 5)
rt = 0.95; % temperature reduction factor
maxevals = 1e11;
neps = 5; % number of values final result is compared to to determine convergence
functol = 1e-3; % required tolerance level for function value comparisons
paramtol = 1e-3; % required tolerance level for parameters
verbosity = 2; % 0: no screen output, 1: final results, 2: summary every temperature change
minarg = 4; % number of the argument-to-be-minimized
control = { lowerBound, upperBound, nt, ns, rt, maxevals, neps, functol, paramtol, verbosity, minarg};


# do sa
t = cputime();
[p, rse, convergence] = samin('rse', {y, F, x, pin}, control);
f = F(x, p);
t = cputime() - t;
printf("Elapsed time = %f\n\n\n",t);

if convergence == 0
	error "safit: No convergence!"
elseif convergence == 2
	warning "safit: Converged to value close to bounds! Suggest loosening bounds!"
elseif convergence != 1
	error "safit: Unknown convergence code from samin"
end
