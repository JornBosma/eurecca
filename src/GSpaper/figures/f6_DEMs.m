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


%% Locations
L2C1 = [117158, 559855];  % L2C1KELLER
L2C2 = [117193, 559822];  % L2C2VEC
L2C4 = [117197, 559818];  % L2C4VEC
L2C10 = [117235, 559781]; % L2C10VEC

L1C1 = [117421,	560054];  % L1C1VEC
L2C5 = [117198, 559815];  % L2C5SONTEK1
L3C1 = [116839, 559536];  % L3C1VEC
L4C1 = [116103,	558945];  % L4C1VEC
L5C1 = [115670,	558604];  % L5C1VEC
L6C1 = [115402,	558225];  % L6C1VEC

L1C2 = [117445, 560045];  % L1C2OSSI
L2C9 = [117222, 559793];  % L2C9OSSI
L4C3 = [116125, 558917];  % L4C3OSSI
L5C2 = [115716, 558560];  % L5C2OSSI
L6C2 = [115470, 558176];  % L6C2OSSI

OSSI = [L6C2; L5C2; L4C3; L2C9; L1C2];
OSSI_names = {"L6", "L5", "L4", "L2", "L1"};


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
cb.FontSize = 26;
clim([-8, 8])
% colormap(crameri('bukavu', 'pivot',0))
% cmocean('delta')
colormap(sandyToMarineBlueColormap(256, true));

% Black background
ax.SortMethod = 'childorder';
patch(ax, pgns.site(:,1), pgns.site(:,2), 'k', 'EdgeColor','k', 'LineWidth',3)
h = get(ax,'Children');
set(ax,'Children',[h(2) h(1)])

% North arrow
Narrow(40)

% MHW & MLW contours
contour(C.DEM.X, C.DEM.Y, C.DEM.Z, [PHZ.MeanLW, PHZ.MeanHW], '-k', 'ShowText','off', 'LineWidth',2)

% Add relief shadow
light
% light("Style","local","Position",[116284 559202 100]);

% Instrument locations
scatter(OSSI(:,1), OSSI(:,2), 150, 'filled', 'MarkerEdgeColor','k', 'MarkerFaceColor','r')
text(OSSI([1:2 5],1)+40, OSSI([1:2 5],2)+20, OSSI_names([1:2 5]), 'FontSize',fontsize*.8)
text(OSSI(3:4,1)+60, OSSI(3:4,2)-30, OSSI_names(3:4), 'FontSize',fontsize*.8)

scatter(L3C1(1), L3C1(2), 150, 'filled', 'MarkerEdgeColor','k', 'MarkerFaceColor','m')
text(L3C1(1)+60, L3C1(2)-80, 'L3', 'FontSize',fontsize*.8)


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
cb.FontSize = 26;
clim([-8, 8])
% colormap(crameri('bukavu', 'pivot',0))
% cmocean('delta')
colormap(sandyToMarineBlueColormap(256, true));

% Black background
ax.SortMethod = 'childorder';
patch(ax, pgns.site(:,1), pgns.site(:,2), 'k', 'EdgeColor','k', 'LineWidth',3)
h = get(ax,'Children');
set(ax,'Children',[h(2) h(1)])

% North arrow
Narrow(40)

% MHW & MLW contours
contour(D.DEM.X, D.DEM.Y, D.DEM.Z, [PHZ.MeanLW, PHZ.MeanHW], '-k', 'ShowText','off', 'LineWidth',2)

% Add relief shadow
light


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
cb.FontSize = 26;
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
contour(D.DEM.X, D.DEM.Y, D.DEM.Z, [PHZ.MeanLW, PHZ.MeanHW], '-k', 'ShowText','off', 'LineWidth',2)

