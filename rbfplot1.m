function rbfplot1(dsites, epoints, Pf, exact)
    
% Approximated Plot vs. Exact Plot
figure(1);
plot(epoints, Pf,'k', epoints, exact);
title('Approximated plot (black) vs. Exact Plot')
xlabel('Evaluation Points')
ylabel('f(x)')

% Error Plot
figure(2); 
plot(epoints, abs(Pf-exact));
title('Error Plot')
xlabel('Evaluation Points')
ylabel('Difference in exact and true values')

% QRE Points
figure(3);
plot(dsites,0*dsites,'.')
title('Data sites')
end

