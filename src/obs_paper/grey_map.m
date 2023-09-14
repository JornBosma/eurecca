%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize, ~, ~] = eurecca_init;

% load DEM
A = load('PHZ_2019_Q0','-mat');
B = load('PHZ_2022_Q4','-mat');

% load polygons
pgns = getPolygons;

%% Computations
A.DEM.Z(A.DEM.Z<0) = NaN;
mask_scope = inpolygon(A.DEM.X, A.DEM.Y, pgns.scope(:,1), pgns.scope(:,2));
A.DEM.Z(~mask_scope) = NaN;

% B.DEM.Z(B.DEM.Z<0) = NaN;
mask_scope = inpolygon(B.DEM.X, B.DEM.Y, pgns.scope(:,1), pgns.scope(:,2));
B.DEM.Z(~mask_scope) = NaN;

% mask_north = inpolygon(B.DEM.X, B.DEM.Y, pgns.north(:,1), pgns.north(:,2));
% B.DEM.Z(~mask_north) = NaN;
mask_harbour = inpolygon(B.DEM.X, B.DEM.Y, pgns.harbour(:,1), pgns.harbour(:,2));
B.DEM.Z(mask_harbour) = NaN;

contourMatrix = contourc(B.DEM.X(1,:), B.DEM.Y(:,1), B.DEM.Z, [0 0]);
x = contourMatrix(1, 2:end);
y = contourMatrix(2, 2:end);
x(x<min(B.DEM.X(1,:))) = NaN;
y(y<min(B.DEM.Y(:,1))) = NaN;

%% Visualisation: grey map 2019 Q0 v. 2022 Q4
f0 = figure;
surf(A.DEM.X, A.DEM.Y, A.DEM.Z); hold on
% surf(B.DEM.X, B.DEM.Y, B.DEM.Z)
axis off; axis vis3d
view(46, 90)

light_gray = [0.8 0.8 0.8];
colormap(repmat(light_gray, 64, 1))
shading flat

plot3(x, y, zeros(size(x)), '-k', 'LineWidth', 1)

patch(pgns.north(:,1),pgns.north(:,2),'k', 'FaceAlpha',.1, 'EdgeColor','r', 'LineWidth',3)
patch(pgns.lagoon(:,1),pgns.lagoon(:,2),'k', 'FaceAlpha',.1, 'EdgeColor','g', 'LineWidth',3)
patch(pgns.hook(:,1),pgns.hook(:,2),'k', 'FaceAlpha',.1, 'EdgeColor','b', 'LineWidth',3)
patch(pgns.spit(:,1),pgns.spit(:,2),'k', 'FaceAlpha',.1, 'EdgeColor','c', 'LineWidth',3)
patch(pgns.south(:,1),pgns.south(:,2),'k', 'FaceAlpha',.1, 'EdgeColor','m', 'LineWidth',3)
patch(pgns.beach(:,1),pgns.beach(:,2),'k', 'FaceAlpha',.1, 'EdgeColor','y', 'LineWidth',3)
patch(pgns.scope(:,1),pgns.scope(:,2),'k', 'FaceAlpha',.1, 'EdgeColor','k', 'LineWidth',3)
patch(pgns.harbour(:,1),pgns.harbour(:,2),'k', 'FaceAlpha',.1, 'EdgeColor','w', 'LineWidth',3)
patch(pgns.chanwall(:,1),pgns.chanwall(:,2),'k', 'FaceAlpha',.1, 'EdgeColor','r', 'LineWidth',3)
ax = gca; ax.SortMethod = 'childorder';

legend('2019 Q0', '2022 Q4', 'north', 'lagoon', 'hook', 'spit', 'south', 'beach', 'scope', 'harbour', 'chanwall')
Narrow(fontsize)
