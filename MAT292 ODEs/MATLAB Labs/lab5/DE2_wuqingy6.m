function [t,y] = DE2_wuqingy6(t0,tN,y0,y1,h, p, q, g)
    % solve y'' + p(t)y' + q(t)y = g(t), y(t0) = y0, y'(to) = y1
    
    % time vector
    t = t0:h:tN;
    
    % initialize y, y'. Note the y' vector is NOT required
    y = zeros(1, length(t));
    yp = zeros(1, length(t));
    
    % initial values
    y(1) = y0;
    yp(1) = y1;
    
    % we need to initialize values for the second time step as well
    % because finding y(i+1) in loop requires y(i-1).
    y(2) = y(1) + yp(1)*h;
    yp(2) = (y(2)-y(1))/h;
    ypp = g(t(1)) - p(t(1))*yp(1) - q(t(1))*y(1);

    for i = 2:length(t)-1        
        y(i+1) = ypp*h^2 + 2*y(i) - y(i-1); % rearrnaging formula for y''
        
        yp(i+1) = (y(i+1) - y(i))/h; % update y' using first difference def'n
        ypp = g(t(i)) - p(t(i))*yp(i) - q(t(i))*y(i); % update y''
    end
end