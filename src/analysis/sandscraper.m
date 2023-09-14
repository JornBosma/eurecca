%% Initialisation
close all
clear
clc

[~, fontsize, cbf, ~] = eurecca_init;

% sediment profiles
load GS_20211007.mat
load GS_20211015.mat

% bed profiles
load 01SEDMEX1007.mat
load 01SEDMEX1015.mat

% sandscraper locations
load 01SEDMEX1007-15.mat
SEDMEX100715zandschraperredacted(end,:) = [];

% sand scraper settings
depth_mm = [-2:-4:-14, -20:-6:-50]';

D50 = table2array(GS_20211007(32, 3:end));
% D50 = [D50(1:10); D50(11:20)]';
% D50 = [depth, D50];
LW07_mu = D50(1:10)';
MW07_mu = D50(11:20)';
HW07_mu = D50(21:end)';

D50 = table2array(GS_20211015(32, 3:end));
LW15_mu = D50(1:10)';
MW15_mu = D50(11:20)';
HW15_mu = D50(21:30)';
bar15_mu = D50(31:40)';
runnel15_mu = [D50(41:end), NaN, NaN]';

D50 = table(depth_mm, LW07_mu, MW07_mu, HW07_mu,...
    LW15_mu, MW15_mu, HW15_mu,...
    bar15_mu, runnel15_mu);

% tidal datums (slotgemiddelden 2011): HHNK & Witteveen+Bos, 2016
DHW = 2.95; % decennial (1/10y) high water level [m+NAP]
BHW = 2.4; % biennial (1/2y) high water level [m+NAP]
AHW = 2.25; % annual (1/1y) high water level [m+NAP]
MHW = 0.64; % mean high water level [m+NAP]
MSL = 0.04; % mean sea level [m+NAP]
MLW = -0.69; % mean low water level [m+NAP]
LAT = -1.17; % lowest astronomical tide [m+NAP]

%% Visualisation: pcolor
D50_new = [D50(1, :); D50];
D50_new{1, 1} = 0;
D50_new(1:end-1, 2:end) = D50_new(2:end, 2:end);
D50_new{:, 2:end} = D50_new{:, 2:end}/1000; % convert mu to mm

figure
tiledlayout(1,3)

ax(1) = nexttile;
pcolor([1, 2], [D50_new.depth_mm, D50_new.depth_mm], [D50_new.HW07_mu, D50_new.HW07_mu])
title('A')
ylabel('depth (mm)')

ax(2) = nexttile;
pcolor([1, 2], [D50_new.depth_mm, D50_new.depth_mm], [D50_new.MW07_mu, D50_new.MW07_mu])
title('B')

ax(3) = nexttile;
pcolor([1, 2], [D50_new.depth_mm, D50_new.depth_mm], [D50_new.LW07_mu, D50_new.LW07_mu])
title('C')
c = colorbar;
c.Label.String = 'D_{50} (mm)';
c.FontSize = fontsize;

set(ax(2:3), 'yTickLabel', [])
set(ax, 'YDir', 'normal')
set(ax,'xTick', [])
set(ax, 'Colormap', flipud(colormap(flipud(brewermap([], 'YlOrRd')))), 'CLim', [0.5 1.5])

%%
figure
tiledlayout(1,3)

ax(1) = nexttile;
pcolor([1, 2], [D50_new.depth_mm, D50_new.depth_mm], [D50_new.HW15_mu, D50_new.HW15_mu])
title('HW')
ylabel('depth (mm)')

ax(2) = nexttile;
pcolor([1, 2], [D50_new.depth_mm, D50_new.depth_mm], [D50_new.MW15_mu, D50_new.MW15_mu])
title('MW')

ax(3) = nexttile;
pcolor([1, 2], [D50_new.depth_mm, D50_new.depth_mm], [D50_new.LW15_mu, D50_new.LW15_mu])
title('LW')
c = colorbar;
c.Label.String = 'D_{50} (mm)';
c.FontSize = fontsize;

set(ax(2:3), 'yTickLabel', [])
set(ax, 'YDir', 'normal')
set(ax,'xTick', [])
set(ax, 'Colormap', flipud(colormap(flipud(brewermap([], 'YlOrRd')))), 'CLim', [0.5 1.5])

%%
figure
tiledlayout(1,2)

