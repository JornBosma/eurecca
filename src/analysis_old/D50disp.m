%% Initialisation
close all
clear
clc

eurecca_init

% processed topo files
load('zSounding.mat')

% processed sedi files
load('sampleGPS.mat')
load('GS_20201016.mat')
load('GS_20201202.mat')
load('GS_20211008.mat')
load('GS_20211008-pos.mat')
% GS20211008pos = [GS20211008pos; ];

% index = 1;
% for i = [1:4:height(sampleData2)]
%     new(index,:) = repmat(sampleData2(i, :),5,1);
%     index = index+4;
% end

data = {z_2020_Q4, z_2021_11};
names = {'2020 Q4', '2021-11'};

% tidal datums (slotgemiddelden 2011): HHNK & Witteveen+Bos, 2016
DHW = 2.95; % decennial (1/10y) high water level [m+NAP]
BHW = 2.4; % biennial (1/2y) high water level [m+NAP]
AHW = 2.25; % annual (1/1y) high water level [m+NAP]
MHW = 0.64; % mean high water level [m+NAP]
MSL = 0.04; % mean sea level [m+NAP]
MLW = -0.69; % mean low water level [m+NAP]
LAT = -1.17; % lowest astronomical tide [m+NAP]

% other settings
fontsize = 30;

% axis limits and ticks
xl = [1.148e+05 1.1805e+05]; % PHZD
yl = [5.5775e+05 5.6065e+05];
xt = 114000:1e3:118000;
yt = 558000:1e3:561000;
% xl = [1.1695e+05 1.1765e+05]; % spit hook zoom-in
% yl = [5.5976e+05 5.6040e+05];

%% Visualisation: topographic map
figure2('Name', 'Elevation maps')
tiledlayout('flow', 'TileSpacing', 'Compact');
ax = nexttile;
scatter(data{2}.xRD, data{2}.yRD, [], data{2}.z, '.')
c = colorbar;
c.Position = [.7 .45 .02 .2];
c.Label.String = 'm +NAP';
c.Label.Interpreter = 'latex';
c.TickLabelInterpreter = 'latex';
caxis([-3 5]);
colormap('gray')
axis equal
axis off
camroll(-52.5)
linkaxes(ax)

%% Visualisation: 16 Sept 2020
figure2
ax1 = axes;
ax2 = axes;
scatter(ax1, data{1}.xRD, data{1}.yRD, [], data{1}.z, '.')
scatter(ax2, sampleData1.xRD, sampleData1.yRD, 150, GS20201016{13, 3:end}./1000, 'filled')

linkaxes([ax1, ax2])

ax2.Visible = 'off';
ax2.XTick = [];
ax2.YTick = [];

% colormap(ax1, brewermap([], '*Greys'))
% colormap(ax2, brewermap([], 'YlOrRd'))
colormap(ax1, gray)
colormap(ax2, flipud(hot))

set([ax1, ax2], 'Position', [.17 .11 .685 .815]);
% cb1 = colorbar(ax1, 'Position', [.06 .11 .0275 .815]);
% cb2 = colorbar(ax2, 'Position', [.88 .11 .0275 .815]);
cb1 = colorbar(ax1, 'Position', [.27 .62 .02 .2]);
cb2 = colorbar(ax2, 'Position', [.37 .62 .02 .2]);

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
axis([ax1 ax2], [xl(1), xl(2), yl(1), yl(2)]) 
axis([ax1 ax2], 'equal')
axis([ax1 ax2], 'off')
set([ax1 ax2], 'Color', [.8 .8 .8])

% camroll(ax1, -55)
% camroll(ax2, -55)

%% Visualisation: 2 Dec 2020
figure2
ax1 = axes;
ax2 = axes;
scatter(ax1, data{1}.xRD, data{1}.yRD, [], data{1}.z, '.')
scatter(ax2, sampleData2.xRD, sampleData2.yRD, 150, GS20201202{13, 3:end}./1000, 'filled')

linkaxes([ax1, ax2])

ax2.Visible = 'off';
ax2.XTick = [];
ax2.YTick = [];

% colormap(ax1, brewermap([], '*Greys'))
% colormap(ax2, brewermap([], 'YlOrRd'))
colormap(ax1, gray)
colormap(ax2, flipud(hot))

set([ax1, ax2], 'Position', [.17 .11 .685 .815]);
% cb1 = colorbar(ax1, 'Position', [.06 .11 .0275 .815]);
% cb2 = colorbar(ax2, 'Position', [.88 .11 .0275 .815]);
% cb1 = colorbar(ax1, 'Position', [.2 .65 .02 .2]);
% cb2 = colorbar(ax2, 'Position', [.2 .35 .02 .2]);
% 
% cb1.Label.String = 'm +NAP';
% cb1.Label.Interpreter = 'latex';
% cb1.TickLabelInterpreter = 'latex';
% cb1.FontSize = fontsize;
% 
% cb2.Label.String = 'D$_{50}$ (mm)';
% cb2.Label.Interpreter = 'latex';
% cb2.TickLabelInterpreter = 'latex';
% cb2.FontSize = fontsize;

xlabel([ax1 ax2], 'xRD (m)')
ylabel([ax1 ax2], 'yRD (m)')

caxis(ax1, [-5 5])
caxis(ax2, [0 2])
axis([ax1 ax2], [xl(1), xl(2), yl(1), yl(2)]) 
axis([ax1 ax2], 'equal')
axis([ax1 ax2], 'off')
set([ax1 ax2], 'Color', [.8 .8 .8])

% camroll(ax1, -55)
% camroll(ax2, -55)

%% Visualisation: 8 Oct 2021
figure2
ax1 = axes;
ax2 = axes;
scatter(ax1, data{2}.xRD, data{2}.yRD, [], data{2}.z, '.')
scatter(ax2, GS20211008pos.xRD, GS20211008pos.yRD, 150, GS20211008{13, [3:22 27 32]}./1000, 'filled')

linkaxes([ax1, ax2])

ax2.Visible = 'off';
ax2.XTick = [];
ax2.YTick = [];

% colormap(ax1, brewermap([], '*Greys'))
% colormap(ax2, brewermap([], 'YlOrRd'))
colormap(ax1, gray)
colormap(ax2, flipud(hot))

set([ax1, ax2], 'Position', [.17 .11 .685 .815]);
% cb1 = colorbar(ax1, 'Position', [.06 .11 .0275 .815]);
% cb2 = colorbar(ax2, 'Position', [.88 .11 .0275 .815]);
% cb1 = colorbar(ax1, 'Position', [.2 .65 .02 .2]);
% cb2 = colorbar(ax2, 'Position', [.2 .35 .02 .2]);
% 
% cb1.Label.String = 'm +NAP';
% cb1.Label.Interpreter = 'latex';
% cb1.TickLabelInterpreter = 'latex';
% cb1.FontSize = fontsize;
% 
% cb2.Label.String = 'D$_{50}$ (mm)';
% cb2.Label.Interpreter = 'latex';
% cb2.TickLabelInterpreter = 'latex';
% cb2.FontSize = fontsize;

xlabel([ax1 ax2], 'xRD (m)')
ylabel([ax1 ax2], 'yRD (m)')

caxis(ax1, [-5 5])
caxis(ax2, [0 2])
axis([ax1 ax2], [xl(1), xl(2), yl(1), yl(2)]) 
axis([ax1 ax2], 'equal')
axis([ax1 ax2], 'off')
set([ax1 ax2], 'Color', [.8 .8 .8])

% camroll(ax1, -55)
% camroll(ax2, -55)
