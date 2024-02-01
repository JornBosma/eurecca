%% Initialisation
close all
clear
clc

[~, fontsize, cbf, PHZ, SEDMEX] = eurecca_init;
% fontsize = 30; % ultra-wide screen


%% Monitoring period
% load UAV-survey meta data
load DEMsurveys.mat
SurveyDates = DEMsurveys.survey_date;
SurveyNames = DEMsurveys.name;

% Split the strings into words
words = split(SurveyNames);

% Rearrange the words
rearranged = [words(:, 2), words(:, 1)];

% Join the words back into strings
newNames = join(rearranged);
SurveyNames = newNames;

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

% Isolation
TThws = TTwater; % extract data above HWS threshold
TTlws = TTwater; % extract data below LWS threshold
TTmws = TTwater; % time series with values inside the bandwidth

TThws.eta(TTwater.eta <= PHZ.HWS) = NaN;
TTlws.eta(TTwater.eta >= PHZ.LWS) = NaN;
TTmws.eta(TTwater.eta > PHZ.HWS | TTwater.eta < PHZ.LWS) = NaN;

% Isolation (SEDMEX period)
TTmhw = TTwater; % extract data above MHW threshold during SEDMEX
TTmlw = TTwater; % extract data below MLW threshold during SEDMEX
TTmw = TTwater; % time series with values inside the bandwidth

TTmhw.eta(TTwater.eta <= SEDMEX.MeanHW) = NaN;
TTmlw.eta(TTwater.eta >= SEDMEX.MeanLW) = NaN;
TTmw.eta(TTwater.eta > SEDMEX.MeanHW | TTwater.eta < SEDMEX.MeanLW) = NaN;


%% Visualisation: 2019-2022
% f1 = figureRH;
% tiledlayout(3,1, 'TileSpacing','tight')
% 
% ax1 = nexttile;
% plot(TTmw.DateTime, TTmw.eta, 'Color','k'); hold on
% plot(TThw.DateTime, TThw.eta, 'Color','r')
% plot(TTlw.DateTime, TTlw.eta, 'Color','r')
% ylabel('η (NAP+m)')
% 
% text(datetime('03-Jan-2023'),PHZ.HWS, 'HWS', 'FontSize',fontsize)
% text(datetime('03-Jan-2023'),PHZ.LWS, 'LWS', 'FontSize',fontsize)
% for n = 1:length(SurveyDates)
%     xline(SurveyDates(n), '-k', SurveyNames(n), 'LineWidth',1, 'LabelHorizontalAlignment','left', 'FontSize',fontsize)
% end
% 
% ax2 = nexttile;
% plot(TTwind.DateTime, TTwind.spd, 'Color','k')
% ylabel('U_{wind} (m s^{-1})')
% 
% ax3 = nexttile;
% scatter(TTwind.DateTime, TTwind.dir, 6, 'k', 'filled')
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
f1 = figure('Position',[1722, 709, 1719, 628]);
plot(TTmws.DateTime, TTmws.eta, 'Color',cbf.blue); hold on
plot(TThws.DateTime, TThws.eta, 'Color',cbf.vermilion)
plot(TTlws.DateTime, TTlws.eta, 'Color',cbf.blue)
ylabel('η (NAP+m)')

text(datetime('03-Jan-2023'),PHZ.HWS, 'HWS', 'FontSize',fontsize)
text(datetime('03-Jan-2023'),PHZ.LWS, 'LWS', 'FontSize',fontsize)
yline(PHZ.HWS, '--', [], 'LineWidth',2)
yline(PHZ.LWS, '--', [], 'LineWidth',2)

for n = [2, 12:length(SurveyDates)]
    xline(SurveyDates(n), '-k', SurveyNames(n), 'LineWidth',1, 'LabelHorizontalAlignment','left', 'FontSize',fontsize)
end
for n = [1, 3:11]
    xline(SurveyDates(n), '-k', SurveyNames(n), 'LineWidth',1, 'LabelHorizontalAlignment','right', 'FontSize',fontsize)
end
% xline(SurveyDates(3), '-k', SurveyNames(3), 'LineWidth',1, 'LabelHorizontalAlignment','right', 'FontSize',fontsize)
% xline(SurveyDates(11), '-k', SurveyNames(11), 'LineWidth',1, 'LabelHorizontalAlignment','right', 'FontSize',fontsize)

xtickformat("MM/''yy")
% xtickangle(20)

