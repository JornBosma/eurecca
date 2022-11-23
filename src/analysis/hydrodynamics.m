%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize] = eurecca_init;

basePath = [filesep 'Volumes' filesep 'geo.data.uu.nl' filesep ...
    'research-eurecca' filesep 'FieldVisits' filesep ...
    '20210908_SEDMEX' filesep 'Data Descriptor'];

addpath([basePath filesep 'ADV'])

start = datetime('2021-09-10 19:00:00'); % UTC+2

L2C4 = ncinfo('L2C4VEC.nc');
t = ncread('L2C4VEC.nc', 't');
tv = start:minutes(10):start+minutes(t(end));

% L2C4
L2C4_U = ncread('L2C4VEC.nc', 'umag'); % flow-velocity magnitude (m/s)
L2C4_Ucross = ncread('L2C4VEC.nc', 'ucm'); % longshore flow-velocity (m/s)
L2C4_Ulong = ncread('L2C4VEC.nc', 'ulm'); % longshore flow-velocity (m/s)
L2C4_h = ncread('L2C4VEC.nc', 'd'); % water depth (m)
L2C4_Hm0 = ncread('L2C4VEC.nc', 'Hm0'); % significant wave height (m)

% L2C3
L2C3_U = ncread('L2C3VEC.nc', 'umag'); % flow-velocity magnitude (m/s)
L2C3_Ucross = ncread('L2C3VEC.nc', 'ucm'); % longshore flow-velocity (m/s)
L2C3_Ulong = ncread('L2C3VEC.nc', 'ulm'); % longshore flow-velocity (m/s)
L2C3_h = ncread('L2C3VEC.nc', 'd'); % water depth (m)
L2C3_Hm0 = ncread('L2C3VEC.nc', 'Hm0'); % significant wave height (m)

% L2C10
L2C10_U = ncread('L2C10VEC.nc', 'umag'); % flow-velocity magnitude (m/s)
L2C10_Ucross = ncread('L2C10VEC.nc', 'ucm'); % longshore flow-velocity (m/s)
L2C10_Ulong = ncread('L2C10VEC.nc', 'ulm'); % longshore flow-velocity (m/s)
L2C10_h = ncread('L2C10VEC.nc', 'd'); % water depth (m)
L2C10_Hm0 = ncread('L2C10VEC.nc', 'Hm0'); % significant wave height (m)

% L2C2
L2C2_U = ncread('L2C2VEC.nc', 'umag'); % flow-velocity magnitude (m/s)
L2C2_Ucross = ncread('L2C2VEC.nc', 'ucm'); % longshore flow-velocity (m/s)
L2C2_Ulong = ncread('L2C2VEC.nc', 'ulm'); % longshore flow-velocity (m/s)
L2C2_h = ncread('L2C2VEC.nc', 'd'); % water depth (m)
L2C2_Hm0 = ncread('L2C2VEC.nc', 'Hm0'); % significant wave height (m)

%% Visualisation
set(0, 'DefaultLineLineWidth', 3);
set(0, 'DefaultLineMarkerSize', 20);

p = (tv >= datetime('2021-09-12 00:00:00')) & (tv <= datetime('2021-09-28 23:59:59'));
p3 = p(31:end); % L2C3 31*10 min (= 5.1667 h) ahead of L2C4 & L2C10
p2 = p(15:end); % L2C2 15*10 min (= 2.5000 h) ahead of L2C4 & L2C10

figure2
tiledlayout(3, 1, 'TileSpacing', 'tight')

ax(1) = nexttile;
scatter(tv(p), L2C3_h(p3), 'filled'); hold on
scatter(tv(p), L2C4_h(p), 'filled')
scatter(tv(p), L2C10_h(p), 'filled')
scatter(tv(p), L2C2_h(p2), 'filled')
set(gca,'xticklabel',{[]})
ylabel('water depth (m)')
legend('L2C3', 'L2C4', 'L2C10', 'L2C2')

ax(2) = nexttile;
scatter(tv(p), L2C3_U(p3), 'filled'); hold on
scatter(tv(p), L2C4_U(p), 'filled')
scatter(tv(p), L2C10_U(p), 'filled')
scatter(tv(p), L2C2_U(p2), 'filled')
set(gca,'xticklabel',{[]})
ylabel('flow velocity (m s^{-1})')
legend('L2C3', 'L2C4', 'L2C10', 'L2C2')

ax(3) = nexttile;
scatter(tv(p), L2C3_Hm0(p3), 'filled'); hold on
scatter(tv(p), L2C4_Hm0(p), 'filled')
scatter(tv(p), L2C10_Hm0(p), 'filled')
scatter(tv(p), L2C2_Hm0(p2), 'filled')
ylabel('wave height (m)')
legend('L2C3', 'L2C4', 'L2C10', 'L2C2')

xlim(ax, [min(tv(p)) max(tv(p))])
linkaxes(ax, 'x')
