function resultFile = finiteSizeScalingFilename(resultFilePrefix, opt)

if opt.simulatedAnnealing
	SAsuffix = sprintf('_nt%d_ns%d_rt%.3f',opt.SAnt,opt.SAns,opt.SArt);
else
	SAsuffix = '';
end

if opt.rescaleWithSize
	rescaling = 'withSize';
else
	rescaling = 'withTime';
end

resultFile = [resultFilePrefix,'_',rescaling,'_singexp',num2str(opt.singleExponent),'_2times',num2str(opt.twoTimescales),'_sqdev',num2str(opt.squaredDeviation),'_loglog',num2str(opt.loglog),'_SA',num2str(opt.simulatedAnnealing),SAsuffix];


