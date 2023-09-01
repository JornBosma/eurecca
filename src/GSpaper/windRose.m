%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize, ~] = eurecca_init;

%% Wind climate: 1989-2019 (30 years) daily record

% load data
DeKooy1989 = readtable('DeKooy1989_2022_daily.txt', 'VariableNamingRule','preserve');

% set dates
startDate1989 = datetime(DeKooy1989.YYYYMMDD(1), 'ConvertFrom','yyyyMMdd');
endDate1989 = datetime(DeKooy1989.YYYYMMDD(end), 'ConvertFrom','yyyyMMdd');

% set wind rose options
Options1989 = WindRoseOptions(startDate1989, endDate1989, fontsize);

% generate wind rose
[f1, ~, ~, ~, ~, ~] = WindRose(DeKooy1989.DDVEC, DeKooy1989.FHVEC/10, Options1989);

% plot coastline orientation
line([-.6, -.065], [-.8, -.065], 'Color','r', 'LineStyle','--', 'LineWidth',5, 'DisplayName','coastline')
line([.065, .8], [.065, .6], 'Color','r', 'LineStyle','--', 'LineWidth',5, 'HandleVisibility','off')

%% Wind climate: 1989-2019 (30 years) hourly record
% 
% % load data
% DeKooy1989 = readtable('DeKooy1989_2022_hourly.txt', 'VariableNamingRule','preserve');
% 
% % set dates
% startDate1989 = datetime(DeKooy1989.YYYYMMDD(1), 'ConvertFrom','yyyyMMdd');
% endDate1989 = datetime(DeKooy1989.YYYYMMDD(end), 'ConvertFrom','yyyyMMdd');
% 
% % set wind rose options
% Options1989 = WindRoseOptions(startDate1989, endDate1989, fontsize);
% 
% % generate wind rose
% [~, ~, ~, ~, ~, ~] = WindRose(DeKooy1989.DD, DeKooy1989.FF/10, Options1989);
% 
% % plot coastline orientation
% line([-.6, -.065], [-.8, -.065], 'Color','r', 'LineStyle','--', 'LineWidth',5, 'DisplayName','coastline')
% line([.065, .8], [.065, .6], 'Color','r', 'LineStyle','--', 'LineWidth',5, 'HandleVisibility','off')

%% Monitoring period: 2019-2022 (3 years) daily record
% 
% % load data
% DeKooy2019 = readtable('DeKooy2019_2022_daily.txt', 'VariableNamingRule','preserve');
% 
% % set dates
% startDate2019 = datetime(DeKooy2019.YYYYMMDD(1), 'ConvertFrom','yyyyMMdd');
% endDate2019 = datetime(DeKooy2019.YYYYMMDD(end), 'ConvertFrom','yyyyMMdd');
% 
% % set wind rose options
% Options2019 = WindRoseOptions(startDate2019, endDate2019, fontsize);
% 
% % generate wind rose
% [~, ~, ~, ~, ~, ~] = WindRose(DeKooy2019.DDVEC, DeKooy2019.FHVEC/10, Options2019);
% 
% % plot coastline orientation
% line([-.6, -.065], [-.8, -.065], 'Color','r', 'LineStyle','--', 'LineWidth',5, 'DisplayName','coastline')
% line([.065, .8], [.065, .6], 'Color','r', 'LineStyle','--', 'LineWidth',5, 'HandleVisibility','off')

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

% plot coastline orientation
line([-.6, -.065], [-.8, -.065], 'Color','r', 'LineStyle','--', 'LineWidth',5, 'DisplayName','coastline')
line([.065, .8], [.065, .6], 'Color','r', 'LineStyle','--', 'LineWidth',5, 'HandleVisibility','off')

%% SEDMEX period: 6 Sep - 18 Oct 2021 (6 weeks) daily record
% 
% % load data
% DeKooySEDMEX = readtable('DeKooy_SEDMEX_daily.txt', 'VariableNamingRule','preserve');
% 
% % set dates
% startDateSEDMEX = datetime(DeKooySEDMEX.YYYYMMDD(1), 'ConvertFrom','yyyyMMdd');
% endDateSEDMEX = datetime(DeKooySEDMEX.YYYYMMDD(end), 'ConvertFrom','yyyyMMdd');
% 
% % set wind rose options
% OptionsSEDMEX = WindRoseOptions(startDateSEDMEX, endDateSEDMEX, fontsize);
% 
% % generate wind rose
% [~, ~, ~, ~, ~, ~] = WindRose(DeKooySEDMEX.DDVEC, DeKooySEDMEX.FHVEC/10, OptionsSEDMEX);
% 
% % plot coastline orientation
% line([-.6, -.065], [-.8, -.065], 'Color','r', 'LineStyle','--', 'LineWidth',5, 'DisplayName','coastline')
% line([.065, .8], [.065, .6], 'Color','r', 'LineStyle','--', 'LineWidth',5, 'HandleVisibility','off')

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

% plot coastline orientation
line([-.6, -.065], [-.8, -.065], 'Color','r', 'LineStyle','--', 'LineWidth',5, 'DisplayName','coastline')
line([.065, .8], [.065, .6], 'Color','r', 'LineStyle','--', 'LineWidth',5, 'HandleVisibility','off')
