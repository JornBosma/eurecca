%% Initialisation
close all
clear
clc

[~, fontsize, ~, PHZ] = eurecca_init;

locs = {'L2C2', 'L2C3', 'L2C3.5', 'L2C4', 'L2C4.5', 'L2C5W', 'L2C5E', 'L2C6'};

% load data
folderPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor' filesep];
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

GS_20211001 = readtable(dataPath{3}, opts);
GS_20211001(1, :) = [];
GS_20211001(endsWith(GS_20211001.Sample_Identity, '1001'), :) = [];
GS_20211001 = [GS_20211001; GS_20211001; GS_20211001; GS_20211001];
GS_20211001{9:end, 6:end} = NaN;
GS_20211001.Sample_Number = repelem([1 2 3 4], 8)';

GS_20211007 = readtable(dataPath{4}, opts);
GS_20211007.Sample_Number = repelem([1 2 3 4], 8)';
GS_20211007.Sample_Identity = regexprep(GS_20211007.Sample_Identity, '_.*', '');

GS_20211015 = readtable(dataPath{5}, opts);
GS_20211015 = [GS_20211015(1:7,:); GS_20211015(15,:); GS_20211015(8:end,:)]; % too deep L2C6_1
GS_20211015.Sample_Identity(8) = {'L2C6_1'};
GS_20211015{8, 6:end} = NaN;
GS_20211015 = [GS_20211015; GS_20211015(1:8, :)];
GS_20211015{25:end, 6:end} = NaN;
GS_20211015.Sample_Number = repelem([1 2 3 4], 8)';
GS_20211015.Sample_Identity = regexprep(GS_20211015.Sample_Identity, '_.*', '');

%% cross-shore profiles
dataPath{6} = [folderPath 'topobathy' filesep 'transects' filesep 'PHZD.nc'];

% assign variables
x = ncread(dataPath{6}, 'x'); % xRD [m]
y = ncread(dataPath{6}, 'y'); % yRD [m]
z = ncread(dataPath{6}, 'z'); % bed level [m+NAP]
d = ncread(dataPath{6}, 'd'); % cross-shore distance [m]
ID = ncread(dataPath{6}, 'ID'); % profile ID (days since 2020-10-16 00:00:00)
transect = ncread(dataPath{6}, 'transect'); % tansect number (Python counting)

% timing
startDate = datetime('2020-10-16 00:00:00');
surveyDates = startDate + days(ID);

% selection
track = 2; % L2
survey = [15 18 19 24 27];

for n = 1:length(survey)
    Zselect(:,n) = z(:, survey(n), track);
    Z{n} = Zselect(~isnan(Zselect(:,n)));
    Z{n} = movmean(Z{n}, 5);
    D{n} = d(~isnan(Zselect(:,n)));
end

% visualisation
f0 = figure;

hold on
for n = 1:length(survey)
    plot(D{n}, Z{n}, 'LineWidth',3)
end

% area(D, Z, 'BaseValue',-1.7, 'FaceColor',yellow)
% scatter(dGS, zSamples, 200, 'filled', 'vr'); hold off
% 
% text(dGS+1, zSamples+.04, names, 'FontSize',fontsize*.7)
% text(dGS(end)+1, zSamples(end)-0, 'L2C6', 'FontSize',fontsize*.7)

yline(PHZ.MHW, '--', 'MHW', 'FontSize',fontsize*.7, 'LineWidth',2)
yline(PHZ.MSL, '-.', 'MSL', 'FontSize',fontsize*.7, 'LineWidth',2)
yline(PHZ.MLW, '--', 'MLW', 'FontSize',fontsize*.7, 'LineWidth',2)

xlim([D(1), D(end)])
ylim([-1.7, 1.7])

xlabel('cross-shore distance [m]')
ylabel('bed level [m +NAP]')

legend(cellstr(surveyDates(survey)))
% legend('', 'bed', 'samples', 'Location','north')

%% GS_20210920 (15) Sep 19
f1 = figure;
tiledlayout(6, 4, 'TileSpacing','tight', 'Padding','compact')

