%% wind parameters over residual flow L2
clear all
close all

sedmexInit;
global basePath;
PS = PLOT_STANDARDS();

%% Open result data BaseParameters
myFolder = [basePath, 'results'];
filePattern = fullfile(myFolder, '*VEC*.mat');
matFiles = dir(filePattern);
      for i = 1:length(matFiles)
          baseFileName = fullfile(myFolder, matFiles(i).name);
          ref_files{i} = load(baseFileName);
      end
            
L2C10VEC=ref_files{1,2}.L2C10VEC;
L2C10VEC(3100:4033,:)=NaN;
L1C1VEC=ref_files{1,1}.L1C1VEC;

%% Open result data BaseParameters
myFolder = [basePath, 'results'];
filePattern = fullfile(myFolder, 'baseParametersOSSI*.mat');
matFiles = dir(filePattern);
      for i = 1:length(matFiles)
          baseFileName = fullfile(myFolder, matFiles(i).name);
          ref_files{i} = load(baseFileName);
      end

OSSI09Par= ref_files{1,5}.OSSI09Par;
%% define time axis entire field campaign
timein2=datetime(2021,09,11,00,00,00);
timeout2=datetime(2021,10,18,10,00,00);
time2=[timein2:minutes(10):timeout2]';

timein=datetime(2021,09,12,00,00,00);
timeout=datetime(2021,10,18,10,00,00);
time=[timein:2:timeout];


id=find(time2 == datetime(2021,10,05,00,00,00));
range=[1:id];

nIDs = 6;
alphabet = ('a':'z').';
chars = num2cell(alphabet(1:nIDs));
chars = chars.';
charlbl = strcat('(',chars,')'); % {'(a)','(b)','(c)','(d)'}


%% wind parameters, create winddata double with time, speed and direction
windoctdekooy = importfile([basePath, 'dataRaw\windKNMI\wind_oct_dekooy.txt']);
winddata(:,1)=MET2eureccatime(datevec(time2));
winddata(:,2)=windoctdekooy.speed;
winddata(:,3)=windoctdekooy.direction;

%%

figure(1);
tiledlayout(3,4);
set(gcf, 'position',[100 50 1200 700],'color','white')

nexttile(1,[1 4]);
    yyaxis left
    plot(datetime(eurecca2METtime(L2C10VEC(:,1))),L2C10VEC(:,13),'LineWidth',1.3);
    ylabel('UL_{residual} (m/s)');
    set(gca,'FontSize',12)

    yyaxis right
    plot(datetime(eurecca2METtime(OSSI09Par(:,1))),OSSI09Par(:,11),'LineWidth',1.3);
    ylabel('\eta_{residual} (m)');
    set(gca,'FontSize',12)
    yline(0);    
    ax = gca;
    ax.XTick= [time];
    xlim ([timein timeout]);
    ax.XAxis.FontWeight = 'bold';
    
    grid on
text(0.025,0.90,charlbl{1},'Units','normalized','FontSize',12);hold on


R1 = corrcoef(L2C10VEC(:,13),OSSI09Par(:,11),'rows','complete');    
nexttile(5,[2 2]);
text(0.025,0.90,charlbl{2},'Units','normalized','FontSize',12);hold on
    scatter(L2C10VEC(:,13),OSSI09Par(:,11),'.');
    hline= refline();
    hline.Color = 'k';
    hline.LineStyle = '--';
    hline.LineWidth = 1.5;
    ylabel('\eta_{residual} (m)');
    xlabel('UL_{residual} (m/s)');
    set(gca,'FontSize',12)
    text(0.025,0.75,{'R^2=' num2str(R1(1,2))},'Units','normalized','FontSize',10); hold on
    
R2 = corrcoef(L2C10VEC(range,14),OSSI09Par(range,11),'rows','complete');


%%
% nexttile(7,[2 2]);
figure
id= find(L2C10VEC(:,13)>=0 |L2C10VEC(:,13)<=0  );
[varargout] =ScatterWindRose(winddata(id,3),winddata(id,2),L2C10VEC(id,13));
title({'Residual longshore flow over wind parameters';'11 Sept- 18 Oct'},'fontWeight','normal');hold on
%  text(0.025,0.90,charlbl{3},'Units','normalized','FontSize',12);hold on

% saveas(figure(1),[basePath '\analysis\currents\figures\resflow_wind.fig']);
% saveas(figure(1),[basePath '\analysis\currents\figures\resflow_wind.png']);
%     scatter(L2C10VEC(range,14),OSSI09Par(range,11),'.');




%%
figure(5)
set(gcf, 'position',[100 50 1200 700],'color','white')
tiledlayout(2,1);
nexttile
    plot(datetime(eurecca2METtime(OSSI09Par(range,1))),OSSI09Par(range,4));
    ylabel('Hs [m]');
      
    ax = gca;
    ax.XTick= [time];
    xlim ([time2(range(1)) time2(range(end))]);
    ax.XAxis.FontWeight = 'bold';
    grid on
text(0.025,0.90,charlbl{1},'Units','normalized','FontSize',12);hold on

nexttile
    plot(datetime(eurecca2METtime(L2C10VEC(range,1))),L2C10VEC(range,14));hold on
    ylabel('UC_{residual} [m/s]');
    ax = gca;
    ax.XTick= [time];
    xlim ([time2(range(1)) time2(range(end))]);
    ax.XAxis.FontWeight = 'bold';
    grid on
text(0.025,0.90,charlbl{2},'Units','normalized','FontSize',12);hold on

figure(6)
R3 = corrcoef(L2C10VEC(range,14),OSSI09Par(range,4),'rows','complete');
    scatter(L2C10VEC(range,14),OSSI09Par(range,4),'.');hold on
    hline= refline();
    hline.Color = 'k';
    hline.LineStyle = '--';
    hline.LineWidth = 1.5;
    ylabel('Hs[m]');
    xlabel('UC_{residual} [m/s]');
    text(0.025,0.75,{'R^2=' num2str(R3(1,2))},'Units','normalized','FontSize',10); hold on



% %% residual flow over wind parameters
% 
% % scatter(winddata(1:end,2),L2C10VEC(1:end,13));
% id= find(L2C10VEC(:,13)>=0 |L2C10VEC(:,13)<=0  );
% 
% figure(3);
% [varargout] =ScatterWindRose(winddata(id,3),winddata(id,2),L2C10VEC(id,13));
% title({'Residual longshore flow over wind parameters';'11 Sept- 18 Oct'});hold on
% 
% 
% %%
% figure(4);
% [varargout] =ScatterWindRose(winddata(:,3),winddata(:,2),OSSI09Par(:,11));
% title({'Residual water level over wind parameters';'11 Sept- 18 Oct'});hold on
% 
% %%
% figure(4);
% [varargout] =ScatterWindRose(L2C10VEC(range,6)',OSSI09Par(range,4)',L2C10VEC(range,13));


