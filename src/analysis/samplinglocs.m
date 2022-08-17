%% Initialisation
close all
clear
clc

[xl, yl, xt, yt, fontsize] = eurecca_init;

% processed topo files
load('zSounding.mat')

% gps-locations samples
load('JDN_samples.mat') % Jan De Nul
load('GS_20201016_gps.mat') % area wide (gps iPhone)
load('GS_20201202_gps.mat') % area wide
load('GS_20201203_gps.mat') % L2 x-shore
% load('GS_20210408_gps.mat') % spit tip
% load('GS_20210606_gps.mat') % spit tip vertical (gps iPhone)
% load('GS_20210920_gps.mat') % L2 x-shore
load('GS_20210921_gps.mat') % longshore
load('GS_20210928_gps.mat') % longshore
% load('GS_20210928x_gps.mat') % L2 x-shore
% load('GS_202109301013_gps.mat') % regular L2C3 & L2C5
% load('GS_20211001_gps.mat') % L2 x-shore
% load('GS_20211007_gps.mat') % sandscraper
% load('GS_20211007x_gps.mat') % L2 x-shore
load('GS_20211008_gps.mat') % area wide (southern half)
load('GS_20211009_gps.mat') % area wide (northern half)
% load('GS_20211015_gps.mat') % sandscraper
% load('GS_20211015x_gps.mat') % L2 x-shore

