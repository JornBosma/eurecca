% Script that generates all figures of paper 1.

%% Initialisation
close all
clear
clc

[xl, yl, ~, ~, fontsize] = eurecca_init;

dataPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'Data Descriptor'];
% addpath('/Users/jwb/Local_NoSync/OET/matlab'); oetsettings('quiet')

% colourblind-friendly colours
orange = [230/255, 159/255, 0];
blue = [86/255, 180/255, 233/255];
yellow = [240/255, 228/255, 66/255];
redpurp = [204/255, 121/255, 167/255];
bluegreen = [0, 158/255, 115/255];

%% Figure 0: study site
AHN1 = 'R5_09DN1.TIF';
AHN2 = 'R5_09DN2.TIF';

info1 = georasterinfo(AHN2);
info2 = georasterinfo(AHN2);

[A1, R1] = readgeoraster(AHN1, 'OutputType','double');
[A2, R2] = readgeoraster(AHN2, 'OutputType','double');

m1 = info1.MissingDataIndicator;
m2 = info2.MissingDataIndicator;

A1 = standardizeMissing(A1, m1);
A2 = standardizeMissing(A2, m2);

load zSounding.mat z_2021_Q1
survey = z_2021_Q1;

% load PHZ_2022_Q4.mat
% DEM.Z(DEM.Z<0) = NaN;

%% Visualisation
f0 = figure;
mapshow(A1, R1, 'DisplayType','surface', 'ZData',zeros(R1.RasterSize)); hold on
mapshow(A2, R2, 'DisplayType','surface', 'ZData',zeros(R2.RasterSize))
scatter(survey.xRD, survey.yRD, [], survey.z, '.'); hold off
% surf(DEM.X, DEM.Y, DEM.Z); hold off

c = colorbar;
c.Label.String = 'm +NAP';
c.Label.Interpreter = 'latex';
c.TickLabelInterpreter = 'latex';
c.FontSize = fontsize;
clim([-2, 10]);

crameri('fes', 'pivot',0)

view(48.5, 90)
xlim([xl(1) xl(2)])
ylim([yl(1) yl(2)])

xlabel('easting [RD] (m)')
ylabel('northing [RD] (m)')

set(gca, 'Color',[0 0.4470 0.7410], 'XColor','r', 'YColor','k')
set(gcf, 'Color','w')

%% Figure 1a: bed-level change from Summer 2019 - Summer 2022
A = load('PHZ_2019_Q3','-mat');
B = load('PHZ_2022_Q3','-mat');

[dQ, dz, dz_Beach, pgns] = getVolumeChange2(A, B);

L1C1 = [117421.461, 560053.687]; % vector
L2C5 = [117199.347, 559816.116]; % 3D-sonar
L3C1 = [116838.947, 559536.489]; % vector
L4C1 = [116103.892, 558946.574]; % 3D-sonar
L5C1 = [115670.000, 558603.700]; % vector
L6C1 = [115401.500, 558224.500]; % vector

LXCX = [L1C1; L2C5; L3C1; L4C1; L5C1; L6C1];
Tr_names = {'L1'; 'L2'; 'L3'; 'L4'; 'L5'; 'L6'};

%% Visualisation
f1a = figure;
surf(A.DEM.X, A.DEM.Y, dz); hold on
% dz_Beach(dz_Beach == 0) = NaN;
% surf(A.DEM.X, A.DEM.Y, dz_Beach); hold on

xlabel('easting [RD] (m)')
ylabel('northing [RD] (m)')
zlabel('z (m +NAP)')
shading flat

% (instruments) transect locations
scatter(LXCX(:,1), LXCX(:,2), 500, '|', 'k', 'LineWidth',2);
text(LXCX(:, 1)+20, LXCX(:, 2)-150, Tr_names, 'FontSize',fontsize/1.3)
ax = gca; ax.SortMethod = 'childorder';

% xlim([1.15e5 1.18e5])
% ylim([5.58e5 5.605e5])
axis off; axis vis3d
view(46, 90)

% colorbar
cb = colorbar;
cb.Location = 'northoutside';
set(cb, 'position', [.25 .62 .2 .01])
cb.TickLabelInterpreter = 'latex';
cb.Label.Interpreter = 'latex';
cb.Label.String = ['$<$ erosion (m) ', repmat('\ ', 1, 9), ' deposition (m) $>$'];
cb.FontSize = fontsize/1.3;
clim([-2, 2])
colormap(crameri('vik', 11, 'pivot', 0))

