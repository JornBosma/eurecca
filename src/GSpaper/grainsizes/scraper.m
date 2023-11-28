%% Initialisation
close all
clear
clc

[~, fontsize, cbf, ~] = eurecca_init;

% sediment profiles
load GS_20211007.mat
load GS_20211015.mat

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

D50_new = [D50(1, :); D50];
D50_new{1, 1} = 0;
D50_new(1:end-1, 2:end) = D50_new(2:end, 2:end);
D50_new{:, 2:end} = D50_new{:, 2:end}/1000; % convert mu to mm

%% Visualisation: pcolor
f1 = figureRH;
tiledlayout(1,8, "TileSpacing","compact")

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

ax(4) = nexttile;
pcolor([1, 2], [D50_new.depth_mm, D50_new.depth_mm], [D50_new.HW15_mu, D50_new.HW15_mu])
title('D')

ax(5) = nexttile;
pcolor([1, 2], [D50_new.depth_mm, D50_new.depth_mm], [D50_new.MW15_mu, D50_new.MW15_mu])
title('E')

ax(6) = nexttile;
pcolor([1, 2], [D50_new.depth_mm, D50_new.depth_mm], [D50_new.LW15_mu, D50_new.LW15_mu])
title('F')

ax(7) = nexttile;
pcolor([1, 2], [D50_new.depth_mm, D50_new.depth_mm], [D50_new.bar15_mu, D50_new.bar15_mu])
title('bar')

ax(8) = nexttile;
pcolor([1, 2], [D50_new.depth_mm, D50_new.depth_mm], [D50_new.runnel15_mu, D50_new.runnel15_mu])
title('runnel')
ax(8).Color = cbf.skyblue;

c = colorbar;
c.Label.String = 'D_{50} (mm)';
c.FontSize = fontsize;
% c.Position = [0.08 0.01 0.5 0.06];

set(ax(2:8), 'yTickLabel', [])
set(ax, 'YDir', 'normal')
set(ax,'xTick', [])
% set(ax, 'Colormap', flipud(colormap(flipud(brewermap([], 'YlOrRd')))), 'CLim',[0.5 1.5])
set(ax, 'Colormap', crameri('lajolla', 'pivot',1.05), 'CLim',[0.5 1.5])
