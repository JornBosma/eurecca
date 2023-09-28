%% Initialisation
close all
clear
clc

[~, fontsize, ~, PHZ] = eurecca_init;

folderPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor' filesep];
locsY = {'S', 'SL', 'L3.5', 'L4', 'T', 'L6'};


%% GS_20210921

% Load sediment data
dataPath = [folderPath 'grainsizes' filesep 'GS_20210921.csv'];
opts = detectImportOptions(dataPath);
opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy');
GS_20210921 = readtable(dataPath, opts);

% Prepare table
GS_20210921 = GS_20210921(~startsWith(GS_20210921.Sample_Identity, 'L2C'), :);
GS_20210921.Sample_Number = [1; 3; 1; 2; 3; 1; 3; 1; 3; 1; 3; 1; 3];
GS_20210921.Sample_Identity = regexprep(GS_20210921.Sample_Identity, '_.*', '');

% Visualisation
f2 = figure;
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(7,[5 5])
h2 = heatmap(GS_20210921, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Mean_mu');
colormap(h2, crameri('lajolla'))
clim([0, 2000])

h2.Title = [];
h2.XDisplayLabels = {'0 m','-0.5 m','-0.75 m'};
h2.YDisplayData = locsY;
h2.XLabel = '';
h2.YLabel = '';
h2.FontSize = fontsize;
h2.CellLabelFormat = '%0.0f';
h2.ColorbarVisible = 'off';
h2.GridVisible = 'off';

nexttile(6)
text(0, .5, '2021-09-21', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata = [h2.ColorData(3,:); h2.ColorData(6,:); h2.ColorData(2,:);...
    h2.ColorData(1,:); h2.ColorData(5,:); h2.ColorData(4,:)]; % correct sequence
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
nexttile(1,[1 5])
errorbar(1.5:3.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 4])
% ylim([0 1000])
ylabel('µm')
xticks([])

meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');
nexttile(12,[5 1])
errorbar(meanT, 1.5:6.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 7])
% xlim([0 1000])
xlabel('µm')
yticks([])


%% GS_20210928

% Load sediment data
dataPath = [folderPath 'grainsizes' filesep 'GS_20210928.csv'];
opts = detectImportOptions(dataPath);
opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy');
GS_20210928 = readtable(dataPath, opts);

% Prepare table
GS_20210928 = GS_20210928(~startsWith(GS_20210928.Sample_Identity, 'L2C'), :);
GS_20210928.Sample_Number = [1; 3; 1; 2; 3; 1; 3; 1; 3; 1; 3; 1; 3];
GS_20210928.Sample_Identity = regexprep(GS_20210928.Sample_Identity, '_.*', '');

% Visualisation
f3 = figure;
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(7,[5 5])
h3 = heatmap(GS_20210928, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Mean_mu');
colormap(h3, crameri('lajolla'))
clim([0, 2000])

h3.Title = [];
h3.XDisplayLabels = {'0 m','-0.5 m','-0.75 m'};
h3.YDisplayData = locsY;
h3.XLabel = '';
h3.YLabel = '';
h3.FontSize = fontsize;
h3.CellLabelFormat = '%0.0f';
h3.ColorbarVisible = 'off';
h3.GridVisible = 'off';

nexttile(6)
text(0, .5, '2021-09-28', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata = [h3.ColorData(3,:); h3.ColorData(6,:); h3.ColorData(2,:);...
    h3.ColorData(1,:); h3.ColorData(5,:); h3.ColorData(4,:)]; % correct sequence
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
nexttile(1,[1 5])
errorbar(1.5:3.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 4])
% ylim([0 1000])
ylabel('µm')
xticks([])

meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');
nexttile(12,[5 1])
errorbar(meanT, 1.5:6.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 7])
% xlim([0 1000])
xlabel('µm')
yticks([])


%% Longshore: 2021-09-21 & 2021-09-28

% Prepare table
Longshore = [GS_20210921; GS_20210928];
Longshore.Sample_Number = repelem([1 2], 13)';

% Visualisation
f1 = figure;
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(7,[5 5])
h1 = heatmap(Longshore, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Mean_mu');
colormap(h1, crameri('lajolla'))
clim([0, 2000])

h1.Title = [];
h1.XDisplayLabels = {string(Longshore.Date_ddMMyyyy(1)), string(Longshore.Date_ddMMyyyy(14))};
h1.YDisplayData = locsY;
h1.XLabel = '';
h1.YLabel = '';
h1.FontSize = fontsize;
h1.CellLabelFormat = '%0.0f';
h1.ColorbarVisible = 'off';
h1.GridVisible = 'off';

nexttile(6)
text(0, .5, 'Longshore', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata = [h1.ColorData(3,:); h1.ColorData(6,:); h1.ColorData(2,:);...
    h1.ColorData(1,:); h1.ColorData(5,:); h1.ColorData(4,:)]; % correct sequence
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
nexttile(1,[1 5])
errorbar(1.5:2.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 3])
% ylim([0 1000])
ylabel('µm')
xticks([])

meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');
nexttile(12,[5 1])
errorbar(meanT, 1.5:6.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 7])
% xlim([0 1000])
xlabel('µm')
yticks([])

