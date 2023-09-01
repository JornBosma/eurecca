%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize, cbf, ~] = eurecca_init;

% load cross-shore tracks
dataPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor'...
    filesep 'topobathy' filesep 'transects' filesep 'PHZD.nc'];

trackInfo = ncinfo(dataPath);

% assign variables
x = ncread(dataPath, 'x'); % xRD [m]
y = ncread(dataPath, 'y'); % yRD [m]
z = ncread(dataPath, 'z'); % bed level [m+NAP]
d = ncread(dataPath, 'd'); % cross-shore distance [m]
ID = ncread(dataPath, 'ID'); % profile ID (days since 2020-10-16 00:00:00)
transect = ncread(dataPath, 'transect'); % tansect number (Python counting)

trackNames = {'L_1', 'L_2', 'L_3', 'L_{3.5}', 'L_4', 'L_5', 'L_6'};
trackNumbers = {'1', '2', '3', '3.5', '4', '5', '6'};

trackStart = [2000, 1600, 1600, 1600, 1700, 2000, 2000];
trackEnd = [3000, 2750, 2800, 2700, 2700, 3000, 3000];
trackCentre = (trackEnd+trackStart)/2;

% timing
startDate = datetime('2020-10-16 00:00:00');
surveyDates = startDate + days(ID);

% load DEMs
A = load('PHZ_2019_Q0','-mat'); % first survey
% B = load('PHZ_2020_Q3','-mat');
B = load('PHZ_2022_Q4','-mat');

% load polygons
pgns = getPolygons;

%% Computations
mask = inpolygon(A.DEM.X, A.DEM.Y, pgns.scope(:, 1), pgns.scope(:, 2));

A.DEM.X(~mask) = NaN;
A.DEM.Y(~mask) = NaN;
A.DEM.Z(~mask) = NaN;
B.DEM.X(~mask) = NaN;
B.DEM.Y(~mask) = NaN;
B.DEM.Z(~mask) = NaN;

% calculate DEM of Difference (DoD)
BminA = B.DEM.Z-A.DEM.Z;

%% Visualisation: initial DEM
f1a = figure;
surf(A.DEM.X, A.DEM.Y, A.DEM.Z); hold on

shading flat
ax = gca; ax.SortMethod = 'childorder';
axis off; axis vis3d
view(46, 90)

% colorbar
cb = colorbar;
cb.Location = 'northoutside';
set(cb, 'position', [.25 .62 .2 .01])
cb.TickLabelInterpreter = 'latex';
cb.Label.Interpreter = 'latex';
cb.Label.String = 'bed level (m+NAP)';
cb.FontSize = fontsize/1.3;
clim([-8, 8])
colormap(crameri('bukavu', 'pivot',0))

% North arrow
% Narrow(fontsize)

%% Visualisation: second DEM
f1b = figure;
surf(B.DEM.X, B.DEM.Y, B.DEM.Z); hold on

shading flat
ax = gca; ax.SortMethod = 'childorder';
axis off; axis vis3d
view(46, 90)

% colorbar
cb = colorbar;
cb.Location = 'northoutside';
set(cb, 'position', [.25 .62 .2 .01])
cb.TickLabelInterpreter = 'latex';
cb.Label.Interpreter = 'latex';
cb.Label.String = 'bed level (m+NAP)';
cb.FontSize = fontsize/1.3;
clim([-8, 8])
colormap(crameri('bukavu', 'pivot',0))

% North arrow
% Narrow(fontsize)

%% Visualisation: DoD
f2 = figure;
ax = axes;
surf(ax, A.DEM.X, A.DEM.Y, BminA); hold on

shading(ax,'flat')
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
colormap(crameri('vik', 'pivot',0))

% black background
ax.SortMethod = 'childorder';
patch(ax, pgns.scope(:,1), pgns.scope(:,2), 'k', 'EdgeColor','k', 'LineWidth',3)
h = get(ax,'Children');
set(ax,'Children',[h(2) h(1)])

% channel wall (rocks)
p = patch(ax, pgns.chanwall(:,1),pgns.chanwall(:,2), 'k');
hatch(p, [45 10 1], 'w');
hatch(p, [15 10 1], 'w');

% tracks
for n = 1:7
    line([x(trackStart(n),n) x(trackEnd(n),n)], [y(trackStart(n),n) y(trackEnd(n),n)], 'Color','red', 'LineStyle',':', 'LineWidth',3)
    text(x(trackCentre(n),n)+80, y(trackCentre(n),n), trackNumbers{n}, 'FontSize',fontsize/2, 'Color','r')
end

% North arrow
% Narrow(fontsize)
