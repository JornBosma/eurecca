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
            
L1C1VEC= ref_files{1,1}.L1C1VEC(:,:);
L2C10VEC=ref_files{1,2}.L2C10VEC;
L3C1VEC= ref_files{1,3}.L3C1VEC(:,:);
L4C1VEC= ref_files{1,4}.L4C1VEC(:,:);
L5C1VEC= ref_files{1,5}.L5C1VEC(:,:);
L6C1VEC= ref_files{1,6}.L6C1VEC(:,:);


%% comparison under south western winds
% time axis for plotting
timein=datetime(2021,09,11,00,00,00);
timeout=datetime(2021,10,18,10,00,00);
time=[timein:2:timeout];

% create subplot labels
nIDs = 6;
alphabet = ('a':'z').';
chars = num2cell(alphabet(1:nIDs));
chars = chars.';
charlbl = strcat('(',chars,')'); % {'(a)','(b)','(c)','(d)'}

%%
range=[datetime(2021,09,26,18,00,00):hours(6):datetime(2021,09,28,00,00,00)];

figure(1);
fig1_comps.fig = gcf;
set(gcf, 'position',[100 50 1000 400],'color','white')
subplot(211);
    fig1_comps.p1 = plot(datetime(eurecca2METtime(L2C10VEC(:,1))),L2C10VEC(:,2)); hold on
    fig1_comps.p2 = plot(datetime(eurecca2METtime(L3C1VEC(:,1))),L3C1VEC(:,2)); hold on
    fig1_comps.p3 = plot(datetime(eurecca2METtime(L4C1VEC(:,1))),L4C1VEC(:,2)); hold on
    fig1_comps.p4 = plot(datetime(eurecca2METtime(L5C1VEC(:,1))),L5C1VEC(:,2)); hold on
    fig1_comps.p5 = plot(datetime(eurecca2METtime(L6C1VEC(:,1))),L6C1VEC(:,2)); hold on
        ylabel('U_{Long} [m/s]');
        ax = gca;
        ax.YTick= [-.50:0.25:0.5];
        ax.YLim= [-0.5 0.5];
        yline(0)
        legend('L2','L3','L4','L5','L6',Location='southeast');
        ax = gca;
        ax.XTick= [range];
        xlim ([range(1) range(end)]);
        ax = gca;
        ax.XTick= [range];
        xlim ([range(1) range(end)]);

subplot(212)
    fig1_comps.p1 = plot(datetime(eurecca2METtime(L2C10VEC(:,1))),L2C10VEC(:,3)); hold on
    fig1_comps.p2 = plot(datetime(eurecca2METtime(L3C1VEC(:,1))),L3C1VEC(:,3)); hold on
    fig1_comps.p3 = plot(datetime(eurecca2METtime(L4C1VEC(:,1))),L4C1VEC(:,3)); hold on
    fig1_comps.p4 = plot(datetime(eurecca2METtime(L5C1VEC(:,1))),L5C1VEC(:,3)); hold on
    fig1_comps.p5 = plot(datetime(eurecca2METtime(L6C1VEC(:,1))),L6C1VEC(:,3)); hold on
        ax = gca;
        ax.XTick= [range];
        xlim ([range(1) range(end)]);
        ax = gca;
        ax.XTick= [range];
        xlim ([range(1) range(end)]);
        ylabel('U_{Cross} [m/s]');
        ax = gca;
      

        yline(0)
    ax = gca;
    ax.XTick= [range];
    xlim ([range(1) range(end)]);

saveas(figure(1),[basePath '\analysis\currents\figures\flowcomparison.fig']);
saveas(figure(1),[basePath '\analysis\currents\figures\flowcomparison.png']);

%% nontidal behaviour near NIOZ
% time axis for plotting
timein=datetime(2021,09,11,00,00,00);
timeout=datetime(2021,10,18,10,00,00);
time=[timein:2:timeout];

range=[datetime(2021,09,21,00,00,00):hours(6):datetime(2021,09,23,00,00,00)];

X_0305=[datetime(2021,09,21,03,10,00) datetime(2021,09,21,05,40,00) datetime(2021,09,21,05,40,00) datetime(2021,09,21,03,10,00)];
Y_0305=[-0.5 -0.5 0.5 0.5];

