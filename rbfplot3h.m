function rbfplot3(dsites, epoints, Pf, exact,ctrs)

figure(1);
plot3(dsites(:,1),dsites(:,2),dsites(:,3),'b*',ctrs(:,1),ctrs(:,2),ctrs(:,3),'ko')
title('Data Sites')


figure(2);
plot3(epoints(:,1),epoints(:,2),epoints(:,3),'.');
title('Evaluation Points')
end