% polygons and volumes
patch(pgns.xv_N,pgns.yv_N,redpurp, 'FaceAlpha',.1, 'EdgeColor',redpurp, 'LineWidth',3)
% text(mean([pgns.xv_N(2) pgns.xv_N(3)])+30, mean([pgns.yv_N(2) pgns.yv_N(3)])-50,...
%     ['$\Delta$Q = ', mat2str(dQ.Net(1),2),' m$^3$'], 'FontSize',fontsize/1.3)
patch(pgns.xv_beach,pgns.yv_beach,yellow, 'FaceAlpha',.1, 'EdgeColor',yellow, 'LineWidth',3)
% text(mean([pgns.xv_beach(2) pgns.xv_beach(4)])+20, mean([pgns.yv_beach(2) pgns.yv_beach(4)])-20,...
%     ['$\Delta$Q = ', mat2str(dQ.Net(4),2),' m$^3$'], 'FontSize',fontsize/1.3)

% North arrow
ta = annotation('textarrow', [.781 .801], [.595 .615], 'String', 'N');
ta.FontSize = fontsize/1.3;
ta.Interpreter = 'latex';
ta.LineWidth = 6;
ta.HeadStyle = 'hypocycloid';
ta.HeadWidth = 30;
ta.HeadLength = 30;
an = annotation('ellipse', [.765 .575 .04 .05]);
an.LineWidth = 2;

%% Figure X: cross-shore profile evolution
file = [dataPath, '/TRANSECTS/field_visits_projected_netcdf/alleen_loop/track6.nc'];

track = ncinfo(file);
x = ncread(file, 'x'); % xRD [m]
y = ncread(file, 'y'); % yRD [m]
d = ncread(file, 'd'); % x-shore distance [m]
profiles = ncread(file, '__xarray_dataarray_variable__'); % depth [m]
ID = ncread(file, 'ID'); % profile ID (seconds since 2020-10-16 12:56:53)

date = datetime(ID, 'ConvertFrom', 'epochtime', 'Epoch', '2020-10-16 12:56:53');

% range = 7:26; % SEDMEX period
range = 1:length(ID);

%% Visualisation
f = figure;
tiledlayout(3,2)

nexttile % L1
plot(d, movmean(profiles(:, range), 6), 'LineWidth', 2)
legend(string(datetime(date(range), 'Format','dd-MM-yy')), 'Location', 'northoutside', 'NumColumns', 6, 'Box', 'on', 'FontSize', fontsize/1.2)
xlim([330, 390])
ylim([-2, 1.5])
xlabel('x-shore distance (m)')
ylabel('bed level (m +NAP)')
xticks(330:10:390)
xticklabels(0:10:60)
newcolors = colormap("winter");
colororder(flipud(newcolors(10:8:250, :)))
grid on

nexttile % L2
plot(d, movmean(profiles(:, range), 6), 'LineWidth', 2)
legend(string(datetime(date(range), 'Format','dd-MM-yy')), 'Location', 'northoutside', 'NumColumns', 6, 'Box', 'on', 'FontSize', fontsize/1.2)
xlim([190, 240])
ylim([-1.5, 2])
xlabel('x-shore distance (m)')
ylabel('bed level (m +NAP)')
xticks(190:10:250)
xticklabels(0:10:60)
newcolors = colormap("pink");
colororder(flipud(newcolors(10:10:230, :)))
grid on

nexttile % L3
plot(d, movmean(profiles(:, range), 6), 'LineWidth', 2)
yline(0, 'LineStyle','--', 'LineWidth',3)
legend([string(datetime(date(range), 'Format','dd-MM-yy')), ], 'Location', 'northoutside', 'NumColumns', 6, 'Box', 'on', 'FontSize', fontsize/1.2)
xlim([230, 290])
% ylim([-2, 1.5])
xlabel('x-shore distance (m)')
ylabel('bed level (m +NAP)')
xticks(230:10:290)
xticklabels(0:10:60)
newcolors = colormap("winter");
colororder(flipud(newcolors(10:8:250, :)))
grid on

nexttile % L4
plot(d, movmean(profiles(:, range), 6), 'LineWidth', 2)
yline(0, 'LineStyle','--', 'LineWidth',3)
legend([string(datetime(date(range), 'Format','dd-MM-yy')), ], 'Location', 'northoutside', 'NumColumns', 6, 'Box', 'on', 'FontSize', fontsize/1.2)
xlim([230, 290])
% ylim([-2, 1.5])
xlabel('x-shore distance (m)')
ylabel('bed level (m +NAP)')
xticks(230:10:290)
xticklabels(0:10:60)
newcolors = colormap("winter");
colororder(flipud(newcolors(10:8:250, :)))
grid on

