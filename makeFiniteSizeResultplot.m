function makeFiniteSizeResultplot(clustNs, clustPs, clustPErrs, areQualities, opt, plotopt, meanStartN)

if nargin < 7; meanStartN = 0; end;

destDir = plotopt.destDir;
relImgDir = plotopt.relImgDir;
graphFilePrefix = plotopt.graphFilePrefix;
T = plotopt.T;
measurement = plotopt.measurement;
quantity = plotopt.quantity;
delta = plotopt.delta;

if areQualities
	parameterLabels = '$Q$';
else
	if opt.rescaleWithSize
		if opt.singleExponent
			parameterLabels = '$\beta$';
		elseif opt.twoTimescales
			error 'twoTimescales not yet implemented for rescale with size'
		else
			parameterLabels = {'$\delta$', '$\beta$'};
		end
	else 
		%rescale with time
		if opt.singleExponent
			parameterLabels = '$\beta$';
		elseif opt.twoTimescales
			error 'twoTimescales not yet implemented'
		else
			parameterLabels = {'$\alpha$', '$\beta$'};
		end
	end
end

[params, paramErrs] = finiteSizeResultplot(clustNs, clustPs, clustPErrs, meanStartN, parameterLabels)


xlab = '$N$';
if areQualities
	ylab = '$Q$';
	graphFilePrefix = [graphFilePrefix,'_quals'];
else
	ylab = 'parameter';
	graphFilePrefix = [graphFilePrefix,'_params'];
end

clusterSize = numel(opt.Ns) - numel(clustNs) + 1;

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

NsStr = '';
for N = opt.Ns
	NsStr = [NsStr, num2str(N),', '];
end
NsStr = NsStr(1:end-2);


if meanStartN > 0
	meanStartNote = sprintf('(neglecting clusterpoints with $N < %d$)', meanStartN);
else
	meanStartNote = '';
end

%scalingForm
if opt.rescaleWithSize
	if opt.singleExponent
		infiniteSizeScaling = sprintf('N^{%s}', delta);;
	elseif opt.twoTimescales
		error 'twoTimescales not yet implemented for rescale with size'
	else
		% two separate exponents
		infiniteSizeScaling = 'N^{\delta}';
	end
else 
	% rescale with time
	if opt.singleExponent
		infiniteSizeScaling = sprintf('t^{%s/\\beta}', delta);
	elseif opt.twoTimescales
		error 'twoTimescales not yet implemented'
	else
		% two separate exponents
		infiniteSizeScaling = 't^{\alpha}';
	end
end
scalingForm = sprintf('$%s = %s F(t/N^\\beta)$', observable, infiniteSizeScaling);

if areQualities
	caption = sprintf('Quality of collapse $Q$ for %s %s from fitting the scaling law %s. Fitting was performed in clusters of size %d on data of lengths $N = %s$ at a temperature of $T = %d^\\circ$C. The combined quality %s is $%s$. It is plotted as a horizontal line together with its error bar.', sqDevStr, measurement, scalingForm, clusterSize, NsStr, T, meanStartNote, numErr2tex(params(1), paramErrs(1)));

else
	if opt.singleExponent
		parameters = 'Parameter $\beta$';
		parameterValues = sprintf('$\\beta = %s$', numErr2tex(params(1), paramErrs(1)));
	elseif opt.twoTimescales
		error 'twoTimescales not yet implemented'
	else
		% two separate exponents
		if opt.rescaleWithSize
			parameters = 'Parameters $\delta$ and $\beta$';
			parameterValues = sprintf('$\\delta = %s$, $\\beta = %s$',
						numErr2tex(params(1), paramErrs(1)),
						numErr2tex(params(2), paramErrs(2)));
		else
			parameters = 'Parameters $\alpha$ and $\beta$';
			parameterValues = sprintf('$\\alpha = %s$, $\\beta = %s$',
						numErr2tex(params(1), paramErrs(1)),
						numErr2tex(params(2), paramErrs(2)));
		end
	end

	caption = sprintf('%s for %s %s from fitting the scaling law %s. Fitting was performed in clusters of size %d on data of lengths $N = %s$ at a temperature of $T = %d^\\circ$C. The combined result %s is %s. It is plotted as a horizontal line together with its error bar.', parameters, sqDevStr, measurement, scalingForm, clusterSize, NsStr, T, meanStartNote, parameterValues);
end



graphFile = finiteSizeScalingFilename(graphFilePrefix, opt);
ylabrule  = '-1.5cm';
width     = '1000';
height    = '800';

makeGraph(graphFile,caption,destDir,relImgDir,xlab,ylab,ylabrule,width,height);
