% Generates a LaTeX file of the current plot that can be included in a 
% LaTeX document using \input{}.
%
% Parameters (all are STRINGS):
%   name:      Name of the image file (without extension).
%              This will also be the label of the image in LaTeX.
%   caption:   The caption of the image. LaTeX code is allowed.
%   destdir:   Destination directory for the images.
%              e.g. "/home/user/project/latex/images"
%   relImgDir: Relative image directory: directory where the images will be 
%              stored, relative to the directory where the main LaTeX file 
%              is (the file that \input{}s the image files)
%              e.g. "images" (if the main file is in /home/user/project/latex 
%                             and the destdir is chosen like in the example 
%                             above)
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
%
% Dependencies:
%   Octave with -depslatex output for print()
%   epstopdf
function makeGraph(name,caption,destdir,relImgDir,xlab,ylab,ylabrule,width,height);
	%This is such a hack, I don't even want to comment on it.
	caption = strrep(caption, '\', '\\');
	wrapper = [
		'\\begin{figure}[htb]\n',...
		'       \\begin{center}\n',...
		'               \\scalebox{0.9}{\n',...
		'                        \\nonstopmode\n',...
		'                        \\input{',relImgDir,'/',name,'.dat.tex}\n',...
		'                        \\errorstopmode\n',...
		'                        \\rule[-0.5cm]{0cm}{0cm}}\n',...
		'                \\caption{',caption,'}\n',...
		'                \\label{',name,'}\n',...
		'        \\end{center}\n',...
		'\\end{figure}\n'];
	wrapper = strrep(wrapper, '\', '\\');
	wrapper = strrep(wrapper, '$', '\$');

	xlabel(xlab);
	ylabel(['\rule{0pt}{',ylabrule,'}',ylab]);

	system(['mkdir -p ',destdir,' &>/dev/null']);
	print([destdir,'/',name,'.tex'],'-depslatex',['-S',width,',',height]);

	system(['cd ',destdir,'; epstopdf ',name,'.eps; rm ',name,'.eps',...
		"; sed -i 's#",destdir,'#',relImgDir,"#' ", name,".tex"]);

	system(['cd ',destdir,'; ',...
		'mv ',name,'.tex ',name,'.dat.tex; ',...
		'echo -e "',wrapper,'" > ',name,'.tex;']);
end

