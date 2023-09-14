%% Initialisation
close all
clear
clc

[~, fontsize, ~, ~] = eurecca_init;

locs = {'L2C2', 'L2C3', 'L2C3.5', 'L2C4', 'L2C4.5', 'L2C5W', 'L2C5E', 'L2C6'};

% processed sedi samples
% load('GS_L2C3_plus.mat') % 09/12 (SL) and 10/08 not exact same locations
% load('GS_L2C5_plus.mat')
% sieveSizes = [8000, 4000, 2000, 1000, 710, 500, 425, 355, 300, 250, 180, 125, 63, 0];

% % L2 array
% GS_20210920 % 4 times (9:15; 12:10; 15:15 & 18:40)
% GS_20210928 % 4 times + longshore double (10:00; 13:00; 16:00 & 19:00)
% GS_20211001 % + L2 double (storm; 9.15 - 10h)
% GS_20211007 % 4 times (10:00; 13:00; 16:00 & 19:00)
% GS_20211015 % 3 times (10:20; 13:25 & 15:30)
% 
% % longshore double
% GS_20210921
% GS_20210928
% 
% % full
% GS_20211008 % southern half
% GS_20211009 % northern half
% 
% % L2 double
% GS_20210930
% GS_20211001
% GS_20211006
% GS_20211011
% GS_20211013
% 
% % scraper
% GS_20211007S
% GS_20211015S

% load data
folderPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor' filesep 'grainsizes'];
dataPath{1} = [folderPath filesep 'GS_20210920.csv'];
dataPath{2} = [folderPath filesep 'GS_20210928.csv'];
dataPath{3} = [folderPath filesep 'GS_20211001.csv'];
dataPath{4} = [folderPath filesep 'GS_20211007.csv'];
dataPath{5} = [folderPath filesep 'GS_20211015.csv'];

opts = detectImportOptions(dataPath{1});
opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy');

GS_20210920 = readtable(dataPath{1}, opts);
GS_20210928 = readtable(dataPath{2}, opts);
GS_20211001 = readtable(dataPath{3}, opts);
GS_20211007 = readtable(dataPath{4}, opts);
GS_20211015 = readtable(dataPath{5}, opts);

GS_20210920 = [GS_20210920(1:16,:); GS_20210920(1,:); GS_20210920(17:end,:)]; % unchanged L2C2_3
GS_20210920.Sample_Identity(17) = {'L2C2_3'};

GS_20211015 = [GS_20211015(1:7,:); GS_20211015(15,:); GS_20211015(8:end,:)]; % too deep L2C6_1
GS_20211015.Sample_Identity(8) = {'L2C6_1'};
GS_20211015{8,6:end} = NaN;

%% GS_20210920
L2C2.Mean = GS_20210920.Mean_mu(1:8:end);
L2C3.Mean = GS_20210920.Mean_mu(2:8:end);
L2C3_5.Mean = GS_20210920.Mean_mu(3:8:end);
L2C4.Mean = GS_20210920.Mean_mu(4:8:end);
L2C4_5.Mean = GS_20210920.Mean_mu(5:8:end);
L2C5W.Mean = GS_20210920.Mean_mu(6:8:end);
L2C5E.Mean = GS_20210920.Mean_mu(7:8:end);
L2C6.Mean = GS_20210920.Mean_mu(8:8:end);

Mean.GS_20210920 = [L2C2.Mean L2C3.Mean L2C3_5.Mean L2C4.Mean L2C4_5.Mean L2C5W.Mean L2C5E.Mean L2C6.Mean];
Mean.GS_20210920 = [Mean.GS_20210920; Mean.GS_20210920(end,:)]; % duplicate last row (required for pcolor)
Mean.GS_20210920 = [Mean.GS_20210920, Mean.GS_20210920(:,end)]; % duplicate last column (required for pcolor)
Mean.GS_20210920 = Mean.GS_20210920/1000; % convert mu to mm

