% Sedmex Profile plots 
%
% Made by: Martijn klein Obbink
% 25-11-2021
sedmexInit
global basePath
%% Initialization
% Specify the folder where the files live.
% Load data
load('ProfileI_L1.mat');
load('ProfileI_L2.mat');
load('ProfileI_L3.mat');
load('ProfileI_L4.mat');
load('ProfileI_L5.mat');
load('ProfileI_L6.mat');


%% Time initialization
startDatesed = datetime(2021,09,09,00,00,00);
endDatesed = datetime(2021,10,20,00,00,00);
xData_sed= [startDatesed:endDatesed];
dates=[startDatesed:2:endDatesed];
% Datetick = xData(1:2:end);
Profile_dates = [xData_sed(5:11),xData_sed(15),xData_sed(18),xData_sed(22),xData_sed(24:25),...
xData_sed(27),xData_sed(28),xData_sed(29),xData_sed(32:33),xData_sed(35),xData_sed(37),xData_sed(40)];


figure(1)
t=tiledlayout(2,3,Padding="compact",TileSpacing="tight");
ylabel(t, 'volume change (m^3/m)','fontname','times new roman','fontsize',15);
set(gcf, 'position',[0 40 1200 600],'color','white')
nexttile
    plot(Profile_dates_L1,SegmentrefL_L1,'r-o','linewidth',1.2);hold on
    plot(Profile_dates_L1,SegmentrefR_L1,'b-d','linewidth',1.2); hold on
    plot(Profile_dates_L1,SegmentrefR_L1+SegmentrefL_L1,'k--x','linewidth',1.2); hold on;
    title('L1');
    ylim([-6 6]);    
    yline(0);
    xticklabels('');
    
    legend('Lower intertidal beach','Upper intertidal beach','Sum',Location='northwest');
    
nexttile
    plot(Profile_dates_L2,SegmentrefL_L2,'r-o','linewidth',1.2);hold on
    plot(Profile_dates_L2,SegmentrefR_L2,'b-d','linewidth',1.2); hold on
    plot(Profile_dates_L2,SegmentrefR_L2+SegmentrefL_L2,'k--x','linewidth',1.2); hold on;
     title('L2');
    ylim([-6 6]);    
  xticklabels('');
    yline(0);
%     legend('Nearshore','Foreshore','Sum',Location='northwest');

nexttile
    plot(Profile_dates_L3,SegmentrefL_L3,'r-o','linewidth',1.2);hold on
    plot(Profile_dates_L3,SegmentrefR_L3,'b-d','linewidth',1.2); hold on
    plot(Profile_dates_L3,SegmentrefR_L3+SegmentrefL_L3,'k--x','linewidth',1.2); hold on;
     title('L3');
     xticklabels('');
    ylim([-6 6]);    
 
    yline(0);
%     legend('Nearshore','Foreshore','Sum',Location='northwest');

nexttile
    plot(Profile_dates_L4,SegmentrefL_L4,'r-o','linewidth',1.2);hold on
    plot(Profile_dates_L4,SegmentrefR_L4,'b-d','linewidth',1.2); hold on
    plot(Profile_dates_L4,SegmentrefR_L4+SegmentrefL_L4,'k--x','linewidth',1.2); hold on;
     title('L4');
     xtickangle(45)
    ylim([-6 6]);    
    yline(0);
%     legend('Nearshore','Foreshore','Sum',Location='northwest');

nexttile
    plot(Profile_dates_L5,SegmentrefL_L5,'r-o','linewidth',1.2);hold on
    plot(Profile_dates_L5,SegmentrefR_L5,'b-d','linewidth',1.2); hold on
    plot(Profile_dates_L5,SegmentrefR_L5+SegmentrefL_L5,'k--x','linewidth',1.2); hold on;
    title('L5');
    ylim([-6 6]);
    xtickangle(45)
    yline(0);
%     legend('Nearshore','Foreshore','Sum',Location='northwest');

