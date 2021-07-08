%% Initialisation
close all
clear
clc

eurecca_init

% processed topo files
load('zSounding.mat')

% processed sedi files
load('JDN_samples.mat')
load('sampleGPS.mat')

data = {z_UTD_realisatie, z_2019_Q4, z_2020_Q1, z_2020_Q2, z_2020_Q3, z_2020_Q4, z_2021_Q1};
names = {'UTD realisatie', '2019 Q4', '2020 Q1', '2020 Q2', '2020 Q3', '2020 Q4', '2021 Q1'};

% tidal datums (slotgemiddelden 2011): HHNK & Witteveen+Bos, 2016
DHW = 2.95; % decennial (1/10y) high water level [m+NAP]
BHW = 2.4; % biennial (1/2y) high water level [m+NAP]
AHW = 2.25; % annual (1/1y) high water level [m+NAP]
MHW = 0.64; % mean high water level [m+NAP]
MSL = 0.04; % mean sea level [m+NAP]
MLW = -0.69; % mean low water level [m+NAP]
LAT = -1.17; % lowest astronomical tide [m+NAP]

% create grid for tidal contours
Xlim = [114800, 118400];
Ylim = [557500, 560800];
res = 200; % resolution
x = linspace(Xlim(1), Xlim(2), res);
y = linspace(Ylim(1), Ylim(2), res);
[X, Y] = meshgrid(x, y);
Z = griddata(data{5}.xRD, data{5}.yRD, data{5}.z, X, Y);

% other settings
fontsize = 25;
xl = [11693 11759];
yl = [559650 560250];

%%
% Sandy_2020-10-16
list = {'0_1','1_1','1_2','1_3','2_1','2_2','2_3','3_1','3_2','3_3','4_1','4_2','4_3','5_1','5_2','5_3','6_1','6_2','6_3','7_0','7_1','7_2','8_0','8_1','8_2'};

