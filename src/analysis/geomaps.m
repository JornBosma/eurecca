%% Initialisation
close all
clear
clc

eurecca_init

%% Coordinates
lat_DeHors = 52.9922;
lon_DeHors = 4.7324;

lat_DenOever = 53.0390;
lon_DenOever = 4.8480;

lat_PHZD = 53.0172;
lon_PHZD = 4.8050;

%% Nederland
figure('Name', 'The Netherlands')
gx(1) = geoaxes;
geolimits(gx(1), [50.6532 53.6832], [2.2160 8.3687])
% gx(1).LatitudeLabel.Interpreter = 'latex';
% gx(1).LongitudeLabel.Interpreter = 'latex';
gx(1).LatitudeLabel.String = [];

%% Texel
figure('Name', 'Texel')
gx(2) = geoaxes;
geolimits(gx(2), [52.7267 53.2999], [4.2279 5.4140])
% gx(2).LatitudeLabel.Interpreter = 'latex';
% gx(2).LongitudeLabel.Interpreter = 'latex';
gx(2).LatitudeLabel.String = [];
gx(2).LongitudeLabel.String = [];

%% Prins Hendrikzanddijk
figure('Name', 'Prins Hendrikzanddijk')
gx(3) = geoaxes;
geolimits(gx(3), [52.9939 53.0404], [4.7617 4.8578])
% gx(3).LatitudeLabel.Interpreter = 'latex';
% gx(3).LongitudeLabel.Interpreter = 'latex';
gx(3).LongitudeLabel.String = '';

%% Collective map settings
set(gx, 'FontSize', 55)
set(gx, 'LabelFontSizeMultiplier', 1.3)
% set(gx, 'Basemap', 'topographic')
