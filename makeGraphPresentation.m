% Generates a stand-alone pdf file of the current plot, with all the LaTeX 
% goodies.
%
% Dependencies:
%   Octave with -depslatexstandalone output for print()
%   epstopdf
%   pdflatex
%   pdfcrop
function makeGraphPresentation(name,destdir,xlab,ylab,ylabrule,width,height);
	relImgDir = '.';
	xlabel(xlab);
	ylabel(['\rule{0pt}{',ylabrule,'}',ylab]);

	print([destdir,'/',name,'.tex'],'-depslatexstandalone',['-S',width,',',height]);

	% So much hacks...
	% Need to use a huge margin and crop later to prevent cropping of the labels
	system(['cd ',destdir,'; ',...
		'epstopdf ',name,'-inc.eps; rm ',name,'-inc.eps; ',...
		"sed -i 's#",destdir,'#',relImgDir,"#' ", name,".tex; ",...
		"sed -i 's#\\\\usepackage\\[papersize.*{geometry}#\\\\usepackage[papersize={120cm,120cm},text={100cm,100cm},margin=10cm]{geometry}#' ", name,".tex; ",...
		]);

	system(['cd ',destdir,'; ',...
		'pdflatex -interaction batchmode ',name,'.tex; ',...
		'pdfcrop ',name,'.pdf; ',...
		'mv ',name,'-crop.pdf ',name,'.pdf; ',...
		'rm ',name,'.tex ',name,'-inc.pdf ',name,'.log ',name,'.aux; ',...
		]);
end
