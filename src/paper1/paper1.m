%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize] = eurecca_init;

basePath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'Data Descriptor'];

% addpath('/Users/jwb/Local_NoSync/OET/matlab'); oetsettings('quiet')

%% Figure 1: time-average longshore conditions

%% 1st tile
load d_2022_Q3-2019_Q3.mat

survey = dz_2022_Q3_2019_Q3;
threshold = survey.z >= -6;

x = survey.xRD(threshold);
y = survey.yRD(threshold);
dz = survey.z(threshold);

tri = delaunay(x, y);

% %
L1C1 = [117421.461, 560053.687]; % vector
L2C5 = [117199.347, 559816.116]; % 3D-sonar
L3C1 = [116838.947, 559536.489]; % vector
L4C1 = [116103.892, 558946.574]; % 3D-sonar
L5C1 = [115670.000, 558603.700]; % vector
L6C1 = [115401.500, 558224.500]; % vector

LXCX = [L1C1; L2C5; L3C1; L4C1; L5C1; L6C1];
Tr_names = {'L1'; 'L2'; 'L3'; 'L4'; 'L5'; 'L6'};

%% 2nd tile
adv_locs = {'L6C1', 'L5C1', 'L4C1', 'L3C1', 'L2C4', 'L1C1'};

for n = 1:length(adv_locs)
    ADVpath{n} = [filesep 'ADV' filesep adv_locs{n} 'VEC' filesep 'tailored_loose' filesep];
    adv_info{n} = ncinfo([basePath ADVpath{n} adv_locs{n} 'VEC.nc']);
    adv_t{n} = ncread([basePath ADVpath{n} adv_locs{n} 'VEC.nc'], 't'); % minutes since 2021-09-10 19:00:00
    U{n} = ncread([basePath ADVpath{n} adv_locs{n} 'VEC.nc'], 'umag');
end

tv{1} = datetime('2021-09-11 00:10:00') + minutes(adv_t{1}); % L6C1 (til 18-Oct-2021 10:00:00)
tv{2} = datetime('2021-09-11 00:00:00') + minutes(adv_t{2}); % L5C1 (til 18-Oct-2021 09:50:00)
tv{3} = datetime('2021-09-10 19:00:00') + minutes(adv_t{3}); % L4C1 (til 18-Oct-2021 04:50:00)
tv{4} = datetime('2021-09-11 00:00:00') + minutes(adv_t{4}); % L3C1 (til 18-Oct-2021 09:50:00)
tv{5} = datetime('2021-09-10 19:00:00') + minutes(adv_t{5}); % L2C4 (til 18-Oct-2021 04:50:00)
tv{6} = datetime('2021-09-11 00:00:00') + minutes(adv_t{6}); % L1C1 (til 18-Oct-2021 09:50:00)

t1 = max([min(tv{1}), min(tv{2}), min(tv{3}), min(tv{4}), min(tv{5}), min(tv{6})]);
t2 = min([max(tv{1}), max(tv{2}), max(tv{3}), max(tv{4}), max(tv{5}), max(tv{6})]);

for n = 1:length(adv_locs)
    Dt{n} = find(tv{n} == t1) : find(tv{n} == t2);
end

U_75 = [U{1}(Dt{1}), U{2}(Dt{2}), U{3}(Dt{3}), U{4}(Dt{4}), U{5}(Dt{5}), U{6}(Dt{6})];
U_75(any(isnan(U_75), 2), :) = NaN; % only if all instruments have measured

%% 3rd tile
getGSdata;

%% Visualisation
f = figure;
tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nexttile
trisurf(tri, x, y, dz); shading interp; hold on
scatter(LXCX(:,1), LXCX(:,2), 500, '|', 'k', 'LineWidth', 3);
text(LXCX(:, 1)+20, LXCX(:, 2)-150, Tr_names, 'FontSize', fontsize)
% EHY_plot_satellite_map('localEPSG', 32750, 'FaceAlpha', 1)
axis vis3d; axis off; ax = gca; ax.SortMethod = 'childorder';
view(46, 90)

cb = colorbar; set(cb, 'position', [.85 .5 .02 .15])
cb.TickLabelInterpreter = 'latex';
cb.FontSize = fontsize;
clim([-2, 2]);
crameri('vik', 'pivot', 0)

ta = annotation('textarrow', [.77 .79], [.60 .62], 'String', 'N');
ta.FontSize = fontsize;
ta.Interpreter = 'latex';
ta.LineWidth = 6;
ta.HeadStyle = 'hypocycloid';
ta.HeadWidth = 30;
ta.HeadLength = 30;
an = annotation('ellipse', [.752 .575 .045 .055]);
an.LineWidth = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nexttile
boxchart(U_75, 'Notch', 'on')
hold on
plot(mean(U_75, 'omitnan'), '-o', 'LineWidth', 2)
hold off
% set(gca,'xticklabel',{[]})
ylabel('U (m s$^{-1}$)')
ylim([0 .6])
xticklabels(adv_locs)
legend('velocity data', 'mean velocity')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nexttile
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
legend([p3(1) p2(1) p1(1)], {'D$_{90}$', 'D$_{50}$', 'D$_{10}$'}, 'Location', 'eastoutside')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% exportgraphics(f, '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/MDPI Article 1 (draft)/Figures/Fig1.pdf')
