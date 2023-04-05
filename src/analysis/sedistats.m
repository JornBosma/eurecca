%% Initialisation
close all
clear
clc

[xl, yl, xt, yt, fontsize, ~] = eurecca_init;

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
f = figure('Name', '02-12-2020');
ax = axes;
scatter(ax, GS_20201202_gps.xRD(ref_20201202), GS_20201202_gps.yRD(ref_20201202), 400, mean(D50_20201202), 'filled')
% text(GS_20201202_gps.xRD(ref_20201202)+80, GS_20201202_gps.yRD(ref_20201202)-80, num2cell(length(ref_20201202):-1:1), 'FontSize', fontsize)

ax.Visible = 'off';
ax.XTick = [];
ax.YTick = [];

colormap(ax, flipud(hot))

set(ax, 'Position', [.17 .11 .685 .815]);
cb = colorbar(ax, 'Position', [.3 .6 .02 .2]);

cb.Label.String = 'D_{50} (mm)';
cb.Label.Interpreter = 'latex';
cb.TickLabelInterpreter = 'latex';
cb.FontSize = fontsize;

xlabel(ax, 'easting - RD (m)')
ylabel(ax, 'northing - RD (m)')

clim(ax, [0.3, 1.0])

axis(ax, [xl(1), xl(2), yl(1), yl(2)]) 
axis(ax, 'equal')
axis(ax, 'off')

%% Visualisation: 2 Dec 2020 (line plot)
f = figure('Name', '02-12-2020');
plot(D50_20201202(1, :), 'LineWidth', 1); hold on
plot(D50_20201202(2, :), 'LineWidth', 1)
plot(D50_20201202(3, :), 'LineWidth', 1)
errorbar(mean(D50_20201202), std(D50_20201202), 'k', 'LineWidth', 3)
ylabel('D50 (mm)', 'FontSize', fontsize)
xlabel('longshore location', 'FontSize', fontsize)
xticks(1:10)
xticklabels(num2cell(1:10))
annotation('textbox', [0.12, 0.07, 0, 0], 'String', 'SW', 'FontSize', fontsize, 'Interpreter', 'latex')
annotation('textbox', [0.89, 0.07, 0, 0], 'String', 'NE',  'FontSize', fontsize, 'Interpreter', 'latex')
legend('~1.6 m +NAP', '~1.0 m +NAP', '~0.2 m +NAP',...
    'cross-shore mean', 'Location', 'northeast', 'FontSize', fontsize)
axis tight

%% Visualisation: 2 Dec 2020 (line plot)
f = figure('Name', '02-12-2020');
plot(mean(D10_20201202), 'o-', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', [1 0.5 0]); hold on
plot(mean(D50_20201202), 'o-', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', [1 0.5 0])
plot(mean(D90_20201202), 'o-', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', [1 0.5 0])
plot(mean(sort_20201202), 'ro:', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', [1 0.5 0])
ylabel('grain size (mm)', 'FontSize', fontsize)
xlabel('longshore location', 'FontSize', fontsize)
xticks(1:10)
xticklabels(num2cell(1:10))
annotation('textbox', [0.3, 0.07, 0, 0], 'String', 'SW', 'FontSize', fontsize, 'Interpreter', 'latex')
annotation('textbox', [0.71, 0.07, 0, 0], 'String', 'NE',  'FontSize', fontsize, 'Interpreter', 'latex')
legend({'D_{10}','D_{50}','D_{90}','\sigma_G'}, 'Location', 'northeast', 'FontSize', fontsize)
newcolors = colormap("cool");
colororder(newcolors(50:50:50*3, :))
axis tight
axis square

%% Visualisation: 8/9 Oct 2021 (no elevation map)
f = figure('Name', '08-10-2021');
ax = axes;
scatter(ax, GS_20211008_9_gps.xRD(ref_20211008_9), GS_20211008_9_gps.yRD(ref_20211008_9), 400, mean(D50_20211008_9), 'filled')
% text(GS_20211008_9_gps.xRD(ref_20211008_9)+80, GS_20211008_9_gps.yRD(ref_20211008_9)-80, num2cell(length(ref_20211008_9):-1:1), 'FontSize', fontsize)

ax.Visible = 'off';
ax.XTick = [];
ax.YTick = [];

colormap(ax, flipud(hot))

set(ax, 'Position', [.17 .11 .685 .815]);
cb = colorbar(ax, 'Position', [.3 .6 .02 .2]);

cb.Label.String = 'D_{50} (mm)';
cb.Label.Interpreter = 'latex';
cb.TickLabelInterpreter = 'latex';
cb.FontSize = fontsize;

xlabel(ax, 'easting - RD (m)')
ylabel(ax, 'northing - RD (m)')

clim(ax, [0.3, 1.0])

axis(ax, [xl(1), xl(2), yl(1), yl(2)]) 
axis(ax, 'equal')
axis(ax, 'off')

%% Visualisation: 8/9 Oct 2021 (line plot)
f = figure('Name', '08-10-2021');
plot(D50_20211008_9(1, :), 'LineWidth', 1); hold on
plot(D50_20211008_9(2, :), 'LineWidth', 1)
plot(D50_20211008_9(3, :), 'LineWidth', 1)
plot(D50_20211008_9(4, :), 'LineWidth', 1)
plot(D50_20211008_9(5, :), 'LineWidth', 1)
errorbar(mean(D50_20211008_9), std(D50_20211008_9), 'k', 'LineWidth', 3)
ylabel('D_{50} (mm)', 'FontSize', fontsize)
xlabel('longshore location', 'FontSize', fontsize)
xticks(1:10)
xticklabels(num2cell(10:-1:1))
annotation('textbox', [0.12, 0.07, 0, 0], 'String', 'SW', 'FontSize', fontsize, 'Interpreter', 'latex')
annotation('textbox', [0.89, 0.07, 0, 0], 'String', 'NE',  'FontSize', fontsize, 'Interpreter', 'latex')
set(gca, 'XDir','reverse')
legend('1.00 m +NAP', '0.75 m +NAP', '0.50 m +NAP', '0.25 m +NAP', '0.00 m +NAP',...
    'cross-shore mean', 'Location', 'northeast', 'FontSize', fontsize)
axis tight

%% Visualisation: 8/9 Oct 2021 (line plot)
f = figure('Name', '08-10-2021');
plot(mean(D10_20211008_9), 'o-', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', [1 0.5 0]); hold on
plot(mean(D50_20211008_9), 'o-', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', [1 0.5 0])
plot(mean(D90_20211008_9), 'o-', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', [1 0.5 0])
plot(mean(sort_20211008_9), 'ro:', 'LineWidth', 3, 'MarkerSize', 8, 'MarkerFaceColor', [1 0.5 0])
ylabel('grain size (mm)', 'FontSize', fontsize)
xlabel('longshore location', 'FontSize', fontsize)
xticks(1:10)
xticklabels(num2cell(10:-1:1))
annotation('textbox', [0.3, 0.07, 0, 0], 'String', 'SW', 'FontSize', fontsize, 'Interpreter', 'latex')
annotation('textbox', [0.7, 0.07, 0, 0], 'String', 'NE',  'FontSize', fontsize, 'Interpreter', 'latex')
set(gca, 'XDir','reverse')
legend({'D_{10}','D_{50}','D_{90}','\sigma_G'}, 'Location', 'northeast', 'FontSize', fontsize)
newcolors = colormap("cool");
colororder(newcolors(50:50:50*3, :))
axis tight
axis square
