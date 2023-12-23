%% Initialisation
close all
clear
clc

[~, ~, cbf, PHZ, SEDMEX] = eurecca_init;

folderPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor' filesep];
locsX = {'L2C2', 'L2C3', 'L2C3.5', 'L2C4', 'L2C4.5', 'L2C5W', 'L2C5E', 'L2C6'};
locsY = {'S', 'SL', 'L3.5', 'L4', 'T', 'L6'};
idxSedi = [2155 2166 2171 2176 2181 2186 2196 2209];

fontsize = 30;

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
survey = [15 18 19 24 27];
survey2 = 14:28;

Z = NaN(length(z), length(survey));
for n = 1:length(survey)
    Z(:,n) = z(:, survey(n), track);
    Z(:,n) = movmean(Z(:,n), length(survey));
end

Z2 = NaN(length(z), length(survey2));
for n = 1:length(survey2)
    Z2(:,n) = z(:, survey2(n), track);
    Z2(:,n) = movmean(Z2(:,n), length(survey2));
end

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

GS_20210928 = readtable(dataPath{2}, opts);
GS_20210928 = GS_20210928(startsWith(GS_20210928.Sample_Identity, 'L2C'), :);
GS_20210928.Sample_Number = repelem([1 2 3 4], 8)';
GS_20210928.Sample_Identity = regexprep(GS_20210928.Sample_Identity, '_.*', '');
GS_20210928.zNAP_m = repmat(Z(idxSedi, 2), 4, 1);

GS_20211001 = readtable(dataPath{3}, opts);
GS_20211001(1, :) = [];
GS_20211001(endsWith(GS_20211001.Sample_Identity, '1001'), :) = [];
GS_20211001 = [GS_20211001; GS_20211001; GS_20211001; GS_20211001];
GS_20211001{9:end, 6:end} = NaN;
GS_20211001.Sample_Number = repelem([1 2 3 4], 8)';
GS_20211001.zNAP_m = repmat(Z(idxSedi, 3), 4, 1);

GS_20211007 = readtable(dataPath{4}, opts);
GS_20211007.Sample_Number = repelem([1 2 3 4], 8)';
GS_20211007.Sample_Identity = regexprep(GS_20211007.Sample_Identity, '_.*', '');
GS_20211007.zNAP_m = repmat(Z(idxSedi, 4), 4, 1);

GS_20211015 = readtable(dataPath{5}, opts);
GS_20211015 = [GS_20211015(1:7,:); GS_20211015(15,:); GS_20211015(8:end,:)]; % too deep L2C6_1
GS_20211015.Sample_Identity(8) = {'L2C6_1'};
GS_20211015{8, 6:end} = NaN;
GS_20211015 = [GS_20211015; GS_20211015(1:8, :)];
GS_20211015{25:end, 6:end} = NaN;
GS_20211015.Sample_Number = repelem([1 2 3 4], 8)';
GS_20211015.Sample_Identity = regexprep(GS_20211015.Sample_Identity, '_.*', '');
GS_20211015.zNAP_m = repmat(Z(idxSedi, 5), 4, 1);


%% L2 profile development
f1 = figure('Position',[1722, 709, 1719, 628]);

hold on
p = nan(length(survey));
valAlpha = nan(size(survey));
for n = 1:length(survey)
    valAlpha(n) = (1/length(survey))+(n-1)*(1/length(survey));
    p(n) = plot(d, Z(:,n), 'LineWidth',3, 'Color',[cbf.orange, valAlpha(n)]);
end
hold off

xline(d(idxSedi), '-', string(locsX), 'FontSize',fontsize*1, 'LabelHorizontalAlignment','center')

yline(SEDMEX.MHW, '--', 'MHW', 'FontSize',fontsize*1)
yline(0, '-.', 'MSL', 'FontSize',fontsize*1)
yline(SEDMEX.MLW, '--', 'MLW', 'FontSize',fontsize*1)

xlim([-30, 20])
ylim([-1.7, 1.7])

xlabel('cross-shore distance (m)')
ylabel('bed level (m +NAP)')
legend(string(surveyDates(survey)), 'Location','southwest')

% newcolors = crameri('roma');
% colororder(newcolors(1:round(length(newcolors)/length(survey)):length(newcolors), :))


%% Bed-level change at sample locations
% zSedi = [GS_20210920.zNAP_m(1:8), GS_20210928.zNAP_m(1:8), GS_20211001.zNAP_m(1:8), GS_20211007.zNAP_m(1:8), GS_20211015.zNAP_m(1:8)];
tSedi = [GS_20210920.Date_ddMMyyyy(1), GS_20210928.Date_ddMMyyyy(1), GS_20211001.Date_ddMMyyyy(1), GS_20211007.Date_ddMMyyyy(1), GS_20211015.Date_ddMMyyyy(1)];
zSedi2 = Z2(idxSedi, :);
tSedi2 = surveyDates(survey2);

f2 = figure('Position',[1722, 709, 1719, 628]);
plot(tSedi2, zSedi2, '-o', 'LineWidth',3)

xline(tSedi, '-', 'sampling', 'FontSize',fontsize*1, 'LabelHorizontalAlignment','center')
yline(PHZ.MHW, '--', 'MHW', 'FontSize',fontsize*1, 'LabelVerticalAlignment','top')
yline(PHZ.MSL, '-.', 'MSL', 'FontSize',fontsize*1, 'LabelVerticalAlignment','top')
yline(PHZ.MLW, '--', 'MLW', 'FontSize',fontsize*1, 'LabelVerticalAlignment','top')

legend(locsX, 'Location','northeastoutside')
xlim([datetime(tSedi2(1)-days(2)), datetime(tSedi2(end)+days(2))])
ylim([-1.5 1.2])
box off

newcolors = crameri('roma');
colororder(newcolors(1:round(length(newcolors)/length(locsX)):length(newcolors), :))

