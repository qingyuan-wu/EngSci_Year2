%% Laplace Transform Lab: Solving ODEs using Laplace Transform in MATLAB
%
% This lab will teach you to solve ODEs using a built in MATLAB Laplace 
% transform function |laplace|.
%
% There are five (5) exercises in this lab that are to be handed in.  
% Write your solutions in a separate file, including appropriate descriptions 
% in each step.
%
% Include your name and student number in the submitted file.
%
%% Student Information
%
%  Student Name: Qingyuan Wu
%
%  Student Number: 1007001664
%

%% Using symbolic variables to define functions
% 
% In this exercise we will use symbolic variables and functions.

syms t s x y % DON'T BE STUPID LIKE ME: CAN'T PUT COMMAS HEREEEEEE

f = cos(t)
h = exp(2*x)


%% Laplace transform and its inverse

% The routine |laplace| computes the Laplace transform of a function

F=laplace(f)

%%
% By default it uses the variable |s| for the Laplace transform
% But we can specify which variable we want:

H=laplace(h)
laplace(h,y)

% Observe that the results are identical: one in the variable |s| and the
% other in the variable |y|

%% 
% We can also specify which variable to use to compute the Laplace
% transform:

j = exp(x*t)
laplace(j) % computing 
laplace(j,x,s)

% By default, MATLAB assumes that the Laplace transform is to be computed
% using the variable |t|, unless we specify that we should use the variable
% |x|

%% 
% We can also use inline functions with |laplace|. When using inline
% functions, we always have to specify the variable of the function.

l = @(t) t^2+t+1
laplace(l(t))

%% 
% MATLAB also has the routine |ilaplace| to compute the inverse Laplace
% transform

ilaplace(F)
ilaplace(H)
ilaplace(laplace(f))

%% 
% If |laplace| cannot compute the Laplace transform, it returns an
% unevaluated call.

g = 1/sqrt(t^2+1)
G = laplace(g)

%% 
% But MATLAB "knows" that it is supposed to be a Laplace transform of a
% function. So if we compute the inverse Laplace transform, we obtain the
% original function

ilaplace(G)

%%
% The Laplace transform of a function is related to the Laplace transform 
% of its derivative:

syms g(t)
laplace(diff(g,t),t,s)


