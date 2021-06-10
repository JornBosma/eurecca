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
gx1 = geoaxes;
geolimits(gx1, [50.6532 53.6832], [2.2160 8.3687])
% geobasemap(gx, 'topographic')

%% Texel
figure('Name', 'Texel')
gx2 = geoaxes;
geolimits(gx2, [52.7267 53.2999], [4.2279 5.4140])
% geobasemap(gx2, 'topographic')

%% Prins Hendrikzanddijk
figure('Name', 'Prins Hendrikzanddijk')
gx3 = geoaxes;
geolimits(gx3, [52.9939 53.0404], [4.7617 4.8578])
% geobasemap(gx3, 'topographic')
