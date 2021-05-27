%% Initialisation
close all
clear
clc

startup

% Jan De Nul
% UTDrealisatie = importfile2("UTDrealisatie.pts", [1, Inf]); % load drone + bathy data
Q32020 = importfile2("Q32020.pts", [1, Inf]); % load drone data

% tidal datums (slotgemiddelden 2011): HHNK & Witteveen+Bos, 2016
DHW = 2.95; % decennial (1/10y) high water level [m+NAP]
BHW = 2.4; % biennial (1/2y) high water level [m+NAP]
AHW = 2.25; % annual (1/1y) high water level [m+NAP]
MHW = 0.64; % mean high water level [m+NAP]
MSL = 0.04; % mean sea level [m+NAP]
LAT = -1.17; % lowest astronomical tide [m+NAP]

% create grid
res = 2000; % resolution
x = linspace(114850, 118400, res);
y = linspace(557680, 560600, res);
[X, Y] = meshgrid(x, y);
Z = griddata(Q32020.xRD, Q32020.yRD, Q32020.z, X, Y);

%% Visualisation: topo-/bathymetric map
figure2('Name', 'Q32020')
scatter(Q32020.xRD, Q32020.yRD, [], Q32020.z, '.')
xlim([114800 118400])
ylim([557500 560800])
xticks(114000:1e3:118000)
yticks(557700:1e3:561000)
xlabel('xRD (m)')
ylabel('yRD (m)')
c = colorbar;
c.Label.String = 'm +NAP';
caxis([-5 5]);
colormap(brewermap([], '*RdBu'))
set(gca, 'Color', [.8 .8 .8])
grid on
axis equal

%% Visualisation: topo-/bathymetric map
figure2('Name', 'Q32020')
surf(X, Y, Z); hold on
[~, c1] = contour3(X, Y, Z, [AHW AHW], 'LineWidth', 1, 'LineColor', 'm');
[~, c2] = contour3(X, Y, Z, [MHW MHW], 'LineWidth', 1, 'LineColor', 'r');
[~, c3] = contour3(X, Y, Z, [MSL MSL], 'LineWidth', 1, 'LineColor', 'g');
[~, c4] = contour3(X, Y, Z, [LAT LAT], 'LineWidth', 1, 'LineColor', 'k');
legend([c1 c2 c3 c4], {['AHW  (', num2str(AHW), ' m)'],...
    ['MHW  (', num2str(MHW), ' m)'], ['MSL    (', num2str(MSL), ' m)'],...
    ['LAT    (', num2str(LAT), ' m)']})
xlabel('xRD (m)')
ylabel('yRD (m)')
zlabel('z (m)')
shading flat
camlight('headlight')
zlim([-12 8])
grid on
view(30, 55) % side view
% view(0, 90) % top view
% daspect([max(daspect)*[1 1] 1]) % x- and y-axis equal
