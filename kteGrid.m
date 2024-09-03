function gridpoints = kteGrid(s,alpha,N,a,b)
if (s==1)
    gridpoints = kte(alpha,N,a,b)';
    return;
end
% Mimic this statement for general s:
% [x1, x2] = ndgrid(linspace(0,1,neval));
outputarg = 'x1';
for d = 2:s
    outputarg = strcat(outputarg,',x',int2str(d));
end
makegrid = strcat('[',outputarg,'] = ndgrid(kte(alpha,N,a,b));');
eval(makegrid);
% Mimic this statement for general s:
% gridpoints = [x1(:) x2(:)];
gridpoints = zeros(N^s,s);
for d = 1:s
    matrices = strcat('gridpoints(:,d) = x',int2str(d),'(:);');
    eval(matrices);
end