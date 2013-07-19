% Writes a graph of the plot of the collapsed function
%
% Input: see finiteSizeCollapse, with addition of:
%    paramErrs: the errors on the fitted parameters
%    measurement: string describing the measured observable
%    quantity: symbol of the measured observable
%    delta: in the case of a single exponent fit: this is the 'delta' exponent (number or string)
function makeFiniteSizeCollapsePlot(params, paramErrs, quality, qualityErr, scalingFunction, Ns, xs, ys, dys, opt, plotopt)

if isempty(plotopt)
	error "plotopt is empty!"
end

destDir = plotopt.destDir;
relImgDir = plotopt.relImgDir;
graphFilePrefix = plotopt.graphFilePrefix;
T = plotopt.T;
measurement = plotopt.measurement;
quantity = plotopt.quantity;
delta = plotopt.delta;

clf;
% TODO this shouldn't have to be here explicitly -- wrap things up some more to avoid duplication
if opt.singleExponent
	% HACK
	beta = params(1);
	if opt.rescaleWithSize
		finiteSizeCollapse([opt.delta; beta], scalingFunction, Ns, xs, ys, dys)
	else
		finiteSizeCollapse([opt.delta/beta; beta], scalingFunction, Ns, xs, ys, dys)
	end
else
	finiteSizeCollapse(params, scalingFunction, Ns, xs, ys, dys)
end


if opt.squaredDeviation
	if not(ischar(delta))
		delta = num2str(2*delta)
	else
		delta = sprintf('2 %s', delta);
	end
	sqDevStr = 'the squared deviation of'
	observable = sprintf('\\sqdif{%s(t,N)}', quantity);
else
	if not(ischar(delta))
		delta = num2str(delta)
	end
	sqDevStr = ''
	observable = sprintf('\\expect{%s(t,N)}', quantity);
end

if not(opt.fixOffsetToZero)
	error 'offsets not yet implemented'
end


%scalingForm
if opt.rescaleWithSize
	if opt.singleExponent
		infiniteSizeScaling = sprintf('N^{%s}', delta);;
		parameters = sprintf('$\\beta = %s$', numErr2tex(params(1), paramErrs(1)));
	elseif opt.twoTimescales
		error 'twoTimescales not yet implemented for rescale with size'
	else
		% two separate exponents
		infiniteSizeScaling = 'N^{\delta}';
		parameters = sprintf('$\\delta = %s$, $\\beta = %s$',
				numErr2tex(params(1), paramErrs(1)),
				numErr2tex(params(2), paramErrs(2)));
	end
else 
	% rescale with time
	if opt.singleExponent
		infiniteSizeScaling = sprintf('t^{%s/\\beta}', delta);
		parameters = sprintf('$\\beta = %s$', numErr2tex(params(1), paramErrs(1)));
	elseif opt.twoTimescales
		error 'twoTimescales not yet implemented'
	else
		% two separate exponents
		infiniteSizeScaling = 't^{\alpha}';
		parameters = sprintf('$\\alpha = %s$, $\\beta = %s$',
				numErr2tex(params(1), paramErrs(1)),
				numErr2tex(params(2), paramErrs(2)));
	end
end
scalingForm = sprintf('$%s = %s F(t/N^\\beta)$', observable, infiniteSizeScaling);


caption = sprintf('Collapse of the scaling function for the measurement of %s %s $%s$ at temperature $T = %d^\\circ$C for a scaling of the form %s, with (fitted) parameter values %s. The quality of the collapse is $Q = %s$.', sqDevStr, measurement, quantity, T, scalingForm, parameters, numErr2tex(quality, qualityErr));

NsStr = '';
for N = Ns
	NsStr = [NsStr,num2str(N),'.'];
end
NsStr = NsStr(1:end-1);

graphFile = finiteSizeScalingFilename([graphFilePrefix,'_collap',NsStr], opt);
ylabrule  = '-1.5cm';
xlab      = '$t/N^\beta$ (s)'
ylab      = ['$',observable,'/',infiniteSizeScaling,'$'];
width     = '1000';
height    = '800';

makeGraph(graphFile,caption,destDir,relImgDir,xlab,ylab,ylabrule,width,height);
