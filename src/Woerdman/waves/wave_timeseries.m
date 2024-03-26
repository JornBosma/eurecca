%% Hs analyses over time
clear all;
close all;

sedmexInit;
global basePath;

% Open result data BaseParameters
myFolder = [basePath, 'results'];
filePattern = fullfile(myFolder, 'baseParametersOSSI*.mat');
matFiles = dir(filePattern);
      for i = 1:length(matFiles)
          baseFileName = fullfile(myFolder, matFiles(i).name);
          ref_files{i} = load(baseFileName);
      end
OSSI01Par= ref_files{1,1}.OSSI01Par;
OSSI09Par= ref_files{1,2}.OSSI04Par;
OSSI04Par= ref_files{1,3}.OSSI05Par;
OSSI05Par= ref_files{1,4}.OSSI06Par;
OSSI06Par= ref_files{1,5}.OSSI09Par;

%% initialization of time vectors and periods of interest
timein=datetime(2021,09,11,00,00,00);
timeout=datetime(2021,10,18,10,00,00);
time=[timein:2:timeout];

%% create subplot labels
nIDs = 6;
alphabet = ('a':'z').';
chars = num2cell(alphabet(1:nIDs));
chars = chars.';
charlbl = strcat('(',chars,')'); % {'(a)','(b)','(c)','(d)'}

%%
figure(1)
set(gcf, 'position',[100 50 700 600],'color','white')
t=tiledlayout(3,1,"Padding","compact","TileSpacing","tight");
% title(t,'Wave characteristics [L2]');

nexttile
    plot(datetime(eurecca2METtime(OSSI09Par(:,1))),OSSI09Par(:,4),'k',LineWidth=1);
%     set(gca,'fontsize',10,'FontWeight','bold'); hold on
    xticks(time);
    xlim([timein timeout]);
    xticklabels('');
    ylim([0 0.6]);
    ylabel('Hs (m)')
    grid on
% text(0.01,0.90,charlbl{1},'Units','normalized','FontSize',12);hold on
set(gca,'fontsize',16,'fontweight','bold')
nexttile
    plot(datetime(eurecca2METtime(OSSI09Par(:,1))),OSSI09Par(:,9),'k',LineWidth=1);
%     set(gca,'fontsize',10,'FontWeight','bold'); hold on
    xticks(time);
    xticklabels('');
    xlim([timein timeout])
    ylim([0 7]);
    ylabel('T_{m-10} (s)')
    grid on
% text(0.01,0.90,charlbl{2},'Units','normalized','FontSize',12);hold on
set(gca,'fontsize',16,'fontweight','bold')

nexttile
Hs_h=(OSSI09Par(:,4)./OSSI09Par(:,2));
aboveLine = (Hs_h>=0.285);
surf=Hs_h; surf(~aboveLine)=NaN;

    plot(datetime(eurecca2METtime(OSSI09Par(:,1))),(Hs_h),'k',LineWidth=1);hold on
    plot(datetime(eurecca2METtime(OSSI09Par(:,1))),surf,'r',LineWidth=1);hold on
%     set(gca,'fontsize',10,'FontWeight','bold'); hold on
    xticks(time);
    xlim([timein timeout]);
    ylabel('Hs/h (-)')
    yline(0.3,'--','Surfzone',FontSize=14,FontName='times new roman',LineWidth=1.3);
    grid on
    set(gca,'fontsize',16,'fontweight','bold')
% text(0.01,0.90,charlbl{3},'Units','normalized','FontSize',12);hold on
saveas(figure(1),[basePath '\analysis\waves\figures\wave_timeseries.fig']);
saveas(figure(1),[basePath '\analysis\waves\figures\wave_timeseries.png']);

%%

figure(2)
set(gcf, 'position',[100 50 500 500],'color','white')
    scatter(OSSI01Par(:,4),OSSI01Par(:,9),'.k'); hold on
    scatter(OSSI09Par(:,4),OSSI09Par(:,9),'ok','SizeData',7)
    scatter(OSSI04Par(:,4),OSSI04Par(:,9),'*k','SizeData',12)
    scatter(OSSI05Par(:,4),OSSI05Par(:,9),'xk','SizeData',10)
    scatter(OSSI06Par(:,4),OSSI06Par(:,9),'+k','SizeData',7)
    xlabel('Hs [m]');
    ylabel('Tm_{10} [s]');
    legend('L1','L2','L4','L5','L6'); legend boxoff
    set(gca,'fontsize',10,'FontWeight','bold'); hold on
saveas(figure(2),[basePath '\analysis\waves\figures\height_period.fig']);
saveas(figure(2),[basePath '\analysis\waves\figures\height_period.png']);

%%
% 
% figure()
% subplot(411)
% plot(OSSI01Par(:,4)) 
% subplot(412)
% plot(OSSI01Par(:,9))
% 
% id=find(OSSI01Par(:,4) >nanmean(OSSI01Par(:,4)));
% subplot(413)
% plot(OSSI01Par(id,4))
% subplot(414)
% plot(OSSI01Par(id,9))

%%
OSSI06Par=OSSI06Par;

figure()
subplot(411)
plot(OSSI06Par(:,4)) 
subplot(412)
plot(OSSI06Par(:,9))

id=find(OSSI06Par(:,4)>nanmean(OSSI06Par(:,4)));
subplot(413)
plot(OSSI06Par(id,4))
subplot(414)
plot(OSSI06Par(id,9))


%%



