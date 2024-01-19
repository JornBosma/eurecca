%% Initialisation
close all
clear
clc

[~, fontsize, ~, PHZ, SEDMEX] = eurecca_init;
% fontsize = 30; % ultra-wide screen

folderPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor' filesep];
locsX = {'L2C2', 'L2C3', 'L2C3.5', 'L2C4', 'L2C4.5', 'L2C5W', 'L2C5E', 'L2C6'};
sampleNames = {'S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8'};
locsY = {'S', 'SL', 'L3.5', 'L4', 'T', 'L6'};
idxSedi = [2155 2166 2171 2176 2181 2186 2196 2209];


%% Cross-shore profiles
dataPath{6} = [folderPath 'topobathy' filesep 'transects' filesep 'PHZD.nc'];

% Assign variables
x = ncread(dataPath{6}, 'x'); % xRD [m]
y = ncread(dataPath{6}, 'y'); % yRD [m]
z = ncread(dataPath{6}, 'z'); % bed level [m+NAP]
d = ncread(dataPath{6}, 'd'); % cross-shore distance [m]
ID = ncread(dataPath{6}, 'ID'); % profile ID (days since 2020-10-16 00:00:00)
transect = ncread(dataPath{6}, 'transect'); % tansect number (Python counting)

% Timing
startDate = datetime('2020-10-16 00:00:00');
surveyDates = startDate + days(ID);
surveyDates.Format = 'dd MMM yyyy';

% Data selection
track = 2; % L2
% survey = [15 18 19 24 27];
survey = [15 18 19 20 21 24];
% survey = 15:24;

Z = NaN(length(z), length(survey));
for n = 1:length(survey)
    Z(:,n) = z(:, survey(n), track);
    Z(:,n) = movmean(Z(:,n), length(survey));
end


%% L2 profile development
f1 = figure('Position',[1722, 709, 1719, 628]);