ax(1) = nexttile;
pcolor([1, 2], [D50_new.depth_mm, D50_new.depth_mm], [D50_new.bar15_mu, D50_new.bar15_mu])
title('bar')
ylabel('depth (mm)')

ax(2) = nexttile;
pcolor([1, 2], [D50_new.depth_mm, D50_new.depth_mm], [D50_new.runnel15_mu, D50_new.runnel15_mu])
title('runnel')
c = colorbar;
c.Label.String = 'D_{50} (mm)';
c.FontSize = fontsize;

set(ax(2), 'yTickLabel', [])
set(ax, 'YDir', 'normal')
set(ax,'xTick', [])
set(ax, 'Colormap', flipud(colormap(flipud(brewermap([], 'YlOrRd')))), 'CLim', [0.5 1.5])

% %% Visualisation: pcolor (separate 1)
% figure
% tiledlayout(1,3)
% 
% ax(1) = nexttile;
% pcolor([1, 2], [D50_new.depth_mm, D50_new.depth_mm], [D50_new.HW07_mu, D50_new.HW07_mu])
% % title('HW')
% ylabel('depth (mm)')
% c = colorbar;
% c.Label.String = 'D_{50} (mm)';
% 
% ax(2) = nexttile;
% pcolor([1, 2], [D50_new.depth_mm, D50_new.depth_mm], [D50_new.MW07_mu, D50_new.MW07_mu])
% % title('MW')
% 
% ax(3) = nexttile;
% pcolor([1, 2], [D50_new.depth_mm, D50_new.depth_mm], [D50_new.LW07_mu, D50_new.LW07_mu])
% % title('LW')
% 
% set(ax, 'YDir', 'normal')
% set(ax,'xTick', [])
% set(ax, 'Colormap', flipud(colormap(flipud(brewermap([], 'YlOrRd')))), 'CLim', [0.5 1.5])

%% Visualisation: bed profile
name = {'3', '2', '1'};

figure
plot3(SEDMEX1007profielenredacted.xRD, SEDMEX1007profielenredacted.yRD, smooth(SEDMEX1007profielenredacted.z, 10),...
    'LineWidth', 3); hold on
plot3(SEDMEX1015profielenredacted.xRD, SEDMEX1015profielenredacted.yRD, smooth(SEDMEX1015profielenredacted.z, 10),...
    'LineWidth', 3)
plot3(SEDMEX100715zandschraperredacted.xRD, SEDMEX100715zandschraperredacted.yRD, SEDMEX100715zandschraperredacted.z,...
    'd', 'LineWidth', 3)
text(SEDMEX100715zandschraperredacted.xRD+10, SEDMEX100715zandschraperredacted.yRD, SEDMEX100715zandschraperredacted.z, name, 'FontSize', 10)
legend('profile_07', 'profile_15', 'sample_loc')
grid on

%%
load Profiles_2D.mat L2_2D
% L2_2D(:,1,15) = L2_2D(:,1,15) - L2_2D(274,1,15);
% L2_2D(:,1,15) = L2_2D(:,1,19) - L2_2D(136,1,19);

figure
plot(L2_2D(:,1,15), smooth(L2_2D(:,2,15), 10), 'LineWidth', 3); hold on % 07/10
scatter([559836, 559823, 559814], [0.842, 0.179, -0.738], 200, 'red', 'LineWidth', 2)
text([559834, 559822, 559814], [0.95, 0.28, -0.59], {'A', 'B', 'C'}, 'FontSize', fontsize)
% plot(L2_2D(:,1,19), smooth(L2_2D(:,2,19), 10), 'LineWidth', 3)          % 15/10
% plot(SEDMEX100715zandschraperredacted.yRD, SEDMEX100715zandschraperredacted.z,...
%     'd', 'LineWidth', 3)
% text(SEDMEX100715zandschraperredacted.yRD-10, SEDMEX100715zandschraperredacted.z+0.2, name, 'FontSize', fontsize)
yline([MHW, MSL, MLW], '--', {'MHW', 'MSL', 'MLW'}, 'LineWidth', 2, 'FontSize', fontsize)
xticks(5.595e5+290:10:5.599e5)
xticklabels(0:10:80)
xlabel('cross-shore distance (m)')
ylabel('m +NAP')
xlim([5.595e5+290, 5.599e5-35])
set(gca, 'XDir','reverse')
