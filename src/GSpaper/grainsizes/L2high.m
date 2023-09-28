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
GS_20211009.Sample_Number = repelem(1, 5)';

% Visualisation
f1 = figure;
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(7,[5 5])
h1 = heatmap(GS_20211009, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Mean_mu');
colormap(h1, crameri('lajolla'))
clim([0, 2000])

h1.Title = [];
h1.XDisplayLabels = 'LW';
h1.YDisplayData = flipud(h1.YDisplayData);
h1.XLabel = '';
h1.YLabel = '';
h1.FontSize = fontsize;
h1.CellLabelFormat = '%0.0f';
h1.ColorbarVisible = 'off';
h1.GridVisible = 'off';

nexttile(6)
text(0, .5, '2021-10-09', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata = h1.ColorData;
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
nexttile(1,[1 5])
errorbar(1.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
% ylim([0 1000])
ylabel('µm')
xticks([])

nexttile(12,[5 1])
plot(GS_20211009.zNAP_m, 1.5:5.5, '-ok', 'LineWidth',3)
xline(PHZ.MSL, '-k', 'MSL', 'LabelVerticalAlignment','middle',...
    'LabelHorizontalAlignment','left', 'FontSize',fontsize, 'LineWidth',2)
xlim([-.5 1.5])
ylim([1 6])
xlabel('z (NAP+m)')
yticks([])
