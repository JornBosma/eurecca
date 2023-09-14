%% Initialisation
close all
clear
clc

[~, fontsize, cbf, PHZ] = eurecca_init;

%% Monitoring period
% load UAV-survey meta data
load DEMsurveys.mat
SurveyNames = DEMsurveys.name;
SurveyDates = DEMsurveys.survey_date;

% load KNMI De Kooy weather station data
DeKooy = readtable('DeKooy2019_2022_hourly.txt', 'VariableNamingRule','preserve');
DeKooy.("# STN") = []; % superfluous

DeKooy = renamevars(DeKooy,'YYYYMMDD','date');
DeKooy = renamevars(DeKooy,'H','time');
DeKooy = renamevars(DeKooy,'DD','dir'); % mean wind direction (in degrees) during the 10-minute period preceding the time of observation (360=north; 90=east; 180=south; 270=west; 0=calm 990=variable)
DeKooy = renamevars(DeKooy,'FF','spd'); % mean wind speed (in 0.1 m/s) during the 10-minute period preceding the time of observation
DeKooy = renamevars(DeKooy,'T','temp'); % temperature in 0.1 degrees Celsius at 1.50 m

DeKooy.date = datetime(DeKooy.date, 'ConvertFrom','yyyyMMDD');
DeKooy.time = hours(DeKooy.time);
DeKooy.DateTime = DeKooy.date + DeKooy.time;
DeKooy = removevars(DeKooy, {'date','time'});

DeKooy.dir(DeKooy.dir == 0) = NaN; % code for no wind
DeKooy.spd(DeKooy.dir == 0) = NaN;
DeKooy.dir(DeKooy.dir == 990) = NaN; % code for variable wind
DeKooy.spd(DeKooy.dir == 990) = NaN;

DeKooy.spd = DeKooy.spd/10; % convert 0.1 m/s to m/s
DeKooy.temp = DeKooy.temp/10; % convert 0.1 deg C to deg C
TTwind = table2timetable(DeKooy);

% load and prepare water-level data
Oudeschild = readtable('20230904_029.csv', 'Range','V1:Y213210', 'VariableNamingRule','preserve');
Oudeschild.('LIMIETSYMBOOL') = []; % superfluous
Oudeschild.NUMERIEKEWAARDE(Oudeschild.NUMERIEKEWAARDE>=999) = NaN; % error code

Oudeschild = renamevars(Oudeschild,'WAARNEMINGDATUM','date');
Oudeschild = renamevars(Oudeschild,'WAARNEMINGTIJD (MET/CET)','time');
Oudeschild = renamevars(Oudeschild,'NUMERIEKEWAARDE','eta');

Oudeschild.date = datetime(Oudeschild.date, 'InputFormat','dd-MM-yyyy');
Oudeschild.DateTime = Oudeschild.date + Oudeschild.time;
Oudeschild = removevars(Oudeschild, {'date','time'});

Oudeschild.eta = Oudeschild.eta/100; % convert cm to m
TTwater = table2timetable(Oudeschild);

% isolation
TThw = TTwater; % extract data above MHWS threshold
TTlw = TTwater; % extract data below MLWS threshold
TTmw = TTwater; % time series with only sub-threshold values

TThw.eta(TTwater.eta <= PHZ.MHWS) = NaN;
TTlw.eta(TTwater.eta >= PHZ.MLWS) = NaN;
TTmw.eta(TTwater.eta > PHZ.MHWS | TTwater.eta < PHZ.MLWS) = NaN;

