function x_comp = Wavelet_Compression(m,x,scale,filt)
J = scale;
[IC1, IS1] = wavedec(x, J,filt); 
[~,ind] = sort(abs(IC1),'descend');
tmp = zeros(size(IC1));
tmp(ind(1:m)) = IC1(ind(1:m));
IC1 = tmp;
x_comp = waverec(IC1, IS1,filt);
x_comp = double(x_comp);
end