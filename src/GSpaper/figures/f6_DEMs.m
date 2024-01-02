%% Initialisation
close all
clear
clc

[~, fontsize, ~, PHZ, SEDMEX] = eurecca_init;
% fontsize = 22; % ultra-wide screen

% Load cross-shore tracks
dataPathTracks = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor'...
    filesep 'topobathy' filesep 'transects' filesep 'PHZD.nc'];

trackInfo = ncinfo(dataPathTracks);

% Assign track variables
x = ncread(dataPathTracks, 'x'); % xRD [m]
y = ncread(dataPathTracks, 'y'); % yRD [m]
z = ncread(dataPathTracks, 'z'); % bed level [NAP+m]
d = ncread(dataPathTracks, 'd'); % cross-shore distance [m]
ID = ncread(dataPathTracks, 'ID'); % profile ID (days since 2020-10-16 00:00:00)
transect = ncread(dataPathTracks, 'transect'); % tansect number (Python counting)

trackNames = {'L_1', 'L_2', 'L_3', 'L_{3.5}', 'L_4', 'L_5', 'L_6'};
trackNumbers = {'1', '2', '3', '3.5', '4', '5', '6'};

trackStart = [2000, 1600, 1600, 1600, 1700, 2000, 2000];
trackEnd = [3000, 2750, 2800, 2700, 2700, 3000, 3000];
trackCentre = (trackEnd+trackStart)/2;

% Load DEMs
A = load('PHZ_2019_Q2','-mat'); % first survey
% B = load('PHZ_2020_Q3','-mat');
B = load('PHZ_2022_Q2','-mat');

% Load polygons
pgns = getPgons;

%% Computations #1
mask = inpolygon(A.DEM.X, A.DEM.Y, pgns.site(:, 1), pgns.site(:, 2));

A.DEM.X(~mask) = NaN;
A.DEM.Y(~mask) = NaN;
A.DEM.Z(~mask) = NaN;
B.DEM.X(~mask) = NaN;
B.DEM.Y(~mask) = NaN;
B.DEM.Z(~mask) = NaN;

% calculate DEM of Difference (DoD)
BminA = B.DEM.Z-A.DEM.Z;

mask = inpolygon(A.DEM.X, A.DEM.Y, pgns.harbour(:, 1), pgns.harbour(:, 2));
BminA(mask) = NaN;

C = A;
C.DEM.X(mask) = NaN;
C.DEM.Y(mask) = NaN;

D = B;
D.DEM.X(mask) = NaN;
D.DEM.Y(mask) = NaN;


%% Visualisation: initial DEM
f1 = figureRH;
surf(A.DEM.X, A.DEM.Y, A.DEM.Z); hold on

shading flat
ax = gca; ax.SortMethod = 'childorder';
axis off equal
view(48.1, 90)

cb = colorbar;
cb.Location = 'northoutside';
set(cb, 'position', [.24 .64 .46 .015])
cb.Label.String = 'bed level (NAP+m)';
cb.FontSize = fontsize;
clim([-8, 8])
% colormap(crameri('bukavu', 'pivot',0))
% cmocean('delta')
colormap(sandyToMarineBlueColormap(256, true));

% black background
ax.SortMethod = 'childorder';
patch(ax, pgns.site(:,1), pgns.site(:,2), 'k', 'EdgeColor','k', 'LineWidth',3)
h = get(ax,'Children');
set(ax,'Children',[h(2) h(1)])

% North arrow
Narrow(40)

% MHW & MLW contours
contour(C.DEM.X, C.DEM.Y, C.DEM.Z, [PHZ.MLW, PHZ.MHW], '-k', 'ShowText','off', 'LineWidth',2)


%% Visualisation: second DEM
f2 = figureRH;
surf(B.DEM.X, B.DEM.Y, B.DEM.Z); hold on

shading flat
ax = gca; ax.SortMethod = 'childorder';
axis off equal
view(48.1, 90)

cb = colorbar;
cb.Location = 'northoutside';
set(cb, 'position', [.24 .64 .46 .015])
cb.Label.String = 'bed level (NAP+m)';
cb.FontSize = fontsize;
clim([-8, 8])
% colormap(crameri('bukavu', 'pivot',0))
% cmocean('delta')
colormap(sandyToMarineBlueColormap(256, true));

% black background
ax.SortMethod = 'childorder';
patch(ax, pgns.site(:,1), pgns.site(:,2), 'k', 'EdgeColor','k', 'LineWidth',3)
h = get(ax,'Children');
set(ax,'Children',[h(2) h(1)])

% North arrow
Narrow(40)

% MHW & MLW contours
contour(D.DEM.X, D.DEM.Y, D.DEM.Z, [PHZ.MLW, PHZ.MHW], '-k', 'ShowText','off', 'LineWidth',2)


%% Visualisation: DoD
f3 = figureRH;
ax = axes;
surf(ax, C.DEM.X, C.DEM.Y, BminA); hold on

shading(ax,'flat')
axis off equal
view(48.1, 90)

cb = colorbar;
cb.Location = 'northoutside';
set(cb, 'position', [.24 .64 .46 .015])
cb.Label.String = 'bed-level change (m)';
cb.FontSize = 22;
clim([-2, 2])
colormap(crameri('bam', 'pivot',0))

% black background
ax.SortMethod = 'childorder';
patch(ax, pgns.site(:,1), pgns.site(:,2), 'k', 'EdgeColor','k', 'LineWidth',3)
h = get(ax,'Children');
set(ax,'Children',[h(2) h(1)])

% channel wall (rocks)
p = patch(ax, pgns.chanwall(:,1),pgns.chanwall(:,2), 'k', 'FaceAlpha',.3);
hatch(p, [45 10 1], 'k');
hatch(p, [15 10 1], 'k');

% % tracks
% for n = 1:7
%     line([x(trackStart(n),n) x(trackEnd(n),n)], [y(trackStart(n),n) y(trackEnd(n),n)], 'Color','k', 'LineStyle',':', 'LineWidth',3)
%     text(x(trackCentre(n),n)+80, y(trackCentre(n),n), trackNumbers{n}, 'FontSize',fontsize, 'Color','k')
% end

% North arrow
Narrow(40)

% MHW & MLW contours
contour(D.DEM.X, D.DEM.Y, D.DEM.Z, [PHZ.MLW, PHZ.MHW], '-k', 'ShowText','off', 'LineWidth',2)

