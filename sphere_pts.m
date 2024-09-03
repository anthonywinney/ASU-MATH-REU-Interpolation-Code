function [P,T]=sphere_pts(h)
% [P,T]=sphere_pts(h)
% Generates roughly equispaced nodes on the sphere
% h is roughly the distance between nodes
% P=phi, -pi<phi<pi
% T=theta, -pi/2<theta<pi/2
% see Fornberg's book page 104
%
% Example:
% [P,T]=sphere_pts(.1);
% [x,y,z] = sph2cart(P,T,ones(size(P)));
% plot3(x,y,z,'*')


Nphi=round((pi-h)/h);
PHI=linspace(h/2,pi-h/2,Nphi)'; 
theta=[]; phi=[];
for i=1:Nphi
   Ntheta=round(2*pi*sin(PHI(i))/h);
   THETA=linspace(0,2*pi,Ntheta)';
   theta=[theta; THETA(1:end-1)];
   phi=[phi; PHI(i)*ones(Ntheta-1,1)];
end

P=theta-pi;
T=pi/2-phi;