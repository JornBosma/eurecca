%% Initialisation
close all
clear
clc

[~, ~, ~, ~, ~] = eurecca_init;

monitoring_period = [datetime('01-Jan-2019'), datetime('01-Jan-2023')];
SEDMEX_period = [datetime('10-Sep-2021'), datetime('19-Oct-2021')];
L2_sampling_period = [datetime('19-Sep-2021'), datetime('08-Oct-2021')];


%% Load all GS data

% Set the folder where your CSV files are located
folder = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor' filesep 'grainsizes' filesep];

% Get a list of all files in the folder that start with 'GS_' and end with '.csv'
files = dir(fullfile(folder, 'GS_*.csv'));

% Preallocate a cell array to store the data from each file
data = cell(length(files), 1);

% Loop over each file
for i = 1:length(files)
    % Construct the full file path
    filename = fullfile(folder, files(i).name);
    
    opts = detectImportOptions(filename);
    opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy');

    % Read the CSV file
    % Use 'readtable' for table data, 'csvread' for numeric data, or 'readmatrix' for mixed data
    data{i} = readtable(filename, opts); % Change this line based on your data type
end


%% GS statistics of complete dataset
totalSamples = 0; % Initialize total rows count

% Loop through each table in the cell array
for i = 1:length(data)
    currentTable = data{i}; % Get the current table
    numSamples = height(currentTable); % Get number of rows in the current table
    totalSamples = totalSamples + numSamples; % Add to total
end
totalSamples = totalSamples-1;  % data{20,1}(33,:) contains NaNs

Mean = NaN(size(data));
Sorting = Mean;
Skewness = Mean;
Kurtosis = Mean;
D10 = Mean;
D50 = Mean;
D90 = Mean;
D75divD25 = Mean;
D75minD25 = Mean;

for n = 1:length(data)
    data{n}.Mean_mu;
    Mean(n) = mean(data{n}.Mean_mu/1000, "omitmissing");
    Sorting(n) = mean(data{n}.Sorting, "omitmissing");
    Skewness(n) = mean(data{n}.Skewness, "omitmissing");
    Kurtosis(n) = mean(data{n}.Kurtosis, "omitmissing");
    D10(n) = mean(data{n}.D10_mu/1000, "omitmissing");
    D50(n) = mean(data{n}.D50_mu/1000, "omitmissing");
    D90(n) = mean(data{n}.D90_mu/1000, "omitmissing");
    D75divD25(n) = mean(data{n}.D75divD25, "omitmissing");
    D75minD25(n) = mean(data{n}.D75minD25_mu/1000, "omitmissing");
end

total_mean = mean(Mean);
total_sorting = mean(Sorting);
total_skewness = mean(Skewness);
total_kurtosis = mean(Kurtosis);
total_D10 = mean(D10);
total_D50 = mean(D50);
total_D90 = mean(D90);
total_D75divD25 = mean(D75divD25);
total_D75minD25 = mean(D75minD25);

% Display the calculated values
disp(['Grain-size stats based on the entire dataset (n=', num2str(totalSamples),'):'])
disp(' ')
disp(['Mean: ', num2str(total_mean, 3), ' mm']);
disp(['Sorting: ', num2str(total_sorting, 3)]);
disp(['Skewness: ', num2str(total_skewness, 3)]);
disp(['Kurtosis: ', num2str(total_kurtosis, 3)]);
disp(['D10: ', num2str(total_D10, 3), ' mm']);
disp(['D50: ', num2str(total_D50, 3), ' mm']);
disp(['D90: ', num2str(total_D90, 3), ' mm']);
disp(['D75divD25: ', num2str(total_D75divD25, 3)]);
disp(['D75minD25: ', num2str(total_D75minD25, 3), ' mm']);
disp('__________________________________________________________')


%% Sort samples by relative location

% Initialize an empty cell array to store modified tables
modifiedTables = cell(size(data));

% Loop through each table and keep only the first 16 columns
for i = 1:length(data)
    currentTable = data{i}; % Get the current table
    modifiedTables{i} = currentTable(:, 1:16); % Keep only the first 16 columns
end

% Changing the header of the coordinate columns so they can be stacked
for i = [1, 5]
    modifiedTables{i}.Properties.VariableNames{'xRD_inaccurate_m'} = 'xRD_m';
    modifiedTables{i}.Properties.VariableNames{'yRD_inaccurate_m'} = 'yRD_m';
    modifiedTables{i}.Properties.VariableNames{'zNAP_inaccurate_m'} = 'zNAP_m';
end

% Vertically concatenate all modified tables
data_stacked = vertcat(modifiedTables{:});

% Sort based on relative location
pgons = getPgons();

% Check if each point is inside the polygon
inside_Sbeach = inpolygon(data_stacked.xRD_m, data_stacked.yRD_m,...
    pgons.south_beach(:,1), pgons.south_beach(:,2));

inside_Hook = inpolygon(data_stacked.xRD_m, data_stacked.yRD_m,...
    pgons.hook(:,1), pgons.hook(:,2));

% Select rows where points are inside the polygon
Sbeach_samples = data_stacked(inside_Sbeach, :);
Hook_samples = data_stacked(inside_Hook, :);
Spit_samples = data_stacked(~inside_Sbeach & ~inside_Hook, :);

% insideZ = (T.z >= zMin) & (T.z <= zMax);
% selectedRows = T(inside & insideZ, :);


