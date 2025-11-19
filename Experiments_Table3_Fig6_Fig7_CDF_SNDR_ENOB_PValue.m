clear all, close all, clc
sndr= @(x,x0) 20*log10(norm(x0)/norm(x-x0)); 
enob = @(a) (a-1.76)/6.02;
Address =  cd;
load([Address,'\Test.mat'])
Test_GT = Data;
load ([Address,'\Train.mat'])
Train_GT = Data;
N = 64;
M = 8; % 2, 4, 8 or 16
FS = 12;
Prop_SNDR = 0; % Initialize
%% Proposed Method  1
% loading the output from the Jupyter script
Approach = 'WHT';
load([Approach,'_CNN','_',num2str(M),'_Test_Rec.mat']) %prediction
pred = double(prediction);
clear prediction
parfor i = 1:size(Test_GT,1)
Prop_SNDR1(i,1) = sndr(pred(i,:),Test_GT(i,:));
ENOB(i,1) = enob(Prop_SNDR1(i,1));
end
fprintf('Proposed')
mean_SNDR = mean(Prop_SNDR1)
std_SNDR = std(Prop_SNDR1)
P1 = cdf('normal',Prop_SNDR1,mean_SNDR,std_SNDR);
mean_ENOB = mean(ENOB)
std_ENOB = std(ENOB)
figure, 
plot(1:size(Test_GT,2),log(sum(abs(Test_GT-pred),1)),'LineWidth',2,'Color','k')
hold on
xlabel('Sample')
ylabel('Total Per-Sample difference w.r.t. GT')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',FS)

%% Proposed Method  2
% loading the output from the Jupyter script
Approach = 'Sym4';
load([Approach,'_CNN','_',num2str(M),'_Test_Rec.mat']) %prediction
pred = double(prediction);
clear prediction
parfor i = 1:size(Test_GT,1)
Prop_SNDR2(i,1) = sndr(pred(i,:),Test_GT(i,:));
ENOB(i,1) = enob(Prop_SNDR2(i,1));
end
fprintf('Proposed')
mean_SNDR = mean(Prop_SNDR2)
std_SNDR = std(Prop_SNDR2)
mean_ENOB = mean(ENOB)
std_ENOB = std(ENOB)
plot(1:size(Test_GT,2),log(sum(abs(Test_GT-pred),1)),'LineWidth',2,'Color','blue')
P2 = cdf('normal',Prop_SNDR2,mean_SNDR,std_SNDR);
%% Wavelets
filt = 'sym4';
scale = 1; % 1 works better!
tic;
parfor i = 1:size(Test_GT,1)
Sym4(i,:) = Wavelet_Compression(M,Test_GT(i,:),scale,filt);
SNDR3(i,1) = sndr(Sym4(i,:),Test_GT(i,:));
ENOB(i,1) = enob(SNDR3(i,1));
end
fprintf(filt);
time = toc
mean_SNDR = mean(SNDR3)
std_SNDR = std(SNDR3)
P3 = cdf('normal',SNDR3,mean_SNDR,std_SNDR);
p_value = ranksum(SNDR3,Prop_SNDR1)
mean_ENOB = mean(ENOB)
std_ENOB = std(ENOB)
plot(1:size(Test_GT,2),log(sum(abs(Test_GT-Sym4),1)),'LineWidth',2,'Color','r')

%% WHT
tic;
parfor i = 1:size(Test_GT,1)
DCT(i,:) = WHT_Compression(M,Test_GT(i,:));
SNDR4(i,1) = sndr(DCT(i,:),Test_GT(i,:));
ENOB(i,1) = enob(SNDR4(i,1));
end
fprintf('WHT')
time = toc
mean_SNDR = mean(SNDR4)
std_SNDR = std(SNDR4)
P4 = cdf('normal',SNDR4,mean_SNDR,std_SNDR);
p_value = ranksum(SNDR4,Prop_SNDR1)
mean_ENOB = mean(ENOB)
std_ENOB = std(ENOB)
plot(1:size(Test_GT,2),log(sum(abs(Test_GT-DCT),1)),'LineWidth',2,'Color','magenta')
%% WHT smoothing
tic;
windowSize = 2; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;
parfor i = 1:size(Test_GT,1)
DCT(i,:) = WHT_Compression(M,Test_GT(i,:));
DCT(i,:) = filter(b,a,DCT(i,:));
SNDR44(i,1) = sndr(DCT(i,:),Test_GT(i,:));
ENOB(i,1) = enob(SNDR44(i,1));
end
fprintf('WHT-Smoothed')
time = toc
mean_SNDR = mean(SNDR44)
std_SNDR = std(SNDR44)
P44 = cdf('normal',SNDR44,mean_SNDR,std_SNDR);
p_value = ranksum(SNDR44,Prop_SNDR1)
mean_ENOB = mean(ENOB)
std_ENOB = std(ENOB)
% plot(1:size(Test_GT,2),log(sum(abs(Test_GT-DCT),1)),'LineWidth',2,'Color','magenta')