xlim([datetime('01-Jan-2019') datetime('01-Jan-2023')])
grid off


%% SEDMEX
SEDMEXtime = [datetime('10-Sep-2021'), datetime('19-Oct-2021')];

dataPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor'...
    filesep 'hydrodynamics' filesep 'ADV' filesep 'L2C10VEC' filesep' 'tailored_L2C10VEC.nc'];

info = ncinfo(dataPath);
t_seconds = ncread(dataPath, 't'); % minutes since 2021-09-10 00:00:00
t = datetime('2021-09-01 00:00:00','InputFormat','yyyy-MM-dd HH:mm:ss')+seconds(t_seconds);
eta = ncread(dataPath, 'zs'); % water depth [m]
umag = ncread(dataPath, 'umag'); % velocity magnitude [m/s]
ucm = ncread(dataPath, 'ucm'); % mean cross-shore velocity magnitude [m/s]
ulm = ncread(dataPath, 'ulm'); % mean cross-shore velocity magnitude [m/s]
Hm0 = ncread(dataPath, 'Hm0'); % significant wave height [m]
puvdir = ncread(dataPath, 'puvdir'); % wave propagation direction [deg]

% puvdir(puvdir < 45 | puvdir > 45+180) = NaN; % remove impossible wave angles

% for n = 1:length(puvdir)
%     if puvdir(n)+180 > 360
%         puvdir(n) = puvdir(n)-180;
%     else
%         puvdir(n) = puvdir(n)+180;
%     end
% end

T_L2C10 = table(t, eta, umag, ucm, ulm, Hm0, puvdir);
TT_L2C10 = table2timetable(T_L2C10);

% Identify waves (SEDMEX period)
TTh_L2C10 = TT_L2C10; % extract data above mean+1std threshold during SEDMEX
TTl_L2C10 = TT_L2C10; % extract data below mean+1std threshold during SEDMEX

Hm0_threshold = mean(TT_L2C10.Hm0,'omitmissing')+2*std(TT_L2C10.Hm0,'omitmissing');
TTh_L2C10.Hm0(TT_L2C10.Hm0 <= Hm0_threshold) = NaN;
TTl_L2C10.Hm0(TT_L2C10.Hm0 > Hm0_threshold) = NaN;


%% Visualisation: SEDMEX
f2 = figureRH;
tiledlayout(6,1, 'TileSpacing','loose')

ax1 = nexttile;
plot(TTwind.DateTime, TTwind.spd, 'Color','k', 'LineWidth',2)
ylabel('U_{wind} (m s^{-1})')

ax2 = nexttile;
scatter(TTwind.DateTime, TTwind.dir, 20, 'k', 'filled'); hold on

% yline(45, '-', 'Color',cbf.redpurp, 'LineWidth',1) % longshore wind (northeastward)
yline(45+90, '-', 'Color','r', 'LineWidth',1) % onshore wind
% yline(45+180, '-', 'Color',cbf.redpurp, 'LineWidth',1) % longshore wind (southwestward)
cross = fill([SEDMEXtime, fliplr(SEDMEXtime)], [[45+135, 45+135], [45+45, 45+45]], cbf.redpurp, 'FaceAlpha',0.1, 'LineStyle','none');
longS = fill([SEDMEXtime, fliplr(SEDMEXtime)], [[45+180, 45+180], [45+135, 45+135]], cbf.vermilion, 'FaceAlpha',0.1, 'LineStyle','none');
longN = fill([SEDMEXtime, fliplr(SEDMEXtime)], [[45, 45], [45+45, 45+45]], cbf.vermilion, 'FaceAlpha',0.1, 'LineStyle','none'); hold off

ylabel('\theta_{wind} (\circ)')
ylim([0 360])
yticks(0:90:360)

legend([cross,longS],{'onshore','longshore'}, 'Location','northeastoutside', 'NumColumns',2)

ax3 = nexttile;
hold on
plot(TT_L2C10.t, TTl_L2C10.Hm0, 'Color','k', 'LineWidth',2)
plot(TT_L2C10.t, TTh_L2C10.Hm0, 'Color','r', 'LineWidth',2)
hold off
yline(Hm0_threshold, '--', '         \mu+2\sigma', 'LineWidth',2,...
    'FontSize',fontsize, 'LabelHorizontalAlignment','left')
ylabel('H_{m0} (m)')
yticks(0:.2:.6)

