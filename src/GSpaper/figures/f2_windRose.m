%% Initialisation
close all
clear
clc

[~, fontsize, cbf, ~] = eurecca_init;
% fontsize = 26; % ultra-wide screen

% plot coastline orientations
coastAngleNdeg = 50; % coastline angle northern beach [deg North]
coastAngleSdeg = 40; % coastline angle southern beach [deg North]

coastAngleN = deg2rad(90-coastAngleNdeg); % coastline angle northern beach [rad wrt East]
coastAngleS = deg2rad(90-coastAngleSdeg); % coastline angle southern beach [rad wrt East]

%% Wind climate: 1989-2019 (30 years) hourly record

% load data
DeKooy1989_1991 = readtable('DeKooy1989_1991_hourly.txt', 'VariableNamingRule','preserve');
DeKooy1992_2001 = readtable('DeKooy1992_2001_hourly.txt', 'VariableNamingRule','preserve');
DeKooy2002_2011 = readtable('DeKooy2002_2011_hourly.txt', 'VariableNamingRule','preserve');
DeKooy2012_2022 = readtable('DeKooy2012_2022_hourly.txt', 'VariableNamingRule','preserve');

% append data
DeKooy1989 = [DeKooy1989_1991; DeKooy1992_2001; DeKooy2002_2011; DeKooy2012_2022];
clear DeKooy1989_1991 DeKooy1992_2001 DeKooy2002_2011 DeKooy2012_2022

% set dates
startDate1989 = datetime(DeKooy1989.YYYYMMDD(1), 'ConvertFrom','yyyyMMdd');
endDate1989 = datetime(DeKooy1989.YYYYMMDD(end), 'ConvertFrom','yyyyMMdd');

% set wind rose options
Options1989 = WindRoseOptions(startDate1989, endDate1989, fontsize);

% generate wind rose
[f1, ~, ~, ~, ~, ~] = WindRose(DeKooy1989.DD, DeKooy1989.FF/10, Options1989);
f1.Position = [1849	213	1164 964];

% plot coastline orientations
line([cos(coastAngleS)*.1, cos(coastAngleS)], [sin(coastAngleS)*.1, sin(coastAngleS)], 'Color','k', 'LineStyle',':', 'LineWidth',4, 'DisplayName','S beach')
line([-cos(coastAngleS), -cos(coastAngleS)*.1], [-sin(coastAngleS), -sin(coastAngleS)*.1], 'Color','k', 'LineStyle',':', 'LineWidth',4, 'HandleVisibility','off')

line([cos(coastAngleN)*.1, cos(coastAngleN)], [sin(coastAngleN)*.1, sin(coastAngleN)], 'Color','k', 'LineStyle','--', 'LineWidth',4, 'DisplayName','Spit')
line([-cos(coastAngleN), -cos(coastAngleN)*.1], [-sin(coastAngleN), -sin(coastAngleN)*.1], 'Color','k', 'LineStyle','--', 'LineWidth',4, 'HandleVisibility','off')
hold off

