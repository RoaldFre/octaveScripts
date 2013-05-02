xs = ones(10,1)*(1:15);
ys = xs.^2;
dys = ys/10;
yse = ys + dys.*randn(size(dys));
xsc={xs(1,:), xs(2,:), xs(3,:)};
ysc={ys(1,:), ys(2,:), ys(3,:)};
ysec={yse(1,:), yse(2,:), yse(3,:)};
dysc={dys(1,:), dys(2,:), dys(3,:)};

overlapQuality(xsc, ysec, dysc)

