function [dsites] = kte(alpha,N,a,b)

ch = chebpts(N,[-1 1]);
x = asin(alpha*ch)/asin(alpha);
dist=(b-a)/2;

dsites = x*dist + dist + a;
end