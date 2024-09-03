function [epoints, index,xb,yb, numIn, n, hollow] = maskDomain(gridpoints,s,n)

%Gridpoints = the points that you want to edit based on the domain
%s = Number of Dimensions
%n = domain type (for running multiple times - optional

%Detects the number of dimensions and gives options based on the number

hollow = false;

switch s
    case 1
    %Cannot limit domain for 1D
    fprintf('Change actual domain for 1D while selecting points \n')
    epoints = gridpoints;
    
    case 2
    
        %Allows user to pick the domain if one isn't already given
        if nargin < 3
        fprintf('1: Star \n');
        fprintf('2: Disc  \n')
        fprintf('3: L-Shape \n');
        fprintf('4: Peanut \n');
        
        n = input('Enter a number ');
        end
        
        if n == 1
            
                        % Defining theta
            theta = linspace(0,2*pi,500);
            
            % Setting boundary Conditions
            xb = (.9+0.1*cos(12*theta)).*cos(theta);
            yb = (.9+0.1*cos(12*theta)).*sin(theta);
            
            % Noting the indices of the points inside polygon
            index = inpolygon(gridpoints(:,1),gridpoints(:,2),xb,yb);
            
            % Selecting only those evaluation points
            epoints = gridpoints(index,:);
             
        end
        
        if n == 2
            
                        % Defining theta
            theta = linspace(0,2*pi,500);
            
            % Setting boundary Conditions
            xb = 1*cos(theta);
            yb = 1*sin(theta);
            
            % Noting the indices of the points inside polygon
            index = inpolygon(gridpoints(:,1),gridpoints(:,2),xb,yb);
            
            % Selecting only those evaluation points
            epoints = gridpoints(index,:);
            
            
        end
        
        if n == 3
            
            %Defining the L-Shape region
            %1
            xb = linspace(0,0,30);
            yb = linspace(0,1,30);
            %2
            xb = [xb linspace(0,-1,30)];
            yb = [yb linspace(1,1,30)];
            %3
            xb = [xb linspace(-1,-1,30)];
            yb = [yb linspace(1,0,30)];
            %4
            xb = [xb linspace(-1,-1,30)];
            yb = [yb linspace(0,-1,30)];
            %5
            xb = [xb linspace(-1,0,30)];
            yb = [yb linspace(-1,-1,30)];
            %6
            xb = [xb linspace(0,1,30)];
            yb = [yb linspace(-1,-1,30)];
            %7
            xb = [xb linspace(1,1,30)];
            yb = [yb linspace(-1,0,30)];
            %8
            xb = [xb linspace(1,0,30)];
            yb = [yb linspace(0,0,30)];
            
            %Finding the indices of the ones that are in the domain
            index = inpolygon(gridpoints(:,1),gridpoints(:,2),xb,yb);
            
            %Selecting only those epoints
            epoints = gridpoints(index,:);

           
        end 
        
        if n == 4
            
            %Defining the peanut region
            theta = linspace(0,2*pi,500);
            r = .6*sqrt(cos(theta).^2+2.8*sin(theta).^2);
            xb = r.*cos(theta);
            yb = r.*sin(theta);
            
            %Finding the indices of the ones that are in the domain
            index = inpolygon(gridpoints(:,1),gridpoints(:,2),xb,yb);
            
            %Selecting only those epoints
            epoints = gridpoints(index,:);            
            
        end 

    

    case 3
        
        %Picking the domain in 3D if one isn't already given
        if nargin < 3
        fprintf('1: Sphere \n');
        fprintf('2: Hollow Sphere \n');
        fprintf('3: Hollow Hyperboloid \n');
        fprintf('4: Solid Hyperboloid \n');

        n = input('Enter a number from 1-3: ');
        end

    
        if n == 1
            
            %Defining x,y,z
            x = gridpoints(:,1);
            y = gridpoints(:,2);
            z = gridpoints(:,3);
            
            %Getting rid of points outside the sphere domain
            rho   =  1;
            out = x.^2 + y.^2 + z.^2  > rho.^2;
            x(out) = [];
            y(out) = [];
            z(out) = [];
            
            %Defining the epoints as the ones still left
            epoints = [x y z];
            

        end 
        
        if n == 2
           
            lat = length(gridpoints);
            
            phiN = linspace(0,pi/2,lat+1);
            phiS = linspace(pi/2,pi,lat+1);
            
            phiN(end) = [];
            phiS(1) = [];
            
            k = 1:1:lat;
            ks = lat:-1:1;
            phiNv = repelem(phiN,k);
            phiSv = repelem(phiS,ks);
            phiEv  = repelem(pi/2,lat+1);
            
            % phi = [phiNv,phiEv,phiSv]';            
            phi = [phiNv,phiEv, phiSv]'; %fliplr(phiNv)+pi/2
            
            thetaN = [];
            for i = 1:lat
                thetaN = [thetaN, linspace(0,2*pi,i+1)];
                thetaN(end) = [];
            end
            
            thetaM = linspace(0,2*pi,lat+2);
            thetaM(end) = [];
            theta = [thetaN,thetaM, fliplr(thetaN)]';
            
            
            rho = 1 ;
            r = rho*sin(phi);
            
            x = r.*cos(theta);
            y = r.*sin(theta);
            z = rho*cos(phi);
            % z((length(z)+1)/2:length(z)) =  -(z((length(z)+1)/2:length(z)));
            epoints = [x y z];

            
            
            %{
            %Creating the theta and phi
            [theta,phi] = ndgrid(linspace(0,2*pi,length(gridpoints).^(1/s)));
            
            %Putting into columns
            thetaf = theta(:);
            phif = phi(:);
            
            %Cannot duplicate points, so remove endpoints
            thetaf(end) = [] ;
            phif(end) = []; 
            
            rho = 1 ;
            
            %Defining the points on the sphere
            r = rho*sin(phif);
            
            x = r.*cos(thetaf);
            y = r.*sin(thetaf);
            z = rho*cos(phif);
            
            %Creating epoints matrix
            epoints = [x y z];
            hollow = true;
            %}
        end
        
        if n == 3
            
            %Creating meshgrid of parameters
            lin = linspace(0,2*pi,round(length(gridpoints).^(1/2)));
            lin(end) = [];
            [u , v] = ndgrid(linspace(-1,1,round(length(gridpoints).^(1/2))),lin);
            
            %Putting u and v into columns and eliminating endpoints to
            %avoid duplication
            uf = u(:);
            vf = v(:);
            
            %Defining x,y,z
            x = sqrt(1/4+uf.^2).*cos(vf);
            y = sqrt(1/4+uf.^2).*sin(vf);
            z = uf;
            
            %Creating matrix of epoints
            epoints = [x y z];
            hollow = true;
            
        end 
        
        if n == 4
            
            %Defining x,y,z
            x = gridpoints(:,1);
            y = gridpoints(:,2);
            z = gridpoints(:,3);
            
            %Defining the epoints as the ones still left            
            out = x.^2 + y.^2 - z.^2  > .25;
            x(out) = [];
            y(out) = [];
            z(out) = [];
            
            %Defining the epoints as the ones still left
            epoints = [x y z];
            
        end 
        
        %Need to set a value to these because the function needs to output
        xb = NaN;           
        yb = NaN;
        index = NaN;
        


end 

%Used for the ratio, to determine how big the dsites matrix needs to be
numIn = length(epoints);
end

