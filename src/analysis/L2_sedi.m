%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize] = eurecca_init;

% processed sedi samples
load('GS_L2C3_plus.mat') % 09/12 (SL) and 10/08 not exact same locations
load('GS_L2C5_plus.mat')

% gps-locations samples
load('GS_20210920_gps.mat')
load('GS_202109301013_gps.mat')

t = datetime('2021-09-16'):datetime('2021-10-16');
t2 = [datetime('2021-09-20 08:00:00'):hours(1):datetime('2021-09-20 11:00:00'),...
    datetime('2021-09-28 08:00:00'):hours(1):datetime('2021-09-28 11:00:00'),...
    datetime('2021-10-07 08:00:00'):hours(1):datetime('2021-10-07 11:00:00'),...
    datetime('2021-10-15 08:00:00'):hours(1):datetime('2021-10-15 10:00:00')];

aperture = [16000, 8000, 4750, 2000, 1180, 710,...
    500, 425, 355, 300, 250, 180, 125, 63, 31]; % sieve opening [mu]

MeasuringDates = {'2021-09-16';'2021-09-20';'2021-09-21';'2021-09-28';'2021-09-30';...
    '2021-10-01';'2021-10-02';'2021-10-06';'2021-10-07';'2021-10-08';'2021-10-11';...
    '2021-10-13';'2021-10-15'};

% MeasuringTimes = {'2021-09-20 08:00:00';'2021-09-20 09:00:00';'2021-09-20 10:00:00';...
%     '2021-09-20 11:00:00';'2021-09-28 08:00:00';'2021-09-28 09:00:00';...
%     '2021-09-28 10:00:00';'2021-09-28 11:00:00';'2021-10-07 08:00:00';...
%     '2021-10-07 09:00:00';'2021-10-07 10:00:00';'2021-10-07 11:00:00';...
%     '2021-10-15 08:00:00';'2021-10-15 09:00:00';'2021-10-15 10:00:00'};

MeasuringTimes = {'2021-09-20 08:00:00';'2021-09-20 09:00:00';...
    '2021-09-20 10:00:00';'2021-09-20 11:00:00'};

%% Necessary adjustments
GS = GS_L2C3_plus;
% GS = GS_L2C5_plus;

GSa = GS(1:end-1, 1);
GSb = GS(2:end, 2:end);
GSc = [GSa, GSb];
GSd = [GSc; GS(end, :)];
GSd{end, :} = 0;
GS = GSd;

%% L2CX (sedmex period)
MD = NaN([length(aperture) length(t)]);
MD(:, 1) = GS.Sep16;
MD(:, 5) = GS.Sep20a;
MD(:, 6) = GS.Sep21;
MD(:, 13) = GS.Sep28a;
MD(:, 15) = GS.Sep30;
MD(:, 16) = GS.Oct01;
MD(:, 17) = GS.Oct02;
MD(:, 21) = GS.Oct06;
MD(:, 22) = GS.Oct07a;
MD(:, 23) = GS.Oct08;
MD(:, 26) = GS.Oct11;
MD(:, 28) = GS.Oct13;
MD(:, 30) = GS.Oct15a;

f = figure2;
pcolor(t, aperture, MD)
shading flat

set(gca, 'YScale', 'log')
yticks(flip(aperture(2:end-1)))
ylabel('aperture (\mum)')
xticks(datetime(MeasuringDates))
xtickangle(45)

c = colorbar;
c.Label.String = 'cumulative mass (%)';
c.Label.FontSize = fontsize;
colormap(brewermap([], 'PuOr'))

% exportgraphics(f, 'L2C3_GS.png')

%% L2CX (tidal cycle)
MD2 = NaN([length(aperture) 19]);
MD2(:, 1) = GS.Sep20a;
MD2(:, 2) = GS.Sep20b;
MD2(:, 3) = GS.Sep20c;
MD2(:, 4) = GS.Sep20d;
MD2(:, 6) = GS.Sep28a;
MD2(:, 7) = GS.Sep28b;
MD2(:, 8) = GS.Sep28c;
MD2(:, 9) = GS.Sep28d;
MD2(:, 11) = GS.Oct07a;
MD2(:, 12) = GS.Oct07b;
MD2(:, 13) = GS.Oct07c;
MD2(:, 14) = GS.Oct07d;
MD2(:, 16) = GS.Oct15a;
MD2(:, 17) = GS.Oct15b;
MD2(:, 18) = GS.Oct15c;

f = figure2;
pcolor(1:19, aperture, MD2)
shading interp

set(gca, 'YScale', 'log')
yticks(flip(aperture(2:end-1)))
ylabel('aperture (\mum)')
xticks([2 7 12 17])
xticklabels({'Sep 20','Sep 28','Oct 7','Oct 15'})
xtickangle(45)

c = colorbar;
c.Label.String = 'cumulative mass (%)';
c.Label.FontSize = fontsize;
colormap(brewermap([], 'PuOr'))

% exportgraphics(f, 'L2C3_GS_tide.png')
