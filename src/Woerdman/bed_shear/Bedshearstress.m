%% bedshearstresses for OSSI locations
clear all;
close all;

sedmexInit;
global basePath;

%% Open result data BaseParameters ADV
myFolder = [basePath, 'results'];
filePattern = fullfile(myFolder, '*VEC*.mat');
matFiles = dir(filePattern);
      for i = 1:length(matFiles)
          baseFileName = fullfile(myFolder, matFiles(i).name);
          ref_files{i} = load(baseFileName);
          vars = fieldnames(ref_files{i});
          varnames{i}=fieldnames(ref_files{i});
             for j = 1:length(vars)
            assignin('base', vars{j}, ref_files{i}.(vars{j}));
            end
      end

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

%% calculate bedshear stresses
D10=[272 451] *10^-6;
D50=[557 1334]*10^-6;
D90=[1939 4105]*10^-6;

Tc=size([length(OSSI09Par) 2]);
Tw=size([length(OSSI09Par) 2]);
Tcw=size([length(OSSI09Par) 2]);

% [Tc, Tw, Tcw]= bedshear_start(T,Hs,h,U,D50,phi_c,phi_w);
for j=1:2
    for i=1:length(OSSI09Par)
    [Tc(i,1,j), Tw(i,1,j), Tcw(i,1,j)]= bedshear_start(OSSI01Par(i,9),OSSI01Par(i,4),OSSI01Par(i,2),L1C1VEC(i,11),D50(j),wrapTo360(L1C1VEC(i,12)),L1C1VEC(i,6)+90);
    [Tc(i,2,j), Tw(i,2,j), Tcw(i,2,j)]= bedshear_start(OSSI09Par(i,9),OSSI09Par(i,4),OSSI09Par(i,2),L2C10VEC(i,11),D50(j),wrapTo360(L2C10VEC(i,12)),L2C10VEC(i,6)+90);
    [Tc(i,3,j), Tw(i,3,j), Tcw(i,3,j)]= bedshear_start(OSSI04Par(i,9),OSSI04Par(i,4),OSSI04Par(i,2),L4C1VEC(i,11),D50(j),wrapTo360(L4C1VEC(i,12)),L4C1VEC(i,6)+90);
    [Tc(i,4,j), Tw(i,4,j), Tcw(i,4,j)]= bedshear_start(OSSI05Par(i,9),OSSI05Par(i,4),OSSI05Par(i,2),L5C1VEC(i,11),D50(j),wrapTo360(L5C1VEC(i,12)),L5C1VEC(i,6)+90);
    [Tc(i,5,j), Tw(i,5,j), Tcw(i,5,j)]= bedshear_start(OSSI06Par(i,9),OSSI06Par(i,4),OSSI06Par(i,2),L6C1VEC(i,11),D50(j),wrapTo360(L6C1VEC(i,12)),L6C1VEC(i,6)+90);
    end
end
save('bed_shear_stresses','Tc','Tw','Tcw')

%% visualizations: wave Bedshear stress
timein=datetime(2021,09,11,00,00,00);
timeout=datetime(2021,10,18,10,00,00);
time=[timein:4:timeout];
nIDs = 6;
alphabet = ('a':'z').';
chars = num2cell(alphabet(1:nIDs));
chars = chars.';
charlbl = strcat('(',chars,')'); % {'(a)','(b)','(c)','(d)'}

colormap jet
cmap = flipud(colormap);

figure3= figure(1);
set(gcf, 'position',[100 50 800 700],'color','white')
tiledlayout(3,2,Padding="compact",TileSpacing="tight")
nexttile
     title('Medium coarse grains'); hold on
    for n=1:5
        plot_color = cmap(n*42,:);
        plot(datetime(eurecca2METtime(OSSI01Par(:,1))),Tw(:,n,1),'LineWidth',1.3,'Color',plot_color); hold on
    end
    yline(0.18,'--','\tau_{e,D10}',LineWidth=1.2);hold on
    yline(0.28,'--','\tau_{e,D50}',LineWidth=1.2);
    yline(1.22,'--','\tau_{e,D90}',LineWidth=1.2);
    
    xticks(time);
    xticklabels('');
    xlim([timein timeout]); %ylim([0 4]);
    ylabel('\tau_{w} (N/m^2)');
    legend('L1','L2','L4','L5','L6','Location','west');legend box off