%% Visualisation: 2019-2022
% f1 = figure;
% tiledlayout(3,1, 'TileSpacing','tight')
% 
% ax1 = nexttile;
% plot(TTmw.DateTime, TTmw.eta, 'Color',cbf.blue); hold on
% plot(TThw.DateTime, TThw.eta, 'Color',cbf.vermilion)
% plot(TTlw.DateTime, TTlw.eta, 'Color',cbf.vermilion)
% ylabel('\eta (m +NAP)')
% 
% text(datetime('03-Jan-2023'),PHZ.MHWS, 'MHWS', 'FontSize',fontsize*.8)
% text(datetime('03-Jan-2023'),PHZ.MLWS, 'MLWS', 'FontSize',fontsize*.8)
% for n = 1:length(SurveyDates)
%     xline(SurveyDates(n), '-k', SurveyNames(n), 'LineWidth',1, 'LabelHorizontalAlignment','left', 'FontSize',fontsize*.8)
% end
% 
% ax2 = nexttile;
% plot(TTwind.DateTime, TTwind.spd, 'Color',cbf.blue)
% ylabel('U_{wind} (m s^{-1})')
% 
% ax3 = nexttile;
% scatter(TTwind.DateTime, TTwind.dir, 6, cbf.blue, 'filled')
% ylabel('\theta_{wind} (\circ)')
% ylim([0 360])
% yticks(0:90:360)
% 
% xtickformat('MM/yy')
% xtickangle(20)
% 
% set([ax1 ax2], 'Xticklabel',[])
% xlim([ax1 ax2 ax3], [datetime('01-Jan-2019') datetime('01-Jan-2023')])
% grid([ax1 ax2 ax3],'on')
% % grid([ax1 ax2 ax3],'minor')
% linkaxes([ax1 ax2 ax3], 'x')
% zoom xon

%% Visualisation: 2019-2022
f1 = figure;
plot(TTmw.DateTime, TTmw.eta, 'Color',cbf.blue); hold on
plot(TThw.DateTime, TThw.eta, 'Color',cbf.vermilion)
plot(TTlw.DateTime, TTlw.eta, 'Color',cbf.vermilion)
ylabel('\eta (m +NAP)')

text(datetime('03-Jan-2023'),PHZ.MHWS, 'MHWS', 'FontSize',fontsize*.8)
text(datetime('03-Jan-2023'),PHZ.MLWS, 'MLWS', 'FontSize',fontsize*.8)
for n = 1:length(SurveyDates)
    xline(SurveyDates(n), '-k', SurveyNames(n), 'LineWidth',1, 'LabelHorizontalAlignment','left', 'FontSize',fontsize*.8)
end

xtickformat('MM/yy')
xtickangle(20)

xlim([datetime('01-Jan-2019') datetime('01-Jan-2023')])
grid on

%% SEDMEX
SEDMEX = [datetime('10-Sep-2021'), datetime('19-Oct-2021')];

dataPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor'...
    filesep 'hydrodynamics' filesep 'ADV' filesep 'L2C10VEC' filesep' 'tailored_L2C10VEC.nc'];

info = ncinfo(dataPath);
t_minutes = ncread(dataPath, 't'); % minutes since 2021-09-10 00:00:00
t = datetime('2021-09-10 00:00:00','InputFormat','yyyy-MM-dd HH:mm:ss')+minutes(t_minutes);
eta = ncread(dataPath, 'zs'); % water depth [m]
umag = ncread(dataPath, 'umag'); % velocity magnitude [m/s]
ucm = ncread(dataPath, 'ucm'); % mean cross-shore velocity magnitude [m/s]
ulm = ncread(dataPath, 'ulm'); % mean cross-shore velocity magnitude [m/s]
Hm0 = ncread(dataPath, 'Hm0'); % significant wave height [m]
puvdir = ncread(dataPath, 'puvdir'); % wave propagation direction [deg]

puvdir(puvdir < 45 | puvdir > 45+180) = NaN; % remove impossible wave angles

% for n = 1:length(puvdir)
%     if puvdir(n)+180 > 360
%         puvdir(n) = puvdir(n)-180;
%     else
%         puvdir(n) = puvdir(n)+180;
%     end
% end

T_L2C10 = table(t, eta, umag, ucm, ulm, Hm0, puvdir);
TT_L2C10 = table2timetable(T_L2C10);

%% Visualisation: SEDMEX
f2 = figure;
tiledlayout(6,1, 'TileSpacing','loose')

ax1 = nexttile;
plot(TTwind.DateTime, TTwind.spd, 'Color',cbf.blue)
ylabel('U_{wind} (m s^{-1})')

ax2 = nexttile;
scatter(TTwind.DateTime, TTwind.dir, 10, cbf.blue, 'filled'); hold on