hold on
p = nan(length(survey));
% valAlpha = nan(size(survey));
% valCol = nan(length(survey), 3);
valCol = repmat(linspace(1,.1,length(survey))', 1, 3);
for n = 1:length(survey)
    % valAlpha(n) = (1/length(survey))+(n-1)*(1/length(survey));
    % p(n) = plot(d, Z(:,n), 'LineWidth',3, 'Color',[cbf.orange, valAlpha(n)]);
    % p(n) = plot(d, Z(:,n), 'LineWidth',3, 'Color',valCol(n,:));
    p(n) = plot(d, Z(:,n), 'LineWidth',3);
end
hold off

newcolors = crameri('-acton', length(survey));
colororder(newcolors)

xline(d(idxSedi), '-', string(sampleNames), 'FontSize',fontsize, 'LabelHorizontalAlignment','center')

yline(.731, '--', 'MHW', 'FontSize',fontsize)
yline(.192, '-.', 'MSL', 'FontSize',fontsize)  % Computed over considered period
yline(-.535, '--', 'MLW', 'FontSize',fontsize)

xlim([-30, 20])
ylim([-1.7, 1.7])

xlabel('cross-shore distance (m)')
ylabel('bed level (NAP+m)')
lgd = legend(string(surveyDates(survey)), 'Location','eastoutside');
% lgd.Position = [0.150 0.172	0.113 0.256];


%% Cross-shore sediment stats
dataPath{1} = [folderPath 'grainsizes' filesep 'GS_20210920.csv'];
dataPath{2} = [folderPath 'grainsizes' filesep 'GS_20210928.csv'];
dataPath{3} = [folderPath 'grainsizes' filesep 'GS_20211001.csv'];
dataPath{4} = [folderPath 'grainsizes' filesep 'GS_20211007.csv'];
dataPath{5} = [folderPath 'grainsizes' filesep 'GS_20211015.csv'];

opts = detectImportOptions(dataPath{1});
opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy');

GS_20210920 = readtable(dataPath{1}, opts);
GS_20210920 = [GS_20210920(1:16,:); GS_20210920(1,:); GS_20210920(17:end,:)]; % unchanged L2C2_3
GS_20210920.Sample_Identity(17) = {'L2C2_3'};
GS_20210920.Sample_Number = repelem([1 2 3 4], 8)';
GS_20210920.Sample_Identity = regexprep(GS_20210920.Sample_Identity, '_.*', '');
GS_20210920.Mean_mm = GS_20210920.Mean_mu/1e3;

GS_20210928 = readtable(dataPath{2}, opts);
GS_20210928 = GS_20210928(startsWith(GS_20210928.Sample_Identity, 'L2C'), :);
GS_20210928.Sample_Number = repelem([1 2 3 4], 8)';
GS_20210928.Sample_Identity = regexprep(GS_20210928.Sample_Identity, '_.*', '');
GS_20210928.zNAP_m = repmat(Z(idxSedi, 2), 4, 1);
GS_20210928.Mean_mm = GS_20210928.Mean_mu/1e3;

GS_20211001 = readtable(dataPath{3}, opts);
GS_20211001(1, :) = [];
GS_20211001(endsWith(GS_20211001.Sample_Identity, '1001'), :) = [];
GS_20211001 = [GS_20211001; GS_20211001; GS_20211001; GS_20211001];
GS_20211001{9:end, 6:end} = NaN;
GS_20211001.Sample_Number = repelem([1 2 3 4], 8)';
GS_20211001.zNAP_m = repmat(Z(idxSedi, 3), 4, 1);
GS_20211001.Mean_mm = GS_20211001.Mean_mu/1e3;

GS_20211007 = readtable(dataPath{4}, opts);
GS_20211007.Sample_Number = repelem([1 2 3 4], 8)';
GS_20211007.Sample_Identity = regexprep(GS_20211007.Sample_Identity, '_.*', '');
GS_20211007.zNAP_m = repmat(Z(idxSedi, 4), 4, 1);
GS_20211007.Mean_mm = GS_20211007.Mean_mu/1e3;

GS_20211015 = readtable(dataPath{5}, opts);
GS_20211015 = [GS_20211015(1:7,:); GS_20211015(15,:); GS_20211015(8:end,:)]; % too deep L2C6_1
GS_20211015.Sample_Identity(8) = {'L2C6_1'};
GS_20211015{8, 6:end} = NaN;
GS_20211015 = [GS_20211015; GS_20211015(1:8, :)];
GS_20211015{25:end, 6:end} = NaN;
GS_20211015.Sample_Number = repelem([1 2 3 4], 8)';
GS_20211015.Sample_Identity = regexprep(GS_20211015.Sample_Identity, '_.*', '');
GS_20211015.zNAP_m = repmat(Z(idxSedi, 5), 4, 1);
GS_20211015.Mean_mm = GS_20211015.Mean_mu/1e3;


%% Quick statistics
minMean = min([GS_20210920.Mean_mm; GS_20210928.Mean_mm; GS_20211007.Mean_mm]);
maxMean = max([GS_20210920.Mean_mm; GS_20210928.Mean_mm; GS_20211007.Mean_mm]);

minStd = min([GS_20210920.Sorting; GS_20210928.Sorting; GS_20211007.Sorting]);
maxStd = max([GS_20210920.Sorting; GS_20210928.Sorting; GS_20211007.Sorting]);

minSk = min([GS_20210920.Skewness; GS_20210928.Skewness; GS_20211007.Skewness]);
maxSk = max([GS_20210920.Skewness; GS_20210928.Skewness; GS_20211007.Skewness]);

minK = min([GS_20210920.Kurtosis; GS_20210928.Kurtosis; GS_20211007.Kurtosis]);
maxK = max([GS_20210920.Kurtosis; GS_20210928.Kurtosis; GS_20211007.Kurtosis]);

meanMapLim = [minMean, maxMean];
stdMapLim = [minStd, maxStd];
skMapLim = [minSk, maxSk];
kMapLim = [minK, maxK];


%% Visualisation: GS_20210920 Mean
f2a = figure('Position',[1654, 714, 893, 623]);
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(13,[4 4])
h2a = heatmap(GS_20210920, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Mean_mm');
colormap(h2a, crameri('lajolla'))
clim(meanMapLim)

h2a.Title = [];
h2a.YDisplayData = flipud(h2a.YDisplayData);
h2a.YDisplayLabels = fliplr({'HW ','MT_\downarrow','LW ','MT_\uparrow'});
h2a.XDisplayData = locsX;
h2a.XDisplayLabels = sampleNames;
h2a.XLabel = '';
h2a.YLabel = '';
h2a.FontSize = fontsize*1.2;
h2a.CellLabelFormat = '%0.1f';
h2a.ColorbarVisible = 'off';
h2a.GridVisible = 'off';

nexttile(5,[2 2])
text(.1, .4, '2021-09-20 \newline  M_{G} (mm)', 'FontSize',fontsize*1.2, 'FontWeight','bold', 'EdgeColor','none', 'Margin',6)
axis off

heatdata = flipud([h2a.ColorData(:, 1:5), h2a.ColorData(:, 7),...
    h2a.ColorData(:, 6), h2a.ColorData(:, 8)]);  % swap C5E and C5W
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');

nexttile(1,[2 4])
errorbar(1.5:8.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 9])
ylim([0 2])
xticks([])
set(gca, 'FontSize',fontsize*1.2);

nexttile(17,[4 2])
errorbar(meanT, 1.5:4.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 5])
xlim([0 2])
yticks([])
set(gca, 'FontSize',fontsize*1.2);