text(0.025,0.90,charlbl{1},'Units','normalized','FontSize',12);hold on
grid on
box on
nexttile
    title('Coarse grains'); hold on
    for n=1:5
        plot_color = cmap(n*42,:);
        plot(datetime(eurecca2METtime(OSSI01Par(:,1))),Tw(:,n,2),'LineWidth',1.3,'Color',plot_color); hold on
    end
    yline(0.25,'--','\tau_{e,D10}',LineWidth=1.2);hold on
    yline(0.79,'--','\tau_{e,D50}',LineWidth=1.2);
    yline(3.42,'--','\tau_{e,D90}',LineWidth=1.2);
    
    xticks(time);
    xticklabels('');
    xlim([timein timeout]); %ylim([0 4]);
%     ylabel('\tau_{w} (N/m^2)');
    legend('L1','L2','L4','L5','L6','Location','west'); legend box off

text(0.025,0.90,charlbl{2},'Units','normalized','FontSize',12);hold on
grid on
box on
%% visualizations:  current bed shear

nexttile
%     title('current bedshear stress [D50=557 \mum]'); hold on
    for n=1:5
        plot_color = cmap(n*42,:);
        plot(datetime(eurecca2METtime(OSSI01Par(:,1))),Tc(:,n,1),'LineWidth',1.3,'Color',plot_color); hold on
    end
    yline(0.18,'--','\tau_{e,D10}',LineWidth=1.2);hold on
    yline(0.28,'--','\tau_{e,D50}',LineWidth=1.2);
    yline(1.22,'--','\tau_{e,D90}',LineWidth=1.2);
    
    xticks(time);
    xticklabels('');
    xlim([timein timeout]);% ylim([0 4]);
    ylim([0 1.5]);
    ylabel('\tau_{c} (N/m^2)');
%     legend('L1', 'L2','L4','L5','L6','Location','northeast'); legend boxoff

    text(0.025,0.90,charlbl{3},'Units','normalized','FontSize',12);hold on
grid on
box on
nexttile
%     title('Current bedshear stress [D50=1334 \mum]'); hold on
    for n=1:5
        plot_color = cmap(n*42,:);
        plot(datetime(eurecca2METtime(OSSI01Par(:,1))),Tc(:,n,2),'LineWidth',1.3,'Color',plot_color); hold on
    end
    yline(0.25,'--','\tau_{e,D10}',LineWidth=1.2);hold on
    yline(0.79,'--','\tau_{e,D50}',LineWidth=1.2);
    yline(3.42,'--','\tau_{e,D90}',LineWidth=1.2);
    
    xticks(time);
    xticklabels('');
    xlim([timein timeout]);% ylim([0 4]);
    ylim([0 1.5]);
%     ylabel('\tau_{c} (N/m^2)');
%     legend('L1', 'L2','L4','L5','L6','Location','east'); legend boxoff

% saveas(figure(1),[basePath '\wave analysis\figures\bedshearstress.fig']);
text(0.025,0.90,charlbl{4},'Units','normalized','FontSize',12);hold on
grid on
%% visualizations: combined bed shear

nexttile
%     title('Combined bedshear stress [D50=557 \mum]'); hold on
    for n=1:5
        plot_color = cmap(n*42,:);
        plot(datetime(eurecca2METtime(OSSI01Par(:,1))),Tcw(:,n,1),'LineWidth',1.3,'Color',plot_color); hold on
    end
    yline(0.18,'--','\tau_{e,D10}',LineWidth=1.2);hold on
    yline(0.28,'--','\tau_{e,D50}',LineWidth=1.2);
    yline(1.22,'--','\tau_{e,D90}',LineWidth=1.2);
    
    xticks(time);
    xlim([timein timeout]);% ylim([0 4]);
    ylim([0 4.5]);
    ylabel('\tau_{cw} (N/m^2)');
%     legend('L1', 'L2','L4','L5','L6','Location','east'); legend boxoff

    text(0.025,0.90,charlbl{5},'Units','normalized','FontSize',12);hold on
