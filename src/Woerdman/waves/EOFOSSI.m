%% script to correlate wind parameters to wave heights.
clear all;
close all;

sedmexInit;
global basePath;

%% Open result data BaseParameters
myFolder = [basePath, 'results'];
filePattern = fullfile(myFolder, 'baseParametersOSSI*.mat');
matFiles = dir(filePattern);
      for i = 1:length(matFiles)
          baseFileName = fullfile(myFolder, matFiles(i).name);
          ref_files{i} = load(baseFileName);
      end
OSSI01Par= ref_files{1,1}.OSSI01Par;
OSSI04Par= ref_files{1,2}.OSSI04Par;
OSSI05Par= ref_files{1,3}.OSSI05Par;
OSSI06Par= ref_files{1,4}.OSSI06Par;
OSSI09Par= ref_files{1,5}.OSSI09Par;

%% define time axis entire field campaign
timein2=datetime(2021,09,11,00,00,00);
timeout2=datetime(2021,10,18,10,00,00);
time2=[timein2:minutes(10):timeout2];

timein=datetime(2021,09,11,00,00,00);
timeout=datetime(2021,10,18,10,00,00);
time=[timein:2:timeout];

%% wind parameters, create winddata double with time, speed and direction
windoctdekooy = importfile([basePath, 'dataRaw\windKNMI\wind_oct_dekooy.txt']);
winddata(:,1)=MET2eureccatime(datevec(time2));
winddata(:,2)=windoctdekooy.speed;
winddata(:,3)=windoctdekooy.direction;

%% create a mnatrix of all wave heights and perform EOF analysis
Hs(:,1)=OSSI01Par(35:4717,4);
Hs(:,2)=OSSI09Par(35:4717,4);
Hs(:,3)=OSSI04Par(35:4717,4);
Hs(:,4)=OSSI05Par(35:4717,4);
Hs(:,5)=OSSI06Par(35:4717,4);

[E,A,D,Dperc] = pcaRuessink(Hs,1);
data_r1 = recon_pca(E,A,1);
data_r2 = recon_pca(E,A,2);
data_r12 = recon_pca(E,A,1:2);
A=A*-1;

figure(200)
set(gcf, 'position',[100 50 1200 700],'color','white')
subplot(211)
plot(datetime(eurecca2METtime(OSSI01Par(35:4717,1))),A(:,1:2),'LineWidth',1.3,'LineStyle','--');
title('1st and 2nd modes over time')
ylabel('Amplitude [m]');
legend('1^{st} mode','2^{nd} mode','Location','southeast'); legend boxoff
xticks(time);
xlim([timein timeout]);
% yticks(-0.5:0.1:0.5);
% xlim([timein timeout]); ylim([-0.5 0.5]);
set(gca,'fontsize',10,'FontWeight','bold');

subplot(212);
set(gca,'fontsize',10,'FontWeight','bold'); hold on
plot(datetime(eurecca2METtime(OSSI01Par(35:4717,1))),data_r1-data_r12,'LineWidth',1.3);
xticks(time);
% yticks(-0.5:0.1:0.5);
% xlim([timein timeout]); ylim([-0.5 0.5]);
title('Reconstruction of Hs')
ylabel('Hs [m]');
legend('L1','L2','L4','L5','L6','Location','northeast'); legend boxoff
set(gca,'fontsize',10,'FontWeight','bold');
xlim([timein timeout]);
% saveas(figure(200),[basePath '\wave analysis\figures\wave_EOF.fig'])

%% wind plots
figure(1);
set(gcf, 'position',[100 50 1200 700],'color','white')
subplot(3,1,1);
set(gca,'fontsize',10,'FontWeight','bold'); hold on
plot(datetime(eurecca2METtime(winddata(:,1))),winddata(:,2),'k'); hold on
title('wind measurements');
ylabel('v_{wind} (m/s)');
xticks([time]);
xlim([timein timeout]);