nexttile % L5
plot(d, movmean(profiles(:, range), 6), 'LineWidth', 2)
yline(0, 'LineStyle','--', 'LineWidth',3)
legend([string(datetime(date(range), 'Format','dd-MM-yy')), ], 'Location', 'northoutside', 'NumColumns', 6, 'Box', 'on', 'FontSize', fontsize/1.2)
xlim([230, 290])
% ylim([-2, 1.5])
xlabel('x-shore distance (m)')
ylabel('bed level (m +NAP)')
xticks(230:10:290)
xticklabels(0:10:60)
newcolors = colormap("winter");
colororder(flipud(newcolors(10:8:250, :)))
grid on

nexttile % L6
plot(d, movmean(profiles(:, range), 6), 'LineWidth', 2)
yline(0, 'LineStyle','--', 'LineWidth',3)
legend([string(datetime(date(range), 'Format','dd-MM-yy')), ], 'Location', 'northoutside', 'NumColumns', 6, 'Box', 'on', 'FontSize', fontsize/1.2)
xlim([230, 290])
% ylim([-2, 1.5])
xlabel('x-shore distance (m)')
ylabel('bed level (m +NAP)')
xticks(230:10:290)
xticklabels(0:10:60)
newcolors = colormap("winter");
colororder(flipud(newcolors(10:8:250, :)))
grid on

%% Figure 1b: time-average longshore hydro conditions
adv_locs = {'L6C1', 'L5C1', 'L4C1', 'L3C1', 'L2C10', 'L1C1'};
ossi_locs = {'L6C2', 'L5C2', 'L4C3', 'L2C6', 'L1C2'};
locs = {'L6', 'L5', 'L4', 'L3', 'L2', 'L1'};

for n = 1:length(adv_locs)
    ADVpath{n} = [filesep 'ADV' filesep adv_locs{n} 'VEC' filesep 'tailored_loose' filesep];
    adv_info{n} = ncinfo([dataPath ADVpath{n} adv_locs{n} 'VEC.nc']);
    adv_t{n} = ncread([dataPath ADVpath{n} adv_locs{n} 'VEC.nc'], 't'); % minutes since 2021-09-10 19:00:00
    U{n} = ncread([dataPath ADVpath{n} adv_locs{n} 'VEC.nc'], 'umag');
    Hm0{n} = ncread([dataPath ADVpath{n} adv_locs{n} 'VEC.nc'], 'Hm0');
    adv_hab{n} = ncread([dataPath ADVpath{n} adv_locs{n} 'VEC.nc'], 'elev');
end

for n = 1:length(ossi_locs)
    OSSIpath{n} = [filesep 'OSSI' filesep ossi_locs{n} 'OSSI' filesep 'tailored' filesep];
    ossi_info{n} = ncinfo([dataPath OSSIpath{n} ossi_locs{n} 'OSSI.nc']);
    ossi_t{n} = ncread([dataPath OSSIpath{n} ossi_locs{n} 'OSSI.nc'], 't'); % minutes since 2021-09-10 19:00:00
    h{n} = ncread([dataPath OSSIpath{n} ossi_locs{n} 'OSSI.nc'], 'd');
    Hm01{n} = ncread([dataPath OSSIpath{n} ossi_locs{n} 'OSSI.nc'], 'Hm0');
end

tv{1} = datetime('2021-09-11 00:10:00') + minutes(adv_t{1}); % L6C1 (til 18-Oct-2021 10:00:00)
tv{2} = datetime('2021-09-11 00:00:00') + minutes(adv_t{2}); % L5C1 (til 18-Oct-2021 09:50:00)
tv{3} = datetime('2021-09-10 19:00:00') + minutes(adv_t{3}); % L4C1 (til 18-Oct-2021 04:50:00)
tv{4} = datetime('2021-09-11 00:00:00') + minutes(adv_t{4}); % L3C1 (til 18-Oct-2021 09:50:00)
tv{5} = datetime('2021-09-10 19:00:00') + minutes(adv_t{5}); % L2C4 (til 18-Oct-2021 04:50:00)
tv{6} = datetime('2021-09-11 00:00:00') + minutes(adv_t{6}); % L1C1 (til 18-Oct-2021 09:50:00)

tv{7} = datetime('2021-09-10 19:00:00') + minutes(ossi_t{1}); % L1C2 (til 18-Oct-2021 09:50:00)

t1 = max([min(tv{1}), min(tv{2}), min(tv{3}), min(tv{4}), min(tv{5}), min(tv{6})]);
t2 = min([max(tv{1}), max(tv{2}), max(tv{3}), max(tv{4}), max(tv{5}), max(tv{6})]);

