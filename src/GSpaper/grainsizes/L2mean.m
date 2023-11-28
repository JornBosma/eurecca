%% Initialisation
close all
clear
clc

[~, fontsize, ~, PHZ] = eurecca_init;

folderPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor' filesep];
locsX = {'L2C2', 'L2C3', 'L2C3.5', 'L2C4', 'L2C4.5', 'L2C5W', 'L2C5E', 'L2C6'};


%% GS_20210920 (bed level: 19 Sep 2021)

% Load sediment data
dataPath = [folderPath 'grainsizes' filesep 'GS_20210920.csv'];
opts = detectImportOptions(dataPath);
opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy');
GS_20210920 = readtable(dataPath, opts);

% Prepare table
GS_20210920 = [GS_20210920(1:16,:); GS_20210920(1,:); GS_20210920(17:end,:)]; % unchanged L2C2_3
GS_20210920.Sample_Identity(17) = {'L2C2_3'};
GS_20210920.Sample_Number = repelem([1 2 3 4], 8)';
GS_20210920.Sample_Identity = regexprep(GS_20210920.Sample_Identity, '_.*', '');

% Visualisation
f1 = figureRH;
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(7,[5 5])
h1 = heatmap(GS_20210920, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Mean_mu');
colormap(h1, crameri('lajolla'))
clim([0, 2000])

h1.Title = [];
h1.XDisplayLabels = {'HW','MT_\downarrow','LW','MT_\uparrow'};
h1.YDisplayData = fliplr(locsX);
h1.XLabel = '';
h1.YLabel = '';
h1.FontSize = fontsize;
h1.CellLabelFormat = '%0.2f';
h1.ColorbarVisible = 'off';
h1.GridVisible = 'off';

nexttile(6)
text(0, .5, '2021-09-20', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata = [h1.ColorData(1:5,:); h1.ColorData(7,:); h1.ColorData(6,:); h1.ColorData(8,:)]; % swap C5E and C5W
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
errorbar(meanT, 1.5:8.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 9])
% xlim([0 1000])
xlabel('µm')
yticks([])


%% GS_20210928 (bed level: 28 Sep 2021)

% Load sediment data
dataPath = [folderPath 'grainsizes' filesep 'GS_20210928.csv'];
opts = detectImportOptions(dataPath);
opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy');
GS_20210928 = readtable(dataPath, opts);

% Prepare table
GS_20210928 = GS_20210928(startsWith(GS_20210928.Sample_Identity, 'L2C'), :);
GS_20210928.Sample_Number = repelem([1 2 3 4], 8)';
GS_20210928.Sample_Identity = regexprep(GS_20210928.Sample_Identity, '_.*', '');

% Visualisation
f2 = figureRH;
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(7,[5 5])
h2 = heatmap(GS_20210928, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Mean_mu');
colormap(h2, crameri('lajolla'))
clim([0, 2000])

h2.Title = [];
h2.XDisplayLabels = {'HW','MT_\downarrow','LW','MT_\uparrow'};
h2.YDisplayData = fliplr(locsX);
h2.XLabel = '';
h2.YLabel = '';
h2.FontSize = fontsize;
h2.CellLabelFormat = '%0.2f';
h2.ColorbarVisible = 'off';
h2.GridVisible = 'off';

nexttile(6)
text(0, .5, '2021-09-28', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata = [h2.ColorData(1:5,:); h2.ColorData(7,:); h2.ColorData(6,:); h2.ColorData(8,:)]; % swap C5E and C5W
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
errorbar(meanT, 1.5:8.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 9])
% xlim([0 1000])
xlabel('µm')
yticks([])


%% GS_20211001 (bed level: 30 Sep 2021)

% Load sediment data
dataPath = [folderPath 'grainsizes' filesep 'GS_20211001.csv'];
opts = detectImportOptions(dataPath);
opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy');
GS_20211001 = readtable(dataPath, opts);

% Prepare table
GS_20211001(1, :) = [];
GS_20211001(endsWith(GS_20211001.Sample_Identity, '1001'), :) = [];
GS_20211001 = [GS_20211001; GS_20211001; GS_20211001; GS_20211001];
GS_20211001{9:end, 6:end} = NaN;
GS_20211001.Sample_Number = repelem([1 2 3 4], 8)';

% Visualisation
f3 = figureRH;
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(7,[5 5])
h3 = heatmap(GS_20211001, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Mean_mu');
colormap(h3, crameri('lajolla'))
clim([0, 2000])

h3.Title = [];
h3.XDisplayData = {'3','4','1','2'};
h3.XDisplayLabels = {'HW','MT_\downarrow','LW','MT_\uparrow'};
h3.YDisplayData = fliplr(locsX);
h3.XLabel = '';
h3.YLabel = '';
h3.FontSize = fontsize;
h3.CellLabelFormat = '%0.2f';
h3.ColorbarVisible = 'off';
h3.GridVisible = 'off';
h3.MissingDataColor = 'w';
h3.MissingDataLabel = 'no data';

nexttile(6)
text(0, .5, '2021-10-01', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata = [h3.ColorData(1:5,:); h3.ColorData(7,:); h3.ColorData(6,:); h3.ColorData(8,:)]; % swap C5E and C5W
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
errorbar(meanT, 1.5:8.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 9])
% xlim([0 1000])
xlabel('µm')
yticks([])


%% GS_20211007 (bed level: 7 Oct 2021)

% Load sediment data
dataPath = [folderPath 'grainsizes' filesep 'GS_20211007.csv'];
opts = detectImportOptions(dataPath);
opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy');
GS_20211007 = readtable(dataPath, opts);

% Prepare table
GS_20211007.Sample_Number = repelem([1 2 3 4], 8)';
GS_20211007.Sample_Identity = regexprep(GS_20211007.Sample_Identity, '_.*', '');

% Visualisation
f4 = figureRH;
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(7,[5 5])
h4 = heatmap(GS_20211007, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Mean_mu');
colormap(h4, crameri('lajolla'))
clim([0, 2000])

h4.Title = [];
h4.XDisplayLabels = {'HW','MT_\downarrow','LW','MT_\uparrow'};
h4.YDisplayData = fliplr(locsX);
h4.XLabel = '';
h4.YLabel = '';
h4.FontSize = fontsize;
h4.CellLabelFormat = '%0.2f';
h4.ColorbarVisible = 'off';
h4.GridVisible = 'off';

nexttile(6)
text(0, .5, '2021-10-07', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata = [h4.ColorData(1:5,:); h4.ColorData(7,:); h4.ColorData(6,:); h4.ColorData(8,:)]; % swap C5E and C5W
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
errorbar(meanT, 1.5:8.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 9])
% xlim([0 1000])
xlabel('µm')
yticks([])


%% GS_20211015 (bed level: 15 Oct 2021)

% Load sediment data
dataPath = [folderPath 'grainsizes' filesep 'GS_20211015.csv'];
opts = detectImportOptions(dataPath);
opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy');
GS_20211015 = readtable(dataPath, opts);

% Prepare table
GS_20211015 = [GS_20211015(1:7,:); GS_20211015(15,:); GS_20211015(8:end,:)]; % too deep L2C6_1
GS_20211015.Sample_Identity(8) = {'L2C6_1'};
GS_20211015{8, 6:end} = NaN;
GS_20211015 = [GS_20211015; GS_20211015(1:8, :)];
GS_20211015{25:end, 6:end} = NaN;
GS_20211015.Sample_Number = repelem([1 2 3 4], 8)';
GS_20211015.Sample_Identity = regexprep(GS_20211015.Sample_Identity, '_.*', '');

% Visualisation
f5 = figureRH;
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(7,[5 5])
h5 = heatmap(GS_20211015, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Mean_mu');
colormap(h5, crameri('lajolla'))
clim([0, 2000])

h5.Title = [];
h5.XDisplayLabels = {'LW','MT_\uparrow','HW','MT_\downarrow'};
h5.YDisplayData = fliplr(locsX);
h5.XLabel = '';
h5.YLabel = '';
h5.FontSize = fontsize;
h5.CellLabelFormat = '%0.2f';
h5.ColorbarVisible = 'off';
h5.GridVisible = 'off';
h5.MissingDataColor = 'w';
h5.MissingDataLabel = 'no data';

nexttile(6)
text(0, .5, '2021-10-15', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata = [h5.ColorData(1:5,:); h5.ColorData(7,:); h5.ColorData(6,:); h5.ColorData(8,:)]; % swap C5E and C5W
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
errorbar(meanT, 1.5:8.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 9])
% xlim([0 1000])
xlabel('µm')
yticks([])

