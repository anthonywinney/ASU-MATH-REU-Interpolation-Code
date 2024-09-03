function rbfplot2m(gridpoints,epoints,dsites,ctrs,M,Pf,index,exact,xb,yb,L)

xx = reshape(gridpoints(:,1),M,M);
yy = reshape(gridpoints(:,2),M,M);
Pfm = NaN(size(xx)) ;
Pfm(index) = Pf ;

Lm = NaN(size(xx));
Lm(index) = L;
exactm = NaN(size(xx)) ;
exactm(index) = exact;

figure(1);
surf(xx,yy,Pfm);
shading interp
title('Approximate Plot (Domain Modified)')

figure(2); 
surf(xx,yy,exactm)
shading interp
title('Exact Plot Plot (Domain Modified)')

figure (3) ;
surf(xx,yy,abs(Pfm - exactm));
shading interp
title('Error Plot')

figure(4);
plot(epoints(:,1),epoints(:,2),'.',dsites(:,1),dsites(:,2),'ro',xb,yb,ctrs(:,1),ctrs(:,2),'k*','markerfacecolor',[1 0 0]);
title('Data Sites, Evaluation Points and Centres')


% lgd = legend('Evaluation points','Interpolation Points','Boundary','Centers');
% lgd.FontSize = 20;
% axis off
% axis square

figure(5);
surf(xx,yy,Lm)
shading interp

axis square



end