%% Exercise 1
%
% Objective: Compute the Laplace transform and use it to show that MATLAB
% 'knows' some of its properties.
%
% Details:  
%
% (a) Define the function |f(t)=exp(2t)*t^3|, and compute its Laplace
%   transform |F(s)|.
% (b) Find a function |f(t)| such that its Laplace transform is
%   |(s - 1)*(s - 2))/(s*(s + 2)*(s - 3)|
% (c) Show that MATLAB 'knows' that if |F(s)| is the Laplace transform of
%   |f(t)|, then the Laplace transform of |exp(at)f(t)| is |F(s-a)| 
% 
% (in your answer, explain part (c) using comments).      
%
% Observe that MATLAB splits the rational function automatically when
% solving the inverse Laplace transform.

f(t) = exp(2*t)*t^3;
laplace(f) % F(s) = 6/(s-2)^4
F(s) = (s - 1)*(s - 2)/(s*(s + 2)*(s - 3));
ilaplace(F) % f(t) = (6*exp(-2*t))/5 + (2*exp(3*t))/15 - 1/3
clear all;
syms f(t) a s t;
F(s) = laplace(f(t)); % outputs laplace(f(t), t, s)
laplace(exp(a*t)*f(t), t, s) % outputs laplace(f(t), t, s - a) = F(s-a)
% MATLAB knows to take the Laplace transform of f(t), then shift the input
% right by a units (the third output argument is s-a, meaning that whatever
% function we get F(s), the variable we use instead is s-a => F(s-a) is the
% final answer.

%% Heaviside and Dirac functions
%
% These two functions are builtin to MATLAB: |heaviside| is the Heaviside
% function |u_0(t)| at |0|
%
% To define |u_2(t)|, we need to write

f=heaviside(t-2)
ezplot(f,[-1,5])

% The Dirac delta function (at |0|) is also defined with the routine |dirac|

g = dirac(t-3)

% MATLAB "knows" how to compute the Laplace transform of these functions

laplace(f)
laplace(g)


%% Exercise 2
%
% Objective: Find a formula comparing the Laplace transform of a 
%   translation of |f(t)| by |t-a| with the Laplace transform of |f(t)|
%
% Details:  
%
% * Give a value to |a|
% * Let |G(s)| be the Laplace transform of |g(t)=u_a(t)f(t-a)| 
%   and |F(s)| is the Laplace transform of |f(t)|, then find a 
%   formula relating |G(s)| and |F(s)|
%
% In your answer, explain the 'proof' using comments.
clear all;
syms a s f(t) t;
a = 5;
G(s) = laplace(heaviside(t-a)*f(t-a), t, s) % exp(-5*s)*laplace(f(t), t, s) = exp(-as)*F(s)
F(s) = laplace(f(t), t, s) % laplace(f(t), t, s) = F(s)
G(s)/F(s) % exp(-5*s)

% as MATLAB has shown, G(s)/F(s) = exp(-5*s). Rearranging, we get G(s) =
% exp(-5*s)*F(s). Here we chose a = 5, but this works for all a with G(s) =
% exp(-a*s)*F(s). To achieve this result, evaluations for F(s) and G(s)
% were made for any generic f(t), where F and G where formulated according
% to the question definitions. Dividing the two function of s resulted in a
% final function independent of f(t), G, and F -> exp(-5*s). The expression
% was rearranged to arrive at the final equation.
%% Solving IVPs using Laplace transforms
%
% Consider the following IVP, |y''-3y = 5t| with the initial
% conditions |y(0)=1| and |y'(0)=2|.
% We can use MATLAB to solve this problem using Laplace transforms:

% First we define the unknown function and its variable and the Laplace
% tranform of the unknown

syms y(t) t Y s

% Then we define the ODE

ODE=diff(y(t),t,2)-3*y(t)-5*t == 0

% Now we compute the Laplace transform of the ODE.

L_ODE = laplace(ODE)

% Use the initial conditions

L_ODE=subs(L_ODE,y(0),1)
L_ODE=subs(L_ODE,subs(diff(y(t), t), t, 0),2)

% We then need to factor out the Laplace transform of |y(t)|

L_ODE = subs(L_ODE,laplace(y(t), t, s), Y)
Y=solve(L_ODE,Y)

% We now need to use the inverse Laplace transform to obtain the solution
% to the original IVP

y = ilaplace(Y)

% We can plot the solution

ezplot(y,[0,20])

% We can check that this is indeed the solution

diff(y,t,2)-3*y


%% Exercise 3
%
% Objective: Solve an IVP using the Laplace transform
%
% Details: Explain your steps using comments
%
%
% * Solve the IVP
% *   |y'''+2y''+y'+2*y=-cos(t)|
% *   |y(0)=0|, |y'(0)=0|, and |y''(0)=0|
% * for |t| in |[0,10*pi]|
% * Is there an initial condition for which |y| remains bounded as |t| goes to infinity? If so, find it.
clear all;
syms t y(t) Y s;

ODE = diff(y(t), t, 3) + 2*diff(y(t), t, 2) + diff(y(t), 1) + 2*y(t) == -cos(t);
L_ODE = laplace(ODE);
L_ODE = subs(L_ODE, y(0), 0);
L_ODE = subs(L_ODE,subs(diff(y(t), t), t, 0),0);
L_ODE = subs(L_ODE, subs(diff(y(t), t, 2), t, 0), 0);

L_ODE = subs(L_ODE, laplace(y(t), t, s), Y);
Y = solve(L_ODE, Y);
y(t) = ilaplace(Y);

% check this indeed equals -cos(t), or the right hand side of the ODE:
LHS = diff(y(t), t, 3) + 2*diff(y(t), t, 2) + diff(y(t), t) + 2*y(t)
g(t) = (t*cos(t))/10 - (t*sin(t))/5;
LHS = diff(g(t), t, 3) + 2*diff(g(t), t, 2) + diff(g(t), t) + 2*g(t)
ezplot(y, [0,20]);

% there is no initial condition for which y remains bounded as t approaches
% infinity. To see this, obtain a general solution for this ODE by first
% solving for the complimentary solution: r^3+2r^2+r+2 = 0 => r = -i, i, -2
% So y_c = Acos(t) + Bsin(t) + Cexp(-2t). The particular solution can be
% found using MATLAB, it's the last two terms of y(t) from above: y_p =
% tsin(t)/5 + tcos(t)/10. Therefore, the general solution for the system is
% y(t) = Acos(t) + Bsin(t) + Cexp(-2t) + tsin(t)/5 + tcos(t)/10. Since none
% of the A, B, C terms have an isolated t, we cannot "cancel out" the
% particular solution. So any initial condition will eventually grow to
% infinity.
%% Exercise 4
%
% Objective: Solve an IVP using the Laplace transform
%
% Details:  
% 
% * Define 
% *   |g(t) = 3 if 0 < t < 2|
% *   |g(t) = t+1 if 2 < t < 5|
% *   |g(t) = 5 if t > 5|
%
% * Solve the IVP
% *   |y''+2y'+5y=g(t)|
% *   |y(0)=2 and y'(0)=1|
%
% * Plot the solution for |t| in |[0,12]| and |y| in |[0,2.25]|.
%
% In your answer, explain your steps using comments.

% g(t) = 3u_{02} + u_{25}(t+1) + 5u_{5}, where u_{ab} = u_a - u_b
% g(t) = 3u_0 + (t-2)u_2 + (4-t)u_5

% declare variables, functions:
syms t y(t) Y s; % CAN'T PUT COMMAS HERE

% expressing g(t) in terms of shifted Heaviside functions:
g(t) = 3*heaviside(t) + (t-2)*heaviside(t-2) + (4-t)*heaviside(t-5);

% expressing the ODE:
ODE = diff(y(t), t, 2) + 2*diff(y(t), t, 1) + 5*y(t) == g(t);

% taking the Laplace transform:
L_ODE = laplace(ODE);

% Initial conditions: y(0) = 2, y'(0) = 1
L_ODE = subs(L_ODE, y(0), 2);
L_ODE = subs(L_ODE,subs(diff(y(t), t), t, 0),1);

% set Y = laplace(f(t)), solve for Y:
L_ODE = subs(L_ODE, laplace(y(t), t, s), Y);
Y = solve(L_ODE, Y);

% take the inverse Laplace of Y(s) to get y(t):
y(t) = ilaplace(Y)

% plot for |t| in |[0,12]| and |y| in |[0,2.25]|:
ezplot(y, [0,12, 0,2.25]);

% In general here are the steps to solve a non-homogenous ODE with a
% piecewise differentiable forcing function g(t):
% - expression the forcing function in terms of Heaviside unit step
% functions
% - Convert the differential equation to an algebraic equation using
% laplace(f(t)), and set initial conditions using the subs function
% - solve the algebraic equation in terms of Y(s)
% - use the ilaplace function to convert Y(s) => y(t), the solution to the
% original ODE

%% Exercise 5
%
% Objective: Use the Laplace transform to solve an integral equation
% 
% Verify that MATLAB knowns about the convolution theorem by explaining why the following transform is computed correctly.
syms t tau y(tau) s
I=int(exp(-2*(t-tau))*y(tau),tau,0,t)
laplace(I,t,s) % output: laplace(y(t), t, s)/(s+2)

% the given integral expression is equivalent to (exp(2t) * y(t))(t), where
% (f*g) denotes the convolution between the functions f and g. We know that
% laplace((f*g)(t)) = F(s)G(s). We know that the laplace transform of
% exp(2t) is 1/(s+2). Therefore, the laplace transform of the convolution
% is the product between 1/(s+2) and y(t), as correctly displayed by
% MATLAB.