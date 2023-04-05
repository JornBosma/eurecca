%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize, ~] = eurecca_init;

dataPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'Data Descriptor'];

% colourblind-friendly colour palette
orange = [230/255, 159/255, 0];
blue = [86/255, 180/255, 233/255];
yellow = [240/255, 228/255, 66/255];
redpurp = [204/255, 121/255, 167/255];
bluegreen = [0, 158/255, 115/255];

newcolors = crameri('-vik');
colours = newcolors(1:round(length(newcolors)/5):length(newcolors), :);

%% Figure 1b: time-average longshore hydro conditions
adv_locs = {'L6C1', 'L5C1', 'L4C1', 'L3C1', 'L2C4', 'L1C1'};
ossi_locs = {'L6C2', 'L5C2', 'L4C3', 'L2C6', 'L1C2'};
locs = {'L6', 'L5', 'L4', 'L3', 'L2', 'L1'};

for n = 1:length(adv_locs)
    ADVpath{n} = [filesep 'ADV' filesep adv_locs{n} 'VEC' filesep 'tailored_loose' filesep];
    adv_info{n} = ncinfo([dataPath ADVpath{n} adv_locs{n} 'VEC.nc']);
    adv_t{n} = ncread([dataPath ADVpath{n} adv_locs{n} 'VEC.nc'], 't'); % minutes since 2021-09-10 19:00:00
    U{n} = ncread([dataPath ADVpath{n} adv_locs{n} 'VEC.nc'], 'umag');
    Hm0{n} = ncread([dataPath ADVpath{n} adv_locs{n} 'VEC.nc'], 'Hm0');
    adv_hab{n} = ncread([dataPath ADVpath{n} adv_locs{n} 'VEC.nc'], 'elev');
end

for n = 1:length(ossi_locs)
    OSSIpath{n} = [filesep 'OSSI' filesep ossi_locs{n} 'OSSI' filesep 'tailored' filesep];
    ossi_info{n} = ncinfo([dataPath OSSIpath{n} ossi_locs{n} 'OSSI.nc']);
    ossi_t{n} = ncread([dataPath OSSIpath{n} ossi_locs{n} 'OSSI.nc'], 't'); % minutes since 2021-09-10 19:00:00
    h{n} = ncread([dataPath OSSIpath{n} ossi_locs{n} 'OSSI.nc'], 'd');
    Hm01{n} = ncread([dataPath OSSIpath{n} ossi_locs{n} 'OSSI.nc'], 'Hm0');
end

tv{1} = datetime('2021-09-11 00:10:00') + minutes(adv_t{1}); % L6C1 (til 18-Oct-2021 10:00:00)
tv{2} = datetime('2021-09-11 00:00:00') + minutes(adv_t{2}); % L5C1 (til 18-Oct-2021 09:50:00)
tv{3} = datetime('2021-09-10 19:00:00') + minutes(adv_t{3}); % L4C1 (til 18-Oct-2021 04:50:00)
tv{4} = datetime('2021-09-11 00:00:00') + minutes(adv_t{4}); % L3C1 (til 18-Oct-2021 09:50:00)
tv{5} = datetime('2021-09-10 19:00:00') + minutes(adv_t{5}); % L2C4 (til 18-Oct-2021 04:50:00)
tv{6} = datetime('2021-09-11 00:00:00') + minutes(adv_t{6}); % L1C1 (til 18-Oct-2021 09:50:00)

tv{7} = datetime('2021-09-10 19:00:00') + minutes(ossi_t{1}); % L1C2 (til 18-Oct-2021 09:50:00)

t1 = max([min(tv{1}), min(tv{2}), min(tv{3}), min(tv{4}), min(tv{5}), min(tv{6})]);
t2 = min([max(tv{1}), max(tv{2}), max(tv{3}), max(tv{4}), max(tv{5}), max(tv{6})]);

for n = 1:length(tv)
    Dt{n} = find(tv{n} == t1) : find(tv{n} == t2);
end