%% Visualisation: GS_20210920 Sorting
f2b = figure('Position',[1654, 11, 893, 623]);
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(13,[4 4])
h2b = heatmap(GS_20210920, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Sorting');
colormap(h2b, crameri('imola'))
clim(stdMapLim)

h2b.Title = [];
h2b.YDisplayData = flipud(h2b.YDisplayData);
h2b.YDisplayLabels = fliplr({'HW ','MT_\downarrow','LW ','MT_\uparrow'});
h2b.XDisplayData = locsX;
h2b.XDisplayLabels = sampleNames;
h2b.XLabel = '';
h2b.YLabel = '';
h2b.FontSize = fontsize*1.2;
h2b.CellLabelFormat = '%0.1f';
h2b.ColorbarVisible = 'off';
h2b.GridVisible = 'off';

nexttile(5,[2 2])
text(.1, .4, '2021-09-20 \newline      \sigma_{G}', 'FontSize',fontsize*1.2, 'FontWeight','bold', 'EdgeColor','none', 'Margin',6)
axis off

heatdata = flipud([h2b.ColorData(:, 1:5), h2b.ColorData(:, 7),...
    h2b.ColorData(:, 6), h2b.ColorData(:, 8)]);  % swap C5E and C5W
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');

nexttile(1,[2 4])
errorbar(1.5:8.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 9])
ylim([1.5 4])
xticks([])
set(gca, 'FontSize',fontsize*1.2);

nexttile(17,[4 2])
errorbar(meanT, 1.5:4.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 5])
xlim([1.5 3.5])
yticks([])
set(gca, 'FontSize',fontsize*1.2);


