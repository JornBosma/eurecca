%% Initialisation
close all
clear
clc

eurecca_init

% processed topo files
load('zSounding.mat')

% processed sedi samples
load('GS_20201202.mat')
load('GS_20211008-9.mat')

% gps-locations samples
load('GS_20201202_gps.mat')
load('GS_20211008_gps.mat')
load('GS_20211009_gps.mat')

GS_20211008_9_gps = [GS_20211009_gps; GS_20211008_gps]; % merge tables
GS_20211008_9_gps(21:30, :) = GS_20211008_9_gps([23:26 21 27:30 22], :); % swap rows

% % tidal datums (slotgemiddelden 2011): HHNK & Witteveen+Bos, 2016
% DHW = 2.95; % decennial (1/10y) high water level [m+NAP]
% BHW = 2.4; % biennial (1/2y) high water level [m+NAP]
% AHW = 2.25; % annual (1/1y) high water level [m+NAP]
% MHW = 0.64; % mean high water level [m+NAP]
% MSL = 0.04; % mean sea level [m+NAP]
% MLW = -0.69; % mean low water level [m+NAP]
% LAT = -1.17; % lowest astronomical tide [m+NAP]

% other settings
fontsize = 20;

% axis limits and ticks
xl = [1.148e+05 1.1805e+05]; % PHZD
yl = [5.5775e+05 5.6065e+05];
xt = 114000:1e3:118000;
yt = 558000:1e3:561000;
% xl = [1.1695e+05 1.1765e+05]; % spit hook zoom-in
% yl = [5.5976e+05 5.6040e+05];

%% Organisation
% statistics corresponding to index number:
% 31 = D10 (mm)
% 32 = D50 (mm)
% 33 = D90 (mm)
% 34 = D90/D10 (mm/mm)
idx = 32;

stat_20201202 = GS_20201202(idx, 3:end);
stat_20201202 = removevars(stat_20201202, "T01S04");
stat_20201202 = table2array(stat_20201202);
stat_20201202 = reshape(stat_20201202, 3, []);

GS_20201202_gps(4, :) = [];

ref_20201202 = 1:3:height(GS_20201202_gps);

stat_20211008_9 = GS_20211008_9(idx, 3:end);
stat_20211008_9 = table2array(stat_20211008_9);
stat_20211008_9 = reshape(stat_20211008_9, 5, []);

ref_20211008_9 = 1:5:height(GS_20211008_9_gps);

%% Visualisation: 2 Dec 2020
figure2
ax1 = axes;
ax2 = axes;
scatter(ax1, z_2020_Q4.xRD, z_2020_Q4.yRD, [], z_2020_Q4.z, '.')
scatter(ax2, GS_20201202_gps.xRD(ref_20201202), GS_20201202_gps.yRD(ref_20201202), 300, mean(stat_20201202)/1000, 'filled')
% text(GS_20201202_gps.xRD(index)+100, GS_20201202_gps.yRD(index)-100, {'10', '9', '8',...
%     '7', '6', '5', '4', '3', '2', '1'}, 'FontSize', 20)

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

xlabel([ax1 ax2], 'easting - RD (m)')
ylabel([ax1 ax2], 'northing - RD (m)')

caxis(ax1, [-5 5])
if idx == 32
    caxis(ax2, [0.3, 1.0]) % D50 (mm)
elseif idx == 31
    caxis(ax2, [0.2, 0.4]) % D10 (mm)
elseif idx == 33
    caxis(ax2, [1.0, 6.0]) % D90 (mm)
else
    caxis(ax2, [3.0, 26.0]) % D90/D10 (mm/mm)
end

axis([ax1 ax2], [xl(1), xl(2), yl(1), yl(2)]) 
axis([ax1 ax2], 'equal')
axis([ax1 ax2], 'off')
set([ax1 ax2], 'Color', [.8 .8 .8])

% camroll(ax1, -55)
% camroll(ax2, -55)

%% Visualisation: 2 Dec 2020 (no elevation map)
% figure2
% ax = axes;
% scatter(ax, GS_20201202_gps.xRD(ref_20201202), GS_20201202_gps.yRD(ref_20201202), 300, mean(stat_20201202)/1000, 'filled')
% 
% ax.Visible = 'off';
% ax.XTick = [];
% ax.YTick = [];
% 
% colormap(ax, flipud(hot))
% 
% set(ax, 'Position', [.17 .11 .685 .815]);
% cb = colorbar(ax, 'Position', [.3 .6 .02 .2]);
% 
% cb.Label.String = 'D$_{50}$ (mm)';
% cb.Label.Interpreter = 'latex';
% cb.TickLabelInterpreter = 'latex';
% cb.FontSize = fontsize;
% 
% xlabel(ax, 'easting - RD (m)')
% ylabel(ax, 'northing - RD (m)')
% 
% if idx == 32
%     caxis(ax, [0.3, 1.0]) % D50 (mm)
% elseif idx == 31
%     caxis(ax, [0.2, 0.4]) % D10 (mm)
% else
%     caxis(ax, [1.0, 6.0]) % D90 (mm)
% end
% 
% axis(ax, [xl(1), xl(2), yl(1), yl(2)]) 
% axis(ax, 'equal')
% axis(ax, 'off')
% set(ax, 'Color', [.8 .8 .8])