%% Tchebycheff
tic;
parfor i = 1:size(Test_GT,1)
DCT(i,:) = Tcheb_Compression(M,Test_GT(i,:));
SNDR5(i,1) = sndr(DCT(i,:),Test_GT(i,:));
ENOB(i,1) = enob(SNDR5(i,1));
end
fprintf('Tcheb')
time = toc
mean_SNDR = mean(SNDR5)
std_SNDR = std(SNDR5)
P5 = cdf('normal',SNDR5,mean_SNDR,std_SNDR);
p_value = ranksum(SNDR5,Prop_SNDR1)
mean_ENOB = mean(ENOB)
std_ENOB = std(ENOB)
plot(1:size(Test_GT,2),log(sum(abs(Test_GT-DCT),1)),'LineWidth',2,'Color','g')

%% PCA 3 
W = PCA_Compression(N,Train_GT);
WW = W(:,1:M);
y = Test_GT * WW; 
DCT = y * WW';

parfor i = 1:size(Test_GT,1)
SNDR6(i,1) = sndr(DCT(i,:),Test_GT(i,:));
ENOB(i,1) = enob(SNDR6(i,1));
end

% time = toc
fprintf('PCA')
mean_SNDR = mean(SNDR6)
std_SNDR = std(SNDR6)
P6 = cdf('normal',SNDR6,mean_SNDR,std_SNDR);
p_value = ranksum(SNDR6,Prop_SNDR1)
mean_ENOB = mean(ENOB)
std_ENOB = std(ENOB)
plot(1:size(Test_GT,2),log(sum(abs(Test_GT-DCT),1)),'LineWidth',2,'Color','cyan')
grid on
legend('WHT-CNN','Sym4-CNN','Sym4','WHT','Tchebycheff','PCA','fontsize',FS)
%% CDF
figure,
plot(sort(Prop_SNDR1),sort(P1),'LineWidth',2,'Color','black')
xlabel('SNDR')
ylabel('Cumulative Distribution Functon')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',FS)
hold on
grid on
plot(sort(Prop_SNDR2),sort(P2),'LineWidth',2,'Color','blue')
plot(sort(SNDR3),sort(P3),'LineWidth',2,'Color','red')
plot(sort(SNDR4),sort(P4),'LineWidth',2,'Color','magenta')
plot(sort(SNDR5),sort(P5),'LineWidth',2,'Color','green')
plot(sort(SNDR6),sort(P6),'LineWidth',2,'Color','cyan')
hold off
legend('WHT-CNN','Sym4-CNN','Sym4','WHT','Tchebycheff','PCA','fontsize',FS,'Location','SouthEast')
%% WHT-CNN vs. Sym4-CNN 
% Approach = 'WHT';
% load([Approach,'_CNN','_',num2str(M),'_Test_Rec.mat']) %prediction
% pred = double(prediction);
% clear prediction
% parfor i = 1:size(Test_GT,1)
% Prop_SNDR(i,1) = sndr(pred(i,:),Test_GT(i,:));
% end
% fprintf('Proposed')
% mean_SNDR = mean(Prop_SNDR)
% std_SNDR = std(Prop_SNDR)
% 
% Approach = 'Sym4';
% load([Approach,'_CNN','_',num2str(M),'_Test_Rec.mat']) %prediction
% pred2 = double(prediction);
% clear prediction
% parfor i = 1:size(Test_GT,1)
% Prop_SNDR2(i,1) = sndr(pred2(i,:),Test_GT(i,:));
% end
% fprintf('Proposed')
% mean_SNDR = mean(Prop_SNDR2)
% std_SNDR = std(Prop_SNDR2)
% 
% p_value = ranksum(Prop_SNDR,Prop_SNDR2)