nexttile
    plot(Profile_dates_L6,SegmentrefL_L6,'r-o','linewidth',1.2);hold on
    plot(Profile_dates_L6,SegmentrefR_L6,'b-d','linewidth',1.2); hold on
    plot(Profile_dates_L6,SegmentrefR_L6+SegmentrefL_L6,'k--x','linewidth',1.2); hold on;
     title('L6');
    ylim([-6 6]);  
    xtickangle(45)
    yline(0);
    xlim([datetime(2021,09,13,00,00,00) datetime(2021,10,18,00,00,00)]);
    xticks([datetime(2021,09,13,00,00,00) datetime(2021,09,20,00,00,00) datetime(2021,09,27,00,00,00) datetime(2021,10,04,00,00,00) datetime(2021,10,11,00,00,00) datetime(2021,10,18,00,00,00) ])

saveas(figure(1),[basePath '\analysis\bedlevel_change\volume_changes.fig']);
saveas(figure(1),[basePath '\analysis\bedlevel_change\volume_changes.png']);



%     legend('Nearshore','Foreshore','Sum',Location='northwest');

% 
% 
%     plot(Profile_dates_L1,SegmentrefL_L1,'r','linewidth',2); hold on
%     plot(Profile_dates_L2,SegmentrefL_L2,'g','linewidth',2)
%     plot(Profile_dates_L3,SegmentrefL_L3,'b','linewidth',2)
%     plot(Profile_dates_L4,SegmentrefL_L4,'c','linewidth',2)
%     plot(Profile_dates_L5,SegmentrefL_L5,'m','linewidth',2)
%     % plot(Profile_dates_L6,SegmentrefL_L6,'k','linewidth',2)
%     yline(0);
%     
%     title('Nearshore volume change')
%     xlabel('Date')
%     ylabel('Area (m^2)')
%     xticks(Profile_dates);
%     xtickangle(45);
%     % set(gca,'xticklabel',Date_area,'fontsize',10,'FontWeight','bold');
% 
% subplot(2,1,2)
%     plot(Profile_dates_L1,SegmentrefR_L1,'r','linewidth',2); hold on
%     plot(Profile_dates_L2,SegmentrefR_L2,'g','linewidth',2); 
%     plot(Profile_dates_L3,SegmentrefR_L3,'b','linewidth',2); 
%     plot(Profile_dates_L4,SegmentrefR_L4,'c','linewidth',2); 
%     plot(Profile_dates_L5,SegmentrefR_L5,'m','linewidth',2); 
%     % plot(Profile_dates_L6,SegmentrefR_L6,'k','linewidth',2); 
%     yline(0);
%     
%     title('Foreshore volume change')
%     xlabel('Date')
%     ylabel('Area (m^2)')
%     xticks(Profile_dates);
%     xtickangle(45);
%     % set(gca,'xticklabel',Date_area,'fontsize',10,'FontWeight','bold');
%     legend('L1','L2','L3','L4','L5','L6')
% 
% 
% 
% 
% figure(2)
% set(gcf, 'position',[0 40 1200 600],'color','white')
% plot(Profile_dates_L1,rel_segarea_L1,'r','linewidth',2); hold on;
% plot(Profile_dates_L2,rel_segarea_L2,'g','linewidth',2)
% plot(Profile_dates_L3,rel_segarea_L3,'b','linewidth',2) 
% plot(Profile_dates_L4,rel_segarea_L4,'c','linewidth',2)
% plot(Profile_dates_L5,rel_segarea_L5,'m','linewidth',2)
% % plot(Profile_dates_L6,rel_segarea_L6,'k','linewidth',2)
% yline(0);
% 
% title('Volume change of all profiles')
% xlabel('Date')
% ylabel('Area (m^2)')
% xticks(Profile_dates);
% xtickangle(45);
% % set(gca,'xticklabel',Date_area,'fontsize',10,'FontWeight','bold');
% legend('L1','L2','L3','L4','L5','L6')




%%
figure
tiledlayout(1,3,'Padding','compact',"TileSpacing","tight")
nexttile(3)
plot(Profile_dates_L2,SegmentrefR_L2+SegmentrefL_L2,'r--o','linewidth',1.2); hold on;
nexttile(2)
plot(Profile_dates_L4,SegmentrefR_L4+SegmentrefL_L4,'b--diamond','linewidth',1.2); hold on;
nexttile(1)
plot(Profile_dates_L5,SegmentrefR_L5+SegmentrefL_L5,'k--x','linewidth',1.2); hold on;