subplot(3,1,2);
set(gca,'fontsize',10,'FontWeight','bold'); hold on
scatter(datetime(eurecca2METtime(winddata(:,1))),winddata(:,3),'.k'); hold on
yline(51,'k--','linewidth',1.5)
yline(51+90,'k','linewidth',1.5)
yline(51+180,'k--','linewidth',1.5)
ylim([0 360])
yticks([0 90 180 270 360]);
ylabel('\theta_{wind} (\circ)');
xticks([time]);
xlim([timein timeout]);

figure(1)
subplot(3,1,3) 
plot(datetime(eurecca2METtime(OSSI01Par(35:4717,1))),A(:,1:2),'LineWidth',1.3,'LineStyle','--');
title('1st and 2nd modes over time')
ylabel('Amplitude [m]');
legend('1^{st} mode','2^{nd} mode','Location','southeast'); legend boxoff
xticks(time);
set(gca,'fontsize',10,'FontWeight','bold');
xlim([timein timeout]);
% saveas(figure(1),[basePath '\wave analysis\figures\wind_EOF.fig'])



%% EOF vs wind
nIDs = 6;
alphabet = ('a':'z').';
chars = num2cell(alphabet(1:nIDs));
chars = chars.';
charlbl = strcat('(',chars,')'); % {'(a)','(b)','(c)','(d)'}

ax=gca;
figure(2); tiledlayout(2,1,Padding="compact",TileSpacing='tight');
set(gcf, 'position',[100 100 800 500],'color','white')

X_1315=[datetime(2021,09,13,20,00,00) datetime(2021,09,15,00,00,00) datetime(2021,09,15,00,00,00) datetime(2021,09,13,20,00,00)];
Y_1315=[-0.1 -0.1 0.1 0.1];

X_1921=[datetime(2021,09,19,00,00,00) datetime(2021,09,21,00,00,00) datetime(2021,09,21,00,00,00) datetime(2021,09,19,00,00,00)];
Y_1921=[-0.1 -0.1 0.1 0.1];

X_27_28=[datetime(2021,09,27,00,00,00) datetime(2021,09,28,06,00,00) datetime(2021,09,28,06,00,00) datetime(2021,09,27,00,00,00) ];
Y_27_28=[-0.1 -0.1 0.1 0.1];

X_29=[datetime(2021,09,28,18,00,00) datetime(2021,09,29,12,00,00) datetime(2021,09,29,12,00,00) datetime(2021,09,28,18,00,00)];
Y_29=[-0.1 -0.1 0.1 0.1];

X_29_03=[datetime(2021,09,29,12,00,00) datetime(2021,10,02,00,00,00) datetime(2021,10,02,00,00,00) datetime(2021,09,29,12,00,00)];
Y_29_03=[-0.1 -0.1 0.1 0.1];

X_03=[datetime(2021,10,02,12,00,00) datetime(2021,10,03,6,00,00) datetime(2021,10,3,6,00,00) datetime(2021,10,02,12,00,00)];
Y_03=[-0.1 -0.1 0.1 0.1];

X_03_05=[datetime(2021,10,03,6,00,00) datetime(2021,10,05,03,00,00) datetime(2021,10,05,03,00,00) datetime(2021,10,3,6,00,00) ];
Y_03_05=[-0.1 -0.1 0.1 0.1];

X_05=[datetime(2021,10,05,03,00,00) datetime(2021,10,05,20,00,00) datetime(2021,10,5,20,00,00) datetime(2021,10,05,03,00,00)];
Y_05=[-0.1 -0.1 0.1 0.1];

X_06=[datetime(2021,10,05,20,00,00) datetime(2021,10,06,12,00,00) datetime(2021,10,6,12,00,00) datetime(2021,10,05,20,00,00)];
Y_06=[-0.1 -0.1 0.1 0.1];

