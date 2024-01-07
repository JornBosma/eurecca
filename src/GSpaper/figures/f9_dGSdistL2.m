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

meanMapLim = [minMean, maxMean];
stdMapLim = [minStd, maxStd];


%% Visualisation
f2 = figure('Position',[2198, 365, 893, 623]);
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(13,[4 4])
h2 = heatmap(GS_20210920, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Mean_mm');
colormap(h2, crameri('lajolla'))
clim(meanMapLim)

h2.Title = [];
h2.YDisplayData = flipud(h2.YDisplayData);
h2.YDisplayLabels = fliplr({'HW ','MT_\downarrow','LW ','MT_\uparrow'});
h2.XDisplayData = locsX;
h2.XDisplayLabels = sampleNames;
h2.XLabel = '';
h2.YLabel = '';
h2.FontSize = fontsize*1.2;
h2.CellLabelFormat = '%0.1f';
h2.ColorbarVisible = 'off';
h2.GridVisible = 'off';

nexttile(5,[2 2])
text(.1, .4, '2021-09-20 \newline  M_{G} (mm)', 'FontSize',fontsize*1.2, 'FontWeight','bold', 'EdgeColor','none', 'Margin',6)
axis off

heatdata = flipud([h2.ColorData(:, 1:5), h2.ColorData(:, 7),...
    h2.ColorData(:, 6), h2.ColorData(:, 8)]);  % swap C5E and C5W
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


%% Visualisation
f3 = figure('Position',[2198, 365, 893, 623]);
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(13,[4 4])
h3 = heatmap(GS_20210920, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Sorting');
colormap(h3, crameri('imola'))
clim(stdMapLim)

h3.Title = [];
h3.YDisplayData = flipud(h3.YDisplayData);
h3.YDisplayLabels = fliplr({'HW ','MT_\downarrow','LW ','MT_\uparrow'});
h3.XDisplayData = locsX;
h3.XDisplayLabels = sampleNames;
h3.XLabel = '';
h3.YLabel = '';
h3.FontSize = fontsize*1.2;
h3.CellLabelFormat = '%0.1f';
h3.ColorbarVisible = 'off';
h3.GridVisible = 'off';

nexttile(5,[2 2])
text(.1, .4, '2021-09-20 \newline      \sigma_{G}', 'FontSize',fontsize*1.2, 'FontWeight','bold', 'EdgeColor','none', 'Margin',6)
axis off

heatdata = flipud([h3.ColorData(:, 1:5), h3.ColorData(:, 7),...
    h3.ColorData(:, 6), h3.ColorData(:, 8)]);  % swap C5E and C5W
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


%% Visualisation
f4 = figure('Position',[2198, 365, 893, 623]);
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(13,[4 4])
h4 = heatmap(GS_20210928, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Mean_mm');
colormap(h4, crameri('lajolla'))
clim(meanMapLim)

h4.Title = [];
h4.YDisplayData = flipud(h4.YDisplayData);
h4.YDisplayLabels = fliplr({'HW ','MT_\downarrow','LW ','MT_\uparrow'});
h4.XDisplayData = locsX;
h4.XDisplayLabels = sampleNames;
h4.XLabel = '';
h4.YLabel = '';
h4.FontSize = fontsize*1.2;
h4.CellLabelFormat = '%0.1f';
h4.ColorbarVisible = 'off';
h4.GridVisible = 'off';

nexttile(5,[2 2])
text(.1, .4, '2021-09-28 \newline  M_{G} (mm)', 'FontSize',fontsize*1.2, 'FontWeight','bold', 'EdgeColor','none', 'Margin',6)
axis off

heatdata = flipud([h4.ColorData(:, 1:5), h4.ColorData(:, 7),...
    h4.ColorData(:, 6), h4.ColorData(:, 8)]);  % swap C5E and C5W
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


%% Visualisation
f5 = figure('Position',[2198, 365, 893, 623]);
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(13,[4 4])
h5 = heatmap(GS_20210928, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Sorting');
colormap(h5, crameri('imola'))
clim(stdMapLim)

h5.Title = [];
h5.YDisplayData = flipud(h5.YDisplayData);
h5.YDisplayLabels = fliplr({'HW ','MT_\downarrow','LW ','MT_\uparrow'});
h5.XDisplayData = locsX;
h5.XDisplayLabels = sampleNames;
h5.XLabel = '';
h5.YLabel = '';
h5.FontSize = fontsize*1.2;
h5.CellLabelFormat = '%0.1f';
h5.ColorbarVisible = 'off';
h5.GridVisible = 'off';

nexttile(5,[2 2])
text(.1, .4, '2021-09-28 \newline      \sigma_{G}', 'FontSize',fontsize*1.2, 'FontWeight','bold', 'EdgeColor','none', 'Margin',6)
axis off

heatdata = flipud([h5.ColorData(:, 1:5), h5.ColorData(:, 7),...
    h5.ColorData(:, 6), h5.ColorData(:, 8)]);  % swap C5E and C5W
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


%% Visualisation
f6 = figure('Position',[2198, 365, 893, 623]);
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(13,[4 4])
h6 = heatmap(GS_20211007, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Mean_mm');
colormap(h6, crameri('lajolla'))
clim(meanMapLim)

h6.Title = [];
h6.YDisplayData = flipud(h6.YDisplayData);
h6.YDisplayLabels = fliplr({'HW ','MT_\downarrow','LW ','MT_\uparrow'});
h6.XDisplayData = locsX;
h6.XDisplayLabels = sampleNames;
h6.XLabel = '';
h6.YLabel = '';
h6.FontSize = fontsize*1.2;
h6.CellLabelFormat = '%0.1f';
h6.ColorbarVisible = 'off';
h6.GridVisible = 'off';

nexttile(5,[2 2])
text(.1, .4, '2021-10-07 \newline  M_{G} (mm)', 'FontSize',fontsize*1.2, 'FontWeight','bold', 'EdgeColor','none', 'Margin',6)
axis off

heatdata = flipud([h6.ColorData(:, 1:5), h6.ColorData(:, 7),...
    h6.ColorData(:, 6), h6.ColorData(:, 8)]);  % swap C5E and C5W
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


%% Visualisation
f7 = figure('Position',[2198, 365, 893, 623]);
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(13,[4 4])
h7 = heatmap(GS_20211007, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Sorting');
colormap(h7, crameri('imola'))
clim(stdMapLim)

h7.Title = [];
h7.YDisplayData = flipud(h7.YDisplayData);
h7.YDisplayLabels = fliplr({'HW ','MT_\downarrow','LW ','MT_\uparrow'});
h7.XDisplayData = locsX;
h7.XDisplayLabels = sampleNames;
h7.XLabel = '';
h7.YLabel = '';
h7.FontSize = fontsize*1.2;
h7.CellLabelFormat = '%0.1f';
h7.ColorbarVisible = 'off';
h7.GridVisible = 'off';

nexttile(5,[2 2])
text(.1, .4, '2021-10-07 \newline      \sigma_{G}', 'FontSize',fontsize*1.2, 'FontWeight','bold', 'EdgeColor','none', 'Margin',6)
axis off

heatdata = flipud([h7.ColorData(:, 1:5), h7.ColorData(:, 7),...
    h7.ColorData(:, 6), h7.ColorData(:, 8)]);  % swap C5E and C5W
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

