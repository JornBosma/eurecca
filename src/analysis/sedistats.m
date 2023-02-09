%% Initialisation
close all
clear
clc

[xl, yl, xt, yt, fontsize] = eurecca_init;

% processed topo files
load('zSounding.mat')

% processed sedi samples
load('JDN_samples.mat') % 28-01-2019
load('GS_20201016.mat')
load('GS_20201202.mat')
load('GS_20210921.mat')
load('GS_20210928.mat')
load('GS_20211008-9.mat')
load('GS_20221026.mat')

% gps-locations samples
load('GS_20201016_gps.mat')
load('GS_20201202_gps.mat')
load('GS_20210921_gps.mat')
load('GS_20210928_gps.mat')
load('GS_20211008_gps.mat')
load('GS_20211009_gps.mat')
load('GS_20221026_gps.mat')

% necessary adjustments
GS_20201016 = removevars(GS_20201016, "Lagoon"); % one too many
GS_20201016_gps(1, :) = [];
GS_20201202 = removevars(GS_20201202, "T01S04"); % one too many
GS_20201202_gps(4, :) = [];
GS_20210921 = removevars(GS_20210921, "T_05"); % one too many
GS_20210921_gps(4, :) = [];
GS_20210928 = removevars(GS_20210928, "T_05"); % one too many
GS_20210928_gps(4, :) = [];
GS_20221026 = removevars(GS_20221026, ["R1_D","R1_E","R2_D","R7_D","R7_E",...
    "R8_D","R8_E","R9_D","R10_D","R10_E"]); % few too many, only A-B-C
GS_20221026_gps([4,5,9,10,14,18,22,23,27,28,32:34,38:40], :) = [];

GS_20211008_9_gps = [GS_20211009_gps; GS_20211008_gps]; % merge tables
GS_20211008_9_gps(21:30, :) = GS_20211008_9_gps([23:26 21 27:30 22], :); % swap rows

% designate reference points (= first/highest point of transect)
ref_20190128 = 1:2:height(sampleArmor);
ref_20201016 = 1:3:height(GS_20201016_gps);
ref_20201202 = 1:3:height(GS_20201202_gps);
ref_20210921 = 1:2:height(GS_20210921_gps);
ref_20210928 = 1:2:height(GS_20210928_gps);
ref_20211008_9 = 1:5:height(GS_20211008_9_gps);
ref_20221026 = 1:3:height(GS_20221026_gps);

%% Grain-size distribution
% 10th percentile, D10 [mm]
D10_20201016 = GS_20201016(31, 3:end);
D10_20201016 = table2array(D10_20201016)/1000;
D10_20201016 = reshape(D10_20201016, 3, []);

D10_20201202 = GS_20201202(31, 3:end); % slice corresponding row
D10_20201202 = table2array(D10_20201202)/1000; % convert unit mu to mm
D10_20201202 = reshape(D10_20201202, 3, []); % group transect points

D10_20210921 = GS_20210921(31, 3:end);
D10_20210921 = table2array(D10_20210921)/1000;
D10_20210921 = reshape(D10_20210921, 2, []);

D10_20210928 = GS_20210928(31, 3:end);
D10_20210928 = table2array(D10_20210928)/1000;
D10_20210928 = reshape(D10_20210928, 2, []);

D10_20211008_9 = GS_20211008_9(31, 3:end);
D10_20211008_9 = table2array(D10_20211008_9)/1000;
D10_20211008_9 = reshape(D10_20211008_9, 5, []);

D10_20221026 = GS_20221026(31, 3:end);
D10_20221026 = table2array(D10_20221026)/1000;
D10_20221026 = reshape(D10_20221026, 3, []);

% 50th percentile (median), D50 [mm]
D50_20190128 = table2array(sampleArmor(:,8))/1000;
D50_20190128 = reshape(D50_20190128, 2, []);

D50_20201016 = GS_20201016(32, 3:end);
D50_20201016 = table2array(D50_20201016)/1000;
D50_20201016 = reshape(D50_20201016, 3, []);

D50_20201202 = GS_20201202(32, 3:end);
D50_20201202 = table2array(D50_20201202)/1000;
D50_20201202 = reshape(D50_20201202, 3, []);

D50_20210921 = GS_20210921(32, 3:end);
D50_20210921 = table2array(D50_20210921)/1000;
D50_20210921 = reshape(D50_20210921, 2, []);

D50_20210928 = GS_20210928(32, 3:end);
D50_20210928 = table2array(D50_20210928)/1000;
D50_20210928 = reshape(D50_20210928, 2, []);

