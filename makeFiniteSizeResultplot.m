function makeFiniteSizeResultplot(clustNs, clustPs, clustPErrs, quals, qualErrs, opt, plotopt, meanStartN)

if nargin < 7; meanStartN = 0; end;

destDir = plotopt.destDir;
relImgDir = plotopt.relImgDir;
graphFilePrefix = [plotopt.graphFilePrefix,'_results'];
resultFilePrefix = plotopt.resultFilePrefix;
T = plotopt.T;
measurement = plotopt.measurement;
quantity = plotopt.quantity;
delta = plotopt.delta;

graphFile = finiteSizeScalingFilename(graphFilePrefix, opt);
ylabrule  = '-1.5cm';
width     = '900';
height    = '1200';


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

clf;
subplot(2,1,1)
[params, paramErrs] = finiteSizeResultplot(clustNs, clustPs, clustPErrs, meanStartN, parameterLabels)
ylabel(['\rule{0pt}{',ylabrule,'}parameter']);
xlabel('$N$')
subplot(2,1,2)
[qual, qualErr] = finiteSizeResultplot(clustNs, quals, qualErrs, meanStartN, '$Q$')
ylabel(['\rule{0pt}{',ylabrule,'}$Q$']);
xlabel('$N$')

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

Ns = opt.Ns;
NsStr = '';
for N = Ns
	NsStr = [NsStr,num2str(N),'.'];
end
NsStr = NsStr(1:end-1);

NsStrh = '';
for N = Ns
	NsStrh = [NsStrh, num2str(N),', '];
end
NsStrh = NsStrh(1:end-2);

clustNsStr = '';
clustNs
for i = 1:numel(clustNs)
	N = clustNs(i)
	clustNsStr = sprintf("%s%f.",clustNsStr,N);
end
clustNsStr = clustNsStr(1:end-1);




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
scalingForm = sprintf('%s = %s F(t/N^\\beta)', observable, infiniteSizeScaling);

if opt.singleExponent
	parameterStr = 'Parameter $\beta$';
	parameterNames = {'\beta'};
	parameterValues = sprintf('$\\beta = %s$', numErr2tex(params(1), paramErrs(1)));
elseif opt.twoTimescales
	error 'twoTimescales not yet implemented'
else
	% two separate exponents
	if opt.rescaleWithSize
		parameterNames = {'\delta','\beta'};
		parameterStr = 'Parameters $\delta$ and $\beta$';
		parameterValues = sprintf('$\\delta = %s$, $\\beta = %s$',
					numErr2tex(params(1), paramErrs(1)),
					numErr2tex(params(2), paramErrs(2)));
	else
		parameterNames = {'\alpha','\beta'};
		parameterStr = 'Parameters $\alpha$ and $\beta$';
		parameterValues = sprintf('$\\alpha = %s$, $\\beta = %s$',
					numErr2tex(params(1), paramErrs(1)),
					numErr2tex(params(2), paramErrs(2)));
	end
end

caption = sprintf('%s (top) and collapse qualities (bottom) for %s %s from fitting the scaling law $%s$. Fitting was performed in clusters of size %d on data of lengths $N = %s$ at a temperature of $T = %d^\\circ$C. The combined result %s is %s with quality $Q = %s$. Combined results are plotted as a horizontal line together with their error bar.', parameterStr, sqDevStr, measurement, scalingForm, clusterSize, NsStrh, T, meanStartNote, parameterValues, numErr2tex(qual, qualErr));

resultFile = finiteSizeScalingFilename([resultFilePrefix,'_result',NsStr,'meanStartN',num2str(meanStartN)], opt);

save('-b', '-z', [resultFile,'_raw'], 'clustNs', 'clustPs', 'clustPErrs', 'quals', 'qualErrs', 'opt', 'plotopt', 'meanStartN');

f = fopen(resultFile, 'w');
fprintf(f, 'observable:%s\n', observable);
fprintf(f, 'scalingForm:%s\n', scalingForm);
fprintf(f, 'theoreticalDelta:%s\n', delta);
fprintf(f, 'numParams:%d\n', numel(params));
for i = 1:numel(params)
	fprintf(f, '%s:%s\n', parameterNames{i}, numErr2tex(params(i), paramErrs(i)));
end
for i = 1:numel(params)
	fprintf(f, '1/%s:%s\n', parameterNames{i}, numErr2tex(1/params(i), paramErrs(i)/params(i)^2));
end
fprintf(f, 'qual:%s\n', numErr2tex(qual, qualErr));
fprintf(f, 'T:%d\n', T);
fprintf(f, 'Ns:%s\n', NsStr);

%Individual cluster results:
fprintf(f, 'clustersize:%d\n', clusterSize);
fprintf(f, 'numClust:%d\n', numel(clustNs));
fprintf(f, 'clustNs:%s\n', clustNsStr);
for i = 1:numel(clustNs)
	N = clustNs(i);
	for p = 1:numel(params)
		fprintf(f, 'clustN%f:%s:%s\n', N, parameterNames{p}, numErr2tex(clustPs(i,p), clustPErrs(i,p)));
	end
	for p = 1:numel(params)
		fprintf(f, 'clustN%f:1/%s:%s\n', N, parameterNames{p}, numErr2tex(1/clustPs(i,p), clustPErrs(i,p)/clustPs(i,p)^2));
	end
	fprintf(f, 'clustN%f:qual:%s\n', N, numErr2tex(quals(i), qualErrs(i)));
end
fclose(f);

makeGraph(graphFile,caption,destDir,relImgDir,'','',ylabrule,width,height);
