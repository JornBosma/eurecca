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

data = {z_UTD_realisatie, z_2019_Q4, z_2020_Q1, z_2020_Q2, z_2020_Q3};
names = {'UTD realisatie', '2019 Q4', '2020 Q1', '2020 Q2', '2020 Q3'};

%%
% tidal datums (slotgemiddelden 2011): HHNK & Witteveen+Bos, 2016
DHW = 2.95; % decennial (1/10y) high water level [m+NAP]
BHW = 2.4; % biennial (1/2y) high water level [m+NAP]
AHW = 2.25; % annual (1/1y) high water level [m+NAP]
MHW = 0.64; % mean high water level [m+NAP]
MSL = 0.04; % mean sea level [m+NAP]
MLW = -0.69; % mean lowe water level [m+NAP]
LAT = -1.17; % lowest astronomical tide [m+NAP]

% create grid for tidal contours
Xlim = [114800, 118400];
Ylim = [557500, 560800];
res = 200; % resolution
x = linspace(Xlim(1), Xlim(2), res);
y = linspace(Ylim(1), Ylim(2), res);
[X, Y] = meshgrid(x, y);
Z = griddata(data{5}.xRD, data{5}.yRD, data{5}.z, X, Y);

%% 
D50x = [1.020 0.461 2.089 0.688 1.125 1.004 0.673 1.008 1.368 0.423];
D90x = [5.322 2.656 6.253 4.708 3.666 4.068 2.754 3.473 4.369 5.350];

sampleData3.D50 = D50x';

for n = 1:length(D50x)
    labelsX{n} = ['Ti', num2str(n)];
end

% low-water line (x.1)
D50y1 = [0.910 0.670 0.926 1.070 1.177 0.710 0.483 1.343];
D90y1 = [2.524 2.473 3.164 3.084 3.375 1.865 1.670 2.853];

for n = 1:length(D50y1)
    labelsY1{n} = ['LW', num2str(n)];
end

% runnel (x.2)
D50y2 = [0.441 0.946 1.579 0.565 1.834 0.439 1.088];
D90y2 = [1.472 2.568 3.960 2.396 6.000 3.312 3.901];

for n = 1:length(D50y2)
    labelsY2{n} = ['R', num2str(n)];
end

% high-water line (x.3)
D50y3 = [0.337 0.817 0.924 0.831 2.365 0.559 0.448];
D90y3 = [0.487 2.132 3.566 3.095 4.758 2.224 1.439];

for n = 1:length(D50y3)
    labelsY3{n} = ['HW', num2str(n)];
end

% other (x.0)
D50y0 = [0.387 0.296 0.272];
D90y0 = [1.060 0.437 0.415];

labelsY0 = {'lagoon', 'TF7', 'TF8'};

%% Visualisation: cross-shore transect
% figure
% bar([D50x;D90x]', 'grouped')
% legend('D$_{50}$', 'D$_{90}$')
% xticks(1:length(D50x))
% xticklabels(labelsX)
% ylim([0 7])
% xlabel('sample')
% ylabel('grain size (mm)')
% title('Cross-shore, 3 Dec 2020')
% 
%% Visualisation: longshore transects
% figure2('Name', 'Longshore transects')
% tl = tiledlayout('flow', 'TileSpacing', 'Compact');
% 
% ax(1) = nexttile;
% bar([D50y1;D90y1]', 'grouped')
% legend('D$_{50}$', 'D$_{90}$')
% xticks(1:length(D50y1))
% xticklabels(labelsY1)
% ylim([0 7])
% xlabel('sample')
% ylabel('grain size (mm)')
% title('Low-water line, 16 Oct 2020')
% 
% ax(2) = nexttile;
% bar([D50y2;D90y2]', 'grouped')
% legend('D$_{50}$', 'D$_{90}$')
% xticks(1:length(D50y2))
% xticklabels(labelsY2)
% ylim([0 7])
% xlabel('sample')
% ylabel('grain size (mm)')
% title('Runnel, 16 Oct 2020')
% 
% ax(3) = nexttile;
% bar([D50y3;D90y3]', 'grouped')
% legend('D$_{50}$', 'D$_{90}$')
% xticks(1:length(D50y3))
% xticklabels(labelsY3)
% ylim([0 7])
% xlabel('sample')
% ylabel('grain size (mm)')
% title('High-water line, 16 Oct 2020')
% 
% ax(4) = nexttile;
% bar([D50y0;D90y0]', 'grouped')
% legend('D$_{50}$', 'D$_{90}$')
% xticks(1:length(D50y0))
% xticklabels(labelsY0)
% ylim([0 7])
% xlabel('sample')
% ylabel('grain size (mm)')
% title('Lagoon and tidal flat, 16 Oct 2020')

%% Visualisation: median grain size overview
figure
ax1 = axes;
ax2 = axes;
scatter(ax1, data{5}.xRD, data{5}.yRD, [], data{5}.z, '.'); hold on
[~, c1] = contour(X, Y, Z, [AHW AHW], ':k', 'LineWidth', 1);
[~, c2] = contour(X, Y, Z, [MHW MHW], '-.k', 'LineWidth', 1);
[~, c3] = contour(X, Y, Z, [MLW MLW], '--k', 'LineWidth', 1);
legend(ax1, [c1 c2 c3], {['AHW  (', num2str(AHW), ' m)'],...
    ['MHW  (', num2str(MHW), ' m)'], ['MLW  (', num2str(MLW), ' m)']},...
    'Location', 'northeast')

scatter(ax2, sampleData3.xRD, sampleData3.yRD, 100, sampleData3.D50, 'filled', 'MarkerEdgeColor', 'k')
text(117100, 558200, '3 Dec 2020', 'FontSize', 16)

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
cb1.FontSize = 16;

cb2.Label.String = 'D$_{50}$ (mm)';
cb2.Label.Interpreter = 'latex';
cb2.TickLabelInterpreter = 'latex';
cb2.FontSize = 16;

xlabel([ax1 ax2], 'xRD (m)')
ylabel([ax1 ax2], 'yRD (m)')

caxis(ax1, [-5 5])
caxis(ax2, [0 2])
axis([ax1 ax2], [Xlim(1), Xlim(2), Ylim(1), Ylim(2)])
% xticks([ax1 ax2], 114000:1e3:118000)
% yticks([ax1 ax2], 558000:1e3:561000) 
axis([ax1 ax2], 'equal')
set([ax1 ax2], 'Color', [.8 .8 .8])
grid([ax1 ax2], 'on')
