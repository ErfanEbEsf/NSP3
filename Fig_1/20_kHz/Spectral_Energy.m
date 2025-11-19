clear all; close all; clc
FS = 12;
%% 
X = [];
mat = dir('*.mat'); 
for q = 1:length(mat)
    load(mat(q).name);
    X = [Spikes;X];
end
%% WHT
x = X';
y = fwht(x);
y = abs(y);
E = sum(y,2);
E = sort(E,'descend');
figure,
plot(1:length(E),E,'LineWidth',2,'Color','red')
grid on
hold on
%% Sym 4
clear y
J = 1;
filt = 'sym4';
for i=1:length(x)
IC1 = wavedec(x(:,i), J,filt); 
y(:,i) = sort(abs(IC1),'descend');
end
E = sum(y,2);
plot(1:length(E),E,'LineWidth',2,'Color','blue')
legend('WHT @ 20 kHz','Sym4 @ 20 kHz','fontsize',FS)
xlabel('Sorted Coefficinet')
ylabel('Total Per-Sample Energy')
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',FS)