for n = 1:length(list)
    D16(n,:) = importD(['eurecca-wp2\data\sediment\processed\Sandy_2020-10-16\' char(list(n)) '\Results_' char(list(n)) '.txt'], [41, 41]);
    D50(n,:) = importD(['eurecca-wp2\data\sediment\processed\Sandy_2020-10-16\' char(list(n)) '\Results_' char(list(n)) '.txt'], [44, 44]);
    D84(n,:) = importD(['eurecca-wp2\data\sediment\processed\Sandy_2020-10-16\' char(list(n)) '\Results_' char(list(n)) '.txt'], [47, 47]);
end

sampleData1.D16 = D16;
sampleData1.D50 = D50;
sampleData1.D84 = D84;
clearvars('D16', 'D50', 'D84')

% Sandy_2020-12-02
list = ls('data\sediment\processed\Sandy_2020-12-02\T*');

for n = 1:length(list)
    D16(n,:) = importD(['eurecca-wp2\data\sediment\processed\Sandy_2020-12-02\' list(n,:) '\Results_' list(n,:) '.txt'], [57, 57]);
    D50(n,:) = importD(['eurecca-wp2\data\sediment\processed\Sandy_2020-12-02\' list(n,:) '\Results_' list(n,:) '.txt'], [60, 60]);
    D84(n,:) = importD(['eurecca-wp2\data\sediment\processed\Sandy_2020-12-02\' list(n,:) '\Results_' list(n,:) '.txt'], [63, 63]);
end

sampleData2.D16 = D16;
sampleData2.D50 = D50;
sampleData2.D84 = D84;
clearvars('D16', 'D50', 'D84')

% Sandy_2020-12-03
list = ls('data\sediment\processed\Sandy_2020-12-03\T*');

for n = 1:length(list)
    D16(n,:) = importD(['eurecca-wp2\data\sediment\processed\Sandy_2020-12-03\' list(n,:) '\Results_' list(n,:) '.txt'], [57, 57]);
    D50(n,:) = importD(['eurecca-wp2\data\sediment\processed\Sandy_2020-12-03\' list(n,:) '\Results_' list(n,:) '.txt'], [60, 60]);
    D84(n,:) = importD(['eurecca-wp2\data\sediment\processed\Sandy_2020-12-03\' list(n,:) '\Results_' list(n,:) '.txt'], [63, 63]);
end

sampleData3.D16 = D16;
sampleData3.D50 = D50;
sampleData3.D84 = D84;
clearvars('D16', 'D50', 'D84')

% Sandy_2021-04-08
list = ls('data\sediment\processed\Sandy_2021-04-08\H*');

for n = 1:length(list)
    D16(n,:) = importD(['eurecca-wp2\data\sediment\processed\Sandy_2021-04-08\' list(n,:) '\Results_' list(n,:) '.txt'], [57, 57]);
    D50(n,:) = importD(['eurecca-wp2\data\sediment\processed\Sandy_2021-04-08\' list(n,:) '\Results_' list(n,:) '.txt'], [60, 60]);
    D84(n,:) = importD(['eurecca-wp2\data\sediment\processed\Sandy_2021-04-08\' list(n,:) '\Results_' list(n,:) '.txt'], [63, 63]);
end

sampleData4.D16 = D16;
sampleData4.D50 = D50;
sampleData4.D84 = D84;
clearvars('D16', 'D50', 'D84')

sampleData = [sampleData1; sampleData2; sampleData3; sampleData4];

%% Visualisation: median grain size
figure
ax1 = axes;
ax2 = axes;
scatter(ax1, data{5}.xRD, data{5}.yRD, [], data{5}.z, '.'); hold on
[~, c1] = contour(X, Y, Z, [AHW AHW], ':k', 'LineWidth', 1.5);
[~, c2] = contour(X, Y, Z, [MHW MHW], '-.k', 'LineWidth', 1);
[~, c3] = contour(X, Y, Z, [MLW MLW], '--k', 'LineWidth', 1);
legend(ax1, [c1 c2 c3], {['AHW  (', num2str(AHW), ' m)'],...
    ['MHW  (', num2str(MHW), ' m)'], ['MLW  (', num2str(MLW), ' m)']},...
    'Location', 'northeast')

scatter(ax2, sampleDune.Easting, sampleDune.Northing, 100, sampleDune.D50m/1e3, 'filled', 'MarkerEdgeColor', 'r'); hold on
scatter(ax2, sampleShell.RDX, sampleShell.RDY, 100, sampleShell.D50_zeef/1e3, 'filled', 'MarkerEdgeColor', 'r')
scatter(ax2, sampleArmor.Easting, sampleArmor.Northing, 100, sampleArmor.D50m/1e3, 'filled', 'MarkerEdgeColor', 'r')
scatter(ax2, sampleData1.xRD, sampleData1.yRD, 100, sampleData1.D50, 'filled', 'MarkerEdgeColor', 'k')
scatter(ax2, sampleData2.xRD, sampleData2.yRD, 100, sampleData2.D50, 'filled', 'MarkerEdgeColor', 'k')
scatter(ax2, sampleData3.xRD, sampleData3.yRD, 100, sampleData3.D50, 'filled', 'MarkerEdgeColor', 'k')
scatter(ax2, sampleData4.xRD, sampleData4.yRD, 100, sampleData4.D50, 'filled', 'MarkerEdgeColor', 'k')
% text(117100, 558200, '2/3 Dec 2020', 'FontSize', fontsize)

linkaxes([ax1, ax2])

ax2.Visible = 'off';
ax2.XTick = [];
ax2.YTick = [];

colormap(ax1, brewermap([], '*PuOr'))
colormap(ax2, brewermap([], 'Greens'))
% colormap(ax2, 'jet')

set([ax1, ax2], 'Position', [.17 .11 .685 .815]);
cb1 = colorbar(ax1, 'Position', [.06 .11 .0275 .815]);
cb2 = colorbar(ax2, 'Position', [.88 .11 .0275 .815]);

cb1.Label.String = 'm +NAP';
cb1.Label.Interpreter = 'latex';
cb1.TickLabelInterpreter = 'latex';
cb1.FontSize = fontsize;

cb2.Label.String = 'D$_{50}$ (mm)';
cb2.Label.Interpreter = 'latex';
cb2.TickLabelInterpreter = 'latex';
cb2.FontSize = fontsize;

xlabel([ax1 ax2], 'xRD (m)')
ylabel([ax1 ax2], 'yRD (m)')

caxis(ax1, [-5 5])
caxis(ax2, [0 2])
% axis([ax1 ax2], [Xlim(1), Xlim(2), Ylim(1), Ylim(2)])
axis([ax1 ax2], [xl(1), xl(2), yl(1), yl(2)])
% xticks([ax1 ax2], 114000:1e3:118000)
% yticks([ax1 ax2], 558000:1e3:561000) 
axis([ax1 ax2], 'equal')
set([ax1 ax2], 'Color', [.8 .8 .8])
grid([ax1 ax2], 'on')

%% Visualisation: degree of sorting
figure
ax1 = axes;
ax2 = axes;
scatter(ax1, data{5}.xRD, data{5}.yRD, [], data{5}.z, '.'); hold on
[~, c1] = contour(X, Y, Z, [AHW AHW], ':k', 'LineWidth', 1.5);
[~, c2] = contour(X, Y, Z, [MHW MHW], '-.k', 'LineWidth', 1);
[~, c3] = contour(X, Y, Z, [MLW MLW], '--k', 'LineWidth', 1);
legend(ax1, [c1 c2 c3], {['AHW  (', num2str(AHW), ' m)'],...
    ['MHW  (', num2str(MHW), ' m)'], ['MLW  (', num2str(MLW), ' m)']},...
    'Location', 'northeast')

scatter(ax2, sampleData1.xRD, sampleData1.yRD, 100, sampleData1.D16./sampleData1.D84, 'filled', 'MarkerEdgeColor', 'k'); hold on
scatter(ax2, sampleData2.xRD, sampleData2.yRD, 100, sampleData2.D16./sampleData2.D84, 'filled', 'MarkerEdgeColor', 'k')
scatter(ax2, sampleData3.xRD, sampleData3.yRD, 100, sampleData3.D16./sampleData3.D84, 'filled', 'MarkerEdgeColor', 'k')
scatter(ax2, sampleData4.xRD, sampleData4.yRD, 100, sampleData4.D16./sampleData4.D84, 'filled', 'MarkerEdgeColor', 'k')
% text(117100, 558200, '2/3 Dec 2020', 'FontSize', fontsize)

linkaxes([ax1, ax2])

ax2.Visible = 'off';
ax2.XTick = [];
ax2.YTick = [];

colormap(ax1, brewermap([], '*PuOr'))
% colormap(ax2, brewermap([], 'Greens'))
colormap(ax2, flipud(jet))

set([ax1, ax2], 'Position', [.17 .11 .685 .815]);
cb1 = colorbar(ax1, 'Position', [.06 .11 .0275 .815]);
cb2 = colorbar(ax2, 'Position', [.88 .11 .0275 .815]);

cb1.Label.Interpreter = 'latex';
cb1.TickLabelInterpreter = 'latex';
cb1.Label.String = 'm +NAP';
cb1.FontSize = fontsize;

cb2.Label.Interpreter = 'latex';
cb2.TickLabelInterpreter = 'latex';
cb2.Label.String = ['$<$ worse sorted $', repmat('\ ', 1, 12), '$ D$_{16}$/D$_{84}$ $', repmat('\ ', 1, 12), '$ better sorted $>$'];
cb2.FontSize = fontsize;

xlabel([ax1 ax2], 'xRD (m)')
ylabel([ax1 ax2], 'yRD (m)')

caxis(ax1, [-5 5])
caxis(ax2, [0 0.5])
% axis([ax1 ax2], [Xlim(1), Xlim(2), Ylim(1), Ylim(2)])
axis([ax1 ax2], [xl(1), xl(2), yl(1), yl(2)])
% xticks([ax1 ax2], 114000:1e3:118000)
% yticks([ax1 ax2], 558000:1e3:561000) 
axis([ax1 ax2], 'equal')
set([ax1 ax2], 'Color', [.8 .8 .8])
grid([ax1 ax2], 'on')

%% Visualisation: grain-size populations
figure
loglog(sampleData1.D50, sampleData1.D16./sampleData1.D84, 'o', 'LineWidth', 1); hold on
loglog(sampleData2.D50, sampleData2.D16./sampleData2.D84, 'o', 'LineWidth', 1); hold on
loglog(sampleData3.D50, sampleData3.D16./sampleData3.D84, 'o', 'LineWidth', 1); hold on
loglog(sampleData4.D50, sampleData4.D16./sampleData4.D84, 'o', 'LineWidth', 1); hold on
text(sampleData.D50+0.01*sampleData.D50, sampleData.D16./sampleData.D84, sampleData.Sample, 'Interpreter', 'tex')
xlabel('D$_{50}$ (mm)')
ylabel('D$_{16}$/D$_{84}$')
legend('2020-10-16', '2020-12-02', '2020-12-03', '2021-04-08', 'Location', 'northeast')
grid on
