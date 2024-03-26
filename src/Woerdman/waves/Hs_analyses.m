%% Hs analyses for different wave directions
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
OSSI04Par= ref_files{1,2}.OSSI04Par;
OSSI05Par= ref_files{1,3}.OSSI05Par;
OSSI06Par= ref_files{1,4}.OSSI06Par;
OSSI09Par= ref_files{1,5}.OSSI09Par;
%% wind parameters
% winddata(:,:)= load([basePath, 'dataRaw\windKNMI\hourwinddata_dekooy.txt']);
% spd=(winddata(:,5)/10);
% dir=winddata(:,4);
% windhour(:,1) = datenum('Sep 8, 2021'):1/24:datenum('Oct 20, 2021 23:00');
% startDate=datenum('Sep 7, 2021');
% endDate= datenum('Oct 21, 2021');
timein2=datetime(2021,09,11,00,00,00);
timeout2=datetime(2021,10,18,10,00,00);
time2=[timein2:minutes(10):timeout2];

windoctdekooy = importfile([basePath, 'dataRaw\windKNMI\wind_oct_dekooy.txt']);
winddata(:,1)=MET2eureccatime(datevec(time2));
winddata(:,2)=windoctdekooy.speed;
winddata(:,3)=windoctdekooy.direction;

%%
% Hs per wind direction
id1=find((winddata(:,3)>= 51)&(winddata(:,3)<= 111));
id2=find((winddata(:,3)>= 111)&(winddata(:,3)<= 171));
id3=find((winddata(:,3)>= 171)&(winddata(:,3)<= 231));
id4=find((winddata(:,3)>=231) & (winddata(:,3)<=291));
id5=find((winddata(:,3)<=51) | (winddata(:,3)>=291));

%% subplot labels
nIDs = 7;
alphabet = ('a':'z').';
chars = num2cell(alphabet(1:nIDs));
chars = chars.';
charlbl = strcat('(',chars,')'); % {'(a)','(b)','(c)','(d)'}

%% Hs analyses over total period 
L2array= [0 max(OSSI09Par(:,4))];
PL2_L1= polyfit(OSSI09Par(35:4717,4),OSSI01Par(35:4717,4),1);
PL2_L4= polyfit(OSSI09Par(35:5388,4),OSSI04Par(35:5388,4),1);
PL2_L5= polyfit(OSSI09Par(35:5388,4),OSSI05Par(35:5388,4),1);
PL2_L6= polyfit(OSSI09Par(35:5388,4),OSSI06Par(35:5388,4),1);

t= tiledlayout(3,3,"TileSpacing","tight","Padding","compact")
set(gcf, 'position',[100 50 1000 700],'color','white')
    xlabel(t,'Hs (m) (L2)');
    ylabel(t,'Hs (m)');

nexttile(1,[2 2]);
    scatter(OSSI09Par(:,4),OSSI01Par(:,4),35,'k');hold on
    scatter(OSSI09Par(:,4),OSSI04Par(:,4),35,'filled','d','k');
    scatter(OSSI09Par(:,4),OSSI05Par(:,4),35,'*','k');
    scatter(OSSI09Par(:,4),OSSI06Par(:,4),35,'x','k');
    plot(L2array,polyval(PL2_L1,L2array),'g','LineWidth', 1.5);hold on
    plot(L2array,polyval(PL2_L4,L2array),'-.g','LineWidth', 1.5);
    plot(L2array,polyval(PL2_L5,L2array),':g','LineWidth', 1.5);
    plot(L2array,polyval(PL2_L6,L2array),'--g','LineWidth', 1.5);
    plot(OSSI09Par(:,4),OSSI09Par(:,4),'r','LineWidth', 1.5)

      ylim([0 0.6]);
    legend('L2 vs L1','L2 vs L4','L2 vs L5','L2 vs L6','linear fit L2 vs L1 (m=0.94)','linear fit L2 vs L4 (m=0.94)','linear fit L2 vs L5 (m=0.82)','linear fit L2 vs L6 (m=0.72)','1:1','Location','northwest'); legend boxoff
    title('Significant wave height comparison L2 vs L1,4-6');  
    set(gca,'fontsize',10,'FontWeight','bold');
    text(0.005,0.95,charlbl{1},'Units','normalized','FontSize',12);hold on