D50_20211008_9 = GS_20211008_9(32, 3:end);
D50_20211008_9 = table2array(D50_20211008_9)/1000;
D50_20211008_9 = reshape(D50_20211008_9, 5, []);

D50_20221026 = GS_20221026(32, 3:end);
D50_20221026 = table2array(D50_20221026)/1000;
D50_20221026 = reshape(D50_20221026, 3, []);

% 90th percentile, D90 [mm]
D90_20201016 = GS_20201016(33, 3:end);
D90_20201016 = table2array(D90_20201016)/1000;
D90_20201016 = reshape(D90_20201016, 3, []);

D90_20201202 = GS_20201202(33, 3:end);
D90_20201202 = table2array(D90_20201202)/1000;
D90_20201202 = reshape(D90_20201202, 3, []);

D90_20210921 = GS_20210921(33, 3:end);
D90_20210921 = table2array(D90_20210921)/1000;
D90_20210921 = reshape(D90_20210921, 2, []);

D90_20210928 = GS_20210928(33, 3:end);
D90_20210928 = table2array(D90_20210928)/1000;
D90_20210928 = reshape(D90_20210928, 2, []);

D90_20211008_9 = GS_20211008_9(33, 3:end);
D90_20211008_9 = table2array(D90_20211008_9)/1000;
D90_20211008_9 = reshape(D90_20211008_9, 5, []);

D90_20221026 = GS_20221026(33, 3:end);
D90_20221026 = table2array(D90_20221026)/1000;
D90_20221026 = reshape(D90_20221026, 3, []);

% degree of sorting, D90/D10
D90_10_20201202 = GS_20201202(34, 3:end);
D90_10_20201202 = table2array(D90_10_20201202);
D90_10_20201202 = reshape(D90_10_20201202, 3, []);

D90_10_20210921 = GS_20210921(34, 3:end);
D90_10_20210921 = table2array(D90_10_20210921);
D90_10_20210921 = reshape(D90_10_20210921, 2, []);

D90_10_20210928 = GS_20210928(34, 3:end);
D90_10_20210928 = table2array(D90_10_20210928);
D90_10_20210928 = reshape(D90_10_20210928, 2, []);

D90_10_20211008_9 = GS_20211008_9(34, 3:end);
D90_10_20211008_9 = table2array(D90_10_20211008_9);
D90_10_20211008_9 = reshape(D90_10_20211008_9, 5, []);

D90_10_20221026 = GS_20221026(34, 3:end);
D90_10_20221026 = table2array(D90_10_20221026);
D90_10_20221026 = reshape(D90_10_20221026, 3, []);

%% Folk and Ward (mu)
% sorting (sigma_G)
sort_20201202 = GS_20201202(14, 3:end);
sort_20201202 = table2array(sort_20201202);
sort_20201202 = reshape(sort_20201202, 3, []);

sort_20210921 = GS_20201202(14, 3:end);
sort_20210921 = table2array(sort_20210921);
sort_20210921 = reshape(sort_20210921, 2, []);

sort_20210928 = GS_20201202(14, 3:end);
sort_20210928 = table2array(sort_20210928);
sort_20210928 = reshape(sort_20210928, 2, []);

sort_20211008_9 = GS_20211008_9(14, 3:end);
sort_20211008_9 = table2array(sort_20211008_9);
sort_20211008_9 = reshape(sort_20211008_9, 5, []);

sort_20221026 = GS_20221026(14, 3:end);
sort_20221026 = table2array(sort_20221026);
sort_20221026 = reshape(sort_20221026, 3, []);

% skewness (Sk_G)
skew_20201202 = GS_20201202(15, 3:end);
skew_20201202 = table2array(skew_20201202);
skew_20201202 = reshape(skew_20201202, 3, []);

skew_20210921 = GS_20201202(15, 3:end);
skew_20210921 = table2array(skew_20210921);
skew_20210921 = reshape(skew_20210921, 2, []);

skew_20210928 = GS_20201202(15, 3:end);
skew_20210928 = table2array(skew_20210928);
skew_20210928 = reshape(skew_20210928, 2, []);

skew_20211008_9 = GS_20211008_9(15, 3:end);
skew_20211008_9 = table2array(skew_20211008_9);
skew_20211008_9 = reshape(skew_20211008_9, 5, []);

skew_20221026 = GS_20221026(15, 3:end);
skew_20221026 = table2array(skew_20221026);
skew_20221026 = reshape(skew_20221026, 3, []);

