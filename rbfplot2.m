function rbfplot2(dsites, Pf, exact)

    [xx,yy] = ndgrid(linspace(0,1,M));    

    % Approximate Plot
    figure(1);
    surf(xx,yy,reshape(Pf,size(xx)))
    title('Surface Plot (Approximate)')
    
    % Exact Plot
    figure(2); 
    surf(xx,yy,reshape(exact,size(xx)));
    title('Surface Plot (Exact)')
    
    % Error Plot
    figure (3) ;
    surf(xx,yy,abs(reshape(exact,size(xx))-reshape(Pf,size(xx))));
    title('Error Plot (Exact)')
    
    % Data Points after QRE
    figure(5);
    plot(dsites(:,1),dsites(:,2),'ro','markerfacecolor',[1 0 0]);
    title('Data Sites')
    axis square;
    
end

