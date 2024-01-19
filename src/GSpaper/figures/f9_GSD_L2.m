%% Initialisation
close all
clear
clc

[~, fontsize, cbf, PHZ, SEDMEX] = eurecca_init;
% fontsize = 30; % ultra-wide screen

folderPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor' filesep];
sampleIDs = {'S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8'};
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

xline(d(idxSedi), '-', sampleIDs, 'FontSize',fontsize, 'LabelHorizontalAlignment','center')

% Tide levels over considered period
yline(.731, '-.', 'MHW', 'FontSize',fontsize, 'Color',cbf.skyblue, 'LineWidth',3)
yline(.192, '-.', 'MSL', 'FontSize',fontsize, 'Color',cbf.skyblue, 'LineWidth',3)  
yline(-.535, '-.', 'MLW', 'FontSize',fontsize, 'Color',cbf.skyblue, 'LineWidth',3)

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

GS_tables = {GS_20210920, GS_20210928, GS_20211001, GS_20211007, GS_20211015};
rowNames = ["GS_20210920"; "GS_20210928"; "GS_20211001"; "GS_20211007"; "GS_20211015"];
columnNames = ["L2C2"; "L2C3"; "L2C3_5"; "L2C4"; "L2C4_5"; "L2C5W"; "L2C5E"; "L2C6"];
samplingDates = ["2021-09-20"; "2021-09-28"; "2021-10-01"; "2021-10-07"; "2021-10-15"];


%% Replace dots ('.') in sample IDs by underscores ('_')

for i = 1:length(GS_tables)
    % Access the 'name' column
    names = GS_tables{i}.Sample_Identity;

    % Replace '.' with '_' in each name
    newNames = strrep(names, '.', '_');

    % Update the 'name' column in the table
    GS_tables{i}.Sample_Identity = newNames;
end


%% Calculations

% Initialize tables for mean and standard deviation with sampleIDs as columns
GS_Mean = array2table(nan(length(GS_tables), length(columnNames)), 'VariableNames',columnNames);
GS_Mean_Std = array2table(nan(length(GS_tables), length(columnNames)), 'VariableNames',columnNames);
GS_Sorting = array2table(nan(length(GS_tables), length(columnNames)), 'VariableNames',columnNames);
GS_Sorting_Std = array2table(nan(length(GS_tables), length(columnNames)), 'VariableNames',columnNames);
GS_Count = array2table(zeros(length(GS_tables), length(columnNames)), 'VariableNames', columnNames);

GS_Mean.Properties.RowNames = rowNames;
GS_Mean_Std.Properties.RowNames = rowNames;
GS_Sorting.Properties.RowNames = rowNames;
GS_Sorting_Std.Properties.RowNames = rowNames;
GS_Count.Properties.RowNames = rowNames;

% Loop through each table
for i = 1:length(GS_tables)
    currentTable = GS_tables{i};

    % Loop through each name
    for j = 1:length(columnNames)
        targetID = columnNames{j};

        % Filter the rows where the name matches targetName
        filteredRows = currentTable(strcmp(currentTable.Sample_Identity, targetID), :);

        % Calculate the mean and standard deviation of the 'Value' column for these rows
        if ~isempty(filteredRows)
            meanValue = mean(filteredRows.Mean_mm, 'omitmissing');
            meanstdValue = std(filteredRows.Mean_mm, 'omitmissing');
            sortingValue = mean(filteredRows.Sorting, 'omitmissing');
            sortingstdValue = std(filteredRows.Sorting, 'omitmissing');
            countValue = sum(~isnan(filteredRows.Mean_mm));
        else
            meanValue = NaN; % Use NaN for no entries
            meanstdValue = NaN;
            sortingValue = NaN;
            sortingstdValue = NaN;
            countValue = 0;  % Zero count for no entries
        end

        % Assign values to tables
        GS_Mean{i, targetID} = meanValue;
        GS_Mean_Std{i, targetID} = meanstdValue;
        GS_Sorting{i, targetID} = sortingValue;
        GS_Sorting_Std{i, targetID} = sortingstdValue;
        GS_Count{i, targetID} = countValue;
    end
end


%% Visualisation
axs = gobjects(size(GS_tables));
ax_left = gobjects(size(GS_tables));
ax_right = gobjects(size(GS_tables));

xpos = [1 3:7 9 11];

f2 = figure(Position=[1832, 1, 1279, 628]);
tl = tiledlayout(3, 2, 'TileSpacing','tight');

for i = 1:length(GS_tables)
    axs(i) = nexttile;
    title(samplingDates(i), FontSize=fontsize*.8)

    yyaxis left
    errorbar(xpos, GS_Mean{i,:}, GS_Mean_Std{i,:}, '-ok', 'LineWidth',3)
    yline(mean(GS_Mean{i,:}), '--k', 'LineWidth',1)
    ylim([0 3])
    ax_left(i) = gca;
    ax_left(i).YColor = 'black';
    if i == 3
        ylabel('M_{G} (mm)')
    end
    if i == 2 || i == 4
        yticklabels('')
    end
    text(1.4, 2.5, ['(n = ', mat2str(GS_Count{i,1}), ')'], 'Fontsize',fontsize*.6)

    yyaxis right
    errorbar(xpos, GS_Sorting{i,:}, GS_Sorting_Std{i,:}, '-or', 'LineWidth',3)
    yline(mean(GS_Sorting{i,:}), '--r', 'LineWidth',1)
    ylim([1 4])
    ax_right(i) = gca;
    ax_right(i).YColor = 'red';
    if i == 4
        ylabel('\sigma_{G}')
    end
end

xticks(axs, xpos)
xticklabels(axs, sampleIDs)
xticklabels(axs(1:3), '')
yticklabels(axs([1, 3]), '')

xlim(axs, [0, 12])
grid(axs, 'on')