hab_75 = [adv_hab{1}(Dt{1}), adv_hab{2}(Dt{2}), adv_hab{3}(Dt{3}), adv_hab{4}(Dt{4}), adv_hab{5}(Dt{5}), adv_hab{6}(Dt{6})];

U_75 = [U{1}(Dt{1}), U{2}(Dt{2}), U{3}(Dt{3}), U{4}(Dt{4}), U{5}(Dt{5}), U{6}(Dt{6})];
U_75(any(isnan(U_75), 2), :) = NaN; % only if all instruments have measured

Hm0_75 = [Hm0{1}(Dt{1}), Hm0{2}(Dt{2}), Hm0{3}(Dt{3}), Hm0{4}(Dt{4}), Hm0{5}(Dt{5}), Hm0{6}(Dt{6})];
Hm0_75(any(isnan(Hm0_75), 2), :) = NaN; % only if all instruments have measured

Hm01_75 = [Hm01{1}(Dt{1}), Hm01{2}(Dt{2}), Hm01{3}(Dt{3}), Hm01{4}(Dt{4}), Hm01{5}(Dt{5})];
Hm01_75(any(isnan(Hm0_75), 2), :) = NaN; % only if all instruments have measured

%% Line plot: longshore distribution time-average hydro
x = 1:6;
x2 = [x, fliplr(x)];

f0 = figure;
tiledlayout(1, 2, 'TileSpacing','compact')

ax1 = nexttile;
plot(mean(U_75, 'omitnan'), '-o', 'Color',blue, 'LineWidth',2, 'MarkerSize',15, 'MarkerFaceColor',blue); hold on
inBetween = [mean(U_75, 'omitnan')+std(U_75, 'omitnan'), fliplr(mean(U_75, 'omitnan')-std(U_75, 'omitnan'))];
fill(x2, inBetween, blue, 'FaceAlpha',.2, 'LineStyle','none');
legend('U$_{hor}$ (m s$^{-1}$)')

ax2 = nexttile;
plot(mean(Hm0_75, 'omitnan'), '-o', 'Color',orange, 'LineWidth',2, 'MarkerSize',15, 'MarkerFaceColor',orange); hold on
inBetween2 = [mean(Hm0_75, 'omitnan')+std(Hm0_75, 'omitnan'), fliplr(mean(Hm0_75, 'omitnan')-std(Hm0_75, 'omitnan'))];
fill(x2, inBetween2, orange, 'FaceAlpha',.2, 'LineStyle','none');
legend('H$_{m0}$ (m)')
set(gca,'yticklabel',{})

ylim([ax1, ax2], [0 .35])
xticks([ax1, ax2], x)
xticklabels([ax1, ax2], locs)
% xtickangle([ax1, ax2], 45)
axis([ax1, ax2], 'square')

%% Box plot: longshore distribution time-average hydro
f1 = figure;
tiledlayout(2, 1, 'TileSpacing','tight')

nexttile
boxchart(U_75, 'Notch','on'); hold on
plot(mean(U_75, 'omitnan'), '-o', 'LineWidth',2); hold off
set(gca,'xticklabel',{[]})
ylabel('U$_{hor}$ (m s$^{-1}$)')
ylim([0 .55])
% xticklabels(adv_locs)
legend('horizontal-velocity data', 'mean horizontal velocity')

nexttile
b = boxchart(Hm0_75, 'Notch','on'); hold on
b.JitterOutliers = 'on';
b.MarkerStyle = '.';
plot(mean(Hm0_75, 'omitnan'), '-o', 'LineWidth',2); hold off
% set(gca,'xticklabel',{[]})
ylabel('H$_{m0}$ (m)')
ylim([0 .7])
xticklabels(adv_locs)
legend('wave-height data', 'mean wave height')

%% Export figures
% exportgraphics(f0, '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/GitHub/eurecca-wp2/results/figures/hydro_C4.png')
% exportgraphics(f1, '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/GitHub/eurecca-wp2/results/figures/hydro_box_C4.png')
