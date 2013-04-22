% Returns the root mean squared error
function rse = rse(y, f, x, p)

if (ischar(f)) f = str2func(f); end

fx = f(x, p)(:);
rse = norm(y(:) - fx(:));