grid on
nexttile
%     title('Combined bedshear stress [D50=1334 \mum]'); hold on
    for n=1:5
        plot_color = cmap(n*42,:);
        plot(datetime(eurecca2METtime(OSSI01Par(:,1))),Tcw(:,n,2),'LineWidth',1.3,'Color',plot_color); hold on
    end
    yline(0.25,'--','\tau_{e,D10}',LineWidth=1.2);hold on
    yline(0.79,'--','\tau_{e,D50}',LineWidth=1.2);
    yline(3.42,'--','\tau_{e,D90}',LineWidth=1.2);
    
    xticks(time);
    xlim([timein timeout]);
    ylim([0 4.5]);
%     ylabel('\tau_{cw} (N/m^2)'); 
%     legend('L1', 'L2','L4','L5','L6','Location','east'); legend boxoff

text(0.025,0.90,charlbl{6},'Units','normalized','FontSize',12);hold on
grid on


saveas(figure(1),[basePath '\analysis\bed_shear\figures\bedshear.fig']);
saveas(figure(1),[basePath '\analysis\bed_shear\figures\bedshear.png']);

%% visualizations: averaged 
nIDs = 6;
alphabet = ('a':'z').';
chars = num2cell(alphabet(1:nIDs));
chars = chars.';
charlbl = strcat('(',chars,')'); % {'(a)','(b)','(c)','(d)'}

average_Tcw(:,1)= mean(Tcw(:,:,1),'omitnan');
average_Tcw(:,2)= mean(Tcw(:,:,2),'omitnan');
% std_Tcw(:,1)= std(Tcw(:,:,1),'omitnan');
% std_Tcw(:,2)=std(Tcw(:,:,2),'omitnan');
std_Tcw(:,1)= prctile(Tcw(:,:,1),75);
std_Tcw(:,2)= prctile(Tcw(:,:,2),75);%'omitnan');
label={'L1','L2','L4','L5','L6'};

figure(100);
set(gcf, 'position',[100 50 800 400],'color','white')
% scatter((1:5),average_Tcw(:,1),'diamond','filled','SizeData',45);hold on
errorbar((0.9:4.9),average_Tcw(:,1),std_Tcw(:,1),'o');hold on
errorbar((1.1:5.1),average_Tcw(:,2),std_Tcw(:,2),'o');
% scatter((1:5),average_Tcw(:,2),'diamond','filled','SizeData',45);hold on
    yline(0.18,'--','  \tau_{e,  D10 = 0.3 mm}',FontWeight='bold', FontSize=14,LabelHorizontalAlignment='left');hold on
    yline(0.28,'--','  \tau_{e,  D50 = 0.6 mm}',FontWeight='bold', FontSize=14,LabelHorizontalAlignment='left');
    xticks(1:5); xticklabels(label);
    xlim([0 6]);
%    ylim([0 2]);
ylabel({'Total bed shear stress'; '\tau_{cw} (Pa)'});
xlabel('Alongshore location');
set(gca,'fontsize',14,'FontWeight','bold');
% text(0.025,0.90,charlbl{2},'Units','normalized','FontSize',12);hold on




%%
stats.average_Tcw(:,1)= mean(Tcw(:,:,1),'omitnan');
stats.average_Tcw(:,2)= mean(Tcw(:,:,2),'omitnan');
stats.max_Tcw(:,1)= max(Tcw(:,:,1));
stats.max_Tcw(:,2)= max(Tcw(:,:,2));
stats.std_Tcw(:,1)= std(Tcw(:,:,1),'omitnan');
stats.std_Tcw(:,2)=std(Tcw(:,:,2),'omitnan');


stats.average_Tc(:,1)= mean(Tc(:,:,1),'omitnan');
stats.average_Tc(:,2)= mean(Tc(:,:,2),'omitnan');
stats.max_Tc(:,1)= max(Tc(:,:,1));
stats.max_Tc(:,2)= max(Tc(:,:,2));
stats.std_Tc(:,1)= std(Tc(:,:,1),'omitnan');
stats.std_Tc(:,2)=std(Tc(:,:,2),'omitnan');

stats.average_Tw(:,1)= mean(Tw(:,:,1),'omitnan');
stats.average_Tw(:,2)= mean(Tw(:,:,2),'omitnan');
stats.max_Tw(:,1)= max(Tw(:,:,1));
stats.max_Tw(:,2)= max(Tw(:,:,2));
stats.std_Tw(:,1)= std(Tw(:,:,1),'omitnan');
stats.std_Tw(:,2)=std(Tw(:,:,2),'omitnan');



