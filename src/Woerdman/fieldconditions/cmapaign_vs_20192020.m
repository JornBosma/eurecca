%% waterlevel from OSSI's
clear all;
close all;

sedmexInit;
global basePath;

%% Open result data BasePar
windoctdekooy = importfile([basePath, 'dataRaw\windKNMI\wind_oct_dekooy.txt']);
winddata(:,1)=windoctdekooy.speed;
winddata(:,2)=windoctdekooy.direction;

wind20192020dekooy= importfile1([basePath, 'dataRaw\windKNMI\daywinddata_dekooy_20192020.txt']);
wind20192020(:,1)=(wind20192020dekooy.speed./10);
wind20192020(:,2)=wind20192020dekooy.direction;
%%

Options = {'anglenorth', 0, 'angleeast', 90, 'labels', {'N', 'E', 'S', 'W'},...
        'cmap','jet','lablegend','U (m/s)','freqlabelangle',...
        -45,'gridstyle', ':', 'gridcolor', 'k', 'gridwidth', 2, 'gridalpha', 0.5};
string= {'11 Sept - 18 Oct 2021','Sept 2019 - Oct 2020'};
nIDs = 6;
alphabet = ('a':'z').';
chars = num2cell(alphabet(1:nIDs));
chars = chars.';
charlbl = strcat('(',chars,')'); % {'(a)','(b)','(c)','(d)'}

figure(1);
set(gcf,'color','white');

ax(1) = subplot(1,2,1);
[figure_handle,count,speeds,directions,Table] =WindRose(winddata(:,2),winddata(:,1),[Options,{'axes',ax(1)}]); hold on
title({string{1};''}); 
set(gca,'fontsize',10,'FontWeight','bold');
 text(0.025,0.90,charlbl{1},'Units','normalized','FontSize',12);hold on

ax(2) = subplot(1,2,2);
[figure_handle,count,speeds,directions,Table] = WindRose(wind20192020(:,2), wind20192020(:,1),[Options,{'axes',ax(2)}]);
title({string{2};''}); 
set(gca,'fontsize',10,'FontWeight','bold');
 text(0.025,0.90,charlbl{2},'Units','normalized','FontSize',12);hold on

%%
avg1=mean(winddata(:,1));
avg2=mean(wind20192020(:,1));

std1=std(winddata(:,1));
std2=std(wind20192020(:,1));

