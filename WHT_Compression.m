function x_comp = WHT_Compression(m,x)
IC1 = fwht(x); 
[~,ind] = sort(abs(IC1),'descend');
tmp = zeros(size(IC1));
tmp(ind(1:m)) = IC1(ind(1:m));
IC1 = tmp;
x_comp = ifwht(IC1);
x_comp = double(x_comp);
end