R6 = corrcoef(OSSI09Par(:,4),OSSI04Par(:,4),'rows','complete')




%%

L2array_id1= [0 max(OSSI09Par(id1,4))];
PL2_L1_id1= polyfit(OSSI09Par(id1,4),OSSI01Par(id1,4),1);
PL2_L4_id1= polyfit(OSSI09Par(id1,4),OSSI04Par(id1,4),1);
PL2_L5_id1= polyfit(OSSI09Par(id1,4),OSSI05Par(id1,4),1);
PL2_L6_id1= polyfit(OSSI09Par(id1,4),OSSI06Par(id1,4),1);

nexttile(9)
        scatter(OSSI09Par(id1,4),OSSI01Par(id1,4),35,'k');hold on
        scatter(OSSI09Par(id1,4),OSSI04Par(id1,4),35,'filled','d','k');
        scatter(OSSI09Par(id1,4),OSSI05Par(id1,4),35,'*','k');
        scatter(OSSI09Par(id1,4),OSSI06Par(id1,4),35,'x','k');    
        plot(L2array_id1,polyval(PL2_L1_id1,L2array_id1),'g','LineWidth', 1.5);hold on
        plot(L2array_id1,polyval(PL2_L4_id1,L2array_id1),'-.g','LineWidth', 1.5);
        plot(L2array_id1,polyval(PL2_L5_id1,L2array_id1),':g','LineWidth', 1.5);
        plot(L2array_id1,polyval(PL2_L6_id1,L2array_id1),'--g','LineWidth', 1.5);
        plot(OSSI09Par(id1,4),OSSI09Par(id1,4),'r','LineWidth', 1.5)
        xlim([0 0.6]); ylim([0 0.6])
%         xlabel('Hs [m] (L2)');
% ylabel('Hs [m]');
ylim([0 0.6]);
% legend('L2 vs L1','L2 vs L4','L2 vs L5','L2 vs L6','linear fit L2 vs L1','linear fit L2 vs L4','linear fit L2 vs L5','linear fit L2 vs L6','1:1','Location','northeast');
title('(30{\circ}<\phi<90{\circ})' );  
set(gca,'fontsize',10,'FontWeight','bold');
text(0.005,0.95,charlbl{6},'Units','normalized','FontSize',12);hold on
%%     
L2array_id2= [0 max(OSSI09Par(id2,4))];
x_id2=L2array_id2;
y_id2=0.9575*x_id2 + 0.0007578;
PL2_L4_id2= polyfit(OSSI09Par(id2,4),OSSI04Par(id2,4),1);
PL2_L5_id2= polyfit(OSSI09Par(id2,4),OSSI05Par(id2,4),1);
PL2_L6_id2= polyfit(OSSI09Par(id2,4),OSSI06Par(id2,4),1);

nexttile(8)
        scatter(OSSI09Par(id2,4),OSSI01Par(id2,4),35,'k');hold on
        scatter(OSSI09Par(id2,4),OSSI04Par(id2,4),35,'filled','d','k');
        scatter(OSSI09Par(id2,4),OSSI05Par(id2,4),35,'*','k');
        scatter(OSSI09Par(id2,4),OSSI06Par(id2,4),35,'x','k');                
        plot(x_id2,y_id2,'g','LineWidth', 1.5);hold on
        plot(L2array_id2,polyval(PL2_L4_id2,L2array_id2),'-.g','LineWidth', 1.5);
        plot(L2array_id2,polyval(PL2_L5_id2,L2array_id2),':g','LineWidth', 1.5);
        plot(L2array_id2,polyval(PL2_L6_id2,L2array_id2),'--g','LineWidth', 1.5);
        plot(OSSI09Par(id2,4),OSSI09Par(id2,4),'r','LineWidth', 1.5)
        xlim([0 0.6]); ylim([0 0.6])