%% Visualisation: 2 Dec 2020 (line plot)
figure2
plot(stat_20201202(1, :), 'LineWidth', 1); hold on
plot(stat_20201202(2, :), 'LineWidth', 1);
plot(stat_20201202(3, :), 'LineWidth', 1);
errorbar(mean(stat_20201202), std(stat_20201202), 'k', 'LineWidth', 3)
ylabel('D50 ($\mu$m)', 'FontSize', fontsize)
xlabel('longshore location', 'FontSize', fontsize)
xticks([1, 10])
xticklabels(['SW'; 'NE'])
legend('~1.6 m +NAP', '~1.0 m +NAP', '~0.2 m +NAP',...
    'cross-shore mean', 'Location', 'northeast', 'FontSize', fontsize)
axis tight

%% Visualisation: 8 Oct 2021
figure2
ax1 = axes;
ax2 = axes;
scatter(ax1, z_2021_11.xRD, z_2021_11.yRD, [], z_2021_11.z, '.')
scatter(ax2, GS_20211008_9_gps.xRD(ref_20211008_9), GS_20211008_9_gps.yRD(ref_20211008_9), 300, mean(stat_20211008_9)/1000, 'filled')

% text(GS_20211008_9_gps.xRD(indexA)+100, GS_20211008_9_gps.yRD(indexA)-100, {'10', '9', '8',...
%     '7', '6', '5', '4', '3', '2', '1'}, 'FontSize', 30)
% text(GS_20211008_9_gps.xRD(indexA)+100, GS_20211008_9_gps.yRD(indexA)-100, int2str(1:10), 'FontSize', 30)

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

xlabel([ax1 ax2], 'easting - RD (m)')
ylabel([ax1 ax2], 'northing - RD (m)')

caxis(ax1, [-5 5])
if idx == 32
    caxis(ax2, [0.3, 1.0]) % D50 (mm)
elseif idx == 31
    caxis(ax2, [0.2, 0.4]) % D10 (mm)
else
    caxis(ax2, [1.0, 6.0]) % D90 (mm)
end

axis([ax1 ax2], [xl(1), xl(2), yl(1), yl(2)]) 
axis([ax1 ax2], 'equal')
axis([ax1 ax2], 'off')
set([ax1 ax2], 'Color', [.8 .8 .8])

% camroll(ax1, -55)
% camroll(ax2, -55)

%% Visualisation: 2 Dec 2020 (no elevation map)
% figure2
% ax = axes;
% scatter(ax, GS_20211008_9_gps.xRD(ref_20211008_9), GS_20211008_9_gps.yRD(ref_20211008_9), 300, mean(stat_20211008_9)/1000, 'filled')
% 
% ax.Visible = 'off';
% ax.XTick = [];
% ax.YTick = [];
% 
% colormap(ax, flipud(hot))
% 
% set(ax, 'Position', [.17 .11 .685 .815]);
% cb = colorbar(ax, 'Position', [.3 .6 .02 .2]);
% 
% cb.Label.String = 'D$_{50}$ (mm)';
% cb.Label.Interpreter = 'latex';
% cb.TickLabelInterpreter = 'latex';
% cb.FontSize = fontsize;
% 
% xlabel(ax, 'easting - RD (m)')
% ylabel(ax, 'northing - RD (m)')
% 
% if idx == 32
%     caxis(ax, [0.3, 1.0]) % D50 (mm)
% elseif idx == 31
%     caxis(ax, [0.2, 0.4]) % D10 (mm)
% else
%     caxis(ax, [1.0, 6.0]) % D90 (mm)
% end
% 
% axis(ax, [xl(1), xl(2), yl(1), yl(2)]) 
% axis(ax, 'equal')
% axis(ax, 'off')
% set(ax, 'Color', [.8 .8 .8])

%% Visualisation: 8 Oct 2021 (line plot)
figure2
plot(stat_20211008_9(1, :), 'LineWidth', 1); hold on
plot(stat_20211008_9(2, :), 'LineWidth', 1)
plot(stat_20211008_9(3, :), 'LineWidth', 1)
plot(stat_20211008_9(4, :), 'LineWidth', 1)
plot(stat_20211008_9(5, :), 'LineWidth', 1)
errorbar(mean(stat_20211008_9), std(stat_20211008_9), 'k', 'LineWidth', 3)
ylabel('D50 ($\mu$m)', 'FontSize', fontsize)
xlabel('longshore location', 'FontSize', fontsize)
xticks([1, 10])
xticklabels(['NE'; 'SW'])
set(gca, 'XDir','reverse')
legend('1.00 m +NAP', '0.75 m +NAP', '0.50 m +NAP', '0.25 m +NAP', '0.00 m +NAP',...
    'cross-shore mean', 'Location', 'northeast', 'FontSize', fontsize)
axis tight
