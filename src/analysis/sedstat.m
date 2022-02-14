%% Initialisation
close all
clear
clc

global basePath
eurecca_init

load GS_20201016.mat
load GS_20201202.mat
load GS_20201203.mat
load GS_20210408.mat
load GS_20210606.mat
load GS_20211007.mat
load 01SEDMEX1007.mat
load 01SEDMEX1007ZS.mat

% sand scraper settings
depth_mm = [-2:-4:-14, -20:-6:-50]';

D50 = table2array(GS20211007(13, 3:end));
% D50 = [D50(1:10); D50(11:20)]';
% D50 = [depth, D50];
LW_mu = D50(1:10)';
MW_mu = D50(11:20)';
HW_mu = D50(21:end)';

D50 = table(depth_mm, LW_mu, MW_mu, HW_mu);

%% Visualisation: stackedplot
figure
s = stackedplot(D50);
s.LineProperties(1).PlotType = "stairs";
s.LineProperties(2).PlotType = "scatter";
s.LineProperties(3).PlotType = "scatter";
s.LineWidth = 2;

%% Visualisation: imagesc
figure
tiledlayout(1,3)

ax(1) = nexttile;
imagesc(1, D50.depth_mm, D50.LW_mu)
title('LW line')
ylabel('depth (mm)')

ax(2) = nexttile;
imagesc(1, D50.depth_mm, D50.MW_mu)
title('MW line')

ax(3) = nexttile;
imagesc(1, D50.depth_mm, D50.HW_mu)
title('HW line')
c = colorbar;
c.Label.Interpreter = 'latex';
c.TickLabelInterpreter = 'latex';
c.Label.String = 'D50 (mu)';

set(ax(2), 'yTickLabel', [])
set(ax, 'YDir', 'normal')
set(ax,'xTick', [])
set(ax, 'Colormap', flipud(autumn), 'CLim', [500 1500])

%% Visualisation: pcolor
D50_new = [D50(1, :); D50];
D50_new{1, 1} = 0;
D50_new(1:end-1, 2:end) = D50_new(2:end, 2:end);

figure
tiledlayout(1,3)

ax(1) = nexttile;
pcolor([1, 2], [D50_new.depth_mm, D50_new.depth_mm], [D50_new.HW_mu, D50_new.HW_mu])
title('HW')
ylabel('depth (mm)')

ax(2) = nexttile;
pcolor([1, 2], [D50_new.depth_mm, D50_new.depth_mm], [D50_new.MW_mu, D50_new.MW_mu])
title('MW')

ax(3) = nexttile;
pcolor([1, 2], [D50_new.depth_mm, D50_new.depth_mm], [D50_new.LW_mu, D50_new.LW_mu])
title('LW')
c = colorbar;
c.Label.Interpreter = 'latex';
c.TickLabelInterpreter = 'latex';
c.Label.String = 'D50 ($\mu$m)';

set(ax(2:3), 'yTickLabel', [])
set(ax, 'YDir', 'normal')
set(ax,'xTick', [])
set(ax, 'Colormap', flipud(colormap(flipud(brewermap([], 'YlOrRd')))), 'CLim', [500 1500])

%% Visualisation: bed profile
name = {'LW', 'MW', 'HW'};

figure
plot3(SEDMEX1007profielenredacted.xRD, SEDMEX1007profielenredacted.yRD, SEDMEX1007profielenredacted.z,...
    'LineWidth', 3); hold on
plot3(SEDMEX1007zandschraperredacted1.xRD, SEDMEX1007zandschraperredacted1.yRD, SEDMEX1007zandschraperredacted1.z,...
    'd', 'LineWidth', 3)
text(SEDMEX1007zandschraperredacted1.xRD+10, SEDMEX1007zandschraperredacted1.yRD, SEDMEX1007zandschraperredacted1.z, name, 'FontSize', 10)
grid on