%% Visualisation: GS_20210920 Skewness
f2c = figure('Position',[2548, 714, 893, 623]);
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(13,[4 4])
h2c = heatmap(GS_20210920, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Skewness');
colormap(h2c, crameri('tokyo'))
clim(skMapLim)

h2c.Title = [];
h2c.YDisplayData = flipud(h2c.YDisplayData);
h2c.YDisplayLabels = fliplr({'HW ','MT_\downarrow','LW ','MT_\uparrow'});
h2c.XDisplayData = locsX;
h2c.XDisplayLabels = sampleNames;
h2c.XLabel = '';
h2c.YLabel = '';
h2c.FontSize = fontsize*1.2;
h2c.CellLabelFormat = '%0.1f';
h2c.ColorbarVisible = 'off';
h2c.GridVisible = 'off';

nexttile(5,[2 2])
text(.1, .4, '2021-09-20 \newline      Sk_{G}', 'FontSize',fontsize*1.2, 'FontWeight','bold', 'EdgeColor','none', 'Margin',6)
axis off

heatdata = flipud([h2c.ColorData(:, 1:5), h2c.ColorData(:, 7),...
    h2c.ColorData(:, 6), h2c.ColorData(:, 8)]);  % swap C5E and C5W
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');

nexttile(1,[2 4])
errorbar(1.5:8.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 9])
ylim([-.2 .6])
xticks([])
set(gca, 'FontSize',fontsize*1.2);

nexttile(17,[4 2])
errorbar(meanT, 1.5:4.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 5])
xlim([-.2 .6])
yticks([])
set(gca, 'FontSize',fontsize*1.2);


%% Visualisation: GS_20210920 Kurtosis
f2d = figure('Position',[2548, 11, 893, 623]);
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(13,[4 4])
h2d = heatmap(GS_20210920, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Kurtosis');
colormap(h2d, crameri('-nuuk'))
clim(kMapLim)

h2d.Title = [];
h2d.YDisplayData = flipud(h2d.YDisplayData);
h2d.YDisplayLabels = fliplr({'HW ','MT_\downarrow','LW ','MT_\uparrow'});
h2d.XDisplayData = locsX;
h2d.XDisplayLabels = sampleNames;
h2d.XLabel = '';
h2d.YLabel = '';
h2d.FontSize = fontsize*1.2;
h2d.CellLabelFormat = '%0.1f';
h2d.ColorbarVisible = 'off';
h2d.GridVisible = 'off';

nexttile(5,[2 2])
text(.1, .4, '2021-09-20 \newline      K_{G}', 'FontSize',fontsize*1.2, 'FontWeight','bold', 'EdgeColor','none', 'Margin',6)
axis off

heatdata = flipud([h2d.ColorData(:, 1:5), h2d.ColorData(:, 7),...
    h2d.ColorData(:, 6), h2d.ColorData(:, 8)]);  % swap C5E and C5W
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');

nexttile(1,[2 4])
errorbar(1.5:8.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 9])
ylim([.6 1.7])
xticks([])
set(gca, 'FontSize',fontsize*1.2);

nexttile(17,[4 2])
errorbar(meanT, 1.5:4.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 5])
xlim([.6 1.7])
yticks([])
set(gca, 'FontSize',fontsize*1.2);


%% Visualisation: GS_20210928 Mean
f3a = figure('Position',[1654, 714, 893, 623]);
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(13,[4 4])
h3a = heatmap(GS_20210928, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Mean_mm');
colormap(h3a, crameri('lajolla'))
clim(meanMapLim)

h3a.Title = [];
h3a.YDisplayData = flipud(h3a.YDisplayData);
h3a.YDisplayLabels = fliplr({'HW ','MT_\downarrow','LW ','MT_\uparrow'});
h3a.XDisplayData = locsX;
h3a.XDisplayLabels = sampleNames;
h3a.XLabel = '';
h3a.YLabel = '';
h3a.FontSize = fontsize*1.2;
h3a.CellLabelFormat = '%0.1f';
h3a.ColorbarVisible = 'off';
h3a.GridVisible = 'off';

nexttile(5,[2 2])
text(.1, .4, '2021-09-28 \newline  M_{G} (mm)', 'FontSize',fontsize*1.2, 'FontWeight','bold', 'EdgeColor','none', 'Margin',6)
axis off

heatdata = flipud([h3a.ColorData(:, 1:5), h3a.ColorData(:, 7),...
    h3a.ColorData(:, 6), h3a.ColorData(:, 8)]);  % swap C5E and C5W
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');

nexttile(1,[2 4])
errorbar(1.5:8.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 9])
ylim([0 2])
xticks([])
set(gca, 'FontSize',fontsize*1.2);