X_0509=[datetime(2021,09,21,05,40,00) datetime(2021,09,21,09,20,00) datetime(2021,09,21,09,20,00) datetime(2021,09,21,05,40,00)];
Y_0509=[-0.5 -0.5 0.5 0.5];

X_0913=[datetime(2021,09,21,09,20,00) datetime(2021,09,21,13,20,00) datetime(2021,09,21,13,20,00) datetime(2021,09,21,09,20,00)];
Y_0913=[-0.5 -0.5 0.5 0.5];

X_1316=[datetime(2021,09,21,13,20,00) datetime(2021,09,21,16,20,00) datetime(2021,09,21,16,20,00) datetime(2021,09,21,13,20,00)];
Y_1316=[-0.5 -0.5 0.5 0.5];


figure(2)
tiledlayout(2,3,'Padding','compact','TileSpacing','tight');

nexttile(1,[1 2])
fig2_comps.fig = gcf;
set(gcf, 'position',[100 50 1000 600],'color','white')
    fig2_comps.p11 = plot(datetime(eurecca2METtime(L2C10VEC(:,1))),L2C10VEC(:,2),'-b'); hold on
    fig2_comps.p14 = plot(datetime(eurecca2METtime(L5C1VEC(:,1))),L5C1VEC(:,2),':b'); hold on
    fig2_comps.p15 = plot(datetime(eurecca2METtime(L6C1VEC(:,1))),L6C1VEC(:,2),'--b'); hold on

%-----------patches----------%
patch(X_0305,Y_0305,'black','FaceAlpha',.1,'EdgeColor','none'); text(0.075,0.95,charlbl{1},'Units','normalized','FontSize',12);hold on
patch(X_0509,Y_0509,'b','FaceAlpha',.1,'EdgeColor','none'); text(0.14,0.95,charlbl{2},'Units','normalized','FontSize',12);hold on
patch(X_0913,Y_0913,'r','FaceAlpha',.1,'EdgeColor','none'); text(0.215,0.95,charlbl{3},'Units','normalized','FontSize',12);hold on
patch(X_1316,Y_1316,'g','FaceAlpha',.1,'EdgeColor','none'); text(0.29,0.95,charlbl{4},'Units','normalized','FontSize',12);hold on


    ax = gca;
    ax.YTick= [-.50:0.25:0.5];
    ax.YLim= [-0.5 0.5];
    yline(0)
    legend('L2','L5','L6',Location='southeast'); legend boxoff
    ylabel('U_{longshore} (m/s)');
ax = gca;
ax.XTick= [range];
xlim ([range(1) range(end)]);
xticklabels('')
set(fig2_comps.p11, 'LineWidth', 1.3, 'Color', PS.Blue3);
set(fig2_comps.p14, 'LineWidth', 1.3, 'Color', PS.Blue3);
set(fig2_comps.p15, 'LineWidth', 1.3, 'Color', PS.Blue3);    
title('Circulation pattern (Spring tide)')


nexttile(4,[1 2])
    fig2_comps.p21 = plot(datetime(eurecca2METtime(L2C10VEC(:,1))),L2C10VEC(:,3),'-'); hold on
    fig2_comps.p24 = plot(datetime(eurecca2METtime(L5C1VEC(:,1))),L5C1VEC(:,3),':'); hold on
    fig2_comps.p25 = plot(datetime(eurecca2METtime(L6C1VEC(:,1))),L6C1VEC(:,3),'--'); hold on

patch(X_0305,Y_0305,'black','FaceAlpha',.1,'EdgeColor','none'); hold on
patch(X_0509,Y_0509,'b','FaceAlpha',.1,'EdgeColor','none'); hold on
patch(X_0913,Y_0913,'r','FaceAlpha',.1,'EdgeColor','none'); hold on
patch(X_1316,Y_1316,'g','FaceAlpha',.1,'EdgeColor','none'); hold on

ax = gca;
ax.XTick= [range];
xlim ([range(1) range(end)]);
ylim ([-0.1 0.1]);
xticklabels
set(fig2_comps.p21, 'LineWidth', 1.3, 'Color', 'black');
set(fig2_comps.p24, 'LineWidth', 1.3, 'Color', 'black');
set(fig2_comps.p25, 'LineWidth', 1.3, 'Color', 'black');
ylabel('U_{cross-shore} (m/s)');
yline(0)