% kurtosis (K_G)
kurt_20201202 = GS_20201202(16, 3:end);
kurt_20201202 = table2array(kurt_20201202);
kurt_20201202 = reshape(kurt_20201202, 3, []);

kurt_20210921 = GS_20201202(16, 3:end);
kurt_20210921 = table2array(kurt_20210921);
kurt_20210921 = reshape(kurt_20210921, 2, []);

kurt_20210928 = GS_20201202(16, 3:end);
kurt_20210928 = table2array(kurt_20210928);
kurt_20210928 = reshape(kurt_20210928, 2, []);

kurt_20211008_9 = GS_20211008_9(16, 3:end);
kurt_20211008_9 = table2array(kurt_20211008_9);
kurt_20211008_9 = reshape(kurt_20211008_9, 5, []);

kurt_20221026 = GS_20221026(16, 3:end);
kurt_20221026 = table2array(kurt_20221026);
kurt_20221026 = reshape(kurt_20221026, 3, []);

%% Visualisation: 28 Jan 2019 (Jan De Nul)
f = figure('Name', '28-01-2019');
ax1 = axes;
ax2 = axes;
scatter(ax1, z_2019_Q4.xRD(z_2019_Q4.z>0), z_2019_Q4.yRD(z_2019_Q4.z>0), [], z_2019_Q4.z(z_2019_Q4.z>0), '.'); hold on
% s2 = scatter(z_2019_Q4.xRD(z_2019_Q4.z>-0.05 & z_2019_Q4.z<0.05),...
%     z_2019_Q4.yRD(z_2019_Q4.z>-0.05 & z_2019_Q4.z<0.05), 4, 'g', 'filled');
% legend([s1, s2], '', 'MSL', 'Location', 'west')
scatter(ax2, sampleArmor.Easting(ref_20190128), sampleArmor.Northing(ref_20190128), 400, mean(D50_20190128), 'filled')
% text(sampleArmor.Easting(ref_20190128)+80, sampleArmor.Northing(ref_20190128)-80, num2cell(1:length(ref_20190128)), 'FontSize', fontsize)

GS_plot_settings(ax1, ax2, fontsize, xl, yl)

% exportgraphics(f, 'D50_2019-01-28.png')

%% Visualisation: 16 Oct 2020
f = figure('Name', '16-10-2020');
ax1 = axes;
ax2 = axes;
scatter(ax1, z_2020_Q4.xRD(z_2020_Q4.z>0), z_2020_Q4.yRD(z_2020_Q4.z>0), [], z_2020_Q4.z(z_2020_Q4.z>0), '.'); hold on
% s2 = scatter(z_2020_Q4.xRD(z_2020_Q4.z>-0.05 & z_2020_Q4.z<0.05),...
%     z_2020_Q4.yRD(z_2020_Q4.z>-0.05 & z_2020_Q4.z<0.05), 4, 'g', 'filled');
% legend([s1, s2], '', 'MSL', 'Location', 'west')
scatter(ax2, GS_20201016_gps.xRD(ref_20201016), GS_20201016_gps.yRD(ref_20201016), 400, mean(D50_20201016), 'filled')
% text(GS_20201016_gps.xRD(ref_20201016)+80, GS_20201016_gps.yRD(ref_20201016)-80, num2cell(length(ref_20201016):-1:1), 'FontSize', fontsize)

GS_plot_settings(ax1, ax2, fontsize, xl, yl)

% exportgraphics(f, 'D50_2020-10-16.png')

%% Visualisation: 2 Dec 2020
f = figure('Name', '02-12-2020');
ax1 = axes;
ax2 = axes;
scatter(ax1, z_2020_Q4.xRD(z_2020_Q4.z>0), z_2020_Q4.yRD(z_2020_Q4.z>0), [], z_2020_Q4.z(z_2020_Q4.z>0), '.'); hold on
% s2 = scatter(z_2020_Q4.xRD(z_2020_Q4.z>-0.05 & z_2020_Q4.z<0.05),...
%     z_2020_Q4.yRD(z_2020_Q4.z>-0.05 & z_2020_Q4.z<0.05), 4, 'g', 'filled');
% legend([s1, s2], '', 'MSL', 'Location', 'west')
scatter(ax2, GS_20201202_gps.xRD(ref_20201202), GS_20201202_gps.yRD(ref_20201202), 400, mean(D50_20201202), 'filled')
% text(GS_20201202_gps.xRD(ref_20201202)+80, GS_20201202_gps.yRD(ref_20201202)-80, num2cell(1:length(ref_20201202)), 'FontSize', fontsize)

GS_plot_settings(ax1, ax2, fontsize, xl, yl)

