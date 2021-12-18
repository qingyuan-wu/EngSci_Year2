% solves a system of ODEs using the Improved Euler's Method
function [t, x1, x2] = solvesystem_wuqingy6(f, g, t0, tN, x0, h)
   t = t0:h:tN;
   x1 = NaN(1, length(t));
   x2 = NaN(1, length(t));
   x1(1) = x0(1);
   x2(1) = x0(2);
   for i = 2:length(t)     
       x1_temp = x1(i-1) + h*(f(t(i-1),x1(i-1),x2(i-1)));
       x2_temp = x2(i-1) + h*(g(t(i-1),x1(i-1),x2(i-1)));
       
       x1(i) = x1(i-1) + h/2*(f(t(i-1),x1(i-1),x2(i-1)) + f(t(i), x1_temp, x2_temp));
       x2(i) = x2(i-1) + h/2*(g(t(i-1),x1(i-1),x2(i-1)) + g(t(i), x1_temp, x2_temp)); 
   end
end