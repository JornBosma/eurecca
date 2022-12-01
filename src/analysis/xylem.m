%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize] = eurecca_init;

% data1 = importxylem("MRD01-210925-210929.xlsx", "MRD01-210925-210929", [19, 602]);
% data2 = importxylem("MRD01-210929-211001.xlsx", "MRD01-210929-211001", [19, 279]);
% data3 = importxylem("MRD01-211001-211015.xlsx", "MRD01-211001-211015", [19, 2057]);
% 
% data1{end, 1} = datetime(2021, 9, 29, 13, 50, 0, 'Format', 'dd-MMM-uuuu HH:mm:ss');
% data2{end, 1} = datetime(2021, 10, 1, 9, 20, 0, 'Format', 'dd-MMM-uuuu HH:mm:ss');
% 
% data = [data1; data2; data3];

load xylem_20210925_20211015
data = xylem_20210925_20211015;
clear xylem_20210925_20211015

temp1 = data{:, 2:end};
temp2 = data{:, 2:end} == 0;
temp1(temp2) = NaN;

data{:, 2:end} = temp1;

%% Visualisation
figure2
t = tiledlayout(2, 1, "TileSpacing", "tight");
title(t, 'Texelstroom wave stats', 'Interpreter', 'latex', 'FontSize', fontsize)

nexttile
scatter(data.RecordTime, data.SignificantWaveHeightHm0m, [], data.WaveMeanDirectionDegM, 'filled')
xlim([data.RecordTime(1), data.RecordTime(end)])
ylabel('H$_{s}$ (m)')
set(gca, 'XTickLabel', [])
grid on
grid minor

c = colorbar;
c.Ticks = 0:90:360;
c.TickLabels = {'north', 'east', 'south', 'west', 'north'};
c.TickLabelInterpreter = 'latex';
c.FontSize = fontsize;
clim([0, 360])
colormap(twilight_shifted)

nexttile
scatter(data.RecordTime, data.WaveMeanPeriodTm02s, 'filled')
xlim([data.RecordTime(1), data.RecordTime(end)])
ylabel('T$_{m02}$ (s)')
xlim([data.RecordTime(1), data.RecordTime(end)])
ylim([0, 10])
grid on
grid minor

% nexttile
% scatter(data.RecordTime, data.WaveMeanDirectionDegM, 'filled')
% xlim([data.RecordTime(1), data.RecordTime(end)])
% ylim([0, 360])
% ylabel('$\theta_{m}$ ($^{\circ}$)')
