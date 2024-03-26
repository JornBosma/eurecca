% Sedmex Profile plots 
%
% Made by: Martijn klein Obbink
% 05-11-2021

%% Initialization
% Specify the folder where the files live.
clear all
close all

rundir = 'C:\Users\jelle\OneDrive\Documenten\MSc\thesis\cross-sections\';

Profiles_2D= load([rundir 'Profiles_2D.mat']);
Fieldnames= load([rundir 'Fieldnames.mat']);
waterlevel= load([rundir 'mean_waterlevel.mat']);

%% load profile data
L1= Profiles_2D.L1_2D;
L2= Profiles_2D.L2_2D;
L3= Profiles_2D.L3_2D;
L4= Profiles_2D.L4_2D;
L5= Profiles_2D.L5_2D;
L6= Profiles_2D.L6_2D;
names= Fieldnames.names;

MeanHW = waterlevel.MeanHW/100; 
MeanLW = waterlevel.MeanLW/100;
a0 = waterlevel.a0/100;

% numit = [1:12 14:20];

%% Integration
% skip O015 (entry 13)
L2_area = L2(:,:,[1:12 14:20]);
Date_area = names([1:12 14:20]);

figure(1)
set(gcf, 'position',[100 50 1200 700],'color','white')
for j = 1:19
Int = cumtrapz(L2_area(:,1,j),(L2_area(:,2,j)+2));
Intv = @(a,b) max(Int(L2_area(:,1,j)<=b)) - min(Int(L2_area(:,1,j)>=a));
SegmentArea(:,j) = Intv(5.598015863023307e+05,5.598480244726846e+05);
plot(SegmentArea,'k'); hold on;
end
xlabel('Date')
ylabel('Area (m^2)')
title('Volume change over time')
xticks(1:1:19);
xtickangle(45)
set(gca,'xticklabel',Date_area,'fontsize',14,'FontWeight','bold');

% %% Intergration by parts
% L_boundary = 5.598015863023307e+05;
% M_point = 5.598251534314845e+05;
% R_boundary = 5.598480244726846e+05; 
% 
% for j = 1:19
% Int = cumtrapz(L2_area(:,1,j),(L2_area(:,2,j)+2));
% Intv = @(a,b) max(Int(L2_area(:,1,j)<=b)) - min(Int(L2_area(:,1,j)>=a));
% SegmentAreaL(:,j) = Intv(L_boundary,M_point);
% SegmentAreaR(:,j) = Intv(M_point,R_boundary);
% SegmentAreaD(:,j) = SegmentAreaR(:,j)-SegmentAreaL(:,j);
% plot(SegmentAreaL,'b'); hold on;
% plot(SegmentAreaR,'r'); hold on;
% plot(SegmentAreaD,'g'); hold on;
% N = normalize(SegmentAreaD);
% plot(N); hold on;
% end
% ylim([-5 5]);
% %%

Distance = [0:20:280];
%% Figures
colormap winter
cmap = colormap;
figure(2)
set(gcf, 'position',[100 50 1200 700],'color','white')
for i = 1:20
    plot_color = cmap(i*12,:);
    plot(L2(:,1,i),L2(:,2,i),'color',plot_color,'linewidth',1.5); hold on; 
%     xline(max(L2(:,1,i)));
%     xL2(i)=max(L2(:,1,i));
    %pause(1),
    ylabel('Bed level to NAP (m)');
    xlabel('Distance (m)');
    xticks(559655:20:559935);
    set(gca,'xticklabel',Distance,'fontsize',14,'FontWeight','bold');
    xlim([559795 5.598480244726846e+05]);

%xlim([5.600306348126862e+05 5.600870501674052e+05]); %L1
%xlim([5.598015863023307e+05 5.598480244726846e+05]); % L2
end
title('Bed level change over time (cross-section L2)');
legend(names,'Location','eastoutside');
% xline(L_boundary,'r','linewidth',2);
% xline(M_point,'r','linewidth',2); 
% xline(R_boundary,'r','linewidth',2);

%%
figure(3)
set(gcf, 'position',[100 50 1200 700],'color','white')
plot(L2(:,1,1),L2(:,2,1),'r','linewidth',1.5); hold on; 
plot(L2(:,1,12),L2(:,2,12),'b','linewidth',1.5);
plot(L2(:,1,14),L2(:,2,14),'g','linewidth',1.5); hold on;
yline(MeanLW,'--','MeanLW','Color','c','LineWidth',2); hold on; %horizontal line of mean low waterlevel
yline(MeanHW,'--','MeanHW','Color','r','LineWidth',2); hold on; %horizontal line of mean high waterlevel
yline(a0,'--','MeanZ','Color','k','LineWidth',2);hold on;       %horizontal line of mean waterlevel
    ylabel('Bed level to NAP (m)');
    xlabel('Distance (m)');
    xticks(559800:20:559900);
    set(gca,'xticklabel',Distance,'fontsize',14,'FontWeight','bold');
    xlim([559800 559850])
    title('bed level change');
    legend(names([1 12 14]));
    


