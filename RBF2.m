%% RBF Function Interpolation 1D
% Vishnu Vardhan Reddy Kancharla

%% GIVENS
format compact; format long; clear all; %#ok<CLALL>

s = 1;                        % Num of Dimensions 
k = 5;                        % Const for 'GIVEN' data sites calculation 
evalNum = 10000;               % Num of eval points on each axis (dimension)

N = (2^k + 1)^s;                             % Number of data sites given
M = evalNum^s;                               % Number of eval. pts in total

dsites = points(N,s);                   % GIVEN data points using 'points'  
ctrs   = dsites;                      % Centres = dsites here, can be diff

epoints = MakeSDGrid(s,evalNum);        % Equally spaced evaluation points

% out = epoints(:,1).^2 + epoints(:,2).^2 > 1;
% epoints(out) = [];

DMi = DistanceMatrix(dsites,ctrs);      % Dist. matrix for IM
DMe = DistanceMatrix(epoints,ctrs);     % Dist. matrix for EM

fprintf('1: Linear \n');
fprintf('2: Cubic \n');
fprintf('3: Gaussian\n');
fprintf('4: Multiquadratics\n');
fprintf('5: Thin Plate\n');
fprintf('6: Quinic\n');
n = input('Enter a number from 1-6: ');

sigma = optimalSigma(n,k,s,evalNum);


switch n
    case 1  % Linear
        
        IM = DMi ;
        EM = DMe;
        
    case 2  % Cubic
        
        IM = DMi.^3 ;
        EM = DMe.^3 ;
        
    case 3  % Gaussian
        
        %C = input('Input the C for sigma: ');
        IM = exp(-DMi.^2/(2*sigma^2));
        EM = exp(-DMe.^2/(2*sigma^2));
        
    case 4  % Multiquadratics
        
        %C = input('Input the C for sigma: ');
        IM = sqrt(1+(DMi.^2/(sigma)^2));
        EM = sqrt(1+(DMe.^2/(sigma)^2));
        
    case 5  % Thin Plate
        
        IM = (DMi.^2).*log(DMi+1);
        EM = (DMe.^2).*log(DMe+1);
        
    case 6  % Quinic
        
        IM = DMi.^5 ;
        EM = DMe.^5 ;
        
    otherwise
        disp('Choose 1-6:')
end

%% QRE STUFF
theuserinput = input('Do you want EM to be QR Permuted? (y/n)','s');
if theuserinput == 'y'
A = orth(EM);
[~,~,E] = qr(A','vector');
dsites = epoints(E(1:N),:);
IM = EM(E(1:N),:);
end
%% (Continued)
if s == 1
    rhs   = testfunction(dsites);         % The GIVEN f(x,y,z,....) of data set 
    exact = testfunction(epoints);        % Exact solution

elseif s == 2
    rhs   = testfunction2(dsites);         % The GIVEN f(x,y,z,....) of data set 
    exact = testfunction2(epoints)';        % Exact solution
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
[xx,yy] = ndgrid(linspace(0,1,evalNum));    

figure(1);
surf(xx,yy,reshape(Pf,size(xx)))
figure(2); 
surf(xx,yy,reshape(exact,size(xx)));
figure (3) ;
surf(xx,yy,abs(reshape(exact,size(xx))-reshape(Pf,size(xx))));

figure(5);
plot(dsites(:,1),dsites(:,2),'ro','markerfacecolor',[1 0 0]);

axis square;
end