%% GS statistics of selections
Mean_Sbeach = mean(Sbeach_samples.Mean_mu, "omitmissing")/1000;
Mean_Spit = mean(Spit_samples.Mean_mu, "omitmissing")/1000;
Mean_Hook = mean(Hook_samples.Mean_mu, "omitmissing")/1000;

Std_Sbeach = mean(Sbeach_samples.Sorting, "omitmissing");
Std_Spit = mean(Spit_samples.Sorting, "omitmissing");
Std_Hook = mean(Hook_samples.Sorting, "omitmissing");

% Display the calculated values
disp('Grain-size stats based on sampling location:')
disp(' ')
disp(['Harbour (n=', num2str(height(Sbeach_samples)),'):'])
disp(['Mean: ', num2str(Mean_Sbeach, 3), ' mm']);
disp(['Sorting: ', num2str(Std_Sbeach, 3)]);
disp(' ')
disp(['Spit (n=', num2str(height(Spit_samples)),'):'])
disp(['Mean: ', num2str(Mean_Spit, 3), ' mm']);
disp(['Sorting: ', num2str(Std_Spit, 3)]);
disp(' ')
disp(['Hook (n=', num2str(height(Hook_samples)),'):'])
disp(['Mean: ', num2str(Mean_Hook, 3), ' mm']);
disp(['Sorting: ', num2str(Std_Hook, 3)]);
disp('__________________________________________________________')


%% Sort samples by elevation

% Vertically concatenate all modified tables
data_stacked = vertcat(modifiedTables{[2:4, 6:end]});  % Tables 1 and 5 contain unreliable coordinates

% Bin samples by elevation
z210_230 = data_stacked.zNAP_m >= +2.10 & data_stacked.zNAP_m < +2.30;
z190_210 = data_stacked.zNAP_m >= +1.90 & data_stacked.zNAP_m < +2.10;
z170_190 = data_stacked.zNAP_m >= +1.70 & data_stacked.zNAP_m < +1.90;
z150_170 = data_stacked.zNAP_m >= +1.50 & data_stacked.zNAP_m < +1.70;
z130_150 = data_stacked.zNAP_m >= +1.30 & data_stacked.zNAP_m < +1.50;
z110_130 = data_stacked.zNAP_m >= +1.10 & data_stacked.zNAP_m < +1.30;
z090_110 = data_stacked.zNAP_m >= +0.90 & data_stacked.zNAP_m < +1.10;
z070_090 = data_stacked.zNAP_m >= +0.70 & data_stacked.zNAP_m < +0.90;
z050_070 = data_stacked.zNAP_m >= +0.50 & data_stacked.zNAP_m < +0.70;
z030_050 = data_stacked.zNAP_m >= +0.30 & data_stacked.zNAP_m < +0.50;
z010_030 = data_stacked.zNAP_m >= +0.10 & data_stacked.zNAP_m < +0.30;
z010_010 = data_stacked.zNAP_m >= -0.10 & data_stacked.zNAP_m < +0.10;
z030_010 = data_stacked.zNAP_m >= -0.30 & data_stacked.zNAP_m < -0.10;
z050_030 = data_stacked.zNAP_m >= -0.50 & data_stacked.zNAP_m < -0.30;
z070_050 = data_stacked.zNAP_m >= -0.70 & data_stacked.zNAP_m < -0.50;
z090_070 = data_stacked.zNAP_m >= -0.90 & data_stacked.zNAP_m < -0.70;
z110_090 = data_stacked.zNAP_m >= -1.10 & data_stacked.zNAP_m < -0.90;
z130_110 = data_stacked.zNAP_m >= -1.30 & data_stacked.zNAP_m < -1.10;

logical_z = [z210_230, z190_210, z170_190, z150_170, z130_150, z110_130,...
    z090_110, z070_090, z050_070, z030_050, z010_030, z010_010,...
    z030_010, z050_030, z070_050, z090_070, z110_090, z130_110];

z_labels = {'+2.10 +2.30', '+1.90 +2.10', '+1.70 +1.90', '+1.50 +1.70', '+1.30 +1.50', '+1.10 +1.30',...
    '+0.90 +1.10', '+0.70 +0.90', '+0.50 +0.70', '+0.30 +0.50', '+0.10 +0.30', '-0.10 +0.10',...
    '-0.30  -0.10', '-0.50  -0.30', '-0.70  -0.50', '-0.90  -0.70', '-1.10  -0.90', '-1.30  -1.10'}';


%% GS statistics of selections
Mean_z = NaN(width(logical_z), 1);
Sorting_z = NaN(width(logical_z), 1);

for i = 1:width(logical_z)
    Mean_z(i) = mean(data_stacked(logical_z(:,i), :).Mean_mu, "omitmissing")/1000;
    Sorting_z(i) = mean(data_stacked(logical_z(:,i), :).Sorting, "omitmissing");
end

x = 1:numel(Mean_z);
y = flipud(Mean_z);

p = polyfit(x(2:end-2), y(2:end-2), 1);
yfit = polyval(p, x(2:end-2));

figureRH;
yyaxis left
scatter(x, y, 200, 'filled'); hold on
plot(x(2:end-2), yfit, '-', 'LineWidth',4); hold off
ylabel('mean M_G (mm)')

yyaxis right
bar(x, fliplr(sum(logical_z)), 'FaceAlpha',.2)
ylabel('# sampels')

xticks(1:numel(Mean_z))
xticklabels(flipud(z_labels))