% xlabel('Hs [m] (L2)');
% ylabel('Hs [m]');
ylim([0 0.6]);
% legend('L2 vs L1','L2 vs L4','L2 vs L5','L2 vs L6','linear fit L2 vs L1','linear fit L2 vs L4','linear fit L2 vs L5','linear fit L2 vs L6','1:1','Location','southeast');
title('Shore normal(-30{\circ}<\phi<30{\circ})');  
set(gca,'fontsize',10,'FontWeight','bold');     
text(0.005,0.95,charlbl{5},'Units','normalized','FontSize',12);hold on
%%              
L2array_id3= [0 max(OSSI09Par(id3,4))];
y_L21_id3=0.9502*L2array_id3-0.001402;
y_L24_id3=0.9234*L2array_id3-0.003395;
y_L25_id3=0.7726*L2array_id3-0.0007491;
y_L26_id3=0.6695*L2array_id3+0.001009;

nexttile(7)
        scatter(OSSI09Par(id3,4),OSSI01Par(id3,4),35,'k');hold on
        scatter(OSSI09Par(id3,4),OSSI04Par(id3,4),35,'filled','d','k');
        scatter(OSSI09Par(id3,4),OSSI05Par(id3,4),35,'*','k');
        scatter(OSSI09Par(id3,4),OSSI06Par(id3,4),35,'x','k');
        plot(L2array_id3,y_L21_id3,'g','LineWidth', 1.5);hold on
        plot(L2array_id3,y_L24_id3,'-.g','LineWidth', 1.5);
        plot(L2array_id3,y_L25_id3,':g','LineWidth', 1.5);
        plot(L2array_id3,y_L26_id3,'--g','LineWidth', 1.5);
        plot(OSSI09Par(id3,4),OSSI09Par(id3,4),'r','LineWidth', 1.5)
        xlim([0 0.6]); ylim([0 0.6])
%         xlabel('Hs [m] (L2)');
% ylabel('Hs [m]');
ylim([0 0.6]);
% legend('L2 vs L1','L2 vs L4','L2 vs L5','L2 vs L6','linear fit L2 vs L1','linear fit L2 vs L4','linear fit L2 vs L5','linear fit L2 vs L6','1:1','Location','southeast');
title('(-90{\circ}<\phi<-30{\circ})' );         
set(gca,'fontsize',10,'FontWeight','bold');
text(0.005,0.95,charlbl{4},'Units','normalized','FontSize',12);hold on
%%    
L2array_id4= [0 max(OSSI09Par(id4,4))];
y_L21_id4=0.8553*L2array_id4+0.00375;
PL2_L4_id4= polyfit(OSSI09Par(id4,4),OSSI04Par(id4,4),1);
PL2_L5_id4= polyfit(OSSI09Par(id4,4),OSSI05Par(id4,4),1);
PL2_L6_id4= polyfit(OSSI09Par(id4,4),OSSI06Par(id4,4),1);

nexttile
        scatter(OSSI09Par(id4,4),OSSI01Par(id4,4),35,'k');hold on
        scatter(OSSI09Par(id4,4),OSSI04Par(id4,4),35,'filled','d','k');
        scatter(OSSI09Par(id4,4),OSSI05Par(id4,4),35,'*','k');
        scatter(OSSI09Par(id4,4),OSSI06Par(id4,4),35,'x','k');        
        plot(L2array_id4,y_L21_id4,'g','LineWidth', 1.5);hold on
        plot(L2array_id4,polyval(PL2_L4_id4,L2array_id4),'-.g','LineWidth', 1.5);
        plot(L2array_id4,polyval(PL2_L5_id4,L2array_id4),':g','LineWidth', 1.5);
        plot(L2array_id4,polyval(PL2_L6_id4,L2array_id4),'--g','LineWidth', 1.5);
        plot(OSSI09Par(id4,4),OSSI09Par(id4,4),'r','LineWidth', 1.5)
        xlim([0 0.6]); ylim([0 0.6])
