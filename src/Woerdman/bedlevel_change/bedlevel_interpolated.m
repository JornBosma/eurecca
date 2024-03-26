% Sedmex Profile plots 
sedmexInit;
global basePath;


rundir = [cd filesep] ;
run_save= [cd filesep 'figures' filesep];

Profiles_2D= load([rundir 'Profiles_2D.mat']);
Profiles_3D_raw= load([rundir 'Profiles_3D_raw.mat']);
Fieldnames= load([rundir 'Fieldnames.mat']);
waterlevel= load([rundir 'mean_waterlevel.mat']);


%% Time initialization
startDatesed = datetime(2021,09,09,00,00,00);
endDatesed = datetime(2021,10,20,00,00,00);
xData_sed= [startDatesed:endDatesed];
dates=[startDatesed:2:endDatesed];
% Datetick = xData(1:2:end);
Profile_dates = [xData_sed(5:11),xData_sed(15),xData_sed(18),xData_sed(22),xData_sed(24:25),...
xData_sed(27),xData_sed(28),xData_sed(29),xData_sed(32:33),xData_sed(35),xData_sed(37),xData_sed(40)];
names=Fieldnames.names;
distance=(0:5:100);

%% water level data
MeanHW = waterlevel.MeanHW/100; 
MeanLW = waterlevel.MeanLW/100;

%% load profile data L1
L1_raw= Profiles_3D_raw;
L1= Profiles_2D.L1_2D;
[L1profile_z,L1profile_mean,L1profile_std,L1xaxis] = meanprofiles(L1);

figure(1); tiledlayout(3,2);
    set(gcf, 'position',[0 40 1500 700],'color','white')
nexttile(5);
    colormap winter
    cmap = colormap;
    for i = 1:20
        plot_color = cmap(i*12,:);
        plot(L1(:,1,i),L1(:,2,i),'color',plot_color,'linewidth',1.5); hold on; 
    end
    xlim([559900+135 559900+180]);
    xticks([559900+135:5:559900+180])
    xticklabels(distance);
    ylim([-1.5 1.5]);
  
    yline(MeanLW,'-.','Color','b','LineWidth',1.2,'Label','MLW','LabelOrientation','horizontal','LabelHorizontalAlignment','left', 'FontSize',10,FontName='times new roman'); hold on; %horizontal line of mean low waterlevel
    yline(MeanHW,'-.','Color','b','LineWidth',1.2,'Label','MHW','LabelOrientation','horizontal','LabelHorizontalAlignment','left', 'FontSize',10,FontName='times new roman'); hold on; %horizontal line of mean high waterlevel
    yline(0.3,'-.','Color','k','LineWidth',1.2)
    ylabel({'Bed level';'+NAP (m)'});
    grid on
    text(0.12,0.8,'Lower supratidal beach','Units','normalized','FontSize',10,FontName='times new roman');hold on
    text(0.12,0.68,'Upper intertidal beach','Units','normalized','FontSize',10,FontName='times new roman');hold on
    text(0.12,0.35,'Lower intertidal beach','Units','normalized','FontSize',10,FontName='times new roman');hold on
    text(0.12,0.20,'Subtidal beach','Units','normalized','FontSize',10);hold on

