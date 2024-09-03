function rbfplot3(dsites, epoints, Pf, exact,ctrs,M,L,hollow)

figure(1);
plot3(dsites(:,1),dsites(:,2),dsites(:,3),'b*',ctrs(:,1),ctrs(:,2),ctrs(:,3),'ko')
title('Data Sites')

if hollow

hold on
xx = reshape(epoints(:,1),M,M);
yy = reshape(epoints(:,2),M,M);
zz = reshape(epoints(:,3),M,M);

LL = reshape(L,M,M);
surf(xx,yy,zz,LL);
hold off
shading interp
end

figure(2);
plot3(epoints(:,1),epoints(:,2),epoints(:,3),'.');
title('Evaluation Points')
end

