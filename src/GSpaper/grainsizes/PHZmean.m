%% Initialisation
close all
clear
clc

[~, fontsize, cbf, PHZ] = eurecca_init;

folderPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor' filesep];


%% Load sediment data
dataPath{1} = [folderPath 'grainsizes' filesep 'GS_20211008.csv'];
dataPath{2} = [folderPath 'grainsizes' filesep 'GS_20211009.csv'];

opts = detectImportOptions(dataPath{1});
opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy');

GS_20211008 = readtable(dataPath{1}, opts);
GS_20211009 = readtable(dataPath{2}, opts);
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


%% Area-wide (x) 8/9 Oct 2021
f1 = figureRH;
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(7,[5 5])
h1 = heatmap(GS_2021, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Mean_mu');
colormap(h1, crameri('lajolla'))
clim([0, 2000])

h1.Title = [];
h1.YDisplayData = flipud(h1.YDisplayData);
h1.YDisplayLabels = fliplr({'+1.00 m', '+0.75 m', '+0.50 m', '+0.25 m', '+0.00 m'});
h1.XLabel = '';
h1.YLabel = '';
h1.FontSize = fontsize;
h1.CellLabelFormat = '%0.0f';
h1.ColorbarVisible = 'off';
h1.GridVisible = 'off';
h1.MissingDataColor = 'w';
h1.MissingDataLabel = 'no data';

nexttile(6)
text(0, .5, '2021-10-08/09', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata = h1.ColorData;
meanS = mean(heatdata, 1, 'omitmissing');
stdS = std(heatdata, 0, 1, 'omitmissing');
nexttile(1,[1 5])
errorbar(1.5:10.5, meanS, stdS, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 11])
ylim([0 1500])
ylabel('µm')
xticks([])

meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');
nexttile(12,[5 1])

errorbar(meanT, 1.5:5.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 6])
xlim([0 1500])
xlabel('µm')
yticks([])


%% Load sediment data
dataPath = [folderPath 'grainsizes' filesep 'GS_20221026.csv'];

opts = detectImportOptions(dataPath);
opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy');

GS_2022 = readtable(dataPath, opts);

% Complete table with missing samples
GS_2022 = [GS_2022(1:5,:); GS_2022(5,:);...                 % R1
    GS_2022(6:10,:); GS_2022(10,:);...                      % R2
    GS_2022(11:14,:); GS_2022(14,:); GS_2022(14,:);...      % R3
    GS_2022(35:end,:);...                                   % R4
    GS_2022(15:18,:); GS_2022(18,:); GS_2022(18,:);...      % R5
    GS_2022(35:end,:);...                                   % R6
    GS_2022(19:23,:); GS_2022(23,:);...                     % R7
    GS_2022(24:28,:); GS_2022(28,:);...                     % R8
    GS_2022(29:end,:)];                                     % R9 & R10
GS_2022{[6 12 17:24 29:36 42 48], 3:end} = NaN;
GS_2022.Sample_Identity(6) = {'R1'};
GS_2022.Sample_Identity(12) = {'R2'};
GS_2022.Sample_Identity(17:18) = {'R3'};
GS_2022.Sample_Identity(19:24) = {'R4'};
GS_2022.Sample_Identity(29:30) = {'R5'};
GS_2022.Sample_Identity(31:36) = {'R6'};
GS_2022.Sample_Identity(42) = {'R7'};
GS_2022.Sample_Identity(48) = {'R8'};


%% Sort table by track number and sample elevation
% Initialize an empty array to store the extracted numbers
Track_Number = zeros(size(GS_2022, 1), 1);

% Loop through each row in the 'name' column and extract the numbers
for row = 1:size(GS_2022, 1)
    name = GS_2022.Sample_Identity{row}; % Get the name from the 'name' column
    numbers = regexp(name, '\d+', 'match'); % Extract all numbers using regular expression
    if ~isempty(numbers)
        Track_Number(row) = str2double(numbers{1}); % Convert the first extracted number to a double
    end
end

% Convert the cell array of numbers to a column in your table
GS_2022.Track_Number = Track_Number;

% Assign sample numbers by elevation
Sample_Number = repelem([1 2 3 4 5 6], 10, 1)';
Sample_Number = Sample_Number(:);
GS_2022.Sample_Number = Sample_Number;

% Remove all characters after the last number in each name
GS_2022.Sample_Identity = regexprep(GS_2022.Sample_Identity, '[^0-9]*$', '');

% Add a '0' before numbers < 10
GS_2022.Sample_Identity = regexprep(GS_2022.Sample_Identity, 'R(\d)$', 'R0$1');

% Clear temp vars
clear Track_Number Sample_Number numbers name row dataPath opts


