%% KTE Analysis 
% REU Summer 2019

numOfAlphas = 200;
startAlpha = .0001;
endAlpha = 1;

%RBF Function Choice
%1=Linear 2=Cubic 3=Gaussian 4=Multiquadratics 5=Thinplate
n = 3;

alpha = linspace(startAlpha,endAlpha,numOfAlphas);
yerror = zeros(numOfAlphas,1);

for i = 1:numOfAlphas


% 'GIVENS'
s = 1;           % Number of Dimensions 
k = 5;           % Constant for num of 'GIVEN' data sites calculation

evalNum = 1000;    % Number of evaluation points on each dimension (axis)
N = (2^k + 1)^s; % Number of data sites given
M = evalNum^s;   % Number of evaluation points in total

C = 1.5;
sigma = C/N ;

dsites = kte(alpha(i),N,0,1); %MakeSDGrid(s,N^(1/s)); %haltonseq(N,s); %linspace(0,1,N)';  % Calculate the 'GIVEN' data points for simulation
ctrs   = dsites;         % We use the same data sites as centres here

% Equally spaced evaluation points
epoints = MakeSDGrid(s,evalNum);

% The GIVEN f(x,y,z,....) of the data set 
rhs = testfunction(dsites,s);

DMi = DistanceMatrix(dsites,ctrs);  % Distance matrix for Interpol. Matrix
DMe = DistanceMatrix(epoints,ctrs); % Distance matrix for evaluation Matrix

%n = input('Enter a number from 1-5: ');

switch n
    case 1  % Linear
        
        IM = DMi ;
        EM = DMe;
        
    case 2  % Cubic
        
        IM = DMi.^3 ;
        EM = DMe.^3 ;
        
    case 3  % Gaussian
        
        IM = exp(-DMi.^2/(2*sigma^2));
        EM = exp(-DMe.^2/(2*sigma^2));
        
    case 4  % Multiquadratics
        
        IM = sqrt(1+(DMi.^2/(sigma)^2));
        EM = sqrt(1+(DMe.^2/(sigma)^2));
        
    case 5  % Thin Plate
        
        IM = (DMi.^2).*log(DMi+1);
        EM = (DMe.^2).*log(DMe+1);
        
    otherwise
        disp('Choose 1-5')
end


% Evaluate the interpolant on evaluation points
Pf = EM * (IM\rhs);

% Compute exact solution,i.e., evaluate test function on evaluation points
exact = testfunction(epoints,s);

% Compute maximum and RMS errors on evaluation grid
maxerr = norm(Pf-exact,inf);

yerror(i) = maxerr;
% fprintf ('Number of Data Points Given: %e\n', N)
% fprintf ('Maximum error: %e\n', maxerr)
% fprintf ('Condition Number: %e\n', cond(IM))
% %% PLOTS
% figure(1);
% plot(epoints, Pf);
% 
% figure(2); 
% plot(epoints, abs(Pf-exact));

end
[MinError, Index] = min(yerror);
BestAlpha = alpha(Index);

rbfFxn = '';

switch n
    case 1  % Linear
        
    rbfFxn = 'Linear';    
        
    case 2  % Cubic
        
    rbfFxn = 'Cubic';
        
    case 3  % Gaussian
        
    rbfFxn = 'Gaussian';
        
    case 4  % Multiquadratics
        
    rbfFxn = 'Multiquadratics';
        
    case 5  % Thin Plate
        
    rbfFxn = 'Thin Plate';
        
    otherwise
        disp('Choose 1-5')
end

figure(1)
scatter(alpha,yerror)


title([rbfFxn ': BestAlpha = ' num2str(BestAlpha) ' MinError = ' num2str(MinError)])
xlabel('Alphas');
ylabel('Error');

