%% Initialisation
close all
clear
clc

eurecca_init

%% Wave statistics
waves = 'waveStats_solo1_11-30-2020_140000_12-04-2020_155000.nc'; % -0.985 m+NAP
% waves = 'waveStats_solo2_11-30-2020_140000_12-04-2020_155000.nc'; % -0.560 m+NAP
% waves = 'waveStats_solo4_11-30-2020_140000_12-04-2020_155000.nc'; % -0.635 m+NAP

info = ncinfo(waves);
t = ncread(waves, 't');
Hm0 = ncread(waves, 'Hm0');
Tp = ncread(waves, 'Tp');
zsmean = ncread(waves, 'zsmean');

% adjustments
Tp(Tp>10) = NaN;

% create time axis
startDateTime = {'2020-11-30 14:00:00'};
t0 = datetime(startDateTime, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
tAx = t0 + minutes(t);

%% Flow velocities
% current = 'vec1_pilot.nc'; % unreliable
current = 'vec2_pilot.nc';
% current = 'tailored_vec1_pilot.nc'; % unreliable
% current = 'tailored_vec2_pilot.nc'; % unreliable

info_c = ncinfo(current);
t_c = ncread(current, 't');
u = ncread(current, 'u');
v = ncread(current, 'v');
w = ncread(current, 'w');
zsmean_c = ncread(current, 'zsmean');

% create time axis
startDateTime_c = {'2020-11-30 16:00:00'};
t0_c = datetime(startDateTime_c, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
tAx_c = t0_c + minutes(t_c);

%% Visualisation
figure2
tl = tiledlayout(4, 1, 'TileSpacing', 'tight');

ax(1) = nexttile; plot(tAx, Hm0, 'LineWidth', 2)
yline(mean(Hm0, 'omitnan'), '--');
text(tAx(end), mean(Hm0, 'omitnan')+0.08, [num2str(mean(Hm0, 'omitnan'),...
    '%.2f'),' m'], 'FontSize', 14)
ylabel('H_{m0} (m)')

ax(2) = nexttile; plot(tAx, Tp, 'LineWidth', 2)
yline(mean(Tp, 'omitnan'), '--');
text(tAx(end), mean(Tp, 'omitnan')+1.1, [num2str(mean(Tp, 'omitnan'),...
    '%.2f'),' s'], 'FontSize', 14)
ylabel('T_p (s)')

ax(3) = nexttile; plot(tAx_c, sqrt(mean(u).^2 + mean(v).^2), 'LineWidth', 2)
ylabel('|u| (m s^{-1})')

ax(4) = nexttile; plot(tAx, zsmean, 'LineWidth', 2); hold on
plot(tAx_c, zsmean_c, '--', 'LineWidth', 2)
ylabel('\zeta_{tide} (m+NAP)')

title(tl, 'December 2020 pilot campaign', 'FontSize', 18)
% datetick('x','dd mmm','keepticks')
set(ax(1:3), 'XTickLabel', [])
% set(ax, 'XLim', [tAx(1) tAx(end)])
linkaxes(ax, 'x')