% Visualisation
f1 = figure;
pcolor(1:height(Mean.GS_20210920), 1:length(Mean.GS_20210920), Mean.GS_20210920')
shading flat

title('2021-09-20')
ylabel('cross-shore location')
xlabel('moment in tidal cycle')

xticks(1.5:4.5)
xticklabels({'HW','HT_\downarrow','LW','HT_\uparrow'})
yticks(1.5:8.5)
yticklabels(locs)

c = colorbar;
c.Label.String = 'M_G (mm)';
c.Label.FontSize = fontsize;
crameri('lajolla')
clim([0, 2])

%% GS_20210928
L2C2.Mean = GS_20210928.Mean_mu(1:8:32);
L2C3.Mean = GS_20210928.Mean_mu(2:8:32);
L2C3_5.Mean = GS_20210928.Mean_mu(3:8:32);
L2C4.Mean = GS_20210928.Mean_mu(4:8:32);
L2C4_5.Mean = GS_20210928.Mean_mu(5:8:32);
L2C5W.Mean = GS_20210928.Mean_mu(6:8:32);
L2C5E.Mean = GS_20210928.Mean_mu(7:8:32);
L2C6.Mean = GS_20210928.Mean_mu(8:8:32);

Mean.GS_20210928 = [L2C2.Mean L2C3.Mean L2C3_5.Mean L2C4.Mean L2C4_5.Mean L2C5W.Mean L2C5E.Mean L2C6.Mean];
Mean.GS_20210928 = [Mean.GS_20210928; Mean.GS_20210928(end,:)]; % duplicate last row (required for pcolor)
Mean.GS_20210928 = [Mean.GS_20210928, Mean.GS_20210928(:,end)]; % duplicate last column (required for pcolor)
Mean.GS_20210928 = Mean.GS_20210928/1000; % convert mu to mm

% Visualisation
f2 = figure;
pcolor(1:height(Mean.GS_20210928), 1:length(Mean.GS_20210928), Mean.GS_20210928')
shading flat

title('2021-09-28')
ylabel('cross-shore location')
xlabel('moment in tidal cycle')

xticks(1.5:4.5)
xticklabels({'HW','HT_\downarrow','LW','HT_\uparrow'})
yticks(1.5:8.5)
yticklabels(locs)

c = colorbar;
c.Label.String = 'M_G (mm)';
c.Label.FontSize = fontsize;
crameri('lajolla')
clim([0, 2])

%% GS_20211001
L2C2.Mean = GS_20211001.Mean_mu(2:8:9);
L2C3.Mean = GS_20211001.Mean_mu(3:8:9);
L2C3_5.Mean = GS_20211001.Mean_mu(4:8:9);
L2C4.Mean = GS_20211001.Mean_mu(5:8:9);
L2C4_5.Mean = GS_20211001.Mean_mu(6:8:9);
L2C5W.Mean = GS_20211001.Mean_mu(7:8:9);
L2C5E.Mean = GS_20211001.Mean_mu(8:8:9);
L2C6.Mean = GS_20211001.Mean_mu(9:8:9);

Mean.GS_20211001 = [L2C2.Mean L2C3.Mean L2C3_5.Mean L2C4.Mean L2C4_5.Mean L2C5W.Mean L2C5E.Mean L2C6.Mean];
Mean.GS_20211001 = [Mean.GS_20211001; Mean.GS_20211001(end,:)]; % duplicate last row (required for pcolor)
Mean.GS_20211001 = [Mean.GS_20211001, Mean.GS_20211001(:,end)]; % duplicate last column (required for pcolor)
Mean.GS_20211001 = Mean.GS_20211001/1000; % convert mu to mm

% Visualisation
f3 = figure;
pcolor(1:height(Mean.GS_20211001), 1:length(Mean.GS_20211001), Mean.GS_20211001')
shading flat

title('2021-10-01')
ylabel('cross-shore location')
xlabel('moment in tidal cycle')

xticks(1.5:4.5)
xticklabels({'LW'})
yticks(1.5:8.5)
yticklabels(locs)

c = colorbar;
c.Label.String = 'M_G (mm)';
c.Label.FontSize = fontsize;
crameri('lajolla')
clim([0, 2])

%% GS_20211007
L2C2.Mean = GS_20211007.Mean_mu(1:8:end);
L2C3.Mean = GS_20211007.Mean_mu(2:8:end);
L2C3_5.Mean = GS_20211007.Mean_mu(3:8:end);
L2C4.Mean = GS_20211007.Mean_mu(4:8:end);
L2C4_5.Mean = GS_20211007.Mean_mu(5:8:end);
L2C5W.Mean = GS_20211007.Mean_mu(6:8:end);
L2C5E.Mean = GS_20211007.Mean_mu(7:8:end);
L2C6.Mean = GS_20211007.Mean_mu(8:8:end);

Mean.GS_20211007 = [L2C2.Mean L2C3.Mean L2C3_5.Mean L2C4.Mean L2C4_5.Mean L2C5W.Mean L2C5E.Mean L2C6.Mean];
Mean.GS_20211007 = [Mean.GS_20211007; Mean.GS_20211007(end,:)]; % duplicate last row (required for pcolor)
Mean.GS_20211007 = [Mean.GS_20211007, Mean.GS_20211007(:,end)]; % duplicate last column (required for pcolor)
Mean.GS_20211007 = Mean.GS_20211007/1000; % convert mu to mm

% Visualisation
f4 = figure;
pcolor(1:height(Mean.GS_20211007), 1:length(Mean.GS_20211007), Mean.GS_20211007')
shading flat

title('2021-10-07')
ylabel('cross-shore location')
xlabel('moment in tidal cycle')

xticks(1.5:4.5)
xticklabels({'HW','HT_\downarrow','LW','HT_\uparrow'})
yticks(1.5:8.5)
yticklabels(locs)

c = colorbar;
c.Label.String = 'M_G (mm)';
c.Label.FontSize = fontsize;
crameri('lajolla')
clim([0, 2])

%% GS_20211015
L2C2.Mean = GS_20211015.Mean_mu(1:8:end);
L2C3.Mean = GS_20211015.Mean_mu(2:8:end);
L2C3_5.Mean = GS_20211015.Mean_mu(3:8:end);
L2C4.Mean = GS_20211015.Mean_mu(4:8:end);
L2C4_5.Mean = GS_20211015.Mean_mu(5:8:end);
L2C5W.Mean = GS_20211015.Mean_mu(6:8:end);
L2C5E.Mean = GS_20211015.Mean_mu(7:8:end);
L2C6.Mean = GS_20211015.Mean_mu(8:8:end);

Mean.GS_20211015 = [L2C2.Mean L2C3.Mean L2C3_5.Mean L2C4.Mean L2C4_5.Mean L2C5W.Mean L2C5E.Mean L2C6.Mean];
Mean.GS_20211015 = [Mean.GS_20211015; Mean.GS_20211015(end,:)]; % duplicate last row (required for pcolor)
Mean.GS_20211015 = [Mean.GS_20211015, Mean.GS_20211015(:,end)]; % duplicate last column (required for pcolor)
Mean.GS_20211015 = Mean.GS_20211015/1000; % convert mu to mm

% Visualisation
f5 = figure;
pcolor(1:height(Mean.GS_20211015), 1:length(Mean.GS_20211015), Mean.GS_20211015')
shading flat

title('2021-10-15')
ylabel('cross-shore location')
xlabel('moment in tidal cycle')

xticks(1.5:4.5)
xticklabels({'LW','HT_\uparrow','HW','HT_\downarrow'})
yticks(1.5:8.5)
yticklabels(locs)

c = colorbar;
c.Label.String = 'M_G (mm)';
c.Label.FontSize = fontsize;
crameri('lajolla')
clim([0, 2])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GS_20210920
L2C2.Sort = GS_20210920.Sorting(1:8:end);
L2C3.Sort = GS_20210920.Sorting(2:8:end);
L2C3_5.Sort = GS_20210920.Sorting(3:8:end);
L2C4.Sort = GS_20210920.Sorting(4:8:end);
L2C4_5.Sort = GS_20210920.Sorting(5:8:end);
L2C5W.Sort = GS_20210920.Sorting(6:8:end);
L2C5E.Sort = GS_20210920.Sorting(7:8:end);
L2C6.Sort = GS_20210920.Sorting(8:8:end);

Sort.GS_20210920 = [L2C2.Sort L2C3.Sort L2C3_5.Sort L2C4.Sort L2C4_5.Sort L2C5W.Sort L2C5E.Sort L2C6.Sort];
Sort.GS_20210920 = [Sort.GS_20210920; Sort.GS_20210920(end,:)]; % duplicate last row (required for pcolor)
Sort.GS_20210920 = [Sort.GS_20210920, Sort.GS_20210920(:,end)]; % duplicate last column (required for pcolor)

% Visualisation
f6 = figure;
pcolor(1:height(Sort.GS_20210920), 1:length(Sort.GS_20210920), Sort.GS_20210920')
shading flat

title('2021-09-20')
ylabel('cross-shore location')
xlabel('moment in tidal cycle')

xticks(1.5:4.5)
xticklabels({'HW','HT_\downarrow','LW','HT_\uparrow'})
yticks(1.5:8.5)
yticklabels(locs)

c = colorbar;
c.Label.String = '\sigma_G';
c.Label.FontSize = fontsize;
crameri('imola')
clim([1, 3])

%% GS_20210928
L2C2.Sort = GS_20210928.Sorting(1:8:32);
L2C3.Sort = GS_20210928.Sorting(2:8:32);
L2C3_5.Sort = GS_20210928.Sorting(3:8:32);
L2C4.Sort = GS_20210928.Sorting(4:8:32);
L2C4_5.Sort = GS_20210928.Sorting(5:8:32);
L2C5W.Sort = GS_20210928.Sorting(6:8:32);
L2C5E.Sort = GS_20210928.Sorting(7:8:32);
L2C6.Sort = GS_20210928.Sorting(8:8:32);

Sort.GS_20210928 = [L2C2.Sort L2C3.Sort L2C3_5.Sort L2C4.Sort L2C4_5.Sort L2C5W.Sort L2C5E.Sort L2C6.Sort];
Sort.GS_20210928 = [Sort.GS_20210928; Sort.GS_20210928(end,:)]; % duplicate last row (required for pcolor)
Sort.GS_20210928 = [Sort.GS_20210928, Sort.GS_20210928(:,end)]; % duplicate last column (required for pcolor)

% Visualisation
f7 = figure;
pcolor(1:height(Sort.GS_20210928), 1:length(Sort.GS_20210928), Sort.GS_20210928')
shading flat

title('2021-09-28')
ylabel('cross-shore location')
xlabel('moment in tidal cycle')

xticks(1.5:4.5)
xticklabels({'HW','HT_\downarrow','LW','HT_\uparrow'})
yticks(1.5:8.5)
yticklabels(locs)

c = colorbar;
c.Label.String = '\sigma_G';
c.Label.FontSize = fontsize;
crameri('imola')
clim([1, 3])

%% GS_20211001
L2C2.Sort = GS_20211001.Sorting(2:8:9);
L2C3.Sort = GS_20211001.Sorting(3:8:9);
L2C3_5.Sort = GS_20211001.Sorting(4:8:9);
L2C4.Sort = GS_20211001.Sorting(5:8:9);
L2C4_5.Sort = GS_20211001.Sorting(6:8:9);
L2C5W.Sort = GS_20211001.Sorting(7:8:9);
L2C5E.Sort = GS_20211001.Sorting(8:8:9);
L2C6.Sort = GS_20211001.Sorting(9:8:9);

Sort.GS_20211001 = [L2C2.Sort L2C3.Sort L2C3_5.Sort L2C4.Sort L2C4_5.Sort L2C5W.Sort L2C5E.Sort L2C6.Sort];
Sort.GS_20211001 = [Sort.GS_20211001; Sort.GS_20211001(end,:)]; % duplicate last row (required for pcolor)
Sort.GS_20211001 = [Sort.GS_20211001, Sort.GS_20211001(:,end)]; % duplicate last column (required for pcolor)

% Visualisation
f8 = figure;
pcolor(1:height(Sort.GS_20211001), 1:length(Sort.GS_20211001), Sort.GS_20211001')
shading flat

title('2021-10-01')
ylabel('cross-shore location')
xlabel('moment in tidal cycle')

xticks(1.5:4.5)
xticklabels({'LW'})
yticks(1.5:8.5)
yticklabels(locs)

c = colorbar;
c.Label.String = '\sigma_G';
c.Label.FontSize = fontsize;
crameri('imola')
clim([1, 3])

%% GS_20211007
L2C2.Sort = GS_20211007.Sorting(1:8:end);
L2C3.Sort = GS_20211007.Sorting(2:8:end);
L2C3_5.Sort = GS_20211007.Sorting(3:8:end);
L2C4.Sort = GS_20211007.Sorting(4:8:end);
L2C4_5.Sort = GS_20211007.Sorting(5:8:end);
L2C5W.Sort = GS_20211007.Sorting(6:8:end);
L2C5E.Sort = GS_20211007.Sorting(7:8:end);
L2C6.Sort = GS_20211007.Sorting(8:8:end);

Sort.GS_20211007 = [L2C2.Sort L2C3.Sort L2C3_5.Sort L2C4.Sort L2C4_5.Sort L2C5W.Sort L2C5E.Sort L2C6.Sort];
Sort.GS_20211007 = [Sort.GS_20211007; Sort.GS_20211007(end,:)]; % duplicate last row (required for pcolor)
Sort.GS_20211007 = [Sort.GS_20211007, Sort.GS_20211007(:,end)]; % duplicate last column (required for pcolor)

% Visualisation
f9 = figure;
pcolor(1:height(Sort.GS_20211007), 1:length(Sort.GS_20211007), Sort.GS_20211007')
shading flat

title('2021-10-07')
ylabel('cross-shore location')
xlabel('moment in tidal cycle')

xticks(1.5:4.5)
xticklabels({'HW','HT_\downarrow','LW','HT_\uparrow'})
yticks(1.5:8.5)
yticklabels(locs)

c = colorbar;
c.Label.String = '\sigma_G';
c.Label.FontSize = fontsize;
crameri('imola')
clim([1, 3])

%% GS_20211015
L2C2.Sort = GS_20211015.Sorting(1:8:end);
L2C3.Sort = GS_20211015.Sorting(2:8:end);
L2C3_5.Sort = GS_20211015.Sorting(3:8:end);
L2C4.Sort = GS_20211015.Sorting(4:8:end);
L2C4_5.Sort = GS_20211015.Sorting(5:8:end);
L2C5W.Sort = GS_20211015.Sorting(6:8:end);
L2C5E.Sort = GS_20211015.Sorting(7:8:end);
L2C6.Sort = GS_20211015.Sorting(8:8:end);

Sort.GS_20211015 = [L2C2.Sort L2C3.Sort L2C3_5.Sort L2C4.Sort L2C4_5.Sort L2C5W.Sort L2C5E.Sort L2C6.Sort];
Sort.GS_20211015 = [Sort.GS_20211015; Sort.GS_20211015(end,:)]; % duplicate last row (required for pcolor)
Sort.GS_20211015 = [Sort.GS_20211015, Sort.GS_20211015(:,end)]; % duplicate last column (required for pcolor)

% Visualisation
f10 = figure;
pcolor(1:height(Sort.GS_20211015), 1:length(Sort.GS_20211015), Sort.GS_20211015')
shading flat

title('2021-10-15')
ylabel('cross-shore location')
xlabel('moment in tidal cycle')

xticks(1.5:4.5)
xticklabels({'LW','HT_\uparrow','HW','HT_\downarrow'})
yticks(1.5:8.5)
yticklabels(locs)

c = colorbar;
c.Label.String = '\sigma_G';
c.Label.FontSize = fontsize;
crameri('imola')
clim([1, 3])
