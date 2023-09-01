%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize, ~] = eurecca_init;

% colourblind-friendly colour palette
orange = [230/255, 159/255, 0];
blue = [86/255, 180/255, 233/255];
yellow = [240/255, 228/255, 66/255];
redpurp = [204/255, 121/255, 167/255];
bluegreen = [0, 158/255, 115/255];

newcolors = crameri('-vik');
colours = newcolors(1:round(length(newcolors)/5):length(newcolors), :);

% load DEM
A = load('PHZ_2022_Q4','-mat');

% load track locations
dataPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor'...
    filesep 'topobathy' filesep 'transects' filesep 'PHZD.nc'];

n = 1;
for j = [1:3 5:7] % discard extra track 4
    file{n} = [dataPath, '/TRANSECTS/field_visits_projected_netcdf/alleen_loop/track' num2str(j-1) '.nc'];
    track{n} = ncinfo(file{n});
    x{n} = ncread(file{n}, 'x'); % xRD [m]
    y{n} = ncread(file{n}, 'y'); % yRD [m]
    d{n} = ncread(file{n}, 'd'); % x-shore distance [m]
    profiles{n} = ncread(file{n}, '__xarray_dataarray_variable__'); % depth [m]
    ID{n} = ncread(file{n}, 'ID'); % profile ID (seconds since 2020-10-16 12:56:53)
    range{n} = 1:length(ID{n});
    n = n+1;
end

tracknames = {'L$_1$','L$_2$','L$_3$','L$_4$','L$_5$','L$_6$'};

% sampling locations
LS_locx = [...
117530
117350
117095
116860
116610
116370
116140
115895
115630
115415];

LS_locy = [...
560005
559820
559620
559445
559250
559060
558870
558700
558400
558120];

%% Visualisation
B = A;
B.DEM.Z(B.DEM.Z<0) = NaN;
B.DEM.Z(B.DEM.Z>=0) = 1;

f0 = figure;
surf(B.DEM.X, B.DEM.Y, B.DEM.Z); hold on

% tracks
for n = 1:6
    line([x{n}(1) x{n}(end)], [y{n}(1) y{n}(end)], 'Color','red', 'LineStyle',':', 'LineWidth',3)
    text(x{n}(1)-20, y{n}(1)+80, tracknames{n}, 'FontSize',fontsize, 'Color','r')
end

shading flat
ax = gca; ax.SortMethod = 'childorder';
axis off; axis vis3d
view(46, 90)

clim([-6, 4])
colormap(flipud('gray'))

% North arrow
Narrow(fontsize)

%% Visualisation
B = A;
B.DEM.Z(B.DEM.Z<0) = NaN;
B.DEM.Z(B.DEM.Z>=0) = 1;

f1 = figure;
surf(B.DEM.X, B.DEM.Y, B.DEM.Z); hold on

% tracks
for n = 1:6
    line([x{n}(1) x{n}(end)], [y{n}(1) y{n}(end)], 'Color','red', 'LineStyle',':', 'LineWidth',3)
    text(x{n}(1)-20, y{n}(1)+80, tracknames{n}, 'FontSize',fontsize, 'Color','r')
end

% sampling locations
plot(LS_locx-150, LS_locy, 'o', 'MarkerSize',18, 'LineWidth',3)
text(LS_locx-280, LS_locy-20, num2cell(10:-1:1), 'FontSize', fontsize, 'Color',[0 0.4470 0.7410])

shading flat
ax = gca; ax.SortMethod = 'childorder';
axis off; axis vis3d
view(46, 90)

clim([-6, 4])
colormap(flipud('gray'))

% North arrow
Narrow(fontsize)
