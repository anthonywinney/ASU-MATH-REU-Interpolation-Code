function [ gridpoints ] = points(N,s,a,b)
% Chooses the type of points you want to use for your simulation

if nargin < 3
    a = -1;
    b = 1;
end

fprintf('1: Equally Spaced Points\n');
fprintf('2: Halton Points\n');
fprintf('3: Chebyshev Points\n');
fprintf('4: KTE Points\n');
n = input('Enter a number from 1-4: ');

if s == 1
    switch n
        case 1 % Equally Spaced Points
            gridpoints = linspace(a,b,N)';
        case 2 % Halton Points
            gridpoints = haltonseq(N,s);
        case 3 % Chebyshev Points
            gridpoints = chebpts(N,[a b]);
        case 4 % KTE Points
            
            % Take Inputs
            alpha = input('Alpha:');
            a = input('a:');
            b = input('b:');

            % Use kte function for dsites
            [gridpoints] = kte(alpha,N,a,b);
    end

elseif s == 2
    
    switch n
        case 1 % Equally Spaced Points
            gridpoints = MakeSDGrid(s,N,-1,1);
            %{
            [xx,yy] = ndgrid(linspace(a,b,sqrt(N)));
            xf = xx(:); yf = yy(:);
            dsites = [xf yf];
            %}
            
        case 2 % Halton Points  
            gridpoints = haltonseq(N,s);

        case 3 % Chebyshev Points
            [x,y] = ndgrid(chebpts(sqrt(N),[a b]));
            xf = x(:); yf = y(:);
            gridpoints = [xf yf];

        case 4 % KTE Points
            alpha = input('Alpha:');
            a = input('a:');
            b = input('b:');

            gridpoints = kteGrid(s,alpha,N,a,b);
    end
    
elseif s == 3
    
    switch n
        case 1 % Equally Spaced Points
            gridpoints = MakeSDGrid(s,N,-1,1);
            %{
            % We can choose the number of points on each axis this way
            [xx,yy,zz] = ndgrid(linspace(-1,1,Nx),linspace(-1,1,Ny),linspace(-1,1,Nz));
            xf = xx(:); yf = yy(:); zf = zz(:);
            dsites = [xf yf zf];
            %}
           
        case 2   
            gridpoints = haltonseq(N,s);
            
        case 3
            [x,y,z] = ndgrid(chebpts(N^(1/3),[a  b]));
            xf = x(:); yf = y(:); zf = z(:);
            gridpoints = [xf yf zf];
            
        case 4
            alpha = input('Alpha:');
            a = input('a:');
            b = input('b:');

            gridpoints = kteGrid(s,alpha,N,a,b);
    end
    
end

end

