function [ dsites, IM ] = QRE( epoints, EM, N)

[A,~] = qr(EM,0);
[~,~,E] = qr(A','vector');
dsites = epoints(E(1:N),:);
IM = EM(E(1:N),:);

end

