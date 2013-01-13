function y=roundsd(x,n)
%ROUNDSD Round with fixed significant digits
%   ROUNDSD(X,N) rounds the elements of X towards the nearest number with
%	N significant digits.
%
%	Examples:
%		roundsd(0.012345,3) returns 0.0123
%		roundsd(12345,2) returns 12000
%
%	See also Matlab's function ROUND.
%
%	Author: François Beauducel <beauducel@ipgp.fr>
%	  Institut de Physique du Globe de Paris
%   Created: 2009-01-16

%	Copyright (c) 2009, François Beauducel, covered by BSD License.
%	All rights reserved.
%
%	Redistribution and use in source and binary forms, with or without 
%	modification, are permitted provided that the following conditions are 
%	met:
%
%	   * Redistributions of source code must retain the above copyright 
%	     notice, this list of conditions and the following disclaimer.
%	   * Redistributions in binary form must reproduce the above copyright 
%	     notice, this list of conditions and the following disclaimer in 
%	     the documentation and/or other materials provided with the distribution
%	                           
%	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%	ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%	LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%	POSSIBILITY OF SUCH DAMAGE.

error(nargchk(2,2,nargin))

if ~isnumeric(x)
		error('X argument must be numeric.')
end

if ~isnumeric(n) | numel(n) ~= 1 | n < 0 | mod(n,1) ~= 0
	error('N argument must be a scalar positive integer.')
end

og = 10.^(floor(log10(abs(x)) - n + 1));
y = round(x./og).*og;