% exportgraphics(f, 'D50_2020-12-02_black.png')

%% Visualisation: 21 Sep 2021
f = figure('Name', '21-09-2021');
ax1 = axes;
ax2 = axes;
scatter(ax1, z_2021_09.xRD(z_2021_09.z>0), z_2021_09.yRD(z_2021_09.z>0), [], z_2021_09.z(z_2021_09.z>0), '.'); hold on
% s2 = scatter(z_2021_09.xRD(z_2021_09.z>-0.05 & z_2021_09.z<0.05),...
%     z_2021_09.yRD(z_2021_09.z>-0.05 & z_2021_09.z<0.05), 4, 'g', 'filled');
% legend([s1, s2], '', 'MSL', 'Location', 'west')
scatter(ax2, GS_20210921_gps.xRD(ref_20210921), GS_20210921_gps.yRD(ref_20210921), 400, mean(D50_20210921), 'filled')
% text(GS_20210921_gps.xRD(ref_20210921)+80, GS_20210921_gps.yRD(ref_20210921)-80, num2cell(1:length(ref_20210921)), 'FontSize', fontsize)

GS_plot_settings(ax1, ax2, fontsize, xl, yl)

% exportgraphics(f, 'D50_2021-09-21.png')

%% Visualisation: 28 Sep 2021
f = figure('Name', '28-09-2021');
ax1 = axes;
ax2 = axes;
scatter(ax1, z_2021_09.xRD(z_2021_09.z>0), z_2021_09.yRD(z_2021_09.z>0), [], z_2021_09.z(z_2021_09.z>0), '.'); hold on
scatter(ax2, GS_20210928_gps.xRD(ref_20210928), GS_20210928_gps.yRD(ref_20210928), 400, mean(D50_20210928), 'filled')
% text(GS_20210928_gps.xRD(ref_20210928)+80, GS_20210928_gps.yRD(ref_20210928)-80, num2cell(1:length(ref_20210928)), 'FontSize', fontsize)

GS_plot_settings(ax1, ax2, fontsize, xl, yl)

% exportgraphics(f, 'D50_2021-09-28.png')

%% Visualisation: 8-9 Oct 2021
f = figure('Name', '8/9-10-2021');
ax1 = axes;
ax2 = axes;
scatter(ax1, z_2021_11.xRD(z_2021_11.z>0), z_2021_11.yRD(z_2021_11.z>0), [], z_2021_11.z(z_2021_11.z>0), '.'); hold on
scatter(ax2, GS_20211008_9_gps.xRD(ref_20211008_9), GS_20211008_9_gps.yRD(ref_20211008_9), 400, mean(D50_20211008_9), 'filled')
% text(GS_20211008_9_gps.xRD(ref_20211008_9)+80, GS_20211008_9_gps.yRD(ref_20211008_9)-80, num2cell(length(ref_20211008_9):-1:1), 'FontSize', fontsize)

GS_plot_settings(ax1, ax2, fontsize, xl, yl)

% exportgraphics(f, 'D50_2021-10-8_9.png')

%% Visualisation: 26 Oct 2022
f = figure('Name', '26-10-2022');
ax1 = axes;
ax2 = axes;
scatter(ax1, z_2022_Q3.xRD(z_2022_Q3.z>0), z_2022_Q3.yRD(z_2022_Q3.z>0), [], z_2022_Q3.z(z_2022_Q3.z>0), '.'); hold on
scatter(ax2, GS_20221026_gps.xRD(ref_20221026), GS_20221026_gps.yRD(ref_20221026), 400, mean(D50_20221026), 'filled')
% text(GS_20221026_gps.xRD(ref_20221026)+80, GS_20221026_gps.yRD(ref_20221026)-80, num2cell(length(ref_20221026):-1:1), 'FontSize', fontsize)

GS_plot_settings(ax1, ax2, fontsize, xl, yl)

% exportgraphics(f, 'D50_2022-10-26.png')