ax4 = nexttile;
scatter(TT_L2C10.t, TT_L2C10.puvdir, 10, 'k', 'filled'); hold on

% yline(45, '-', 'Color','r', 'LineWidth',1) % longshore wind (northeastward)
yline(45+90, '-', 'Color','r', 'LineWidth',1) % onshore wind
% yline(45+180, '-', 'Color','r', 'LineWidth',1) % longshore wind (southwestward)
cross = fill([SEDMEXtime, fliplr(SEDMEXtime)], [[45+135, 45+135], [45+45, 45+45]], cbf.redpurp, 'FaceAlpha',0.1, 'LineStyle','none');
longS = fill([SEDMEXtime, fliplr(SEDMEXtime)], [[45+180, 45+180], [45+135, 45+135]], cbf.vermilion, 'FaceAlpha',0.1, 'LineStyle','none');
longN = fill([SEDMEXtime, fliplr(SEDMEXtime)], [[45, 45], [45+45, 45+45]], cbf.vermilion, 'FaceAlpha',0.1, 'LineStyle','none'); hold off

ylabel('\theta_{wave} (\circ)')
ylim([45 225])
yticks(0:90:360)

ax5 = nexttile;
plot(TT_L2C10.t, TT_L2C10.ulm, 'Color','k', 'LineWidth',2); hold on
plot(TT_L2C10.t, TT_L2C10.ucm, 'Color','r', 'LineWidth',2); hold off
ylabel('U_{mag} (m s^{-1})')
legend('longshore', 'cross-shore', 'Location','northeastoutside', 'NumColumns',2)

ax6 = nexttile;
plot(TTmw.DateTime, TTmw.eta, 'Color','k', 'LineWidth',2); hold on
plot(TTmhw.DateTime, TTmhw.eta, 'Color','r', 'LineWidth',2)
plot(TTmlw.DateTime, TTmlw.eta, 'Color','k', 'LineWidth',2); hold off
ylabel('η (NAP+m)')

yline(SEDMEX.MeanHW, '--', 'MHW', 'LineWidth',2, 'FontSize',fontsize*.8)
yline(SEDMEX.MeanLW, '--', 'MLW', 'LineWidth',2, 'FontSize',fontsize*.8, 'LabelVerticalAlignment','bottom')
% text(SEDMEXtime(2)+hours(4),PHZ.HWS, '<-HWS', 'FontSize',fontsize)
% text(SEDMEXtime(2)+hours(4),PHZ.LWS, '<-LWS', 'FontSize',fontsize)

xlim([ax1 ax2 ax3 ax4 ax5 ax6], [SEDMEXtime(1), SEDMEXtime(2)])
xticks([ax1 ax2 ax3 ax4 ax5 ax6], SEDMEXtime(1):days(2):SEDMEXtime(2))
xticklabels([ax1 ax2 ax3 ax4 ax5], [])
xtickformat('MMM dd')
xtickangle(45)
grid([ax1 ax2 ax3 ax4 ax5 ax6],'on')
linkaxes([ax1 ax2 ax3 ax4 ax5 ax6], 'x')
zoom xon


%% Visualisation: UCM6
sampling_dates = [datetime('20-Sep-2021'), datetime('28-Sep-2021'),...
    datetime('01-Oct-2021'), datetime('07-Oct-2021'), datetime('15-Oct-2021')];

sampling_window = [sampling_dates', sampling_dates'];
for i = 1:length(sampling_dates)
    sampling_window(i,:) = [sampling_dates(i)+hours(8), sampling_dates(i)+hours(19)];
end

f2 = figure("Position",[1953, 1063, 1488, 274]);
hold on
plot(TT_L2C10.t, TTl_L2C10.Hm0, 'Color','k', 'LineWidth',2)
plot(TT_L2C10.t, TTh_L2C10.Hm0, 'Color','r', 'LineWidth',2)
xregion(sampling_window(:,1), sampling_window(:,2))
hold off
yline(Hm0_threshold, '--', '         \mu+2\sigma', 'LineWidth',2,...
    'FontSize',fontsize, 'LabelHorizontalAlignment','left')
ylabel('H_{m0} (m)')
yticks(0:.2:.6)

xlim([SEDMEXtime(1), SEDMEXtime(2)])
xticks(SEDMEXtime(1):days(2):SEDMEXtime(2))
xticklabels([])
xtickformat('MMM dd')
xtickangle(45)
grid('on')
zoom xon