legend('L2','L5','L6',Location='northeast'); legend boxoff
% saveas(figure(2),[basePath '\analysis\currents\figures\circulation.fig']);
% saveas(figure(2),[basePath '\analysis\currents\figures\circulation.png']);


%next date tiles
range=[datetime(2021,09,15,00,00,00):hours(6):datetime(2021,09,16,12,00,00)];

X_0912=[datetime(2021,09,15,09,20,00) datetime(2021,09,15,12,10,00) datetime(2021,09,15,12,10,00) datetime(2021,09,15,09,20,00)];
Y_0912=[-0.5 -0.5 0.5 0.5];

X_1215=[datetime(2021,09,15,12,10,00) datetime(2021,09,15,15,40,00) datetime(2021,09,15,15,40,00) datetime(2021,09,15,12,10,00)];
Y_1215=[-0.5 -0.5 0.5 0.5];

X_1519=[datetime(2021,09,15,15,40,00) datetime(2021,09,15,19,50,00) datetime(2021,09,15,19,50,00) datetime(2021,09,15,15,40,00) ];
Y_1519=[-0.5 -0.5 0.5 0.5];

X_2022=[datetime(2021,09,15,19,50,00) datetime(2021,09,15,22,20,00) datetime(2021,09,15,22,20,00)  datetime(2021,09,15,19,50,00)];
Y_2022=[-0.5 -0.5 0.5 0.5];



nexttile(3);
                    plot(datetime(eurecca2METtime(L2C10VEC(:,1))),L2C10VEC(:,2),'-'); hold on
    fig2_comps.p4 = plot(datetime(eurecca2METtime(L5C1VEC(:,1))),L5C1VEC(:,2),':'); hold on
    fig2_comps.p5 = plot(datetime(eurecca2METtime(L6C1VEC(:,1))),L6C1VEC(:,2),'--'); hold on
   
set(fig2_comps.p4, 'LineWidth', 1.3, 'Color', PS.Blue3);
set(fig2_comps.p5, 'LineWidth', 1.3, 'Color', PS.Blue3);
ax = gca;
xticklabels('')
ax.XTick= [range];
xlim ([range(1) range(end)]);
ylim ([-0.31 0.31]);
yline(0)
title(['Circulation pattern (Neap tide)']) 
patch(X_0912,Y_0912,'black','FaceAlpha',.1,'EdgeColor','none'); hold on
patch(X_1215,Y_1215,'b','FaceAlpha',.1,'EdgeColor','none'); hold on
patch(X_1519,Y_1519,'r','FaceAlpha',.1,'EdgeColor','none'); hold on
patch(X_2022,Y_2022,'g','FaceAlpha',.1,'EdgeColor','none'); hold on

nexttile(6)
                     plot(datetime(eurecca2METtime(L2C10VEC(:,1))),L2C10VEC(:,3),'-k'); hold on
    fig22_comps.p4 = plot(datetime(eurecca2METtime(L5C1VEC(:,1))),L5C1VEC(:,3),':k'); hold on
    fig22_comps.p5 = plot(datetime(eurecca2METtime(L6C1VEC(:,1))),L6C1VEC(:,3),'--k'); hold on
set(fig22_comps.p4, 'LineWidth', 1.3);
set(fig22_comps.p5, 'LineWidth',1.3);

ax = gca;
ax.XTick= [range];
xlim ([range(1) range(end)]);
yline(0)
ylim([-0.1 0.1])
patch(X_0912,Y_0912,'black','FaceAlpha',.1,'EdgeColor','none'); hold on
patch(X_1215,Y_1215,'b','FaceAlpha',.1,'EdgeColor','none'); hold on
patch(X_1519,Y_1519,'r','FaceAlpha',.1,'EdgeColor','none'); hold on
patch(X_2022,Y_2022,'g','FaceAlpha',.1,'EdgeColor','none'); hold on

saveas(figure(2),[basePath '\analysis\currents\figures\circulation.fig']);
saveas(figure(2),[basePath '\analysis\currents\figures\circulation.png']);

