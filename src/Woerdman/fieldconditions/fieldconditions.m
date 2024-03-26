%% waterlevel from OSSI's
clear all;
close all;

% relevant paths
% cd('R:\Zandmotor');
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

%% initialization of time vectors and periods of interest
timein=datetime(2021,09,11,00,00,00);
timeout=datetime(2021,10,18,10,00,00);
time=[timein:2:timeout];

spring= [datetime(2021,09,09,00,00,00);datetime(2021,09,23,00,00,00);datetime(2021,10,08,00,00,00)];
neap=   [datetime(2021,09,15,00,00,00);datetime(2021,10,01,00,00,00);datetime(2021,10,15,00,00,00)];
%% define time axis entire field campaign
timein2=datetime(2021,09,11,00,00,00);
timeout2=datetime(2021,10,18,10,00,00);
time2=[timein2:minutes(10):timeout2];

%% wind parameters, create winddata double with time, speed and direction
windoctdekooy = importfile([basePath, 'dataRaw\windKNMI\wind_oct_dekooy.txt']);
winddata(:,1)=MET2eureccatime(datevec(time2));
winddata(:,2)=windoctdekooy.speed;
winddata(:,3)=windoctdekooy.direction;

%% create subplot labels
nIDs = 6;
alphabet = ('a':'z').';
chars = num2cell(alphabet(1:nIDs));
chars = chars.';
charlbl = strcat('(',chars,')'); % {'(a)','(b)','(c)','(d)'}

%% visualization wind and waterlevel
figure(1);
set(gcf, 'position',[100 50 700 700],'color','white')
t=tiledlayout(4,1,"Padding","compact","TileSpacing","tight");
% title(t,'Field Conditions entire campaign');
nexttile
%     set(gca,'fontsize',14,'FontWeight','bold'); hold on
    plot(datetime(eurecca2METtime(winddata(:,1))),winddata(:,2),'k'); hold on
%     title('Wind Speed');
    ylabel('v_{wind} (m/s)');
    yticks(0:5:15)
    ylim([0 15])
    xticks([time]);
    xticklabels('');
    xlim([timein timeout]);
%     text(0.005,0.90,charlbl{1},'Units','normalized','FontSize',12);hold on
set(gca, 'FontSize',16,'FontWeight','bold');
    grid on
nexttile
%     set(gca,'fontsize',14,'FontWeight','bold'); hold on
    scatter(datetime(eurecca2METtime(winddata(:,1))),winddata(:,3),'.k'); hold on
%     title('Wind Direction');
    yline(51,'k--','linewidth',1.5)
    yline(51+90,'k','linewidth',1.5)
    yline(51+180,'k--','linewidth',1.5)
    ylim([0 360])
    yticks([0 90 180 270 360]);
    ylabel('\theta_{wind} (\circ)');
    xticklabels('');
    xticks([time]);
    xlim([timein timeout]);
    text(0.005,0.90,charlbl{2},'Units','normalized','FontSize',12);hold on
    grid on
    set(gca, 'FontSize',16,'FontWeight','bold');
nexttile
%     set(gca,'fontsize',14,'FontWeight','bold'); hold on
    plot(datetime(eurecca2METtime(OSSI09Par(:,1))),OSSI09Par(:,10),'k','LineWidth',1.3);hold on
    xticks(time);
    xline(spring,'--g','linewidth',1.8);
    xline(neap,'--r','linewidth',1.8);
    yline(0)
    xlim([timein timeout]);
    xticklabels('');
    ylabel('\eta (m)');
    yticks(-1.4:0.7:1.4)
    ylim([-1.4 1.4]);
%     title('Water level');
    text(0.005,0.90,charlbl{3},'Units','normalized','FontSize',12);hold on
    grid on
set(gca, 'FontSize',16,'FontWeight','bold');
nexttile
%     set(gca,'fontsize',14,'FontWeight','bold'); hold on
    plot(datetime(eurecca2METtime(OSSI09Par(:,1))),OSSI09Par(:,11),'k','LineWidth',1.3);
    xticks(time);
    xline(spring,'--g','linewidth',1.8);
    xline(neap,'--r','linewidth',1.8);
    xlim([timein timeout]);
    ylabel('\eta_{res} (m)');
    yticks(-0.1:0.1:0.4)
    ylim([-0.1 0.4]);
%     title('Residual water level');
    text(0.005,0.90,charlbl{4},'Units','normalized','FontSize',12);hold on
    grid on
    set(gca, 'FontSize',16,'FontWeight','bold');
saveas(figure(1),[basePath '\analysis\fieldconditions\figures\fieldconditions.fig'])
saveas(figure(1),[basePath '\analysis\fieldconditions\figures\fieldconditions.png'])


%% residual flow over windparameters

figure(2);
[varargout] =ScatterWindRose(winddata(151:5239,3),winddata(151:5239,2),OSSI09Par(151:5239,11));
title({'Residual water level over wind speed/direction';'11 Sept- 18 Oct'});hold on
plot([0 14],[51 51]);hold on

saveas(figure(2),[basePath '\analysis\fieldconditions\figures\H_res_wind.fig'])
saveas(figure(2),[basePath '\analysis\fieldconditions\figures\H_res_wind.png'])



%% 
[x1, loc1]=findpeaks(smoothdata(OSSI09Par(:,10),'lowess'));

[y,loc2]=findpeaks(-smoothdata(OSSI09Par(:,10),'lowess'));

figure(1)
x=x1(2:73);
plot(time2(loc1(:,:)),x1);hold on
plot(time2(loc2),-y);
plot(time2(loc2),(x+y));
    xline(spring,'--g','linewidth',1.3);
    xline(neap,'--r','linewidth',1.3);

% plot(OSSI09Par(:,11)); hold on
figure(2)
plot(x);hold on
plot(-y);
plot((x+y));

%%










