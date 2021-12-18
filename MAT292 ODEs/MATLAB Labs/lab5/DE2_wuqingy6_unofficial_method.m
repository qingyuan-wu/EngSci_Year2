function [t,y] = DE2_wuqingy6_unofficial_method(t0,tN,y0,y1,h, p, q, g)
    % solve y'' + p(t)y' + q(t)y = g(t), y(t0) = y0, y'(to) = y1
    t = t0:h:tN;
    y = zeros(1, length(t));
    yp = zeros(1, length(t));
    
    y(1) = y0;
    yp(1) = y1;
    ypp = g(t(1)) - p(t(1))*yp(1) - q(t(1))*y(1);
    for i = 1:length(t)-1
        y(i+1) = y(i) + yp(i)*h;
        yp(i+1) = yp(i) + ypp*h;
        ypp = g(t(i+1)) - p(t(i+1))*yp(i+1) - q(t(i+1))*y(i+1);
    end
end