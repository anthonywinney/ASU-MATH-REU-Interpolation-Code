%% RBF Function Interpolation 1D
% Vishnu Vardhan Reddy Kancharla

%% GIVENS
format compact; format long; clear all; %#ok<CLALL>

s = 2;                        % Num of Dimensions 
N = 100;                      % Number of data sites "given"
evalNumGrid = 100;            % Num of eval points on each axis (dimension)

% dsites = points(N,s);                  % GIVEN data points using 'points'  
% ctrs   = dsites;                     % Centres = dsites here, can be diff

% Equally spaced gridpoints
gridpoints = MakeSDGrid(s,evalNumGrid,-1,1);

%ds Points after Domain Modification
[index, epoints, xb, yb] = maskDomain(gridpoints); 
evalNum = length(epoints);
P = randperm(evalNum,N);

dsites = epoints(P,:);
ctrs = dsites;

DMi = DistanceMatrix(dsites,ctrs);      % Dist. matrix for IM
DMe = DistanceMatrix(epoints,ctrs);     % Dist. matrix for EM

[IM, EM,rbftype] = rbfchoose(DMi, DMe, N,s) ;     % IM and EM after choosing an RBF

%% QRE STUFF
n = input('Do you want EM to be QR Permuted? (y/n)','s');
if n == 'y'
    for i = 1:4
        figure(6)
        plot(ctrs(:,1),ctrs(:,2),'*',xb,yb),drawnow
        A = orth(EM);
        [~,~,E] = qr(A','vector');
        dsites = epoints(E(1:N),:); 
        ctrs = dsites;
        % IM = EM(E(1:N),:);
        DMi = DistanceMatrix(dsites,ctrs);      % Dist. matrix for IM
        DMe = DistanceMatrix(epoints,ctrs);     % Dist. matrix for EM

        [IM, EM] = rbfchoose(DMi, DMe, N,s,rbftype) ;     % IM and EM after choosing an RBF
    end
end

%% (Continued)
if s == 1
    rhs   = testfunction(dsites);         % The GIVEN f(x,y,z,....) of data set 
    exact = testfunction(epoints);        % Exact solution

elseif s == 2
    rhs   = testfunction2(dsites);         % The GIVEN f(x,y,z,....) of data set 
    exact = testfunction2(epoints);        % Exact solution
end

Pf = EM * (IM\rhs);                     % f(x,y,z,...) at evaluation points


%% Maximum Error and Condition Number

maxerr = norm(Pf-exact(1:length(Pf)),inf);
fprintf ('Number of Data Points Given: %e\n', N)
fprintf ('Maximum error: %e\n', maxerr)
fprintf ('Condition Number: %e\n', cond(IM))

%% PLOTS

if s == 1 
% Approximated Plot vs. Exact Plot
figure(1);
plot(epoints, Pf, epoints, exact);
% Error Plot
figure(2); 
plot(epoints, abs(Pf-exact));
% QRE Points
figure(3);
plot(dsites,0*dsites,'.')

elseif s == 2  
xx = reshape(gridpoints(:,1),evalNumGrid,evalNumGrid);
yy = reshape(gridpoints(:,2),evalNumGrid,evalNumGrid);
Pfm = NaN(size(xx)) ;
Pfm(index) = Pf ; 

exactm = NaN(size(xx)) ;
exactm(index) = exact;

figure(1);
surf(xx,yy,Pfm);
shading interp

figure(2); 
surf(xx,yy,exactm)
shading interp

figure (3) ;
surf(xx,yy,abs(Pfm - exactm));
shading interp

%%
figure(5);
plot(epoints(:,1),epoints(:,2),'.',dsites(:,1),dsites(:,2),'ro',xb,yb,ctrs(:,1),ctrs(:,2),'*','markerfacecolor',[1 0 0]);

axis square;
end