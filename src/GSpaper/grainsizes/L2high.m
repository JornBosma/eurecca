%% Initialisation
close all
clear
clc

[~, fontsize, ~, PHZ] = eurecca_init;

folderPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor' filesep];


%% GS_20211009 (x): 9 Oct 2021

% Load sediment data
dataPath = [folderPath 'grainsizes' filesep 'GS_20211009.csv'];
opts = detectImportOptions(dataPath);
opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy');
GS_20211009 = readtable(dataPath, opts);

% Prepare table
GS_20211009 = GS_20211009(startsWith(GS_20211009.Sample_Identity, 'R02'), :);
GS_20211009 = [GS_20211009; GS_20211009; GS_20211009; GS_20211009];
GS_20211009{6:end, 6:end} = NaN;
GS_20211009.Sample_Number = repelem([1 2 3 4], 5)';

% Visualisation
f1 = figureRH;
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(7,[5 5])
h1 = heatmap(GS_20211009, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Mean_mu');
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
text(0, .5, '2021-10-09', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
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
plot(GS_20211009.zNAP_m(1:5), 1.5:5.5, '-ok', 'LineWidth',3)
xline(PHZ.MeanSL, '-k', 'MSL', 'LabelVerticalAlignment','middle',...
    'LabelHorizontalAlignment','left', 'FontSize',fontsize, 'LineWidth',2)
xlim([-.5 1.5])
ylim([1 6])
xlabel('z (NAP+m)')
yticks([])


%% GS_20201203 (x): 3 Dec 2020

% Load sediment data
dataPath = [folderPath 'grainsizes' filesep 'GS_20201203.csv'];
opts = detectImportOptions(dataPath);
opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy');
GS_20201203 = readtable(dataPath, opts);

% Prepare table
GS_20201203 = [GS_20201203; GS_20201203; GS_20201203; GS_20201203];
GS_20201203{11:end, 6:end} = NaN;
GS_20201203.Sample_Number = repelem([1 2 3 4], 10)';

% Visualisation
f2 = figureRH;
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(7,[5 5])
h2 = heatmap(GS_20201203, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Mean_mu');
colormap(h2, crameri('lajolla'))
clim([0, 2000])

h2.Title = [];
h2.XDisplayData = {'3','4','1','2'};
h2.XDisplayLabels = {'HW','MT_\downarrow','LW','MT_\uparrow'};
h2.YDisplayData = flipud(h2.YDisplayData);
h2.XLabel = '';
h2.YLabel = '';
h2.FontSize = fontsize;
h2.CellLabelFormat = '%0.0f';
h2.ColorbarVisible = 'off';
h2.GridVisible = 'off';
h2.MissingDataColor = 'w';
h2.MissingDataLabel = 'no data';

nexttile(6)
text(0, .5, '2020-12-03', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata = h2.ColorData;
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
plot(GS_20201203.zNAP_m(1:10), 1.5:10.5, '-ok', 'LineWidth',3)
xline(PHZ.MeanSL, '-k', 'MSL', 'LabelVerticalAlignment','middle',...
    'LabelHorizontalAlignment','left', 'FontSize',fontsize, 'LineWidth',2)
xlim([-1.5 2.5])
ylim([1 11])
xlabel('z (NAP+m)')
yticks([])

