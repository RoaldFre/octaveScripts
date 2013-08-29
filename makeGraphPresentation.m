% Generates a stand-alone eps file of the current plot, with all the LaTeX 
% goodies.
%
% Parameters (all are STRINGS):
%   name:      Name of the image file (without extension).
%   caption:   The caption of the image. LaTeX code is allowed.
%   destdir:   Destination directory for the images.
%   xlab:      label for x axis. LaTeX code allowed.
%   ylab:      label for y axis. LaTeX code allowed.
%   ylabrule:  Ruler size to move the y label closer or further away. You'll 
%              have to tweak this a bit to get it looking OK.
%              e.g. "-1.5cm"
%   width:     Determines the horizontal size of the image in points
%              e.g. "1000"
%   height:    Determines the vertical size of the image in points
%              e.g. "800"
%
% Dependencies:
%   Octave with -depslatexstandalone output for print()
%   epstopdf
%   pdflatex
%   pdfcrop
function makeGraphPresentation(name,destdir,xlab,ylab,ylabrule,width,height);
	relImgDir = '.';
	if (numel(xlab) != 0) % not the empty string ''
		xlabel(xlab);
	end
	if (numel(ylab) != 0) % not the empty string ''
		ylabel(['\rule{0pt}{',ylabrule,'}',ylab]);
	end

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
		'pdftops -eps ',name,'.pdf ',name,'.eps; rm ',name,'.pdf',...
		]);
		% Comment last line above if you want to output to pdf instead of eps
end
