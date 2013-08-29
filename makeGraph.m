% Generates a LaTeX file of the current plot that can be included in a 
% LaTeX document using \input{}.
%
% Parameters (all are STRINGS):
%   name:       Name of the image file (without extension).
%               This will also be the label of the image in LaTeX.
%   caption:    The caption of the image. LaTeX code is allowed.
%   destdir:    Destination directory for the images.
%               e.g. "/home/user/project/latex/images"
%   relImgDir:  Relative image directory: directory where the images will be 
%               stored, relative to the directory where the main LaTeX file 
%               is (the file that \input{}s the image files)
%               e.g. "images" (if the main file is in /home/user/project/latex 
%                              and the destdir is chosen like in the example 
%                              above)
%   xlab:       label for x axis. LaTeX code allowed.
%   ylab:       label for y axis. LaTeX code allowed.
%   ylabrule:   Ruler size to move the y label closer or further away. You'll 
%               have to tweak this a bit to get it looking OK.
%               e.g. "-1.5cm"
%   width:      Determines the horizontal size of the image in points
%               e.g. "1000"
%   height:     Determines the vertical size of the image in points
%               e.g. "800"
%   altCaption: Optional. You need to set this if doing fancy things in the 
%               caption (such as multiple, tabulars, etc). What you give 
%               here will be what is displayed in the list of figures.
%
% Dependencies:
%   Octave with -depslatex output for print()
%   epstopdf
function makeGraph(name,caption,destdir,relImgDir,xlab,ylab,ylabrule,width,height,altCaption);

	if exist('altCaption')
		altCaptionStr = ['[',altCaption,']'];
	else
		altCaptionStr = '';
	end

	%This is such a hack, I don't even want to comment on it.
	caption = strrep(caption, '\', '\\');
	wrapper = [
		'\\begin{figure}[htbp]\n',...
		'       \\begin{center}\n',...
		'               \\scalebox{0.9}{\n',...
		'                        \\nonstopmode\n',...
		'                        \\input{',relImgDir,'/',name,'.dat.tex}\n',...
		'                        \\errorstopmode\n',...
		'                        \\rule[-0.5cm]{0cm}{0cm}}\n',...
		'                \\caption',altCaptionStr,'{',caption,'}\n',...
		'                \\label{',name,'}\n',...
		'        \\end{center}\n',...
		'\\end{figure}\n'];
	wrapper = strrep(wrapper, '\', '\\');
	wrapper = strrep(wrapper, '$', '\$');

	if (numel(xlab) != 0) % not the empty string ''
		xlabel(xlab);
	end
	if (numel(ylab) != 0) % not the empty string ''
		ylabel(['\rule{0pt}{',ylabrule,'}',ylab]);
	end

	system(['mkdir -p ',destdir,' &>/dev/null']);
	print([destdir,'/',name,'.tex'],'-depslatex',['-S',width,',',height]);

	system(['cd ',destdir,'; epstopdf ',name,'.eps; rm ',name,'.eps',...
		"; sed -i 's#includegraphics\\(.*\\)",destdir,'#includegraphics[type=pdf,ext=.pdf,read=.pdf]\1',relImgDir,"#' ",name,".tex"]);

	system(['cd ',destdir,'; ',...
		'mv ',name,'.tex ',name,'.dat.tex; ',...
		'echo "',wrapper,'" > ',name,'.tex;']);
		%'echo -e "',wrapper,'" > ',name,'.tex;']);
end