nexttile(17,[4 2])
errorbar(meanT, 1.5:4.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 5])
xlim([0 2])
yticks([])
set(gca, 'FontSize',fontsize*1.2);


%% Visualisation: GS_20210928 Sorting
f3b = figure('Position',[1654, 11, 893, 623]);
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(13,[4 4])
h3b = heatmap(GS_20210928, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Sorting');
colormap(h3b, crameri('imola'))
clim(stdMapLim)

h3b.Title = [];
h3b.YDisplayData = flipud(h3b.YDisplayData);
h3b.YDisplayLabels = fliplr({'HW ','MT_\downarrow','LW ','MT_\uparrow'});
h3b.XDisplayData = locsX;
h3b.XDisplayLabels = sampleNames;
h3b.XLabel = '';
h3b.YLabel = '';
h3b.FontSize = fontsize*1.2;
h3b.CellLabelFormat = '%0.1f';
h3b.ColorbarVisible = 'off';
h3b.GridVisible = 'off';

nexttile(5,[2 2])
text(.1, .4, '2021-09-28 \newline      \sigma_{G}', 'FontSize',fontsize*1.2, 'FontWeight','bold', 'EdgeColor','none', 'Margin',6)
axis off

heatdata = flipud([h3b.ColorData(:, 1:5), h3b.ColorData(:, 7),...
    h3b.ColorData(:, 6), h3b.ColorData(:, 8)]);  % swap C5E and C5W
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');

nexttile(1,[2 4])
errorbar(1.5:8.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 9])
ylim([1.5 4])
xticks([])
set(gca, 'FontSize',fontsize*1.2);

nexttile(17,[4 2])
errorbar(meanT, 1.5:4.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 5])
xlim([1.5 3.5])
yticks([])
set(gca, 'FontSize',fontsize*1.2);


%% Visualisation: GS_20210928 Skewness
f3c = figure('Position',[2548, 714, 893, 623]);
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(13,[4 4])
h3c = heatmap(GS_20210928, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Skewness');
colormap(h3c, crameri('tokyo'))
clim(skMapLim)

h3c.Title = [];
h3c.YDisplayData = flipud(h3c.YDisplayData);
h3c.YDisplayLabels = fliplr({'HW ','MT_\downarrow','LW ','MT_\uparrow'});
h3c.XDisplayData = locsX;
h3c.XDisplayLabels = sampleNames;
h3c.XLabel = '';
h3c.YLabel = '';
h3c.FontSize = fontsize*1.2;
h3c.CellLabelFormat = '%0.1f';
h3c.ColorbarVisible = 'off';
h3c.GridVisible = 'off';

nexttile(5,[2 2])
text(.1, .4, '2021-09-28 \newline      Sk_{G}', 'FontSize',fontsize*1.2, 'FontWeight','bold', 'EdgeColor','none', 'Margin',6)
axis off

heatdata = flipud([h3c.ColorData(:, 1:5), h3c.ColorData(:, 7),...
    h3c.ColorData(:, 6), h3c.ColorData(:, 8)]);  % swap C5E and C5W
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');

nexttile(1,[2 4])
errorbar(1.5:8.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 9])
ylim([-.2 .6])
xticks([])
set(gca, 'FontSize',fontsize*1.2);

nexttile(17,[4 2])
errorbar(meanT, 1.5:4.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 5])
xlim([-.2 .6])
yticks([])
set(gca, 'FontSize',fontsize*1.2);