%         xlabel('Hs [m] (L2)');
% ylabel('Hs [m]');
ylim([0 0.6]);
% legend('L2 vs L1','L2 vs L4','L2 vs L5','L2 vs L6','linear fit L2 vs L1','linear fit L2 vs L4','linear fit L2 vs L5','linear fit L2 vs L6','1:1','Location','southeast');
title('Offshore(-90{\circ}<\phi<-180{\circ})'); 
set(gca,'fontsize',10,'FontWeight','bold');
text(0.005,0.95,charlbl{2},'Units','normalized','FontSize',12);hold on
%%
L2array_id5= [0 max(OSSI09Par(id5,4))];
y_L21_id5=0.9028*L2array_id5+0.001877;
PL2_L4_id5= polyfit(OSSI09Par(id5,4),OSSI04Par(id5,4),1);
PL2_L5_id5= polyfit(OSSI09Par(id5,4),OSSI05Par(id5,4),1);
PL2_L6_id5= polyfit(OSSI09Par(id5,4),OSSI06Par(id5,4),1);

nexttile
        scatter(OSSI09Par(id5,4),OSSI01Par(id5,4),35,'k');hold on
        scatter(OSSI09Par(id5,4),OSSI04Par(id5,4),35,'filled','d','k');
        scatter(OSSI09Par(id5,4),OSSI05Par(id5,4),35,'*','k');
        scatter(OSSI09Par(id5,4),OSSI06Par(id5,4),35,'x','k');        
        plot(L2array_id5,y_L21_id5,'g','LineWidth', 1.5);hold on
        plot(L2array_id5,polyval(PL2_L4_id5,L2array_id5),'-.g','LineWidth', 1.5);
        plot(L2array_id5,polyval(PL2_L5_id5,L2array_id5),':g','LineWidth', 1.5);
        plot(L2array_id5,polyval(PL2_L6_id5,L2array_id5),'--g','LineWidth', 1.5);
        plot(OSSI09Par(id5,4),OSSI09Par(id5,4),'r','LineWidth', 1.5)
        xlim([0 0.6]); ylim([0 0.6])
%         xlabel('Hs [m] (L2)');
% ylabel('Hs [m]');
ylim([0 0.6]);
% legend('L2 vs L1','L2 vs L4','L2 vs L5','L2 vs L6','linear fit L2 vs L1','linear fit L2 vs L4','linear fit L2 vs L5','linear fit L2 vs L6','1:1','Location','southeast');
title('Offshore wind (90{\circ}<\phi<180{\circ})');         
set(gca,'fontsize',10,'FontWeight','bold');
text(0.005,0.95,charlbl{3},'Units','normalized','FontSize',12);hold on

saveas(figure(1),[basePath '\analysis\waves\figures\scatterplotHs.fig'])
saveas(figure(1),[basePath '\analysis\waves\figures\scatterplotHs.png'])
%%
load("baseParametersL2C5Pressure.mat");

figure(10);
set(gcf,'color','white')
    scatter(OSSI09Par(:,4),L2C5PressurePar(:,4),'.k');
title('Wave height Comparison');hold on
xlabel('L2C9 Hs (m)');ylabel('L2C5 Hs (m)')
set(gca, 'FontSize',12,'FontWeight','bold');

hline=refline(1,0);
hline.Color='g';
hline.LineStyle= '--';
hline.LineWidth= 1.3;
legend(hline,'1:1',Location='best'); legend boxoff

    






