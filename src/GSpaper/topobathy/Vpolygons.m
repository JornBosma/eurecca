%% Initialisation
close all
clear
clc

[basePath, fontsize, cbf, PHZ] = eurecca_init;

dataPath = [basePath 'results' filesep 'metrics' filesep];

% Load metrics for different zones
load([dataPath 'NAP_03_23_43_-16.mat']);

% Load survey info
load DEMsurveys.mat

% Obtain structure fieldnames
fieldNames = fieldnames(Volume);
segments = fieldnames(Polyshape);

% Load DEMs
PHZ1 = load('PHZ_2019_Q2','-mat');
PHZ2 = load('PHZ_2022_Q4','-mat');

% Load polygons
pgons = getPgons;

light_grey = [0.8, 0.8, 0.8];
grey = [0.6, 0.6, 0.6];


%% Process DEMs
PHZ1.DEM.Z(PHZ1.DEM.Z<0) = NaN;
mask_site = inpolygon(PHZ1.DEM.X, PHZ1.DEM.Y, pgons.site(:,1), pgons.site(:,2));
PHZ1.DEM.Z(~mask_site) = NaN;

mask_scope = inpolygon(PHZ2.DEM.X, PHZ2.DEM.Y, pgons.scope(:,1), pgons.scope(:,2));
PHZ2.DEM.Z(~mask_scope ) = NaN;

contourMatrix = contourc(PHZ2.DEM.X(1,:), PHZ2.DEM.Y(:,1), PHZ2.DEM.Z, [0 0]);
x = contourMatrix(1, 2:end);
y = contourMatrix(2, 2:end);
x(x<min(PHZ2.DEM.X(1,:))) = NaN;
y(y<min(PHZ2.DEM.Y(:,1))) = NaN;

clearvars PHZ2 mask_site mask_scope contourMatrix


%% Visualisation: volume wrt first survey (polygons)

% Dry beach
f2 = figureRH;
surf(PHZ1.DEM.X, PHZ1.DEM.Y, PHZ1.DEM.Z); hold on
colormap(repmat(light_grey, 64, 1))
shading flat

plot(x, y, '-k', 'LineWidth', 1)
ax = gca; ax.SortMethod = 'childorder';

patch(pgons.south_beach(:,1), pgons.south_beach(:,2), cbf.custom12(1,:), 'FaceAlpha',.2, 'EdgeColor',cbf.custom12(1,:), 'LineWidth',3)
patch(pgons.spit(:,1), pgons.spit(:,2), cbf.custom12(2,:), 'FaceAlpha',.2, 'EdgeColor',cbf.custom12(2,:), 'LineWidth',3)
patch(pgons.NW_beach(:,1), pgons.NW_beach(:,2), cbf.custom12(4,:), 'FaceAlpha',.2, 'EdgeColor',cbf.custom12(4,:), 'LineWidth',3)
hold off

text(1.147e5, 5.584e5, [mat2str(contourLevels(2)), ' \leq z < ', mat2str(contourLevels(3)), ' m'],...
    "Fontsize",fontsize*.8, "FontWeight","bold")

axis off equal
view(46, 90)

% Beachface
f3 = figureRH;
surf(PHZ1.DEM.X, PHZ1.DEM.Y, PHZ1.DEM.Z); hold on
colormap(repmat(light_grey, 64, 1))
shading flat

plot(x, y, '-k', 'LineWidth', 1)
ax = gca; ax.SortMethod = 'childorder';

patch(pgons.south_beach(:,1), pgons.south_beach(:,2), cbf.custom12(1,:), 'FaceAlpha',.2, 'EdgeColor',cbf.custom12(1,:), 'LineWidth',3)
patch(pgons.spit_sea(:,1), pgons.spit_sea(:,2), cbf.custom12(2,:), 'FaceAlpha',.2, 'EdgeColor',cbf.custom12(2,:), 'LineWidth',3)
patch(pgons.hook(:,1), pgons.hook(:,2), cbf.custom12(3,:), 'FaceAlpha',.2, 'EdgeColor',cbf.custom12(3,:), 'LineWidth',3)
patch(pgons.lagoon(:,1), pgons.lagoon(:,2), cbf.custom12(4,:), 'FaceAlpha',.2, 'EdgeColor',cbf.custom12(4,:), 'LineWidth',3)
patch(pgons.ceres(:,1), pgons.ceres(:,2), cbf.custom12(5,:), 'FaceAlpha',.2, 'EdgeColor',cbf.custom12(5,:), 'LineWidth',3)
hold off

% legend('2019 Q2', '2022 Q4', "Location","north", "Orientation","horizontal")
text(1.147e5, 5.584e5, [mat2str(contourLevels(1)), ' \leq z < ', mat2str(contourLevels(2)), ' m'],...
    "Fontsize",fontsize*.8, "FontWeight","bold")

axis off equal
view(46, 90)

% Platform
f4 = figureRH;
surf(PHZ1.DEM.X, PHZ1.DEM.Y, PHZ1.DEM.Z); hold on
colormap(repmat(light_grey, 64, 1))
shading flat

plot(x, y, '-k', 'LineWidth', 1)
ax = gca; ax.SortMethod = 'childorder';

patch(pgons.south_bathy(:,1), pgons.south_bathy(:,2), cbf.custom12(1,:), 'FaceAlpha',.2, 'EdgeColor',cbf.custom12(1,:), 'LineWidth',3)
patch(pgons.spit_bathy(:,1), pgons.spit_bathy(:,2), cbf.custom12(2,:), 'FaceAlpha',.2, 'EdgeColor',cbf.custom12(2,:), 'LineWidth',3)
patch(pgons.north_bathy(:,1), pgons.north_bathy(:,2), cbf.custom12(3,:), 'FaceAlpha',.2, 'EdgeColor',cbf.custom12(3,:), 'LineWidth',3)
patch(pgons.lagoon_bathy(:,1), pgons.lagoon_bathy(:,2), cbf.custom12(4,:), 'FaceAlpha',.2, 'EdgeColor',cbf.custom12(4,:), 'LineWidth',3)
hold off

text(1.147e5, 5.584e5, [mat2str(contourLevels(4)), ' \leq z < ', mat2str(contourLevels(1)), ' m'],...
    "Fontsize",fontsize*.8, "FontWeight","bold")

axis off equal
view(46, 90)

% clearvars ax light_grey PHZ1 TTarea TTperimeter TTvolume fieldNames
% dfieldNames 