%% Visualisation: proposed sampling locations
% a = [116542; 116557; 116572]; % reference x-coordinates
% b = [559337; 559320; 559303]; % reference y-coordinates
% shX = 120; % shift in x-direction
% shY = 95; % shift in y-direction
% xRD = [a-10*shX; a-8*shX; a-6*shX; a-4*shX; a-2*shX; a; a+2*shX; a+4*shX;...
%     a+6*shX; a+7.1*shX]; % x transects
% yRD = [b-11.4*shY; b-8.2*shY; b-6*shY; b-4*shY; b-2*shY; b; b+2*shY; b+4*shY;...
%     b+6*shY; b+8*shY]; % y transects
% xRD_a = [115350; 117662; 117900; 117200; 116500]; % x additional
% yRD_a = [558050; 560161.5; 560260; 560150; 559620]; % y additional
% xRD_c = [115777; 116497; 117217]; % x cores
% yRD_c = [558818; 559388; 559958]; % y cores
% nSample = 3; % number of samples per transect
% transectN = append('T', string(reshape(repmat((1:length(xRD)/nSample)', 1, nSample)', [], 1)));
% sampleN = repmat({'S1';'S2';'S3'}, length(xRD)/nSample, 1);
% sampleProp = table(transectN, sampleN, xRD, yRD);
% 
% for n = 5
%     figure2('Name', 'Proposed locations')
%     p(1) = scatter(data{n}.xRD, data{n}.yRD, [], data{n}.z, '.'); hold on
% %     p(2) = scatter(data{n}.xRD(data{n}.z==-1.6), data{n}.yRD(data{n}.z==-1.6), 4, 'g', 'filled');
%     p(3) = plot([sampleProp.xRD; xRD_a], [sampleProp.yRD; yRD_a], 'o',...
%     'LineWidth',2,...
%     'MarkerSize',5,...
%      'MarkerEdgeColor',[.8, 0, 0],...
%     'MarkerFaceColor','k');
%     text(xRD(1:3:end)+20, yRD(1:3:end)+20, transectN(1:3:end), 'Color', 'k', 'FontSize', fontsize/1.5)
%     text(xRD_a+10, yRD_a+50, ['A1'; 'A2'; 'A3'; 'A4'; 'A5'], 'Color', 'k', 'FontSize', fontsize/1.5)
%     p(4) = plot(xRD_c, yRD_c, 'o',...
%     'LineWidth',2,...
%     'MarkerSize',5,...
%     'MarkerEdgeColor','k',...
%     'MarkerFaceColor','w');
%     text([115777; 116497; 117217]+10, [558818; 559388; 559958]+50, ['C1'; 'C2'; 'C3'],...
%         'Color', 'k', 'FontSize', fontsize/1.5)
%     xlim([114800 118400])
%     ylim([557500 560800])
%     xticks(114000:1e3:118000)
%     yticks(558000:1e3:561000) 
%     xlabel('xRD (m)')
%     ylabel('yRD (m)')
%     c = colorbar;
%     c.Label.String = 'm +NAP';
%     c.Label.Interpreter = 'latex';
%     c.TickLabelInterpreter = 'latex';
%     c.FontSize = fontsize;
%     caxis([-5 5]);
%     colormap(brewermap([], '*PuOr'))
%     set(gca, 'Color', [.8 .8 .8])
%     text(117100, 558200, 'most recent map', 'FontSize', fontsize)
% %     legend([p(2) p(3) p(4)], {'NAP -1.6m','sample','Core'}, 'Location', 'northwest')
%     legend([p(3) p(4)], {'sample','Core'}, 'Location', 'northwest')
%     grid on
%     axis equal
% end

%% Visualisation: actual sampling locations
figure2('Name', 'Sampling overview')
tl = tiledlayout('flow', 'TileSpacing', 'none');

ax(1) = nexttile;
scatter(z_2019_Q4.xRD, z_2019_Q4.yRD, [], z_2019_Q4.z, '.'); hold on
p(1) = plot(sampleShell.RDX, sampleShell.RDY, 'o',...
'LineWidth',2,...
'MarkerSize',5,...
 'MarkerEdgeColor',[.8, 0, 0],...
'MarkerFaceColor','k');
p(2) = plot(sampleDune.Easting, sampleDune.Northing, 'o',...
'LineWidth',2,...
'MarkerSize',5,...
'MarkerEdgeColor',[.4, 1, 1],...
'MarkerFaceColor','k');
p(3) = plot(sampleArmor.Easting, sampleArmor.Northing, 'o',...
'LineWidth',2,...
'MarkerSize',5,...
'MarkerEdgeColor',[0, .8, 0],...
'MarkerFaceColor','k');
text(116000, 558200, 'Jan De Nul', 'FontSize', fontsize)
legend([p(1) p(2) p(3)], {'shell layer (23 Oct - 1 Dec 2018)','dune (28 Jan 2019)','armor layer (28 Jan 2019)'}, 'Location', 'northwest')
colormap(brewermap([], '*PuOr'))
clim([-5 5])

ax(2) = nexttile;
p(1) = scatter(z_2020_Q4.xRD, z_2020_Q4.yRD, [], z_2020_Q4.z, '.'); hold on
p(2) = plot(GS_20201016_gps.xRD, GS_20201016_gps.yRD, 'o',...
'LineWidth',2,...
'MarkerSize',5,...
 'MarkerEdgeColor',[0, .8, 0],...
'MarkerFaceColor','k');
% text(GS_20201016_gps.xRD, GS_20201016_gps.yRD, GS_20201016_gps.sample, 'FontSize', fontsize)
text(116500, 558200, '16 Oct 2020 (iPhone)', 'FontSize', fontsize)
legend(p(2), '16 Oct', 'Location', 'northwest')
colormap(brewermap([], '*PuOr'))
clim([-5 5])

ax(3) = nexttile;
p(1) = scatter(z_2020_Q4.xRD, z_2020_Q4.yRD, [], z_2020_Q4.z, '.'); hold on
p(2) = plot(GS_20201202_gps.xRD, GS_20201202_gps.yRD, 'o',...
'LineWidth',2,...
'MarkerSize',5,...
 'MarkerEdgeColor',[0, .8, 0],...
'MarkerFaceColor','k');
% text(GS_20201202_gps.xRD, GS_20201202_gps.yRD, GS_20201202_gps.sample, 'FontSize', fontsize)
p(3) = plot(GS_20201203_gps.xRD, GS_20201203_gps.yRD, 'o',...
'LineWidth',2,...
'MarkerSize',5,...
'MarkerEdgeColor',[.8, 0, 0],...
'MarkerFaceColor','k');
% text(GS_20201203_gps.xRD, GS_20201203_gps.yRD, GS_20201203_gps.sample, 'FontSize', fontsize)
text(116500, 558200, '2/3 Dec 2020', 'FontSize', fontsize)
legend([p(2) p(3)], {'2 Dec','3 Dec'}, 'Location', 'northwest')
colormap(brewermap([], '*PuOr'))
clim([-5 5])

ax(4) = nexttile;
p(1) = scatter(z_2021_09.xRD, z_2021_09.yRD, [], z_2021_09.z, '.'); hold on
p(2) = plot(GS_20210921_gps.xRD, GS_20210921_gps.yRD, 'o',...
'LineWidth',2,...
'MarkerSize',5,...
 'MarkerEdgeColor',[0, .8, 0],...
'MarkerFaceColor','k');
% text(GS_20210921_gps.xRD, GS_20210921_gps.yRD, GS_20210921_gps.sample, 'FontSize', fontsize)
text(116500, 558200, '21 Sept 2021', 'FontSize', fontsize)
legend(p(2), '21 Sept', 'Location', 'northwest')
colormap(brewermap([], '*PuOr'))
clim([-5 5])

ax(5) = nexttile;
p(1) = scatter(z_2021_09.xRD, z_2021_09.yRD, [], z_2021_09.z, '.'); hold on
p(2) = plot(GS_20210928_gps.xRD, GS_20210928_gps.yRD, 'o',...
'LineWidth',2,...
'MarkerSize',5,...
 'MarkerEdgeColor',[0, .8, 0],...
'MarkerFaceColor','k');
% text(GS_20210928_gps.xRD, GS_20210928_gps.yRD, GS_20210928_gps.sample, 'FontSize', fontsize)
text(116500, 558200, '28 Sept 2021', 'FontSize', fontsize)
legend(p(2), '28 Sept', 'Location', 'northwest')
colormap(brewermap([], '*PuOr'))
clim([-5 5])

ax(6) = nexttile;
p(1) = scatter(z_2021_11.xRD, z_2021_11.yRD, [], z_2021_11.z, '.'); hold on
p(2) = plot(GS_20211008_gps.xRD, GS_20211008_gps.yRD, 'o',...
'LineWidth',2,...
'MarkerSize',5,...
'MarkerEdgeColor',[.8, 0, 0],...
'MarkerFaceColor','k');
% text(GS_20211008_gps.xRD, GS_20211008_gps.yRD, GS_20211008_gps.sample, 'FontSize', fontsize)
p(3) = plot(GS_20211009_gps.xRD, GS_20211009_gps.yRD, 'o',...
'LineWidth',2,...
'MarkerSize',5,...
 'MarkerEdgeColor',[0, .8, 0],...
'MarkerFaceColor','k');
% text(GS_20211009_gps.xRD, GS_20211009_gps.yRD, GS_20211009_gps.sample, 'FontSize', fontsize)
text(116500, 558200, '8/9 Oct 2021', 'FontSize', fontsize)
legend([p(2) p(3)], {'8 Oct','9 Oct'}, 'Location', 'northwest')
colormap(brewermap([], '*PuOr'))
clim([-5 5])

% set(ax, 'Color', [.8 .8 .8])
axis(ax, [xl(1), xl(2), yl(1), yl(2)])
xticks(ax, xt)
yticks(ax, yt)
grid(ax, 'on')
linkaxes(ax)
axis(ax, 'equal')
axis(ax, 'off')

c = colorbar('Position', [0.93 0.168 0.015 0.7]);
c.Label.String = 'm +NAP';
c.Label.Interpreter = 'latex';
c.TickLabelInterpreter = 'latex';
c.FontSize = fontsize;

xlabel(tl, 'easting - RD (m)', 'Interpreter', 'latex', 'FontSize', fontsize)
ylabel(tl, {'northing - RD (m)',''}, 'Interpreter', 'latex', 'FontSize', fontsize)