%% Visualisation: 2 Dec 2020 (no elevation map)
% f = figure('Name', '02-12-2020');
% ax = axes;
% scatter(ax, GS_20201202_gps.xRD(ref_20201202), GS_20201202_gps.yRD(ref_20201202), 400, mean(D50_20201202), 'filled')
% % text(GS_20201202_gps.xRD(ref_20201202)+80, GS_20201202_gps.yRD(ref_20201202)-80, num2cell(length(ref_20201202):-1:1), 'FontSize', fontsize)
% 
% ax.Visible = 'off';
% ax.XTick = [];
% ax.YTick = [];
% 
% colormap(ax, flipud(hot))
% 
% set(ax, 'Position', [.17 .11 .685 .815]);
% cb = colorbar(ax, 'Position', [.3 .6 .02 .2]);
% 
% cb.Label.String = 'D_{50} (mm)';
% cb.Label.Interpreter = 'tex';
% cb.TickLabelInterpreter = 'tex';
% cb.FontSize = fontsize;
% 
% xlabel(ax, 'easting - RD (m)')
% ylabel(ax, 'northing - RD (m)')
% 
% clim(ax, [0.3, 1.0])
% 
% axis(ax, [xl(1), xl(2), yl(1), yl(2)]) 
% axis(ax, 'equal')
% axis(ax, 'off')

%% Visualisation: 2 Dec 2020 (line plot)
% f = figure('Name', '02-12-2020');
% plot(D50_20201202(1, :), 'LineWidth', 1); hold on
% plot(D50_20201202(2, :), 'LineWidth', 1)
% plot(D50_20201202(3, :), 'LineWidth', 1)
% errorbar(mean(D50_20201202), std(D50_20201202), 'k', 'LineWidth', 3)
% ylabel('D50 (mm)', 'FontSize', fontsize)
% xlabel('longshore location', 'FontSize', fontsize)
% xticks(1:10)
% xticklabels(num2cell(1:10))
% annotation('textbox', [0.12, 0.07, 0, 0], 'String', 'SW', 'FontSize', fontsize, 'Interpreter', 'tex')
% annotation('textbox', [0.89, 0.07, 0, 0], 'String', 'NE',  'FontSize', fontsize, 'Interpreter', 'tex')
% legend('~1.6 m +NAP', '~1.0 m +NAP', '~0.2 m +NAP',...
%     'cross-shore mean', 'Location', 'northeast', 'FontSize', fontsize)
% axis tight

