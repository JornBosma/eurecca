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
A = load('PHZ_2022_Q4','-mat');

%% Polygon definitions
[pgns, inside] = get_polygon(A);

%% Visualisation
B = A;
B.DEM.Z(B.DEM.Z<0) = NaN;
B.DEM.Z(B.DEM.Z>=0) = 1;

f0 = figure;
surf(B.DEM.X, B.DEM.Y, B.DEM.Z); hold on

shading flat
ax = gca; ax.SortMethod = 'childorder';
axis off; axis vis3d
view(46, 90)

clim([-4, 4])
colormap(flipud('gray'))

% polygons and volumes
patch(pgns.xv_N,pgns.yv_N,redpurp, 'FaceAlpha',.1, 'EdgeColor',redpurp, 'LineWidth',3)
patch(pgns.xv_spit,pgns.yv_spit,yellow, 'FaceAlpha',.1, 'EdgeColor',yellow, 'LineWidth',3)
patch(pgns.xv_S,pgns.yv_S,blue, 'FaceAlpha',.1, 'EdgeColor',blue, 'LineWidth',3)

% North arrow
ta = annotation('textarrow', [.78 .80], [.595 .615], 'String', 'N');
ta.FontSize = fontsize/1.3;
ta.Interpreter = 'latex';
ta.LineWidth = 6;
ta.HeadStyle = 'hypocycloid';
ta.HeadWidth = 30;
ta.HeadLength = 30;

%% Visualisation
C = A;
C.DEM.Z(C.DEM.Z<0) = NaN;
C.DEM.Z(C.DEM.Z>=0 & ~inside.in_beach & ~inside.in_N) = 0;

f1 = figure;
surf(C.DEM.X, C.DEM.Y, C.DEM.Z); hold on

shading flat
ax = gca; ax.SortMethod = 'childorder';
axis off; axis vis3d
view(46, 90)

clim([-2, 2])
colormap(crameri('vik', 'pivot',0))

% polygons and volumes
patch(pgns.xv_N,pgns.yv_N,redpurp, 'FaceAlpha',.1, 'EdgeColor',redpurp, 'LineWidth',3)
patch(pgns.xv_spit,pgns.yv_spit,yellow, 'FaceAlpha',.1, 'EdgeColor',yellow, 'LineWidth',3)
patch(pgns.xv_S,pgns.yv_S,blue, 'FaceAlpha',.1, 'EdgeColor',blue, 'LineWidth',3)

% North arrow
Narrow(fontsize)

%% Export figures
% exportgraphics(f0, '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/GitHub/eurecca-wp2/results/figures/greymap_poly.png')
% exportgraphics(f1, '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/GitHub/eurecca-wp2/results/figures/z_map_poly.png')