%% Visualisation: GS_20210928 Kurtosis
f3d = figure('Position',[2548, 11, 893, 623]);
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(13,[4 4])
h3d = heatmap(GS_20210928, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Kurtosis');
colormap(h3d, crameri('-nuuk'))
clim(kMapLim)

h3d.Title = [];
h3d.YDisplayData = flipud(h3d.YDisplayData);
h3d.YDisplayLabels = fliplr({'HW ','MT_\downarrow','LW ','MT_\uparrow'});
h3d.XDisplayData = locsX;
h3d.XDisplayLabels = sampleNames;
h3d.XLabel = '';
h3d.YLabel = '';
h3d.FontSize = fontsize*1.2;
h3d.CellLabelFormat = '%0.1f';
h3d.ColorbarVisible = 'off';
h3d.GridVisible = 'off';

nexttile(5,[2 2])
text(.1, .4, '2021-09-28 \newline      K_{G}', 'FontSize',fontsize*1.2, 'FontWeight','bold', 'EdgeColor','none', 'Margin',6)
axis off

heatdata = flipud([h3d.ColorData(:, 1:5), h3d.ColorData(:, 7),...
    h3d.ColorData(:, 6), h3d.ColorData(:, 8)]);  % swap C5E and C5W
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');

nexttile(1,[2 4])
errorbar(1.5:8.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 9])
ylim([.6 1.7])
xticks([])
set(gca, 'FontSize',fontsize*1.2);

nexttile(17,[4 2])
errorbar(meanT, 1.5:4.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 5])
xlim([.6 1.7])
yticks([])
set(gca, 'FontSize',fontsize*1.2);


%% Visualisation: GS_2021007 Mean
f4a = figure('Position',[1654, 714, 893, 623]);
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(13,[4 4])
h4a = heatmap(GS_20211007, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Mean_mm');
colormap(h4a, crameri('lajolla'))
clim(meanMapLim)

h4a.Title = [];
h4a.YDisplayData = flipud(h4a.YDisplayData);
h4a.YDisplayLabels = fliplr({'HW ','MT_\downarrow','LW ','MT_\uparrow'});
h4a.XDisplayData = locsX;
h4a.XDisplayLabels = sampleNames;
h4a.XLabel = '';
h4a.YLabel = '';
h4a.FontSize = fontsize*1.2;
h4a.CellLabelFormat = '%0.1f';
h4a.ColorbarVisible = 'off';
h4a.GridVisible = 'off';

nexttile(5,[2 2])
text(.1, .4, '2021-10-07 \newline  M_{G} (mm)', 'FontSize',fontsize*1.2, 'FontWeight','bold', 'EdgeColor','none', 'Margin',6)
axis off

heatdata = flipud([h4a.ColorData(:, 1:5), h4a.ColorData(:, 7),...
    h4a.ColorData(:, 6), h4a.ColorData(:, 8)]);  % swap C5E and C5W
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');

nexttile(1,[2 4])
errorbar(1.5:8.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 9])
ylim([0 2])
xticks([])
set(gca, 'FontSize',fontsize*1.2);

nexttile(17,[4 2])
errorbar(meanT, 1.5:4.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 5])
xlim([0 2])
yticks([])
set(gca, 'FontSize',fontsize*1.2);


%% Visualisation: GS_2021007 Sorting
f4b = figure('Position',[1654, 11, 893, 623]);
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(13,[4 4])
h4b = heatmap(GS_20211007, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Sorting');
colormap(h4b, crameri('imola'))
clim(stdMapLim)

h4b.Title = [];
h4b.YDisplayData = flipud(h4b.YDisplayData);
h4b.YDisplayLabels = fliplr({'HW ','MT_\downarrow','LW ','MT_\uparrow'});
h4b.XDisplayData = locsX;
h4b.XDisplayLabels = sampleNames;
h4b.XLabel = '';
h4b.YLabel = '';
h4b.FontSize = fontsize*1.2;
h4b.CellLabelFormat = '%0.1f';
h4b.ColorbarVisible = 'off';
h4b.GridVisible = 'off';

nexttile(5,[2 2])
text(.1, .4, '2021-10-07 \newline      \sigma_{G}', 'FontSize',fontsize*1.2, 'FontWeight','bold', 'EdgeColor','none', 'Margin',6)
axis off

heatdata = flipud([h4b.ColorData(:, 1:5), h4b.ColorData(:, 7),...
    h4b.ColorData(:, 6), h4b.ColorData(:, 8)]);  % swap C5E and C5W
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');

nexttile(1,[2 4])
errorbar(1.5:8.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 9])
ylim([1.5 4])
xticks([])
set(gca, 'FontSize',fontsize*1.2);