%% Area-wide (x) 26 Oct 2022
f2 = figureRH;
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(7,[5 5])
h2 = heatmap(GS_2022, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Mean_mu');
colormap(h2, crameri('lajolla'))
clim([0, 2000])

h2.Title = [];
h2.YDisplayData = flipud(h2.YDisplayData);
h2.YDisplayLabels = fliplr({'+1.00 m', '+0.75 m', '+0.50 m', '+0.25 m', '0.00 m', '-0.25 m'});
h2.XLabel = '';
h2.YLabel = '';
h2.FontSize = fontsize;
h2.CellLabelFormat = '%0.0f';
h2.ColorbarVisible = 'off';
h2.GridVisible = 'off';
h2.MissingDataColor = 'w';
h2.MissingDataLabel = 'no data';

nexttile(6)
text(0, .5, '2022-10-26', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata = h2.ColorData;
meanS = mean(heatdata, 1, 'omitmissing');
stdS2 = std(heatdata, 0, 1, 'omitmissing');
nexttile(1,[1 5])
errorbar(1.5:10.5, meanS, stdS2, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 11])
ylim([0 1500])
ylabel('µm')
xticks([])

meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');
nexttile(12,[5 1])
errorbar(meanT, 1.5:6.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 7])
xlim([0 1500])
xlabel('µm')
yticks([])


%% Load sediment data
dataPath = [folderPath 'grainsizes' filesep 'GS_20201202.csv'];

opts = detectImportOptions(dataPath);
opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy');

GS_2020 = readtable(dataPath, opts);


%% Complete table with missing samples
GS_2020 = [GS_2020(1:4,:);...               % R1
    GS_2020(5:7,:); GS_2020(7,:);...        % R2
    GS_2020(8:10,:); GS_2020(10,:);...      % R3
    GS_2020(11:13,:); GS_2020(13,:);...     % R4
    GS_2020(14:16,:); GS_2020(16,:);...     % R5
    GS_2020(17:19,:); GS_2020(19,:);...     % R6
    GS_2020(20:22,:); GS_2020(22,:);...     % R7
    GS_2020(23:25,:); GS_2020(25,:);...     % R8
    GS_2020(26:28,:); GS_2020(28,:);...     % R9
    GS_2020(29:end,:); GS_2020(end,:)];     % R10
GS_2020{8:4:end, 3:end} = NaN;
GS_2020.Sample_Identity(1:4) = {'R01'};
GS_2020.Sample_Identity(5:8) = {'R02'};
GS_2020.Sample_Identity(9:12) = {'R03'};
GS_2020.Sample_Identity(13:16) = {'R04'};
GS_2020.Sample_Identity(17:20) = {'R05'};
GS_2020.Sample_Identity(21:24) = {'R06'};
GS_2020.Sample_Identity(25:28) = {'R07'};
GS_2020.Sample_Identity(29:32) = {'R08'};
GS_2020.Sample_Identity(33:36) = {'R09'};
GS_2020.Sample_Identity(37:40) = {'R10'};

% Flip track names so they match the other surveys (R1 = N; R10 = S)
GS_2020.Sample_Identity = flipud(GS_2020.Sample_Identity);


%% Sort table by track number and sample elevation
% Initialize an empty array to store the extracted numbers
Track_Number = zeros(size(GS_2020, 1), 1);

% Loop through each row in the 'name' column and extract the numbers
for row = 1:size(GS_2020, 1)
    name = GS_2020.Sample_Identity{row}; % Get the name from the 'name' column
    numbers = regexp(name, '\d+', 'match'); % Extract all numbers using regular expression
    if ~isempty(numbers)
        Track_Number(row) = str2double(numbers{1}); % Convert the first extracted number to a double
    end
end

% Convert the cell array of numbers to a column in your table
GS_2020.Track_Number = Track_Number;

% Assign sample numbers by elevation
Sample_Number = repelem([1 2 3 4], 10, 1)';
Sample_Number = Sample_Number(:);
GS_2020.Sample_Number = Sample_Number;

% Clear temp vars
clear Track_Number Sample_Number numbers name row dataPath folderPath opts


%% Area-wide (x) 02 Dec 2020
f3 = figureRH;
tiledlayout(6, 6, 'TileSpacing','tight', 'Padding','compact')

nexttile(7,[5 5])
h3 = heatmap(GS_2020, 'Sample_Identity', 'Sample_Number', 'ColorVariable','Mean_mu');
colormap(h3, crameri('lajolla'))
clim([0, 2000])

h3.Title = [];
h3.YDisplayData = flipud(h3.YDisplayData);
h3.YDisplayLabels = fliplr({'high', 'mid', 'low', 'lower'});
h3.XLabel = '';
h3.YLabel = '';
h3.FontSize = fontsize;
h3.CellLabelFormat = '%0.0f';
h3.ColorbarVisible = 'off';
h3.GridVisible = 'off';
h3.MissingDataColor = 'w';
h3.MissingDataLabel = 'no data';

nexttile(6)
text(0, .5, '2020-12-02', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata = h3.ColorData;
meanS = mean(heatdata, 1, 'omitmissing');
stdS3 = std(heatdata, 0, 1, 'omitmissing');
nexttile(1,[1 5])
errorbar(1.5:10.5, meanS, stdS3, '-ok', 'LineWidth',3)
yline(mean(meanS, 'omitmissing'), '--k', 'LineWidth',2)
xlim([1 11])
ylim([0 1500])
ylabel('µm')
xticks([])

meanT = mean(heatdata, 2, 'omitmissing');
stdT = std(heatdata, 0, 2, 'omitmissing');
nexttile(12,[5 1])
errorbar(meanT, 1.5:4.5, stdT, 'horizontal', '-ok', 'LineWidth',3)
xline(mean(meanT, 'omitmissing'), '--k', 'LineWidth',2)
ylim([1 5])
xlim([0 1500])
xlabel('µm')
yticks([])

