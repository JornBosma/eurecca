%% Initialisation
close all
clear
clc

[~, fontsize, ~, PHZ, ~] = eurecca_init;

folderPath = [filesep 'Volumes' filesep 'T7 Shield' filesep...
    'DataDescriptor' filesep 'grainsizes' filesep];

% List all files in the folder
fileList = dir(fullfile(folderPath, 'GS_*.csv'));

S = struct();

for n = 1:length(fileList)
    fileName = fileList(n).name;
    dataPath{1} = [folderPath filesep fileName];

    opts = detectImportOptions(dataPath{1});
    opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy'); 

    [~, fileNam, ~] = fileparts(fileName); % Extract the name without extension
    T = readtable(dataPath{1}, opts);
    S.(fileNam) = T;
end


%% Apply mask
A = load('PHZ_2022_Q2','-mat');

pgns = getPgons;

mask_scope = inpolygon(A.DEM.X, A.DEM.Y, pgns.scope(:,1), pgns.scope(:,2));
A.DEM.Z(~mask_scope) = NaN;

contourMatrixB = contourc(A.DEM.X(1,:), A.DEM.Y(:,1), A.DEM.Z, [0 0]);
x = contourMatrixB(1, 2:end);
y = contourMatrixB(2, 2:end);
x(x<min(A.DEM.X(1,:))) = NaN;
y(y<min(A.DEM.Y(:,1))) = NaN;


%% Horizontal sample locations
f1 = figureRH;

plot(x, y, '-k', 'LineWidth', 2); hold on
scatter(S.GS_20211008.xRD_m([1, 5, 9, 14, 19, 24]), S.GS_20211008.yRD_m([1, 5, 9, 14, 19, 24]), 200, 'r', 'filled', 'LineWidth',2);
scatter(S.GS_20211009.xRD_m([1, 6, 11, 16]), S.GS_20211009.yRD_m([1, 6, 11, 16]), 200, 'r', 'filled', 'LineWidth',2);
% title('2021-10-08/9', 'FontSize',fontsize*.7, 'Units','normalized',...
%     'Position',[.5, .65]);

xlim(PHZ.xLim);
ylim(PHZ.yLim);
axis off vis3d
view(46, 90);


%% Load sediment data
dataPath{2} = [folderPath 'GS_20211008.csv'];
dataPath{3} = [folderPath 'GS_20211009.csv'];

opts = detectImportOptions(dataPath{2});
opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy');

GS_20211008 = readtable(dataPath{2}, opts);
GS_20211009 = readtable(dataPath{3}, opts);
GS_2021 = [GS_20211009; GS_20211008];


%% Sort table by track number and sample elevation
% Initialize an empty array to store the extracted numbers
Track_Number = zeros(size(GS_2021, 1), 1);

% Loop through each row in the 'name' column and extract the numbers
for row = 1:size(GS_2021, 1)
    name = GS_2021.Sample_Identity{row}; % Get the name from the 'name' column
    numbers = regexp(name, '\d+', 'match'); % Extract all numbers using regular expression
    if ~isempty(numbers)
        Track_Number(row) = str2double(numbers{1}); % Convert the first extracted number to a double
    end
end

% Convert the cell array of numbers to a column in your table
GS_2021.Track_Number = Track_Number;

GS_2021 = sortrows(GS_2021, 'Track_Number', 'ascend');

% Assign sample numbers by elevation
Sample_Number = repelem([1 2 3 4 5], 10, 1)';
Sample_Number = Sample_Number(:);
GS_2021.Sample_Number = Sample_Number;

% Remove all characters after the last number in each name
GS_2021.Sample_Identity = regexprep(GS_2021.Sample_Identity, '[^0-9]*$', '');

% Clear temp vars
clear Track_Number Sample_Number numbers name row dataPath opts GS_20211008 GS_20211009


%% Area-wide (mean) 8/9 Oct 2021
f2 = figure('Position',[730, 1846, 1279, 391]);
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(13,[4 5])
h1 = heatmap(GS_2021, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Mean_mu');
colormap(h1, crameri('lajolla'))
clim([300, 1400])

h1.Title = [];
h1.XDisplayData = flipud(h1.XDisplayData);
h1.XDisplayLabels = flipud(h1.XDisplayLabels);
h1.YDisplayLabels = {'+1.00 m', '+0.75 m', '+0.50 m', '+0.25 m', '+0.00 m'};
h1.XLabel = '';
h1.YLabel = '';
h1.FontSize = fontsize*.8;
h1.CellLabelFormat = '%0.0f';
h1.ColorbarVisible = 'off';
h1.GridVisible = 'off';
h1.MissingDataColor = 'w';
h1.MissingDataLabel = 'no data';

nexttile(6,[2 1])
% text(0, .5, '2021-10-08/09', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
text(0, .5, 'M_{G} (µm)', 'FontSize',fontsize*.8, 'FontWeight','normal', 'EdgeColor','none', 'Margin',6)
axis off

heatdata = rot90(h1.ColorData, 2);
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');

nexttile(1,[2 5])
errorbar(1.5:10.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 11])
ylim([250 1150])
% ylabel('M_{G} (µm)')
xticks([])

nexttile(18,[4 1])
errorbar(meanT, 1.5:5.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 6])
xlim([250 1150])
% xlabel('M_{G} (µm)')
yticks([])


%% Area-wide (std) 8/9 Oct 2021
f3 = figure('Position',[730, 1846, 1279, 391]);
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(13,[4 5])
h2 = heatmap(GS_2021, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Sorting');
colormap(h2, crameri('imola'))
clim([1.5, 4])

h2.Title = [];
h2.XDisplayData = flipud(h2.XDisplayData);
h2.XDisplayLabels = flipud(h2.XDisplayLabels);
h2.YDisplayLabels = {'+1.00 m', '+0.75 m', '+0.50 m', '+0.25 m', '+0.00 m'};
h2.XLabel = '';
h2.YLabel = '';
h2.FontSize = fontsize*.8;
h2.CellLabelFormat = '%0.2f';
h2.ColorbarVisible = 'off';
h2.GridVisible = 'off';
h2.MissingDataColor = 'w';
h2.MissingDataLabel = 'no data';

nexttile(6,[2 1])
% text(0, .5, '2021-10-08/09', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
text(0, .5, '\sigma_{G} (µm)', 'FontSize',fontsize*.8, 'FontWeight','normal', 'EdgeColor','none', 'Margin',6)
axis off

heatdata = rot90(h2.ColorData, 2);
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');

nexttile(1,[2 5])
errorbar(1.5:10.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 11])
ylim([1.5 3.2])
% ylabel('M_{G} (µm)')
xticks([])

nexttile(18,[4 1])
errorbar(meanT, 1.5:5.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 6])
xlim([1.5 3.2])
% xlabel('M_{G} (µm)')
yticks([])

