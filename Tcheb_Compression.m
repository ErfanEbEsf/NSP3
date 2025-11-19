function x_comp = Tcheb_Compression(m,x)
if size(x,2)>1
    x = x';
end

T0 =[1 1 1 1 1 1 1 1
    -2 -2 -1 0 0 1 2 2
     3 0 -1 -2 -2 -1 0 3
    -2 1 2 0 0 -2 -1 2
     1 -2 -1 2 2 -1 -2 1
    -1 2 -2 -1 1 2 -2 1
    0 -1 2 -1 -1 2 -1 0
    0 1 -2 3 -3 2 -1 0];
S=diag([1/sqrt(8);1/sqrt(18);1/sqrt(28);...
    1/sqrt(18); 1/sqrt(20);1/sqrt(20);1/sqrt(12);...
    1/sqrt(28)]);
T = S*T0;
T_inv = inv(T);
%%%%%%%%%%%%%%%%%%%
N = 8;
L = length(x)/N; %64/8 = 8 subintervals
for i = 1:L
   IC1((i-1)*L+1:(i-1)*L+N) = T*x((i-1)*L+1:(i-1)*L+N); 
end

[~,ind] = sort(abs(IC1),'descend');
tmp = zeros(size(IC1));
tmp(ind(1:m)) = IC1(ind(1:m));
IC1 = tmp';

for i = 1:L
   x_comp((i-1)*L+1:(i-1)*L+N) = T_inv*IC1((i-1)*L+1:(i-1)*L+N); 
end

x_comp = double(x_comp');