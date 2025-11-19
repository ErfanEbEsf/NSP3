% Learns W offline, returns W.
function W = PCA_Compression(m,x)
k = m;
Mean = mean(x);
x = x - Mean;
C = (x'*x)/size(x,1);
[V,L,E] = pcacov(C);
W = V(:,1:k);
% y = x * W; 
% x_comp = y * W';
% x_comp = double(x_comp + Mean);
end