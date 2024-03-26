clear all;
close all;

% relevant paths
% cd('R:\Zandmotor');
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
L2C10VEC(3100:4033,2:19)=NaN;

%% Open result data BaseParameters
myFolder = [basePath, 'results'];
filePattern = fullfile(myFolder, 'baseParametersOSSI*.mat');
matFiles = dir(filePattern);
      for i = 1:length(matFiles)
          baseFileName = fullfile(myFolder, matFiles(i).name);
          ref_files{i} = load(baseFileName);
          vars = fieldnames(ref_files{i});
          varnames{i}=fieldnames(ref_files{i});
             for j = 1
            assignin('base', vars{j}, ref_files{i}.(vars{j}));
            end
      end


%% time axis for plotting
timein=datetime(2021,09,11,00,00,00);
timeout=datetime(2021,10,18,10,00,00);
time=[timein:2:timeout];
reftime=[timein:minutes(10):timeout]';

spring= [datetime(2021,09,09,00,00,00);datetime(2021,09,23,00,00,00);datetime(2021,10,08,00,00,00)];
neap=   [datetime(2021,09,15,00,00,00);datetime(2021,10,01,00,00,00);datetime(2021,10,15,00,00,00)];


%% create subplot labels
nIDs = 6;
alphabet = ('a':'z').';
chars = num2cell(alphabet(1:nIDs));
chars = chars.';
charlbl = strcat('(',chars,')'); % {'(a)','(b)','(c)','(d)'}

%% current plots
figure(1);
fig1_comps.fig = gcf;
set(gcf, 'position',[100 50 700 600],'color','white')

tiledlayout(3,1,'TileSpacing','tight','Padding','compact')
nexttile
%patch highlight;
X_27=[datetime(2021,09,27,6,00,00) datetime(2021,09,28,00,00,00) datetime(2021,09,28,00,00,00) datetime(2021,09,27,6,00,00)];
Y_27=[-0.5 -0.5 0.5 0.5];
p1=patch(X_27,Y_27,'black','FaceAlpha',.1,'EdgeColor','none'); hold on

X_30=[datetime(2021,09,30,6,00,00) datetime(2021,10,02,00,00,00) datetime(2021,10,02,00,00,00) datetime(2021,09,30,06,00,00)];
Y_30=[-0.5 -0.5 0.5 0.5];
p2=patch(X_30,Y_30,'black','FaceAlpha',.1,'EdgeColor','none'); hold on

    p(1)=plot(datetime(eurecca2METtime(L2C10VEC(:,1))),L2C10VEC(:,2)); hold on
    p(2)=plot(datetime(eurecca2METtime(L2C10VEC(:,1))),L2C10VEC(:,3),'k','LineWidth',1.3); hold on
    set(gca,'YColor','k')
    ylabel('U (m/s)');
    ax = gca;
    ax.YTick= [-.50:0.2:0.5];
    ax.YLim= [-0.5 0.5];

ax = gca;
ax.XTick= [time];
xlim ([timein timeout]);
text(0.025,0.95,charlbl{1},'Units','normalized','FontSize',12);hold on
    xline(spring,'--g','linewidth',1.3);hold on
    xline(neap,'--r','linewidth',1.3);
    yline(0)
grid on
t = datetime(eurecca2METtime(L2C10VEC(:,1)));
A = L2C10VEC(:,2);
TF_flood = islocalmax(A,'MinSeparation',minutes(10*60),'SamplePoints',t);
TF_flood(1237)= 0;
TF_flood(3099)= 0;
p(3)=plot(t(TF_flood),A(TF_flood),'r*'); hold on
avrg_flood=mean(A(TF_flood))

t = datetime(eurecca2METtime(L2C10VEC(:,1)));
B = L2C10VEC(:,2);
TF_ebb = islocalmin(B,'MinSeparation',minutes(10*60),'SamplePoints',t);
p(4)=plot(t(TF_ebb),B(TF_ebb),'b*') 
avrg_ebb=mean(B(TF_ebb))
yline(avrg_flood,'-.r',LineWidth=1.2);
yline(avrg_ebb,'-.b',LineWidth=1.2);
yline(0)

legend(p,'longshore','cross-shore','peak flood','peak ebb','Orientation','horizontal',Location='southeast')
legend box off

nexttile
    plot(datetime(eurecca2METtime(L2C10VEC(:,1))),L2C10VEC(:,13)); hold on
    ylabel('U_{residual} (m/s)');
    ax = gca;
    ax.YTick= [-.25:0.1:0.25];
    ax.YLim= [-0.25 0.25];

yline(0)
ax = gca;
ax.XTick= [time];
xlim ([timein timeout]);
text(0.025,0.95,charlbl{2},'Units','normalized','FontSize',12);hold on
grid on

nexttile
    yyaxis left
    p(1)=plot(datetime(eurecca2METtime(L2C10VEC(:,1))),L2C10VEC(:,2)); hold on
    p(2)=plot(datetime(eurecca2METtime(L2C10VEC(:,1))),L2C10VEC(:,3),'-k','LineWidth',1.3); hold on
    ylim([-0.4 0.4]);
    ylabel('U (m/s)');
    yyaxis right
    plot(datetime(eurecca2METtime(L2C10VEC(:,1))),OSSI09Par(:,10),'--k');hold on
    xlim([datetime(2021,10,11,0,00,00) datetime(2021,10,13,0,00,00)])
    ylim([-2 2]) ;
    ylabel('\eta (m)');
    text(0.025,0.95,charlbl{3},'Units','normalized','FontSize',12);hold on
    legend('longshore','cross-shore','water level','Location','south','Orientation','horizontal');
    legend box off
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';

% 
% saveas(figure(1),[basePath '\analysis\currents\figures\current_timeseries.fig'])
% saveas(figure(1),[basePath '\analysis\currents\figures\current_timeseries.png'])

