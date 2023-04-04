%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize] = eurecca_init;

% colourblind-friendly colour palette
orange = [230/255, 159/255, 0];
blue = [86/255, 180/255, 233/255];
yellow = [240/255, 228/255, 66/255];
redpurp = [204/255, 121/255, 167/255];
bluegreen = [0, 158/255, 115/255];

newcolors = crameri('-vik');
colours = newcolors(1:round(length(newcolors)/5):length(newcolors), :);

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
f0 = figure;
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
