%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize] = eurecca_init;

% basePath = [filesep 'Volumes' filesep 'geo.data.uu.nl' filesep ...
%     'research-eurecca' filesep 'FieldVisits' filesep ...
%     '20210908_SEDMEX' filesep 'Data Descriptor'];

basePath = [filesep 'Volumes' filesep 'JWB' filesep 'Data Descriptor' filesep];

addpath(genpath([basePath filesep 'OSSI' filesep 'L4C3OSSI' filesep 'tailored' filesep]))

start = datetime('2021-09-10 19:00:00'); % UTC+2

% L4C3
L4C3 = ncinfo('L4C3OSSI.nc');
L4C3_d = ncread('L4C3OSSI.nc', 'd');
L4C3_zb = ncread('L4C3OSSI.nc', 'zb');
L4C3_h = L4C3_d - L4C3_zb;
L4C3_Hm0 = ncread('L4C3OSSI.nc', 'Hm0');

% L2C10
L2C10 = ncinfo('L2C10VEC.nc');
L2C10_U = ncread('L2C10VEC.nc', 'umag'); % flow-velocity magnitude (m/s)
L2C10_Ucross = ncread('L2C10VEC.nc', 'ucm'); % longshore flow-velocity (m/s)
L2C10_Ulong = ncread('L2C10VEC.nc', 'ulm'); % longshore flow-velocity (m/s)
L2C10_h = ncread('L2C10VEC.nc', 'd'); % water depth (m)
L2C10_Hm0 = ncread('L2C10VEC.nc', 'Hm0'); % significant wave height (m)

t = ncread('L2C10VEC.nc', 't');
tv = start:minutes(10):start+minutes(t(end));

%% Visualisation
p = (tv >= datetime('2021-09-10 19:00:00')) & (tv <= datetime('2021-10-18 9:50:00'));

f = figure;
tiledlayout(3, 1, 'TileSpacing', 'tight')

ax(1) = nexttile;
plot(tv(p), L4C3_h(p)-mean(L4C3_h), 'LineWidth', 2)
set(gca,'xticklabel',{[]})
ylabel('z (m +NAP)')

ax(2) = nexttile;
plot(tv(p), L2C10_Ulong(p), 'LineWidth', 2); hold on
plot(tv(p), L2C10_Ucross(p), 'LineWidth', 2)
set(gca,'xticklabel',{[]})
ylabel('U_{mag} (m s^{-1})')
legend('longshore', 'cross-shore', 'Location', 'eastoutside')

ax(3) = nexttile;
plot(tv(p), L4C3_Hm0(p), 'LineWidth', 2)
ylabel('H_{m0} (m)')

xlim(ax, [min(tv(p)) max(tv(p))])
linkaxes(ax, 'x')
grid(ax, "on")

% exportgraphics(f, 'sedmex_conditions.png')