nexttile(1,[2 1]);
    colormap(redblue(250)), colorbar
    differ=NaN(length(L1profile_z), length(xData_sed));
    
    for i=1:20
        id=find(Profile_dates(i)==xData_sed(:));
        if i==1
        differ(:,id)=L1profile_z(:,1)-L1profile_z(:,1);
    %     pcolor(L1xaxis,datenum(Profile_dates_L1),L1profile_z(:,i)); hold on
        else
            if sum(isnan(L1profile_z(:,i-1))) == length(L1profile_z(:,i-1))
               differ(:,id)=L1profile_z(:,i)-L1profile_z(:,i-2); 
            else   
            differ(:,id)=L1profile_z(:,i)-L1profile_z(:,i-1);
            end
        end
    end
    p=pcolor(L1xaxis,xData_sed,differ');hold on
    set(p, 'EdgeColor', 'none');
    yticks(Profile_dates);
    ylim([xData_sed(4) xData_sed(42)]);
    ytickformat('dd');
    xlim([559900+135 559900+180]);
    xticks([559900+135:5:559900+180])
    xticklabels(distance);
    xlabel('Distance (m)');
    cb=colorbar('eastoutside');caxis([-0.4 0.4])
    cb.Label.String = 'Bed level change (m)';
    cb.Label.FontSize=12;
    title('L1')
    grid on

% load profile data L2
L2_raw= Profiles_3D_raw;
L2= Profiles_2D.L2_2D;

[L2profile_z,L2profile_mean,L2profile_std,L2xaxis] = meanprofiles(L2);

figure(1);
nexttile(6);
colormap winter
cmap = colormap;
    for i = 1:20
        plot_color = cmap(i*12,:);
        plot(L2(:,1,i),L2(:,2,i),'color',plot_color,'linewidth',1.5); hold on; 
        xlim([559795 559850]);
        xticks([559795:5:559850])
        xticklabels(distance);
        ylim([-1.5 1.5]);
%     title({'Cross-shore';'profiles'});

    end
    yline(MeanLW,'-.','Color','b','LineWidth',1.2,'Label','MLW','LabelOrientation','horizontal','LabelHorizontalAlignment','left', 'FontSize',10,FontName='times new roman'); hold on; %horizontal line of mean low waterlevel
    yline(MeanHW,'-.','Color','b','LineWidth',1.2,'Label','MHW','LabelOrientation','horizontal','LabelHorizontalAlignment','left', 'FontSize',10,FontName='times new roman'); hold on; %horizontal line of mean high waterlevel
    yline(0.3,'-.','Color','k','LineWidth',1.2) 

   grid on
    legend(names,'Position',[0.90 0.08 0.1 0.60]); legend box off
    

  nexttile(2,[2 1]);
    colormap(redblue(250)), colorbar
    differ=NaN(length(L2profile_z), length(xData_sed));
    
    for i=1:20
        id=find(Profile_dates(i)==xData_sed(:));
        if i==1
        differ(:,id)=L2profile_z(:,1)-L2profile_z(:,1);
    %     pcolor(L1xaxis,datenum(Profile_dates_L1),L1profile_z(:,i)); hold on
        else
        differ(:,id)=L2profile_z(:,i)-L2profile_z(:,i-1);
        end
    end
    p=pcolor(L2xaxis,xData_sed,differ');hold on
    set(p, 'EdgeColor', 'none');
    ylim([xData_sed(4) xData_sed(42)]);
    ytickformat('dd');
    yticks(Profile_dates);
    xlim([559795 559850]);
    xticks([559795:5:559850])
    xticklabels(distance);
    xlabel('Distance (m)');
    caxis([-0.4 0.4]),
    title('L2')
    grid on
    
saveas(figure(1),"bedlevel_change_L12.fig");
saveas(figure(1),"bedlevel_change_L12.png");

%% load profile data L3
L3_raw= Profiles_3D_raw;
L3= Profiles_2D.L3_2D;
[L3profile_z,L3profile_mean,L3profile_std,L3xaxis] = meanprofiles(L3);

figure(2);tiledlayout(3,2);
    set(gcf, 'position',[0 40 1500 700],'color','white')

nexttile(5);
    colormap winter
    cmap = colormap;
    for i = 1:20
        plot_color = cmap(i*12,:);
        plot(L3(:,1,i),L3(:,2,i),'color',plot_color,'linewidth',1.5); hold on; 
    end
    xlim([559440+75 559440+130]);
    xticks([559440+75:5:559440+130]);
    xticklabels(distance);
    ylim([-1.5 1.5]);
    yline(MeanLW,'-.','Color','b','LineWidth',1.2,'Label','MLW','LabelOrientation','horizontal','LabelHorizontalAlignment','left', 'FontSize',10,FontName='times new roman'); hold on; %horizontal line of mean low waterlevel
    yline(MeanHW,'-.','Color','b','LineWidth',1.2,'Label','MHW','LabelOrientation','horizontal','LabelHorizontalAlignment','left', 'FontSize',10,FontName='times new roman'); hold on; %horizontal line of mean high waterlevel
    yline(0.3,'-.','Color','k','LineWidth',1.2)   
    ylabel({'Bed level';'+NAP (m)'});
    grid on
    text(0.12,0.8,'Lower supratidal beach','Units','normalized','FontSize',10,FontName='times new roman');hold on
    text(0.12,0.68,'Upper intertidal beach','Units','normalized','FontSize',10,FontName='times new roman');hold on
    text(0.12,0.35,'Lower intertidal beach','Units','normalized','FontSize',10,FontName='times new roman');hold on
    text(0.12,0.20,'Subtidal beach','Units','normalized','FontSize',10);hold on
 nexttile(1,[2 1]);
    colormap(redblue(250)), colorbar
    differ=NaN(length(L3profile_z), length(xData_sed));
    for i=1:20
        id=find(Profile_dates(i)==xData_sed(:));
        if i==1
        differ(:,id)=L3profile_z(:,1)-L3profile_z(:,1);
        else
            if sum(isnan(L3profile_z(:,i-1))) == length(L3profile_z(:,i-1))
               differ(:,id)=L3profile_z(:,i)-L3profile_z(:,i-2); 
            else   
            differ(:,id)=L3profile_z(:,i)-L3profile_z(:,i-1);
            end
        end
    end

    p=pcolor(L3xaxis,xData_sed,differ');hold on
    set(p, 'EdgeColor', 'none');
        yticks(Profile_dates);
        ylim([xData_sed(4) xData_sed(42)]);
        ytickformat('dd');
        xlim([559440+75 559440+130]);
        xticks([559440+75:5:559440+130]);
        xticklabels(distance);
        xlabel('Distance (m)');
        cb=colorbar('eastoutside');caxis([-0.4 0.4])
        cb.Label.String = 'Bed level change (m)';
         cb.Label.FontSize=12;
        title('L3')
        grid on


% load profile data L4
L4_raw= Profiles_3D_raw;
L4= Profiles_2D.L4_2D;

[L4profile_z,L4profile_mean,L4profile_std,L4xaxis] = meanprofiles(L4);

figure(2);
nexttile(6);
    colormap winter
    cmap = colormap;

    for i = 1:20
        plot_color = cmap(i*12,:);
        plot(L4(:,1,i),L4(:,2,i),'color',plot_color,'linewidth',1.5); hold on;     
    end
    
    xlim([558892+40 558892+95]);
    xticks([558892+40:5:558892+95]);
    xticklabels(distance);
    ylim([-1.5 1.5]);

    yline(MeanLW,'-.','Color','b','LineWidth',1.2,'Label','MLW','LabelOrientation','horizontal','LabelHorizontalAlignment','left', 'FontSize',10,FontName='times new roman'); hold on; %horizontal line of mean low waterlevel
    yline(MeanHW,'-.','Color','b','LineWidth',1.2,'Label','MHW','LabelOrientation','horizontal','LabelHorizontalAlignment','left', 'FontSize',10,FontName='times new roman'); hold on; %horizontal line of mean high waterlevel
    yline(0.3,'-.','Color','k','LineWidth',1.2)    
    legend(names,'Position',[0.90 0.08 0.1 0.60]); legend box off
    grid on
   

nexttile(2,[2 1]);
    colormap(redblue(250)), colorbar
    differ=NaN(length(L4profile_z), length(xData_sed));
    
    for i=1:20
     id=find(Profile_dates(i)==xData_sed(:));
        if i==1
        differ(:,id)=L4profile_z(:,1)-L4profile_z(:,1);
   
        else
            if sum(isnan(L4profile_z(:,i-1))) == length(L4profile_z(:,i-1))
               differ(:,id)=L4profile_z(:,i)-L4profile_z(:,i-2); 
            else   
            differ(:,id)=L4profile_z(:,i)-L4profile_z(:,i-1);
            end
        end
    end

    p=pcolor(L4xaxis,xData_sed,differ');hold on
    set(p, 'EdgeColor', 'none');
    yticks(Profile_dates);
    ylim([xData_sed(4) xData_sed(42)]);
    ytickformat('dd');
        xlim([558892+40 558892+95]);
        xticks([558892+40:5:558892+95]);
        xticklabels(distance);
        xlabel('Distance (m)');
    caxis([-0.4 0.4])
    title('L4')
    grid on
saveas(figure(2),"bedlevel_change_L34.fig");
saveas(figure(2),"bedlevel_change_L34.png");



%% load profile data L5
L5_raw= Profiles_3D_raw;
L5= Profiles_2D.L5_2D;
[L5profile_z,L5profile_mean,L5profile_std,L5xaxis] = meanprofiles(L5);


figure(3); tiledlayout(3,2);
    set(gcf, 'position',[0 40 1500 700],'color','white')
    colormap winter
    cmap = colormap;
    nexttile(5)
    
    for i = 1:20
        plot_color = cmap(i*12,:);
        plot(L5(:,1,i),L5(:,2,i),'color',plot_color,'linewidth',1.5); hold on; 
       
    end
    xlim([558495+95 558495+150]);
    xticks([558495+95:5:558495+150]);
    xticklabels(distance);
    ylim([-1.5 1.5]);

    yline(MeanLW,'-.','Color','b','LineWidth',1.2,'Label','MLW','LabelOrientation','horizontal','LabelHorizontalAlignment','left', 'FontSize',10,FontName='times new roman'); hold on; %horizontal line of mean low waterlevel
    yline(MeanHW,'-.','Color','b','LineWidth',1.2,'Label','MHW','LabelOrientation','horizontal','LabelHorizontalAlignment','left', 'FontSize',10,FontName='times new roman'); hold on; %horizontal line of mean high waterlevel
    yline(0.3,'-.','Color','k','LineWidth',1.2)
    ylabel({'Bed level';'+NAP (m)'});
    %     legend(names,'Position',[0.910888888968362 0.380083326975505 0.0618333337942759 0.555833346048991]); legend box off
    grid on
       text(0.12,0.8,'Lower supratidal beach','Units','normalized','FontSize',10,FontName='times new roman');hold on
    text(0.12,0.68,'Upper intertidal beach','Units','normalized','FontSize',10,FontName='times new roman');hold on
    text(0.12,0.35,'Lower intertidal beach','Units','normalized','FontSize',10,FontName='times new roman');hold on
    text(0.12,0.20,'Subtidal beach','Units','normalized','FontSize',10);hold on
nexttile(1, [2 1]);
    colormap(redblue(250)), colorbar
    differ=NaN(length(L5profile_z), length(xData_sed));
    
    for i=1:20
        id=find(Profile_dates(i)==xData_sed(:));
        if i==1
        differ(:,id)=L5profile_z(:,1)-L5profile_z(:,1);
        else
            if sum(isnan(L5profile_z(:,i-1))) == length(L5profile_z(:,i-1))
               differ(:,id)=L5profile_z(:,i)-L5profile_z(:,i-2); 
            else   
            differ(:,id)=L5profile_z(:,i)-L5profile_z(:,i-1);
            end
        end
    end

    p=pcolor(L5xaxis,xData_sed,differ');hold on
    set(p, 'EdgeColor', 'none');
    yticks(Profile_dates);
    ylim([xData_sed(4) xData_sed(42)]);
    ytickformat('dd');

    xlim([558495+95 558495+150]);
    xticks([558495+95:5:558495+150]);
    xticklabels(distance);
    xlabel('Distance (m)');
    cb=colorbar('eastoutside');caxis([-0.4 0.4])
    cb.Label.String = 'Bed level change (m)';
     cb.Label.FontSize=12;
    title('L5')
    grid on


    % load profile data L6
L6_raw= Profiles_3D_raw;
L6= Profiles_2D.L6_2D;
[L6profile_z,L6profile_mean,L6profile_std,L6xaxis] = meanprofiles(L6);


figure(3);
nexttile(6);

     colormap winter
    cmap = colormap;
    for i = 1:20
        plot_color = cmap(i*12,:);
        plot(L6(:,1,i),L6(:,2,i),'color',plot_color,'linewidth',1.5); hold on; 
    end
        xlim([558111+100 558111+155]);
        xticks([558111+100:5:558111+155]);
        xticklabels(distance);
    ylim([-1.5 1.5]);
    yline(MeanLW,'-.','Color','b','LineWidth',1.2,'Label','MLW','LabelOrientation','horizontal','LabelHorizontalAlignment','left', 'FontSize',10,FontName='times new roman'); hold on; %horizontal line of mean low waterlevel
    yline(MeanHW,'-.','Color','b','LineWidth',1.2,'Label','MHW','LabelOrientation','horizontal','LabelHorizontalAlignment','left', 'FontSize',10,FontName='times new roman'); hold on; %horizontal line of mean high waterlevel
    yline(0.3,'-.','Color','k','LineWidth',1.2)
    legend(names,'Position',[0.90 0.08 0.1 0.60]); legend box off
    grid on


nexttile(2,[2 1]);
    colormap(redblue(250)), colorbar
    differ=NaN(length(L6profile_z), length(xData_sed));
   
    for i=3:20
        id=find(Profile_dates(i)==xData_sed(:));
        if i==1
        differ(:,id)=L6profile_z(:,1)-L6profile_z(:,1);
        else
            if sum(isnan(L6profile_z(:,i-1))) == length(L6profile_z(:,i-1))
               differ(:,id)=L6profile_z(:,i)-L6profile_z(:,i-2); 
            else   
            differ(:,id)=L6profile_z(:,i)-L6profile_z(:,i-1);
            end
        end
    end

    p=pcolor(L6xaxis,xData_sed,differ');hold on
    set(p, 'EdgeColor', 'none');
    yticks(Profile_dates);
    ylim([xData_sed(4) xData_sed(42)]);
    ytickformat('dd');
        xlim([558111+100 558111+155]);
        xticks([558111+100:5:558111+155]);
        xticklabels(distance);
        xlabel('Distance (m)');
    caxis([-0.4 0.4])
    title('L6')
    grid on

saveas(figure(3), "bedlevel_change_L56.fig");
saveas(figure(3), "bedlevel_change_L56.png");




%%

% load profile data L2
% L2_raw= Profiles_3D_raw;
L2= Profiles_2D.L2_2D;

[L2profile_z,L2profile_mean,L2profile_std,L2xaxis] = meanprofiles(L2);

figure(100)
tiledlayout(3,1);
nexttile(2);
colormap winter
cmap = colormap;
    for i = 1:20
        plot_color = cmap(i*12,:);
        plot(L2(:,1,i),L2(:,2,i),'color',plot_color,'linewidth',1.5); hold on; 
        xlim([559795 559850]);
        xticks([559795:5:559850])
        xticklabels(distance);
        ylim([-1.5 1.5]);
%     title({'Cross-shore';'profiles'});

    end
%     yline(MeanLW,'-.','Color','b','LineWidth',1.2,'Label','MLW','LabelOrientation','horizontal','LabelHorizontalAlignment','left', 'FontSize',10,FontName='times new roman'); hold on; %horizontal line of mean low waterlevel
%     yline(MeanHW,'-.','Color','b','LineWidth',1.2,'Label','MHW','LabelOrientation','horizontal','LabelHorizontalAlignment','left', 'FontSize',10,FontName='times new roman'); hold on; %horizontal line of mean high waterlevel
    yline(0.3,'-.','Color','k','LineWidth',1.2) 
ylabel('bed level (m)'); xlabel('distance (m)')
   grid on
    legend(names,'Position',[0.90 0.2 0.1 0.60]); legend box off
    text(0.05,0.9,'L2','Units','normalized','FontSize',12);hold on

L4_raw= Profiles_3D_raw;
L4= Profiles_2D.L4_2D;

[L4profile_z,L4profile_mean,L4profile_std,L4xaxis] = meanprofiles(L4);

% figure(2);
nexttile(1);
    colormap winter
    cmap = colormap;

    for i = 1:20
        plot_color = cmap(i*12,:);
        plot(L4(:,1,i),L4(:,2,i),'color',plot_color,'linewidth',1.5); hold on;     
    end
    
    xlim([558892+40 558892+95]);
    xticks([558892+40:5:558892+95]);
    xticklabels(distance);
    ylim([-1.5 1.5]);

%     yline(MeanLW,'-.','Color','b','LineWidth',1.2,'Label','MLW','LabelOrientation','horizontal','LabelHorizontalAlignment','left', 'FontSize',10,FontName='times new roman'); hold on; %horizontal line of mean low waterlevel
%     yline(MeanHW,'-.','Color','b','LineWidth',1.2,'Label','MHW','LabelOrientation','horizontal','LabelHorizontalAlignment','left', 'FontSize',10,FontName='times new roman'); hold on; %horizontal line of mean high waterlevel
    yline(0.3,'-.','Color','k','LineWidth',1.2)    
%     legend(names,'Position',[0.90 0.08 0.1 0.60]); legend box off
    grid on
   text(0.05,0.9,'L4','Units','normalized','FontSize',12);hold on





nexttile(3);
L6_raw= Profiles_3D_raw;
L6= Profiles_2D.L6_2D;
[L6profile_z,L6profile_mean,L6profile_std,L6xaxis] = meanprofiles(L6);
     colormap winter
    cmap = colormap;
    for i = 1:20
        plot_color = cmap(i*12,:);
        plot(L6(:,1,i),L6(:,2,i),'color',plot_color,'linewidth',1.5); hold on; 
    end
        xlim([558111+100 558111+155]);
        xticks([558111+100:5:558111+155]);
        xticklabels(distance);
    ylim([-1.5 1.5]);
%     yline(MeanLW,'-.','Color','b','LineWidth',1.2,'Label','MLW','LabelOrientation','horizontal','LabelHorizontalAlignment','left', 'FontSize',10,FontName='times new roman'); hold on; %horizontal line of mean low waterlevel
%     yline(MeanHW,'-.','Color','b','LineWidth',1.2,'Label','MHW','LabelOrientation','horizontal','LabelHorizontalAlignment','left', 'FontSize',10,FontName='times new roman'); hold on; %horizontal line of mean high waterlevel
    yline(0.3,'-.','Color','k','LineWidth',1.2)
%     legend(names,'Position',[0.90 0.08 0.1 0.60]); legend box off
    grid on
    text(0.05,0.9,'L6','Units','normalized','FontSize',12);hold on



















