clear all, close all, clc
rng(1)
TileSpacing = 'compact';
loc = 'best';
FS = 10;
Edge = 'k';
load Test.mat
GT = Data;
Ind = randi([-1 size(GT,1)],1,9);
%% Setup
M = 2; % 2 or 16
Approach = 'WHT'; % WHT or Sym4
load ([Approach,'_',num2str(M),'_Noisy_Test.mat']) %X
load([Approach,'_CNN','_',num2str(M),'_Den_Test_Rec.mat']) %prediction
pred = prediction;
clear prediction

%% Transform
figure
t = tiledlayout(3, 3, "TileSpacing", TileSpacing);
k=1;
for i = Ind
%subplot(3,3,k)
nexttile
plot(1:size(GT,2),GT(i,:),'r','LineWidth',2)
hold on
plot(1:size(GT,2),X(i,:),'b','LineWidth',2)
k = k+1;
set(gca,'XTick',[], 'YTick', [])
end

legend('GT',Approach, 'fontsize',FS, 'Location',loc,'EdgeColor',Edge)

%% CNN-Transform-Denoiser
figure
t = tiledlayout(3, 3, "TileSpacing", TileSpacing);
k=1;
for i = Ind
%subplot(3,3,k)
nexttile
plot(1:size(GT,2),GT(i,:),'r','LineWidth',2)
hold on
plot(1:size(GT,2),pred(i,:),'b','LineWidth',2)
k = k+1;
set(gca,'XTick',[], 'YTick', [])
end

legend('GT',[Approach,'-CNN'], 'fontsize',FS, 'Location',loc)
  