%% Visualisation: 2 Dec 2020 (line plot)
% f = figure('Name', '02-12-2020');
% plot(mean(D10_20201202), 'o-', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', [1 0.5 0]); hold on
% plot(mean(D50_20201202), 'o-', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', [1 0.5 0])
% plot(mean(D90_20201202), 'o-', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', [1 0.5 0])
% plot(mean(sort_20201202), 'ro:', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', [1 0.5 0])
% ylabel('grain size (mm)', 'FontSize', fontsize)
% xlabel('longshore location', 'FontSize', fontsize)
% xticks(1:10)
% xticklabels(num2cell(1:10))
% annotation('textbox', [0.3, 0.07, 0, 0], 'String', 'SW', 'FontSize', fontsize, 'Interpreter', 'tex')
% annotation('textbox', [0.71, 0.07, 0, 0], 'String', 'NE',  'FontSize', fontsize, 'Interpreter', 'tex')
% legend({'D_{10}','D_{50}','D_{90}','\sigma_G'}, 'Location', 'northeast', 'FontSize', fontsize)
% newcolors = colormap("cool");
% colororder(newcolors(50:50:50*3, :))
% axis tight
% axis square

%% Visualisation: 8/9 Oct 2021 (no elevation map)
% f = figure('Name', '08-10-2021');
% ax = axes;
% scatter(ax, GS_20211008_9_gps.xRD(ref_20211008_9), GS_20211008_9_gps.yRD(ref_20211008_9), 400, mean(D50_20211008_9), 'filled')
% % text(GS_20211008_9_gps.xRD(ref_20211008_9)+80, GS_20211008_9_gps.yRD(ref_20211008_9)-80, num2cell(length(ref_20211008_9):-1:1), 'FontSize', fontsize)
% 
% ax.Visible = 'off';
% ax.XTick = [];
% ax.YTick = [];
% 
% colormap(ax, flipud(hot))
% 
% set(ax, 'Position', [.17 .11 .685 .815]);
% cb = colorbar(ax, 'Position', [.3 .6 .02 .2]);
% 
% cb.Label.String = 'D_{50} (mm)';
% cb.Label.Interpreter = 'tex';
% cb.TickLabelInterpreter = 'tex';
% cb.FontSize = fontsize;
% 
% xlabel(ax, 'easting - RD (m)')
% ylabel(ax, 'northing - RD (m)')
% 
% clim(ax, [0.3, 1.0])
% 
% axis(ax, [xl(1), xl(2), yl(1), yl(2)]) 
% axis(ax, 'equal')
% axis(ax, 'off')

%% Visualisation: 8/9 Oct 2021 (line plot)
% f = figure('Name', '08-10-2021');
% plot(D50_20211008_9(1, :), 'LineWidth', 1); hold on
% plot(D50_20211008_9(2, :), 'LineWidth', 1)
% plot(D50_20211008_9(3, :), 'LineWidth', 1)
% plot(D50_20211008_9(4, :), 'LineWidth', 1)
% plot(D50_20211008_9(5, :), 'LineWidth', 1)
% errorbar(mean(D50_20211008_9), std(D50_20211008_9), 'k', 'LineWidth', 3)
% ylabel('D50 (mm)', 'FontSize', fontsize)
% xlabel('longshore location', 'FontSize', fontsize)
% xticks(1:10)
% xticklabels(num2cell(10:-1:1))
% annotation('textbox', [0.12, 0.07, 0, 0], 'String', 'SW', 'FontSize', fontsize, 'Interpreter', 'tex')
% annotation('textbox', [0.89, 0.07, 0, 0], 'String', 'NE',  'FontSize', fontsize, 'Interpreter', 'tex')
% set(gca, 'XDir','reverse')
% legend('1.00 m +NAP', '0.75 m +NAP', '0.50 m +NAP', '0.25 m +NAP', '0.00 m +NAP',...
%     'cross-shore mean', 'Location', 'northeast', 'FontSize', fontsize)
% axis tight

%% Visualisation: 8/9 Oct 2021 (line plot)
% f = figure('Name', '08-10-2021');
% plot(mean(D10_20211008_9), 'o-', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', [1 0.5 0]); hold on
% plot(mean(D50_20211008_9), 'o-', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', [1 0.5 0])
% plot(mean(D90_20211008_9), 'o-', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', [1 0.5 0])
% plot(mean(sort_20211008_9), 'ro:', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', [1 0.5 0])
% ylabel('grain size (mm)', 'FontSize', fontsize)
% xlabel('longshore location', 'FontSize', fontsize)
% xticks(1:10)
% xticklabels(num2cell(10:-1:1))
% annotation('textbox', [0.3, 0.07, 0, 0], 'String', 'SW', 'FontSize', fontsize, 'Interpreter', 'tex')
% annotation('textbox', [0.7, 0.07, 0, 0], 'String', 'NE',  'FontSize', fontsize, 'Interpreter', 'tex')
% set(gca, 'XDir','reverse')
% legend({'D_{10}','D_{50}','D_{90}','\sigma_G'}, 'Location', 'northeast', 'FontSize', fontsize)
% newcolors = colormap("cool");
% colororder(newcolors(50:50:50*3, :))
% axis tight
% axis square

%% Visualisation: comparison line plot
% f = figure;
% plot(mean(D50_20201202), 'o-', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', [1 0.5 0]); hold on
% plot(flip(mean(D50_20211008_9)), 'o-', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', [1 0.5 0])
% ylabel('D_{50} (mm)', 'FontSize', fontsize)
% xlabel('longshore location', 'FontSize', fontsize)
% xticks(1:10)
% xticklabels(num2cell(1:10))
% annotation('textbox', [0.3, 0.07, 0, 0], 'String', 'SW', 'FontSize', fontsize, 'Interpreter', 'tex')
% annotation('textbox', [0.7, 0.07, 0, 0], 'String', 'NE',  'FontSize', fontsize, 'Interpreter', 'tex')
% legend({'20211202','20211008/9'}, 'Location', 'northeast', 'FontSize', fontsize)
% newcolors = colormap("cool");
% colororder(newcolors(50:50:50*3, :))
% axis tight
% axis square

%% Calculation
% D50
D50_20190128_mean = mean(D50_20190128);
D50_20190128_mean(1) = [];
D50_20190128_L = [[1.5, 3, 4, 6, 7.5, 9.5]; D50_20190128_mean];

D50_20201016_mean = mean(D50_20201016);
D50_20201016_L = [[1.5, 3, 4, 6, 7, 8, 9, 10]; D50_20201016_mean];

D50_20201202_mean = mean(D50_20201202);
D50_20201202_L = [1:10; D50_20201202_mean];

D50_20210921_mean = mean(D50_20210921);
D50_20210921_L = [[1, 3, 4, 6, 10.2, 10.4]; D50_20210921_mean];

D50_20210928_mean = mean(D50_20210928);
D50_20210928_L = [[1, 3, 4, 6, 10.2, 10.4]; D50_20210928_mean];

D50_20211008_9_mean = mean(D50_20211008_9);
D50_20211008_9_L = [1:10; flip(D50_20211008_9_mean)];

D50_20221026_mean = mean(D50_20221026);
D50_20221026_L = [[1:4, 6, 8:10]; flip(D50_20221026_mean)];

D50_day = {D50_20190128_L, D50_20201016_L, D50_20201202_L, D50_20210921_L, D50_20210928_L, D50_20211008_9_L, D50_20221026_L};
D50_all = [D50_20190128_L, D50_20201016_L, D50_20201202_L, D50_20210921_L, D50_20210928_L, D50_20211008_9_L, D50_20221026_L];

p_D50 = polyfit(D50_all(1, :), D50_all(2, :), 3);
D50_fit = polyval(p_D50, 1:11);

% D10
D10_20190128_L = [[1.5, 3, 4, 6, 7.5, 9.5]; NaN(size(D50_20190128_mean))];

D10_20201016_mean = mean(D10_20201016);
D10_20201016_L = [[1.5, 3, 4, 6, 7, 8, 9, 10]; D10_20201016_mean];

D10_20201202_mean = mean(D10_20201202);
D10_20201202_L = [1:10; D10_20201202_mean];

D10_20210921_mean = mean(D10_20210921);
D10_20210921_L = [[1, 3, 4, 6, 10.2, 10.4]; D10_20210921_mean];

D10_20210928_mean = mean(D10_20210928);
D10_20210928_L = [[1, 3, 4, 6, 10.2, 10.4]; D10_20210928_mean];

D10_20211008_9_mean = mean(D10_20211008_9);
D10_20211008_9_L = [1:10; flip(D10_20211008_9_mean)];

D10_20221026_mean = mean(D10_20221026);
D10_20221026_L = [[1:4, 6, 8:10]; flip(D10_20221026_mean)];

D10_day = {D10_20190128_L, D10_20201016_L, D10_20201202_L, D10_20210921_L, D10_20210928_L, D10_20211008_9_L, D10_20221026_L};
D10_all = [D10_20190128_L, D10_20201016_L, D10_20201202_L, D10_20210921_L, D10_20210928_L, D10_20211008_9_L, D10_20221026_L];

p_D10 = polyfit(D10_all(1, 7:end), D10_all(2, 7:end), 3);
D10_fit = polyval(p_D10, 1:11);

% D90
D90_20190128_L = [[1.5, 3, 4, 6, 7.5, 9.5]; NaN(size(D50_20190128_mean))];

D90_20201016_mean = mean(D90_20201016);
D90_20201016_L = [[1.5, 3, 4, 6, 7, 8, 9, 10]; D90_20201016_mean];

D90_20201202_mean = mean(D90_20201202);
D90_20201202_L = [1:10; D90_20201202_mean];

D90_20210921_mean = mean(D90_20210921);
D90_20210921_L = [[1, 3, 4, 6, 10.2, 10.4]; D90_20210921_mean];

D90_20210928_mean = mean(D90_20210928);
D90_20210928_L = [[1, 3, 4, 6, 10.2, 10.4]; D90_20210928_mean];

D90_20211008_9_mean = mean(D90_20211008_9);
D90_20211008_9_L = [1:10; flip(D90_20211008_9_mean)];

D90_20221026_mean = mean(D90_20221026);
D90_20221026_L = [[1:4, 6, 8:10]; flip(D90_20221026_mean)];

D90_day = {D90_20190128_L, D90_20201016_L, D90_20201202_L, D90_20210921_L, D90_20210928_L, D90_20211008_9_L, D90_20221026_L};
D90_all = [D90_20190128_L, D90_20201016_L, D90_20201202_L, D90_20210921_L, D90_20210928_L, D90_20211008_9_L, D90_20221026_L];

p_D90 = polyfit(D90_all(1, 7:end), D90_all(2, 7:end), 3);
D90_fit = polyval(p_D90, 1:11);

%% Visualisation: total comparison line plot
f = figure;
tiledlayout(3, 1, 'TileSpacing', 'tight')

nexttile;
hold on
for n = 1:length(D90_day)
    scatter(D90_day{n}(1, :), D90_day{n}(2, :), 250, 'filled', 'LineWidth', 3)
end
xlim([0.5 11])
ylim([0, 6])
newcolors = colormap("hot");
colororder(newcolors(50:30:50*5, :))
set(gca,'XTickLabel',[]);
ylabel('D_{90} (mm)', 'FontSize', fontsize)
% legend({'2019-01-28', '2020-10-16', '2021-12-02', '2021-09-21', '2021-09-28',...
%     '2021-10-08', '2022-10-26'}, 'Location', 'northoutside', 'NumColumns', 7, 'FontSize', fontsize)

nexttile
hold on
for n = 1:length(D50_day)
    scatter(D50_day{n}(1, :), D50_day{n}(2, :), 250, 'filled', 'LineWidth', 3)
end
xlim([0.5 11])
ylim([0, 1.5])
newcolors = colormap("hot");
colororder(newcolors(50:30:50*5, :))
set(gca,'XTickLabel',[]);
legend({'2019-01-28', '2020-10-16', '2021-12-02', '2021-09-21', '2021-09-28',...
    '2021-10-08', '2022-10-26'}, 'Location', 'northeastoutside', 'FontSize', fontsize)
ylabel('D_{50} (mm)', 'FontSize', fontsize)

nexttile
hold on
for n = 1:length(D10_day)
    scatter(D10_day{n}(1, :), D10_day{n}(2, :), 250, 'filled', 'LineWidth', 3)
end
xlim([0.5 11])
ylim([0.1, 0.6])
newcolors = colormap("cool");
colororder(newcolors(50:30:50*5, :))
ylabel('D_{10} (mm)', 'FontSize', fontsize)
xlabel('longshore location', 'FontSize', fontsize)
xticks(1:10)
xticklabels(num2cell(1:10))
annotation('textbox', [0.05, 0.06, 0, 0], 'String', 'SW', 'FontSize', fontsize, 'Interpreter', 'tex')
annotation('textbox', [0.82, 0.06, 0, 0], 'String', 'NE',  'FontSize', fontsize, 'Interpreter', 'tex')

% exportgraphics(f, 'DX0_longshore_time.png')

%% Visualisation: total comparison line plot
f = figure;

hold on
for n = 1:length(D10_day)
    s1 = scatter(D10_day{n}(1, :), D10_day{n}(2, :), 200, 'filled', 'MarkerFaceColor', 'b', 'MarkerFaceAlpha', 0.1);
end
p1 = plot(1:11, D10_fit, 'b', 'LineWidth', 4);
yline(mean(D10_all(2, :), 'omitnan'), '--b', 'LineWidth', 2)
text(1, mean(D10_all(2, :)+.02, 'omitnan'), [mat2str(mean(D10_all(2, :), 'omitnan'), 3), ' mm'], 'FontSize', fontsize, 'Color', 'b')
yline(mean(D10_20201202_L(2, :), 'omitnan'), ':b', 'LineWidth', 2)

hold on
for n = 1:length(D50_day)
    s2 = scatter(D50_day{n}(1, :), D50_day{n}(2, :), 200, 'filled', 'MarkerFaceColor', 'g', 'MarkerFaceAlpha', 0.1);
end
p2 = plot(1:11, D50_fit, 'g', 'LineWidth', 4);
yline(mean(D50_all(2, :), 'omitnan'), '--g', 'LineWidth', 2)
text(1, mean(D50_all(2, :)+.05, 'omitnan'), [mat2str(mean(D50_all(2, :), 'omitnan'), 3), ' mm'], 'FontSize', fontsize, 'Color', 'g')
yline(mean(D50_20201202_L(2, :), 'omitnan'), ':g', 'LineWidth', 2)

hold on
for n = 1:length(D90_day)
    s3 = scatter(D90_day{n}(1, :), D90_day{n}(2, :), 200, 'filled', 'MarkerFaceColor', 'r', 'MarkerFaceAlpha', 0.1);
end
p3 = plot(1:11, D90_fit, 'r', 'LineWidth', 4);
yline(mean(D90_all(2, :), 'omitnan'), '--r', 'LineWidth', 2)
text(1, mean(D90_all(2, :)+.2, 'omitnan'), [mat2str(mean(D90_all(2, :), 'omitnan'), 3), ' mm'], 'FontSize', fontsize, 'Color', 'r')
yline(mean(D90_20201202_L(2, :), 'omitnan'), ':r', 'LineWidth', 2)

xlim([0.5, 11])
set(gca, 'YScale', 'log')
ylabel('grain size (mm)', 'FontSize', fontsize)
xlabel('longshore location', 'FontSize', fontsize)
xticks(1:10)
xticklabels(num2cell(1:10))
annotation('textbox', [0.1, 0.07, 0, 0], 'String', 'SW', 'FontSize', fontsize, 'Interpreter', 'tex')
annotation('textbox', [0.82, 0.07, 0, 0], 'String', 'NE',  'FontSize', fontsize, 'Interpreter', 'tex')
legend([p3(1) p2(1) p1(1)], {'D_{90}', 'D_{50}', 'D_{10}'}, 'Location', 'eastoutside')

% exportgraphics(f, 'DX0_longshore_mean.png')