X_22=[datetime(2021,09,22,11,00,00) datetime(2021,09,25,00,00,00) datetime(2021,09,25,00,00,00) datetime(2021,09,22,11,00,00)];
Y_22=[-0.1 -0.1 0.1 0.1];

% p1=patch(X_1315,Y_1315,'black','FaceAlpha',.1,'EdgeColor','none'); hold on
% p2=patch(X_1921,Y_1921,'black','FaceAlpha',.1,'EdgeColor','none'); hold on


nexttile
    plot(datetime(eurecca2METtime(OSSI01Par(35:4717,1))),A(:,1),'g','LineWidth',1.3);hold on
    plot(datetime(eurecca2METtime(OSSI01Par(35:4717,1))),A(:,2),'k','LineWidth',1.3);hold on
    legend('1st PC', '2nd PC',Location=['northeast']);
    ylabel('Amplitude (m)')
    xticks(time);
    xticklabels('');
    xlim([timein datetime(2021,10,14,00,00,00)]);
    grid on
    text(0.01,0.90,charlbl{1},'Units','normalized','FontSize',12);hold on

nexttile
    yyaxis left
    p(1)=plot(datetime(eurecca2METtime(OSSI01Par(35:4717,1))),A(:,2),'k','LineWidth',1.3);
    ylabel('Amplitude (m)');
    xticks(time);
    xlim([timein timeout]);
    ylim([-0.08 0.08]);
    p1=patch(X_1315,Y_1315,'black','FaceAlpha',.2,'EdgeColor','none'); hold on
    p2=patch(X_1921,Y_1921,'black','FaceAlpha',.2,'EdgeColor','none'); hold on
    p5=patch(X_29,Y_29,'black','FaceAlpha',.2,'EdgeColor','none'); hold on
    p3=patch(X_03,Y_03,'black','FaceAlpha',.2,'EdgeColor','none'); hold on
    p4=patch(X_05,Y_05,'black','FaceAlpha',.2,'EdgeColor','none'); hold on
    p4=patch(X_22,Y_22,'b','FaceAlpha',.2,'EdgeColor','none'); hold on
    p6=patch(X_06,Y_06,'b','FaceAlpha',.1,'EdgeColor','none'); hold on
    p7=patch(X_03_05,Y_03_05,'b','FaceAlpha',.1,'EdgeColor','none'); hold on
    p7=patch(X_29_03,Y_29_03,'b','FaceAlpha',.1,'EdgeColor','none'); hold on
    p7=patch(X_27_28,Y_27_28,'b','FaceAlpha',.1,'EdgeColor','none'); hold on

    yyaxis right
    p(2)=scatter(datetime(eurecca2METtime(OSSI01Par(35:4717,1))),winddata(35:4717,3),'ob','SizeData',4);
    ylabel('Wind direction (\circ)');
    xticks(time);
    xlim([timein datetime(2021,10,14,00,00,00)]);
    yline(45,'b--','linewidth',1.5)
     yline(45+90,'b','linewidth',1.5)
     yline(45+180,'b--','linewidth',1.5)
     yticks([0:90:360]);
    ylim([0 360]);
    grid on
    text(0.01,0.90,charlbl{2},'Units','normalized','FontSize',12);hold on

legend(p,'2nd PC', 'Wind direction',Location='northeast')
% title('2^{nd} Principle component over wind direction')
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'b';
ax.XAxis.TickLabelFormat = 'dd-MM';
saveas(figure(2),[basePath 'analysis\waves\figures\wave_EOF.fig'])
saveas(figure(2),[basePath 'analysis\waves\figures\wave_EOF.png'])
% %%
% 
% [varargout] =ScatterWindRose(winddata(35:4717,3),winddata(35:4717,2),A(:,2));
% title({'2nd PC over wind speed and direction';'11 Sept- 18 Oct'});hold on
% plot([0 14],[51 51]);hold on
% 
% %%
% figure
% plot(A(:,1:2))
% 