for n = 1:length(tv)
    Dt{n} = find(tv{n} == t1) : find(tv{n} == t2);
end

hab_75 = [adv_hab{1}(Dt{1}), adv_hab{2}(Dt{2}), adv_hab{3}(Dt{3}), adv_hab{4}(Dt{4}), adv_hab{5}(Dt{5}), adv_hab{6}(Dt{6})];

U_75 = [U{1}(Dt{1}), U{2}(Dt{2}), U{3}(Dt{3}), U{4}(Dt{4}), U{5}(Dt{5}), U{6}(Dt{6})];
U_75(any(isnan(U_75), 2), :) = NaN; % only if all instruments have measured

Hm0_75 = [Hm0{1}(Dt{1}), Hm0{2}(Dt{2}), Hm0{3}(Dt{3}), Hm0{4}(Dt{4}), Hm0{5}(Dt{5}), Hm0{6}(Dt{6})];
Hm0_75(any(isnan(Hm0_75), 2), :) = NaN; % only if all instruments have measured

Hm01_75 = [Hm01{1}(Dt{1}), Hm01{2}(Dt{2}), Hm01{3}(Dt{3}), Hm01{4}(Dt{4}), Hm01{5}(Dt{5})];
Hm01_75(any(isnan(Hm0_75), 2), :) = NaN; % only if all instruments have measured

%% Visualisation
x = 1:6;
x2 = [x, fliplr(x)];

f1b = figure;
tiledlayout(1, 2, 'TileSpacing','compact')

ax1 = nexttile;
plot(mean(U_75, 'omitnan'), '-o', 'Color',blue, 'LineWidth',2, 'MarkerSize',15, 'MarkerFaceColor',blue); hold on
inBetween = [mean(U_75, 'omitnan')+std(U_75, 'omitnan'), fliplr(mean(U_75, 'omitnan')-std(U_75, 'omitnan'))];
fill(x2, inBetween, blue, 'FaceAlpha',.2, 'LineStyle','none');
legend('U$_{hor}$ (m s$^{-1}$)')

ax2 = nexttile;
plot(mean(Hm0_75, 'omitnan'), '-o', 'Color',orange, 'LineWidth',2, 'MarkerSize',15, 'MarkerFaceColor',orange); hold on
inBetween2 = [mean(Hm0_75, 'omitnan')+std(Hm0_75, 'omitnan'), fliplr(mean(Hm0_75, 'omitnan')-std(Hm0_75, 'omitnan'))];
fill(x2, inBetween2, orange, 'FaceAlpha',.2, 'LineStyle','none');
legend('H$_{m0}$ (m)')
set(gca,'yticklabel',{})

ylim([ax1, ax2], [0 .35])
xticks([ax1, ax2], x)
xticklabels([ax1, ax2], locs)
% xtickangle([ax1, ax2], 45)
axis([ax1, ax2], 'square')

%% Visualisation
f1b = figure;
tiledlayout(2, 1, 'TileSpacing','tight')

nexttile
boxchart(U_75, 'Notch','on'); hold on
plot(mean(U_75, 'omitnan'), '-o', 'LineWidth',2); hold off
set(gca,'xticklabel',{[]})
ylabel('U$_{hor}$ (m s$^{-1}$)')
ylim([0 .55])
% xticklabels(adv_locs)
legend('horizontal-velocity data', 'mean horizontal velocity')

nexttile
b = boxchart(Hm0_75, 'Notch','on'); hold on
b.JitterOutliers = 'on';
b.MarkerStyle = '.';
plot(mean(Hm0_75, 'omitnan'), '-o', 'LineWidth',2); hold off
% set(gca,'xticklabel',{[]})
ylabel('H$_{m0}$ (m)')
ylim([0 .7])
xticklabels(adv_locs)
legend('wave-height data', 'mean wave height')

%% Figure 1c: longshore GS distribution
[f1c, f1d] = getGSdata(fontsize);

%% Export figures
% exportgraphics(f0, '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/manuscript_observation/Figures/StudySite.png')
% exportgraphics(f1a, '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/manuscript_observation/Figures/dz.png')
% exportgraphics(f1b, '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/manuscript_observation/Figures/LongMeanHydro.png')
% exportgraphics(f1c, '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/manuscript_observation/Figures/LongMeanGS.png')
% exportgraphics(f1d, '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/manuscript_observation/Figures/LongGStime.png')

% exportgraphics(f1a, '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/Events/NCK/2023/poster/figures/dz.png')
% exportgraphics(f1b, '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/Events/NCK/2023/poster/figures/hydro.png')
% exportgraphics(f1d, '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/Events/NCK/2023/poster/figures/grains.png')
