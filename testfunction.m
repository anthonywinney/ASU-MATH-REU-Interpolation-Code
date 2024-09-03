function tf = testfunction(points,s)
%tf = 1./(1+25*points.^2);

%tf = sin(10*points);
if s == 1
    tf = cos(10*(points(:,1).^2));
elseif s == 2
    tf = cos(10*(points(:,1).^2 + points(:,2).^2));
elseif s == 3
    tf = cos(points(:,1).^2 + points(:,2).^2 + points(:,3).^2 );
end
