% The improved Euler's Method, two evaluations per time step
function [t,y] = IEM(f,t0,tN,y0,h)
    t = t0:h:tN;
    y = zeros(length(t), 1)';
    y(1) = y0;
    for i = 1:length(t)-1
        y(i+1) = y(i) + h/2*(f(t(i), y(i)) + f(t(i+1), y(i)+h*f(t(i),y(i))));
    end
end