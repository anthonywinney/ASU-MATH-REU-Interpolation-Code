function [ IM, EM, n ] = rbfchoose(DMi, DMe, N,s,rbftype)
% Let's you choose the rbf you want for interpolating your points
% The function will prompt for input in the command window
% Input:
%     N  : Number of datasites
%     DMi: Distance Matrix of IM
%     DMe: Distance Matrix of EM
% Output:
%     IM : Interpolation Matrix
%     EM : Evaluation Points

if nargin < 5
    % MENU
    fprintf('1: Linear \n');
    fprintf('2: Cubic \n');
    fprintf('3: Gaussian\n');
    fprintf('4: Multiquadratics\n');
    fprintf('5: Thin Plate\n');
    fprintf('6: Quintic\n');
    fprintf('7: Inverse Multiquadric\n');
    n = input('Enter a number from 1-7: ');

% Use this feature when running loops with rbf so you don't get 
% prompted everytime for input
else  
    n = rbftype;
end

switch n
    case 1  % Linear
        
        IM = DMi ;
        EM = DMe;
        
    case 2  % Cubic
        
        IM = DMi.^3 ;
        EM = DMe.^3 ;
        
    case 3  % Gaussian
        
        C = input('Input the C for sigma: ');
        sigma = C/N^(1/s) ;
        IM = exp(-DMi.^2/(2*sigma^2));
        EM = exp(-DMe.^2/(2*sigma^2));
        
    case 4  % Multiquadratics
        
        C = input('Input the C for sigma: ');
        sigma = C/N^(1/s) ;
        IM = sqrt(1+(DMi.^2/(sigma)^2));
        EM = sqrt(1+(DMe.^2/(sigma)^2));
        
    case 5  % Thin Plate
        
        IM = (DMi.^2).*log(DMi+1);
        EM = (DMe.^2).*log(DMe+1);
        
    case 6  % Quintic
        
        IM = DMi.^5 ;
        EM = DMe.^5 ;
        
    case 7  % Inverse Multiquadric

        C = input('Input the C for sigma: ');
        sigma = C/N^(1/s) ;
        IM = 1./(sqrt(1+(DMi.^2/(sigma)^2)));
        EM = 1./(sqrt(1+(DMe.^2/(sigma)^2)));
        
    otherwise
        disp('Choose 1-7:')
end

end

