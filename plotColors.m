% Returns a modified jet(n) that is more print-friendly (No very dark 
% colors, and no very light colors).
function colors = plotColors(n)

colors = jet(n)*0.7 + 0.15;

