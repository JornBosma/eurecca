%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize, ~] = eurecca_init;

% colourblind-friendly colour palette
orange = [230/255, 159/255, 0];
blue = [86/255, 180/255, 233/255];
yellow = [240/255, 228/255, 66/255];
redpurp = [204/255, 121/255, 167/255];
bluegreen = [0, 158/255, 115/255];

newcolors = crameri('-vik');
colours = newcolors(1:round(length(newcolors)/5):length(newcolors), :);

% load DEM
A = load('PHZ_2020_Q3','-mat');

%% Polygon definitions
[pgns, inside] = getPolygon(A);

%% Visualisation
B = A;
B.DEM.Z(B.DEM.Z<0) = NaN;
% B.DEM.Z(B.DEM.Z>=0) = 1;

f0 = figure;
surf(B.DEM.X, B.DEM.Y, B.DEM.Z); hold on

shading flat
ax = gca; ax.SortMethod = 'childorder';
axis off; axis vis3d
view(46, 90)

light_gray = [0.8 0.8 0.8];
colormap(repmat(light_gray, 64, 1))

% polygons and volumes
% patch(pgns.xv_N,pgns.yv_N,redpurp, 'FaceAlpha',.1, 'EdgeColor',redpurp, 'LineWidth',3)
% patch(pgns.xv_spit,pgns.yv_spit,yellow, 'FaceAlpha',.1, 'EdgeColor',yellow, 'LineWidth',3)
% patch(pgns.xv_S,pgns.yv_S,blue, 'FaceAlpha',.1, 'EdgeColor',blue, 'LineWidth',3)

% sampling locations
LS_locx = [...
117491.990000000
117345.034000000
117113.948000000
116861.018000000
116646.619000000
116387.343000000
116152.658000000
115896.593000000
115606.006000000
115387.277000000];

LS_locy = [...
560006.329000000
559822.696000000
559621.521000000
559445.443000000
559250.492000000
559062.809000000
558871.963000000
558697.807000000
558402.354000000
558120.895000000];

text(LS_locx, LS_locy, num2cell(10:-1:1), 'FontSize', fontsize)

% North arrow
Narrow(fontsize)

%% Visualisation
C = A;
C.DEM.Z(C.DEM.Z<-.5) = NaN;
C.DEM.Z(C.DEM.Z>=-.5 & ~inside.in_beach & ~inside.in_N) = 2.8;
C.DEM.Z(~inside.in_scope) = NaN;

f1 = figure;
surf(C.DEM.X, C.DEM.Y, C.DEM.Z); hold on

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
clim([-.5, 3])
colormap(crameri('fes', 'pivot',-.5))

% polygons and volumes
patch(pgns.xv_N,pgns.yv_N,redpurp, 'FaceAlpha',.1, 'EdgeColor',redpurp, 'LineWidth',3)
patch(pgns.xv_spit,pgns.yv_spit,yellow, 'FaceAlpha',.1, 'EdgeColor',yellow, 'LineWidth',3)
patch(pgns.xv_S,pgns.yv_S,blue, 'FaceAlpha',.1, 'EdgeColor',blue, 'LineWidth',3)

% North arrow
Narrow(fontsize)

%% Visualisation
F = load('PHZ_2022_Q4.mat','-mat');
F.DEM.Z(~inside.in_scope) = NaN;

f2 = figure;
surf(F.DEM.X, F.DEM.Y, F.DEM.Z); hold on

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
Narrow(fontsize)
