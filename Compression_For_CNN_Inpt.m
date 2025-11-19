clear all, close all, clc
M = 2; % 2, 16
%% Load 
load ('Train.mat')
Tr = Data;
load ('Test.mat')
Te = Data;
load ('val.mat')
V = Data;
%% Compress by M - WHT
X = zeros(size(Tr));
parfor i = 1:size(Tr,1)
X(i,:) = WHT_Compression(M,Tr(i,:));
end
save(['WHT_',num2str(M),'_Train.mat'],'X')
clear X
X = zeros(size(Te));
parfor i =1:size(Te,1)
X(i,:) = WHT_Compression(M,Te(i,:));
end
save(['WHT_',num2str(M),'_Test.mat'],'X')
clear X
parfor i = 1:size(V,1)
X(i,:) = WHT_Compression(M,V(i,:));
end
save(['WHT_',num2str(M),'_Val.mat'],'X')
clear X
%% Compress by M - Sym4
% filt = 'sym4'; scale = 1;
% X = zeros(size(Tr));
% parfor i = 1 : size(Tr,1)
% X(i,:) = Wavelet_Compression(M,Tr(i,:),scale,filt);
% end
% save(['Sym4_',num2str(M),'_Train.mat'],'X')
% clear X
% X = zeros(size(Te));
% parfor i = 1:size(Te,1)
% X(i,:) = Wavelet_Compression(M,Te(i,:),scale,filt);
% end
% save(['Sym4_',num2str(M),'_Test.mat'],'X')
% clear X
% X = zeros(size(V));
% parfor i =1:size(V,1)
% X(i,:) = Wavelet_Compression(M,V(i,:),scale,filt);
% end
% save(['Sym4_',num2str(M),'_Val.mat'],'X')
% clear X