yline(45, ':', 'Color',cbf.vermilion) % longshore wind (northeastward)
yline(45+90, '--', 'Color',cbf.vermilion) % onshore wind
yline(45+180, ':', 'Color',cbf.vermilion) % longshore wind (southwestward)
cross = fill([SEDMEX, fliplr(SEDMEX)], [[45+135, 45+135], [45+45, 45+45]], cbf.vermilion, 'FaceAlpha',0.1, 'LineStyle','none');
longS = fill([SEDMEX, fliplr(SEDMEX)], [[45+180, 45+180], [45+135, 45+135]], cbf.redpurp, 'FaceAlpha',0.1, 'LineStyle','none');
longN = fill([SEDMEX, fliplr(SEDMEX)], [[45, 45], [45+45, 45+45]], cbf.redpurp, 'FaceAlpha',0.1, 'LineStyle','none'); hold off

ylabel('\theta_{wind} (\circ)')
ylim([0 360])
yticks(0:90:360)
legend([cross,longS],{'onshore','longshore'}, 'Location','northeast', 'NumColumns',1)

ax3 = nexttile;
plot(TT_L2C10.t, TT_L2C10.Hm0, 'Color',cbf.blue)
ylabel('H_{m0} (m)')
yticks(0:.2:.6)

ax4 = nexttile;
scatter(TT_L2C10.t, TT_L2C10.puvdir, 5, cbf.blue, 'filled'); hold on

yline(45, ':', 'Color',cbf.vermilion) % longshore wind (northeastward)
yline(45+90, '--', 'Color',cbf.vermilion) % onshore wind
yline(45+180, ':', 'Color',cbf.vermilion) % longshore wind (southwestward)
cross = fill([SEDMEX, fliplr(SEDMEX)], [[45+135, 45+135], [45+45, 45+45]], cbf.vermilion, 'FaceAlpha',0.1, 'LineStyle','none');
longS = fill([SEDMEX, fliplr(SEDMEX)], [[45+180, 45+180], [45+135, 45+135]], cbf.redpurp, 'FaceAlpha',0.1, 'LineStyle','none');
longN = fill([SEDMEX, fliplr(SEDMEX)], [[45, 45], [45+45, 45+45]], cbf.redpurp, 'FaceAlpha',0.1, 'LineStyle','none'); hold off

ylabel('\theta_{wave} (\circ)')
ylim([0 360])
yticks(0:90:360)

ax5 = nexttile;
plot(TT_L2C10.t, TT_L2C10.ulm, 'Color',cbf.blue); hold on
plot(TT_L2C10.t, TT_L2C10.ucm, 'Color',cbf.vermilion); hold off
ylabel('U_{mag} (m s^{-1})')
legend('longshore', 'cross-shore', 'Location','northeast', 'NumColumns',1)

ax6 = nexttile;
plot(TTmw.DateTime, TTmw.eta, 'Color',cbf.blue); hold on
plot(TThw.DateTime, TThw.eta, 'Color',cbf.vermilion)
plot(TTlw.DateTime, TTlw.eta, 'Color',cbf.vermilion); hold off
ylabel('\eta (m +NAP)')

yline(PHZ.MHWS, '--', 'MHWS', 'LineWidth',1, 'FontSize',fontsize*.7)
yline(PHZ.MLWS, '--', 'MLWS', 'LineWidth',1, 'FontSize',fontsize*.7)
% text(SEDMEX(2)+hours(4),PHZ.MHWS, '<-MHWS', 'FontSize',fontsize*.8)
% text(SEDMEX(2)+hours(4),PHZ.MLWS, '<-MLWS', 'FontSize',fontsize*.8)

xlim([ax1 ax2 ax3 ax4 ax5 ax6], [SEDMEX(1), SEDMEX(2)])
xticks([ax1 ax2 ax3 ax4 ax5 ax6], SEDMEX(1):days(2):SEDMEX(2))
xticklabels([ax1 ax2 ax3 ax4 ax5], [])
xtickformat('MMM dd')
xtickangle(45)
grid([ax1 ax2 ax3 ax4 ax5 ax6],'on')
linkaxes([ax1 ax2 ax3 ax4 ax5 ax6], 'x')
zoom xon