nexttile(17,[4 2])
errorbar(meanT, 1.5:4.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 5])
xlim([1.5 3.5])
yticks([])
set(gca, 'FontSize',fontsize*1.2);


%% Visualisation: GS_2021007 Skewness
f4c = figure('Position',[2548, 714, 893, 623]);
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(13,[4 4])
h4c = heatmap(GS_20211007, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Skewness');
colormap(h4c, crameri('tokyo'))
clim(skMapLim)

h4c.Title = [];
h4c.YDisplayData = flipud(h4c.YDisplayData);
h4c.YDisplayLabels = fliplr({'HW ','MT_\downarrow','LW ','MT_\uparrow'});
h4c.XDisplayData = locsX;
h4c.XDisplayLabels = sampleNames;
h4c.XLabel = '';
h4c.YLabel = '';
h4c.FontSize = fontsize*1.2;
h4c.CellLabelFormat = '%0.1f';
h4c.ColorbarVisible = 'off';
h4c.GridVisible = 'off';

nexttile(5,[2 2])
text(.1, .4, '2021-10-07 \newline      Sk_{G}', 'FontSize',fontsize*1.2, 'FontWeight','bold', 'EdgeColor','none', 'Margin',6)
axis off

heatdata = flipud([h4c.ColorData(:, 1:5), h4c.ColorData(:, 7),...
    h4c.ColorData(:, 6), h4c.ColorData(:, 8)]);  % swap C5E and C5W
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');

nexttile(1,[2 4])
errorbar(1.5:8.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 9])
ylim([-.2 .6])
xticks([])
set(gca, 'FontSize',fontsize*1.2);

nexttile(17,[4 2])
errorbar(meanT, 1.5:4.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 5])
xlim([-.2 .6])
yticks([])
set(gca, 'FontSize',fontsize*1.2);


%% Visualisation: GS_2021007 Kurtosis
f4d = figure('Position',[2548, 11, 893, 623]);
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(13,[4 4])
h4d = heatmap(GS_20211007, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Kurtosis');
colormap(h4d, crameri('-nuuk'))
clim(kMapLim)

h4d.Title = [];
h4d.YDisplayData = flipud(h4d.YDisplayData);
h4d.YDisplayLabels = fliplr({'HW ','MT_\downarrow','LW ','MT_\uparrow'});
h4d.XDisplayData = locsX;
h4d.XDisplayLabels = sampleNames;
h4d.XLabel = '';
h4d.YLabel = '';
h4d.FontSize = fontsize*1.2;
h4d.CellLabelFormat = '%0.1f';
h4d.ColorbarVisible = 'off';
h4d.GridVisible = 'off';

nexttile(5,[2 2])
text(.1, .4, '2021-10-07 \newline      K_{G}', 'FontSize',fontsize*1.2, 'FontWeight','bold', 'EdgeColor','none', 'Margin',6)
axis off

heatdata = flipud([h4d.ColorData(:, 1:5), h4d.ColorData(:, 7),...
    h4d.ColorData(:, 6), h4d.ColorData(:, 8)]);  % swap C5E and C5W
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');

nexttile(1,[2 4])
errorbar(1.5:8.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 9])
ylim([.6 1.7])
xticks([])
set(gca, 'FontSize',fontsize*1.2);

nexttile(17,[4 2])
errorbar(meanT, 1.5:4.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 5])
xlim([.6 1.7])
yticks([])
set(gca, 'FontSize',fontsize*1.2);

