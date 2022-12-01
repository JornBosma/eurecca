%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize] = eurecca_init;

basePath = [filesep 'Volumes' filesep 'geo.data.uu.nl' filesep ...
    'research-eurecca' filesep 'FieldVisits' filesep ...
    '20210908_SEDMEX' filesep 'Data Descriptor'];

file = [basePath, '/TRANSECTS/field_visits_projected_netcdf/alleen_loop/track1.nc'];

track = ncinfo(file);
x = ncread(file, 'x'); % xRD [m]
y = ncread(file, 'y'); % yRD [m]
d = ncread(file, 'd'); % x-shore distance [m]
profiles = ncread(file, '__xarray_dataarray_variable__'); % depth [m]
ID = ncread(file, 'ID'); % profile ID (seconds since 2020-10-16 12:56:53)

date = datetime(ID, 'ConvertFrom', 'epochtime', 'Epoch', '2020-10-16 12:56:53');

range = 7:26; % SEDMEX period

%% Visualisation
f = figure;
plot(d, movmean(profiles(:, range), 6))
legend(string(datetime(date(range), 'Format','dd-MM-yy')), 'Location', 'northoutside', 'NumColumns', 6, 'Box', 'on', 'FontSize', fontsize/1.3)
xlim([190, 240])
ylim([-1.5, 2])
xlabel('x-shore distance (m)')
ylabel('bed level\newline(m +NAP)')
xticks(190:10:250)
xticklabels(0:10:60)

newcolors = colormap("pink");
colororder(flipud(newcolors(10:10:230, :)))

grid on

% exportgraphics(f, 'L2_profiles.png')