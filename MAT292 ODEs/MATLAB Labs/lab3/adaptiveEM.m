function [t,y] = adaptiveEM(f,t0,tN,y0,h)
    t = [];
    y = [];
    y(1) = y0;
    t(1) = t0;
    i = 1;
    while t(i) < tN
        Y = y(i) + h/2*(f(t(i), y(i)) + f(t(i)+h, y(i)+h*f(t(i),y(i))));
        
        Z_half = y(i) + h/4*(f(t(i), y(i)) + f(t(i)+h, y(i)+h*f(t(i),y(i))));
        Z = Z_half + h/4*(f(t(i)+h,Z_half) + f(t(i)+2*h, Z_half + h/2*f(t(i)+2*h,Z_half)));
        tol = 1e-8;
        D = Z-Y;
        
        if abs(D) < tol
            y(i+1) = Z-D; % local error O(h^3)
            t(i+1) = t(i)+h;
            i = i + 1;
        else
           h = 0.9*h*min(max(tol/abs(D),0.3),2);
        end    
    end
end