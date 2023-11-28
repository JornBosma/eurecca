%% Initialisation
close all
clear
clc

[~, fontsize, ~, PHZ] = eurecca_init;

folderPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor' filesep];


%% GS_20210408 (x): 8 Apr 2021

% Load sediment data
dataPath = [folderPath 'grainsizes' filesep 'GS_20210408.csv'];
opts = detectImportOptions(dataPath);
opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy');
GS_20210408 = readtable(dataPath, opts);

% Prepare table
GS_20210408 = [GS_20210408; GS_20210408; GS_20210408; GS_20210408];
GS_20210408{5:end, 6:end} = NaN;
GS_20210408.Sample_Number = repelem([1 2 3 4], 4)';

% Visualisation
f1 = figureRH;
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(7,[5 5])
h1 = heatmap(GS_20210408, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Mean_mu');
colormap(h1, crameri('lajolla'))
clim([0, 2000])

h1.Title = [];
h1.XDisplayData = {'3','4','1','2'};
h1.XDisplayLabels = {'HW','MT_\downarrow','LW','MT_\uparrow'};
h1.YDisplayData = flipud(h1.YDisplayData);
h1.XLabel = '';
h1.YLabel = '';
h1.FontSize = fontsize;
h1.CellLabelFormat = '%0.0f';
h1.ColorbarVisible = 'off';
h1.GridVisible = 'off';
h1.MissingDataColor = 'w';
h1.MissingDataLabel = 'no data';

nexttile(6)
text(0, .5, '2021-04-08', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata = h1.ColorData;
heatdata = [heatdata(:,3:4) heatdata(:,1) heatdata(:,2)]; % correct sequence
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
nexttile(1,[1 5])
errorbar(1.5:4.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 5])
% ylim([0 1000])
ylabel('µm')
xticks([])

nexttile(12,[5 1])
plot(GS_20210408.zNAP_m(1:4), 1.5:4.5, '-ok', 'LineWidth',3)
xline(PHZ.MSL, '-k', 'MSL', 'LabelVerticalAlignment','middle',...
    'LabelHorizontalAlignment','left', 'FontSize',fontsize, 'LineWidth',2)
xlim([-.5 1.5])
ylim([1 5])
xlabel('z (NAP+m)')
yticks([])


%% GS_20210606 (x): 6 Jun 2021

% Load sediment data
dataPath = [folderPath 'grainsizes' filesep 'GS_20210606.csv'];
opts = detectImportOptions(dataPath);
opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy');
GS_20210606 = readtable(dataPath, opts);

% Prepare table
GS_20210606(1, :) = [];
GS_20210606 = [GS_20210606; GS_20210606; GS_20210606; GS_20210606];
GS_20210606{5:end, 6:end} = NaN;
GS_20210606.Sample_Number = repelem([1 2 3 4], 4)';

% Visualisation
f2 = figureRH;
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(7,[5 5])
h2 = heatmap(GS_20210606, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Mean_mu');
colormap(h2, crameri('lajolla'))
clim([0, 2000])

h2.Title = [];
h2.XDisplayData = {'3','4','1','2'};
h2.XDisplayLabels = {'HW','MT_\downarrow','LW','MT_\uparrow'};
h2.YDisplayData = h2.YDisplayData;
h2.YDisplayLabels = {'0.00 m','-0.08 m','-0.20 m','-0.35 m'};
h2.XLabel = '';
h2.YLabel = '';
h2.FontSize = fontsize;
h2.CellLabelFormat = '%0.2f';
h2.ColorbarVisible = 'off';
h2.GridVisible = 'off';
h2.MissingDataColor = 'w';
h2.MissingDataLabel = 'no data';

nexttile(6)
text(0, .5, '2021-06-06', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata = flipud(h2.ColorData);
heatdata = [heatdata(:,3:4) heatdata(:,1) heatdata(:,2)]; % correct sequence
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
nexttile(1,[1 5])
errorbar(1.5:4.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 5])
% ylim([0 1000])
ylabel('µm')
xticks([])

meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');
nexttile(12,[5 1])
errorbar(meanT, 1.5:4.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 5])
% xlim([0 1000])
xlabel('µm')
yticks([])

