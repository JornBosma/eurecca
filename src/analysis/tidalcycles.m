%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize] = eurecca_init;

basePath = [filesep 'Volumes' filesep 'JWB' filesep 'Data Descriptor' filesep];

file1 = [basePath, '/OSSI/L2C6OSSI/tailored/L2C6OSSI.nc'];

start = datetime('2021-09-10 19:00:00'); % UTC+2

L2C6OSSI = ncinfo(file1);
z = ncread(file1, 'zs');
Hm0 = ncread(file1, 'Hm0');

t = ncread(file1, 't'); % minutes since 2021-09-10 19:00:00
tv = (start:minutes(10):start+minutes(t(end)))';

from = '2021-09-20 00:00:00';
to = '2021-09-20 23:59:59';

p = (tv >= datetime(from)) & (tv <= datetime(to)); % 20, 28, 7, 15

%% Visualisation
f = figure2;
tiledlayout(2, 1, 'TileSpacing', 'tight')

ax(1) = nexttile;
plot(tv(p), z(p), 'LineWidth', 2)
set(gca,'xticklabel',{[]})
ylabel('z (m +NAP)')
ylim([-1.5, 1.5])

ax(2) = nexttile;
plot(tv(p), Hm0(p), 'LineWidth', 2)
ylabel('H_{m0} (m)')

exportgraphics(f, 'tidalcycle.png')