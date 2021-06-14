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

% % 2018 Q4 / 23 Apr 2019?
% D50_shell = sampleShell.D50_zeef;
% D50_armour = sampleArmor.D50m;
% D50_dune = sampleDune.D50m;

% % 16 Oct 2020
D50 = [0.384 0.909 0.441 0.337 0.670 0.946 0.817 0.926 1.578 0.924 1.070 0.564 0.831 1.177 1.833 2.365 0.709 0.439 0.559 0.296 0.483 1.087 0.272 1.342 0.448]';
D90 = [1.050 2.523 1.473 0.487 2.472 2.567 2.131 3.164 3.960 3.566 3.083 2.395 3.094 3.374 5.999 4.758 1.865 3.309 2.223 0.437 1.669 3.901 0.415 2.852 1.438]';
STD = [0.884 1.151 0.892 0.474 1.205 1.094 1.022 1.058 1.283 1.336 1.032 1.161 1.194 1.041 1.228 1.402 0.957 1.340 1.095 0.453 1.018 1.355 0.455 0.817 0.890]';

sampleData1.D50 = D50;
sampleData1.D90 = D90;
sampleData1.STD = STD;

% % 2 Dec 2020
D50 = [0.936 0.430 0.399 0.266 0.679 0.553 0.810 0.424 0.425 0.616 0.999 0.650 0.895 0.355 0.541 0.911 0.381 0.728 1.117 0.996 0.902 0.513 0.906 0.839]';
D90 = [4.596 2.992 5.328 0.488 3.925 2.704 3.952 4.482 2.355 3.371 2.799 1.827 2.616 1.037 2.990 3.096 4.498 4.289 2.792 3.626 2.893 1.460 3.407 2.410]';
STD = [1.646 1.378 1.613 0.573 1.640 1.312 1.415 1.645 1.297 1.341 1.323 0.933 1.163 0.789 1.310 1.232 1.486 1.510 1.116 1.355 1.207 0.936 1.211 1.135]';

sampleData2(20:26, :) = []; % sieving not yet finished
sampleData2.D50 = D50;
sampleData2.D90 = D90;
sampleData2.STD = STD;

% 3 Dec 2020
D50 = [1.018 0.460 2.089 0.687 1.125 1.004 0.673 1.009 1.369 0.423]';
D90 = [5.320 2.656 6.253 4.707 3.666 4.068 2.754 3.473 4.369 5.349]';
STD = [1.757 1.313 1.792 1.581 1.389 1.374 1.252 1.234 1.350 1.718]';

sampleData3.D50 = D50;
sampleData3.D90 = D90;
sampleData3.STD = STD;

% 8 Apr 2021
D50 = [1.617 0.435 0.990 0.482]';
D90 = [5.028 1.357 2.382 2.026]';
STD = [1.312 0.920 1.081 1.146]';

sampleData4.D50 = D50;
sampleData4.D90 = D90;
sampleData4.STD = STD;

clearvars('D50', 'D90', 'STD')

xl = [11693 11759];
yl = [559650 560250];

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

scatter(ax2, sampleDune.Easting, sampleDune.Northing, 200, sampleDune.D50m/1e3, 'filled', 'MarkerEdgeColor', 'r'); hold on
scatter(ax2, sampleShell.RDX, sampleShell.RDY, 200, sampleShell.D50_zeef/1e3, 'filled', 'MarkerEdgeColor', 'r')
scatter(ax2, sampleArmor.Easting, sampleArmor.Northing, 200, sampleArmor.D50m/1e3, 'filled', 'MarkerEdgeColor', 'r')
scatter(ax2, sampleData1.xRD, sampleData1.yRD, 200, sampleData1.D50, 'filled', 'MarkerEdgeColor', 'k')
scatter(ax2, sampleData2.xRD, sampleData2.yRD, 200, sampleData2.D50, 'filled', 'MarkerEdgeColor', 'k')
scatter(ax2, sampleData3.xRD, sampleData3.yRD, 200, sampleData3.D50, 'filled', 'MarkerEdgeColor', 'k')
scatter(ax2, sampleData4.xRD, sampleData4.yRD, 200, sampleData4.D50, 'filled', 'MarkerEdgeColor', 'k')
% text(117100, 558200, '2/3 Dec 2020', 'FontSize', 25)

linkaxes([ax1, ax2])

ax2.Visible = 'off';
ax2.XTick = [];
ax2.YTick = [];

colormap(ax1, brewermap([], '*PuOr'))
colormap(ax2, brewermap([], 'Greens'))
% colormap(ax2, 'jet')

set([ax1, ax2], 'Position', [.17 .11 .685 .815]);
cb1 = colorbar(ax1, 'Position', [.05 .11 .0375 .815]);
cb2 = colorbar(ax2, 'Position', [.88 .11 .0375 .815]);

cb1.Label.String = 'm +NAP';
cb1.Label.Interpreter = 'latex';
cb1.TickLabelInterpreter = 'latex';
cb1.FontSize = 25;

cb2.Label.String = 'D$_{50}$ (mm)';
cb2.Label.Interpreter = 'latex';
cb2.TickLabelInterpreter = 'latex';
cb2.FontSize = 25;

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

%% Visualisation: sample standard deviation (sorting)
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

scatter(ax2, sampleData1.xRD, sampleData1.yRD, 200, sampleData1.STD, 'filled', 'MarkerEdgeColor', 'k'); hold on
scatter(ax2, sampleData2.xRD, sampleData2.yRD, 200, sampleData2.STD, 'filled', 'MarkerEdgeColor', 'k')
scatter(ax2, sampleData3.xRD, sampleData3.yRD, 200, sampleData3.STD, 'filled', 'MarkerEdgeColor', 'k')
scatter(ax2, sampleData4.xRD, sampleData4.yRD, 200, sampleData4.STD, 'filled', 'MarkerEdgeColor', 'k')
% text(117100, 558200, '2/3 Dec 2020', 'FontSize', 25)

linkaxes([ax1, ax2])

ax2.Visible = 'off';
ax2.XTick = [];
ax2.YTick = [];

colormap(ax1, brewermap([], '*PuOr'))
% colormap(ax2, brewermap([], 'Greens'))
colormap(ax2, 'jet')

set([ax1, ax2], 'Position', [.17 .11 .685 .815]);
cb1 = colorbar(ax1, 'Position', [.05 .11 .0375 .815]);
cb2 = colorbar(ax2, 'Position', [.88 .11 .0375 .815]);

cb1.Label.String = 'm +NAP';
cb1.Label.Interpreter = 'latex';
cb1.TickLabelInterpreter = 'latex';
cb1.FontSize = 25;

cb2.Label.String = 'STD';
cb2.Label.Interpreter = 'latex';
cb2.TickLabelInterpreter = 'latex';
cb2.FontSize = 25;

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
