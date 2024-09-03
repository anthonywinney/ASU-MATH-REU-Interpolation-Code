            u = linspace(-1,1,200);
            v = u;
            
            
            x = sqrt(1/4+u.^2).*cos(v);
            y = sqrt(1/4+u.^2).*sin(v);
            z = u;

            tri = delaunayn([x' y' z']);
            tn = tsearchn([x y z], tri, gridpoints);