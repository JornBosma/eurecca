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

%% Monitoring period: 2019-2022 (3 years) hourly record

% load data
DeKooy2019 = readtable('DeKooy2019_2022_hourly.txt', 'VariableNamingRule','preserve');

% set dates
startDate2019 = datetime(DeKooy2019.YYYYMMDD(1), 'ConvertFrom','yyyyMMdd');
endDate2019 = datetime(DeKooy2019.YYYYMMDD(end), 'ConvertFrom','yyyyMMdd');

% set wind rose options
Options2019 = WindRoseOptions(startDate2019, endDate2019, fontsize);

% generate wind rose
[f2, ~, ~, ~, ~, ~] = WindRose(DeKooy2019.DD, DeKooy2019.FF/10, Options2019);

% plot coastline orientations
line([cos(coastAngleN)*.1, cos(coastAngleN)], [sin(coastAngleN)*.1, sin(coastAngleN)], 'Color',cbf.vermilion, 'LineStyle',':', 'LineWidth',3, 'DisplayName','N beach')
line([-cos(coastAngleN), -cos(coastAngleN)*.1], [-sin(coastAngleN), -sin(coastAngleN)*.1], 'Color',cbf.vermilion, 'LineStyle',':', 'LineWidth',3, 'HandleVisibility','off')

line([cos(coastAngleS)*.1, cos(coastAngleS)], [sin(coastAngleS)*.1, sin(coastAngleS)], 'Color',cbf.blue, 'LineStyle',':', 'LineWidth',3, 'DisplayName','S beach')
line([-cos(coastAngleS), -cos(coastAngleS)*.1], [-sin(coastAngleS), -sin(coastAngleS)*.1], 'Color',cbf.blue, 'LineStyle',':', 'LineWidth',3, 'HandleVisibility','off')

hold off

%% SEDMEX period: 6 Sep - 18 Oct 2021 (6 weeks) hourly record

% load data
DeKooySEDMEX = readtable('DeKooy_SEDMEX_hourly.txt', 'VariableNamingRule','preserve');

% set dates
startDateSEDMEX = datetime(DeKooySEDMEX.YYYYMMDD(1), 'ConvertFrom','yyyyMMdd');
endDateSEDMEX = datetime(DeKooySEDMEX.YYYYMMDD(end), 'ConvertFrom','yyyyMMdd');

% set wind rose options
OptionsSEDMEX = WindRoseOptions(startDateSEDMEX, endDateSEDMEX, fontsize);

% generate wind rose
[f3, ~, ~, ~, ~, ~] = WindRose(DeKooySEDMEX.DD, DeKooySEDMEX.FF/10, OptionsSEDMEX);

% plot coastline orientations
line([cos(coastAngleN)*.1, cos(coastAngleN)], [sin(coastAngleN)*.1, sin(coastAngleN)], 'Color',cbf.vermilion, 'LineStyle',':', 'LineWidth',3, 'DisplayName','N beach')
line([-cos(coastAngleN), -cos(coastAngleN)*.1], [-sin(coastAngleN), -sin(coastAngleN)*.1], 'Color',cbf.vermilion, 'LineStyle',':', 'LineWidth',3, 'HandleVisibility','off')

line([cos(coastAngleS)*.1, cos(coastAngleS)], [sin(coastAngleS)*.1, sin(coastAngleS)], 'Color',cbf.blue, 'LineStyle',':', 'LineWidth',3, 'DisplayName','S beach')
line([-cos(coastAngleS), -cos(coastAngleS)*.1], [-sin(coastAngleS), -sin(coastAngleS)*.1], 'Color',cbf.blue, 'LineStyle',':', 'LineWidth',3, 'HandleVisibility','off')

hold off