nexttile(5,[5 3])
h1 = heatmap(GS_20210920, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Mean_mu');
colormap(h1, crameri('lajolla'))
clim([0, 2000])

% h1.Title = '2021-09-20';
h1.Title = [];
h1.XDisplayLabels = {'HW','MT_\downarrow','LW','MT_\uparrow'};
h1.YDisplayData = fliplr(locs);
h1.XLabel = '';
h1.YLabel = '';
h1.FontSize = fontsize;
h1.CellLabelFormat = '%0.0f';

nexttile(4)
text(-.7, .5, '2021-09-20', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata1 = [h1.ColorData(1:5,:); h1.ColorData(7,:); h1.ColorData(6,:); h1.ColorData(8,:)]; % swap C5E and C5W
stdS_20210920 = std(heatdata1, 0, 1, 'omitmissing');
nexttile(1,[1 3])
plot(1.5:4.5, stdS_20210920, '-k', 'LineWidth',3)
yline(mean(stdS_20210920, 'omitmissing'), '--', 'LineWidth',2)
xticks([])
xlim([1 5])
ylabel('\sigma_s (µm)')

stdT_20210920 = std(heatdata1, 0, 2, 'omitmissing');
nexttile(8,[5 1])
plot(stdT_20210920, 1.5:8.5, '-k', 'LineWidth',3)
xline(mean(stdT_20210920, 'omitmissing'), '--', 'LineWidth',2)
yticks([])
ylim([1 9])
xlabel('\sigma_t (µm)')
text(-190, 4, 'M_G (µm)', 'FontSize',fontsize, 'Rotation',90) % colorbar label heatmap

%% GS_20210928 (18) Sep 28
f2 = figure;
tiledlayout(6, 4, 'TileSpacing','tight', 'Padding','compact')

nexttile(5,[5 3])
h2 = heatmap(GS_20210928, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Mean_mu');
colormap(h2, crameri('lajolla'))
clim([0, 2000])

% h2.Title = '2021-09-28';
h2.Title = [];
h2.XDisplayLabels = {'HW','MT_\downarrow','LW','MT_\uparrow'};
h2.YDisplayData = fliplr(locs);
h2.XLabel = '';
h2.YLabel = '';
h2.FontSize = fontsize;
h2.CellLabelFormat = '%0.0f';

nexttile(4)
text(-.7, .5, '2021-09-28', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata2 = [h2.ColorData(1:5,:); h2.ColorData(7,:); h2.ColorData(6,:); h2.ColorData(8,:)]; % swap C5E and C5W
stdS_20210928 = std(heatdata2, 0, 1, 'omitmissing');
nexttile(1,[1 3])
plot(1.5:4.5, stdS_20210928, '-k', 'LineWidth',3)
yline(mean(stdS_20210928, 'omitmissing'), '--', 'LineWidth',2)
xticks([])
xlim([1 5])
ylabel('\sigma_s (µm)')

stdT_20210928 = std(heatdata2, 0, 2, 'omitmissing');
nexttile(8,[5 1])
plot(stdT_20210928, 1.5:8.5, '-k', 'LineWidth',3)
xline(mean(stdT_20210928, 'omitmissing'), '--', 'LineWidth',2)
yticks([])
ylim([1 9])
xlabel('\sigma_t (µm)')
text(-190, 4, 'M_G (µm)', 'FontSize',fontsize, 'Rotation',90) % colorbar label heatmap

%% GS_20211001 (19) Sep 30
f3 = figure;
tiledlayout(6, 4, 'TileSpacing','tight', 'Padding','compact')

nexttile(5,[5 3])
h3 = heatmap(GS_20211001, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Mean_mu');
colormap(h3, crameri('lajolla'))
clim([0, 2000])

% h3.Title = '2021-10-01';
h3.Title = [];
h3.XDisplayData = {'3','4','1','2'};
h3.XDisplayLabels = {'HW','MT_\downarrow','LW','MT_\uparrow'};
h3.YDisplayData = fliplr(locs);
h3.XLabel = '';
h3.YLabel = '';
h3.FontSize = fontsize;
h3.CellLabelFormat = '%0.0f';
h3.MissingDataColor = 'w';
h3.MissingDataLabel = 'no data';

nexttile(4)
text(-.7, .5, '2021-10-01', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata3 = [h3.ColorData(1:5,:); h3.ColorData(7,:); h3.ColorData(6,:); h3.ColorData(8,:)]; % swap C5E and C5W
heatdata3 = [heatdata3(:,3:4) heatdata3(:,1) heatdata3(:,2)]; % correct sequence
stdS_20211001 = std(heatdata3, 0, 1, 'omitmissing');
nexttile(1,[1 3])
plot(1.5:4.5, stdS_20211001, 'ok', 'LineWidth',3, 'MarkerFaceColor','k')
yline(mean(stdS_20211001, 'omitmissing'), '--', 'LineWidth',2)
xticks([])
xlim([1 5])
ylabel('\sigma_s (µm)')

stdT_20211001 = std(heatdata3, 0, 2, 'omitmissing');
nexttile(8,[5 1])
plot(stdT_20211001, 1.5:8.5, 'ok', 'LineWidth',3, 'MarkerFaceColor','k')
xline(mean(stdT_20211001, 'omitmissing'), '--', 'LineWidth',2)
yticks([])
ylim([1 9])
xlabel('\sigma_t (µm)')
text(-190, 4, 'M_G (µm)', 'FontSize',fontsize, 'Rotation',90) % colorbar label heatmap

%% GS_20211007 (24) Oct 7
f4 = figure;
tiledlayout(6, 4, 'TileSpacing','tight', 'Padding','compact')

nexttile(5,[5 3])
h4 = heatmap(GS_20211007, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Mean_mu');
colormap(h4, crameri('lajolla'))
clim([0, 2000])

% h4.Title = '2021-10-07';
h4.Title = [];
h4.XDisplayLabels = {'HW','MT_\downarrow','LW','MT_\uparrow'};
h4.YDisplayData = fliplr(locs);
h4.XLabel = '';
h4.YLabel = '';
h4.FontSize = fontsize;
h4.CellLabelFormat = '%0.0f';

nexttile(4)
text(-.7, .5, '2021-10-07', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata4 = [h4.ColorData(1:5,:); h4.ColorData(7,:); h4.ColorData(6,:); h4.ColorData(8,:)]; % swap C5E and C5W
stdS_20211007 = std(heatdata4, 0, 1, 'omitmissing');
nexttile(1,[1 3])
plot(1.5:4.5, stdS_20211007, '-k', 'LineWidth',3)
yline(mean(stdS_20211007, 'omitmissing'), '--', 'LineWidth',2)
xticks([])
xlim([1 5])
ylabel('\sigma_s (µm)')

stdT_20211007 = std(heatdata4, 0, 2, 'omitmissing');
nexttile(8,[5 1])
plot(stdT_20211007, 1.5:8.5, '-k', 'LineWidth',3)
xline(mean(stdT_20211007, 'omitmissing'), '--', 'LineWidth',2)
yticks([])
ylim([1 9])
xlabel('\sigma_t (µm)')
text(-190, 4, 'M_G (µm)', 'FontSize',fontsize, 'Rotation',90) % colorbar label heatmap

%% GS_20211015 (27) Oct 15
f5 = figure;
tiledlayout(6, 4, 'TileSpacing','tight', 'Padding','compact')

nexttile(5,[5 3])
h5 = heatmap(GS_20211015, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Mean_mu');
colormap(h5, crameri('lajolla'))
clim([0, 2000])

% h5.Title = '2021-10-15';
h5.Title = [];
h5.XDisplayLabels = {'LW','MT_\uparrow','HW','MT_\downarrow'};
h5.YDisplayData = fliplr(locs);
h5.XLabel = '';
h5.YLabel = '';
h5.FontSize = fontsize;
h5.CellLabelFormat = '%0.0f';
h5.MissingDataColor = 'w';
h5.MissingDataLabel = 'no data';

nexttile(4)
text(-.7, .5, '2021-10-15', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata5 = [h5.ColorData(1:5,:); h5.ColorData(7,:); h5.ColorData(6,:); h5.ColorData(8,:)]; % swap C5E and C5W
stdS_20211015 = std(heatdata5, 0, 1, 'omitmissing');
nexttile(1,[1 3])
plot(1.5:4.5, stdS_20211015, '-k', 'LineWidth',3)
yline(mean(stdS_20211015, 'omitmissing'), '--', 'LineWidth',2)
xticks([])
xlim([1 5])
ylabel('\sigma_s (µm)')

stdT_20211015 = std(heatdata5, 0, 2, 'omitmissing');
nexttile(8,[5 1])
plot(stdT_20211015, 1.5:8.5, '-k', 'LineWidth',3)
xline(mean(stdT_20211015, 'omitmissing'), '--', 'LineWidth',2)
yticks([])
ylim([1 9])
xlabel('\sigma_t (µm)')
text(-190, 4, 'M_G (µm)', 'FontSize',fontsize, 'Rotation',90) % colorbar label heatmap

%% GS_20210920
f1b = figure;
tiledlayout(6, 4, 'TileSpacing','tight', 'Padding','compact')

nexttile(5,[5 3])
h1 = heatmap(GS_20210920, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Sorting');
colormap(h1, crameri('imola'))
clim([1, 3])

% h1.Title = '2021-09-20';
h1.Title = [];
h1.XDisplayLabels = {'HW','MT_\downarrow','LW','MT_\uparrow'};
h1.YDisplayData = fliplr(locs);
h1.XLabel = '';
h1.YLabel = '';
h1.FontSize = fontsize;
h1.CellLabelFormat = '%0.2f';

nexttile(4)
text(-.7, .5, '2021-09-20', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata1 = [h1.ColorData(1:5,:); h1.ColorData(7,:); h1.ColorData(6,:); h1.ColorData(8,:)]; % swap C5E and C5W
stdS_20210920 = std(heatdata1, 0, 1, 'omitmissing');
nexttile(1,[1 3])
plot(1.5:4.5, stdS_20210920, '-k', 'LineWidth',3)
yline(mean(stdS_20210920, 'omitmissing'), '--', 'LineWidth',2)
xticks([])
xlim([1 5])
ylabel('\sigma_s (µm)')

stdT_20210920 = std(heatdata1, 0, 2, 'omitmissing');
nexttile(8,[5 1])
plot(stdT_20210920, 1.5:8.5, '-k', 'LineWidth',3)
xline(mean(stdT_20210920, 'omitmissing'), '--', 'LineWidth',2)
yticks([])
ylim([1 9])
xlabel('\sigma_t (µm)')
text(-190, 4, '\sigma_G (µm)', 'FontSize',fontsize, 'Rotation',90) % colorbar label heatmap

%% GS_20210928
f2b = figure;
tiledlayout(6, 4, 'TileSpacing','tight', 'Padding','compact')

nexttile(5,[5 3])
h2 = heatmap(GS_20210928, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Sorting');
colormap(h2, crameri('imola'))
clim([1, 3])

% h2.Title = '2021-09-28';
h2.Title = [];
h2.XDisplayLabels = {'HW','MT_\downarrow','LW','MT_\uparrow'};
h2.YDisplayData = fliplr(locs);
h2.XLabel = '';
h2.YLabel = '';
h2.FontSize = fontsize;
h2.CellLabelFormat = '%0.2f';

nexttile(4)
text(-.7, .5, '2021-09-28', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata2 = [h2.ColorData(1:5,:); h2.ColorData(7,:); h2.ColorData(6,:); h2.ColorData(8,:)]; % swap C5E and C5W
stdS_20210928 = std(heatdata2, 0, 1, 'omitmissing');
nexttile(1,[1 3])
plot(1.5:4.5, stdS_20210928, '-k', 'LineWidth',3)
yline(mean(stdS_20210928, 'omitmissing'), '--', 'LineWidth',2)
xticks([])
xlim([1 5])
ylabel('\sigma_s (µm)')

stdT_20210928 = std(heatdata2, 0, 2, 'omitmissing');
nexttile(8,[5 1])
plot(stdT_20210928, 1.5:8.5, '-k', 'LineWidth',3)
xline(mean(stdT_20210928, 'omitmissing'), '--', 'LineWidth',2)
yticks([])
ylim([1 9])
xlabel('\sigma_t (µm)')
text(-190, 4, '\sigma_G (µm)', 'FontSize',fontsize, 'Rotation',90) % colorbar label heatmap

%% GS_20211001
f3b = figure;
tiledlayout(6, 4, 'TileSpacing','tight', 'Padding','compact')

nexttile(5,[5 3])
h3 = heatmap(GS_20211001, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Sorting');
colormap(h3, crameri('imola'))
clim([1, 3])

% h3.Title = '2021-10-01';
h3.Title = [];
h3.XDisplayData = {'3','4','1','2'};
h3.XDisplayLabels = {'HW','MT_\downarrow','LW','MT_\uparrow'};
h3.YDisplayData = fliplr(locs);
h3.XLabel = '';
h3.YLabel = '';
h3.FontSize = fontsize;
h3.CellLabelFormat = '%0.2f';
h3.MissingDataColor = 'w';
h3.MissingDataLabel = 'no data';

nexttile(4)
text(-.7, .5, '2021-10-01', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata3 = [h3.ColorData(1:5,:); h3.ColorData(7,:); h3.ColorData(6,:); h3.ColorData(8,:)]; % swap C5E and C5W
heatdata3 = [heatdata3(:,3:4) heatdata3(:,1) heatdata3(:,2)]; % correct sequence
stdS_20211001 = std(heatdata3, 0, 1, 'omitmissing');
nexttile(1,[1 3])
plot(1.5:4.5, stdS_20211001, 'ok', 'LineWidth',3, 'MarkerFaceColor','k')
yline(mean(stdS_20211001, 'omitmissing'), '--', 'LineWidth',2)
xticks([])
xlim([1 5])
ylabel('\sigma_s (µm)')

stdT_20211001 = std(heatdata3, 0, 2, 'omitmissing');
nexttile(8,[5 1])
plot(stdT_20211001, 1.5:8.5, 'ok', 'LineWidth',3, 'MarkerFaceColor','k')
xline(mean(stdT_20211001, 'omitmissing'), '--', 'LineWidth',2)
yticks([])
ylim([1 9])
xlabel('\sigma_t (µm)')
text(-190, 4, '\sigma_G (µm)', 'FontSize',fontsize, 'Rotation',90) % colorbar label heatmap

%% GS_20211007
f4b = figure;
tiledlayout(6, 4, 'TileSpacing','tight', 'Padding','compact')

nexttile(5,[5 3])
h4 = heatmap(GS_20211007, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Sorting');
colormap(h4, crameri('imola'))
clim([1, 3])

% h4.Title = '2021-10-07';
h4.Title = [];
h4.XDisplayLabels = {'HW','MT_\downarrow','LW','MT_\uparrow'};
h4.YDisplayData = fliplr(locs);
h4.XLabel = '';
h4.YLabel = '';
h4.FontSize = fontsize;
h4.CellLabelFormat = '%0.2f';

nexttile(4)
text(-.7, .5, '2021-10-07', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata4 = [h4.ColorData(1:5,:); h4.ColorData(7,:); h4.ColorData(6,:); h4.ColorData(8,:)]; % swap C5E and C5W
stdS_20211007 = std(heatdata4, 0, 1, 'omitmissing');
nexttile(1,[1 3])
plot(1.5:4.5, stdS_20211007, '-k', 'LineWidth',3)
yline(mean(stdS_20211007, 'omitmissing'), '--', 'LineWidth',2)
xticks([])
xlim([1 5])
ylabel('\sigma_s (µm)')

stdT_20211007 = std(heatdata4, 0, 2, 'omitmissing');
nexttile(8,[5 1])
plot(stdT_20211007, 1.5:8.5, '-k', 'LineWidth',3)
xline(mean(stdT_20211007, 'omitmissing'), '--', 'LineWidth',2)
yticks([])
ylim([1 9])
xlabel('\sigma_t (µm)')
text(-190, 4, '\sigma_G (µm)', 'FontSize',fontsize, 'Rotation',90) % colorbar label heatmap

%% GS_20211015
f5b = figure;
tiledlayout(6, 4, 'TileSpacing','tight', 'Padding','compact')

nexttile(5,[5 3])
h5 = heatmap(GS_20211015, 'Sample_Number', 'Sample_Identity', 'ColorVariable','Sorting');
colormap(h5, crameri('imola'))
clim([1, 3])

% h5.Title = '2021-10-15';
h5.Title = [];
h5.XDisplayLabels = {'LW','MT_\uparrow','HW','MT_\downarrow'};
h5.YDisplayData = fliplr(locs);
h5.XLabel = '';
h5.YLabel = '';
h5.FontSize = fontsize;
h5.CellLabelFormat = '%0.2f';
h5.MissingDataColor = 'w';
h5.MissingDataLabel = 'no data';

nexttile(4)
text(-.7, .5, '2021-10-15', 'FontSize',fontsize, 'FontWeight','bold', 'EdgeColor','k', 'Margin',6)
axis off

heatdata5 = [h5.ColorData(1:5,:); h5.ColorData(7,:); h5.ColorData(6,:); h5.ColorData(8,:)]; % swap C5E and C5W
stdS_20211015 = std(heatdata5, 0, 1, 'omitmissing');
nexttile(1,[1 3])
plot(1.5:4.5, stdS_20211015, '-k', 'LineWidth',3)
yline(mean(stdS_20211015, 'omitmissing'), '--', 'LineWidth',2)
xticks([])
xlim([1 5])
ylabel('\sigma_s (µm)')

stdT_20211015 = std(heatdata5, 0, 2, 'omitmissing');
nexttile(8,[5 1])
plot(stdT_20211015, 1.5:8.5, '-k', 'LineWidth',3)
xline(mean(stdT_20211015, 'omitmissing'), '--', 'LineWidth',2)
yticks([])
ylim([1 9])
xlabel('\sigma_t (µm)')
text(-190, 4, '\sigma_G (µm)', 'FontSize',fontsize, 'Rotation',90) % colorbar label heatmap
