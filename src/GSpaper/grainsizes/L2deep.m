%% Initialisation
close all
clear
clc

[~, fontsize, ~, PHZ] = eurecca_init;

folderPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor' filesep];
locsX = {'L2C2', 'L2C3', 'L2C3.5', 'L2C4', 'L2C4.5', 'L2C5W', 'L2C5E', 'L2C6'};


%% Cross-shore (x)

% Load sediment data
dataPath{1} = [folderPath 'grainsizes' filesep 'GS_20210930.csv'];
dataPath{2} = [folderPath 'grainsizes' filesep 'GS_20211001.csv'];
dataPath{3} = [folderPath 'grainsizes' filesep 'GS_20211006.csv'];
dataPath{4} = [folderPath 'grainsizes' filesep 'GS_20211011.csv'];
dataPath{5} = [folderPath 'grainsizes' filesep 'GS_20211013.csv'];

opts = detectImportOptions(dataPath{1});
opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy');
GS_20210930 = readtable(dataPath{1}, opts);
GS_20211001 = readtable(dataPath{2}, opts);
GS_20211006 = readtable(dataPath{3}, opts);
GS_20211011 = readtable(dataPath{4}, opts);
GS_20211013 = readtable(dataPath{5}, opts);

% Prepare table
GS_20210930 = GS_20210930(startsWith(GS_20210930.Sample_Identity, 'L2C3_') | startsWith(GS_20210930.Sample_Identity, 'L2C5_'), :);
GS_20211001 = GS_20211001(startsWith(GS_20211001.Sample_Identity, 'L2C3_') | startsWith(GS_20211001.Sample_Identity, 'L2C5_'), :);
GS_20211006 = GS_20211006(startsWith(GS_20211006.Sample_Identity, 'L2C3_') | startsWith(GS_20211006.Sample_Identity, 'L2C5_'), :);
GS_20211011 = GS_20211011(startsWith(GS_20211011.Sample_Identity, 'L2C3_') | startsWith(GS_20211011.Sample_Identity, 'L2C5_'), :);
GS_20211013 = GS_20211013(startsWith(GS_20211013.Sample_Identity, 'L2C3_') | startsWith(GS_20211013.Sample_Identity, 'L2C5_'), :);
GS_20210930(:, 16:end) = [];
GS_20211001(:, 16:end) = [];
GS_20211006(:, 16:end) = [];
GS_20211011(:, 16:end) = [];
GS_20211013(:, 16:end) = [];
GS = [GS_20210930; GS_20211001; GS_20211006; GS_20211011; GS_20211013];
GS.Sample_Identity = regexprep(GS.Sample_Identity, '_.*', '');
GS.Sample_Number = [1 1 2 2 3 3 4 4 5 5]';

% Visualisation
f1 = figureRH;
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(7,[5 5])
h1 = heatmap(GS, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Mean_mu');
colormap(h1, crameri('lajolla'))
clim([0, 2000])

h1.Title = [];
h1.XDisplayLabels = GS.Date_ddMMyyyy(1:2:end);
h1.YDisplayData = flipud(h1.YDisplayData);
h1.XLabel = '';
h1.YLabel = '';
h1.FontSize = fontsize;
h1.CellLabelFormat = '%0.0f';
h1.ColorbarVisible = 'off';
h1.GridVisible = 'off';

nexttile(6)
text(0, .5, 'L2 deep', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata = h1.ColorData;
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
nexttile(1,[1 5])
errorbar(1.5:5.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 6])
% ylim([0 1000])
ylabel('µm')
xticks([])

meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');
nexttile(12,[5 1])
errorbar(meanT, 1.5:2.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 3])
% xlim([0 1000])
xlabel('µm')
yticks([])
