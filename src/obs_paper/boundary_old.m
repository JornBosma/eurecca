%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize, ~] = eurecca_init;

% water levels @ PHZ
MHWS = 0.81; % mean high water spring [m]
MLWS = -1.07; % mean low water spring [m]
MSL = 0; % mean sea level [m]
NAP = MSL-0.1; % local reference datum [m]

load DEMsurveys.mat
SurveyNames = DEMsurveys.name;
SurveyDates = DEMsurveys.survey_date;

%% Prepare Xylem data
load Xylem210114_210415.mat
load Xylem210925_220119.mat

TTxyl1 = table2timetable(Xylem210114_210415);
TTxyl2 = table2timetable(Xylem210925_220119);

TTxyl1(TTxyl1.Time>=datetime('2021-02-20 09:40:00'), 32:36) = {NaN}; % weather station malfunction

%% Preparation (1/3)
load oud_wathte.mat
Toud = wathte;

Date = datetime(cellstr(Toud.WAARNEMINGDATUM), 'InputFormat','dd-MM-yyyy');
Time = datetime(Toud.WAARNEMINGTIJDMETCET, 'InputFormat','HH:mm:ss');
DT = Date + timeofday(Time);
% DT = T.WAARNEMINGDATUM + timeofday(T.WAARNEMINGTIJDMETCET);

Toud.NUMERIEKEWAARDE(Toud.NUMERIEKEWAARDE>999) = NaN;

TToud = table2timetable(Toud(:,'NUMERIEKEWAARDE'), 'RowTimes',DT);
TToud.NUMERIEKEWAARDE = TToud.NUMERIEKEWAARDE/100; % convert cm to m
TToud = renamevars(TToud,'NUMERIEKEWAARDE','eta_m');

%% Preparation (2/3)
% Strangely enough, there is a gap in the waterinfo data from 04/2022 to 05/2023
% but the data file that Tim received does contain that part

load eta_Oudeschild.mat
Toud2 = eta_Oudeschild;

DT2 = datetime([Toud2.year Toud2.month Toud2.day Toud2.hour Toud2.minute Toud2.second]);

Toud2.eta(Toud2.eta>=999) = NaN;

TToud2 = table2timetable(Toud2(:,'eta'), 'RowTimes',DT2);
TToud2.eta = TToud2.eta/100; % convert cm to m
TToud2 = renamevars(TToud2,'eta','eta_m');

%% Preparation (3/3)
TToud(TToud.Time>='01-Apr-2022', :) = [];
TToud = [TToud;TToud2(TToud2.Time>='01-Apr-2022', :)];

%% KNMI wind data
load wind_DeKooy.mat

DateDK = datetime(wind_DeKooy.YYYYMMDD, 'ConvertFrom','yyyyMMdd');
DT_DK = DateDK + hours(wind_DeKooy.H-1);

wind_DeKooy.DD(wind_DeKooy.DD==0) = NaN;
wind_DeKooy.DD(wind_DeKooy.DD==990) = NaN;

TTdekooy = table2timetable([wind_DeKooy(:,'DD') wind_DeKooy(:,'FF')], 'RowTimes',DT_DK);

%% Visualisation
threshold1 = MHWS;
threshold2 = MLWS;

f0 = figure;
tiledlayout(4,1, 'TileSpacing','compact')

ax1 = nexttile;
plot(TToud.Time, TToud.eta_m, 'Color',blue); hold on
plot(TToud.Time(TToud.eta_m>threshold1), TToud.eta_m(TToud.eta_m>threshold1), '.', 'MarkerSize',1, 'Color',orange)
plot(TToud.Time(TToud.eta_m<threshold2), TToud.eta_m(TToud.eta_m<threshold2), '.', 'MarkerSize',1, 'Color',orange)
text(datetime('03-Jan-2023'),MHWS, 'MHWS', 'FontSize',fontsize)
text(datetime('03-Jan-2023'),MLWS, 'MLWS', 'FontSize',fontsize)
for n = 1:length(SurveyDates)
    xregion(SurveyDates(n), SurveyDates(n)+day(7))
    text(SurveyDates(n)+day(3.5),3, SurveyNames(n), 'FontSize',fontsize, 'HorizontalAlignment','center', 'Rotation',25)
end
ylabel('$\eta$ (m +NAP)')

ax2 = nexttile;
yyaxis left
plot(TTdekooy.Time, TTdekooy.FF)
ylabel('u$_{10}$ (m)', 'Color','k')
yyaxis right
scatter(TTdekooy.Time, TTdekooy.DD, '.')
ylim([0 360])
yticklabels([0, 180, 360])
ylabel('dir ($^{\circ}$)', 'Color','k')

ax3 = nexttile;
scatter(TTxyl1.Time, TTxyl1.MRD01TEXELAverageCorrectedWindSpeedmsDCSNA, 1, TTxyl1.MRD01TEXELAverageCorrectedWindDirectionDegDCSNA); hold on
scatter(TTxyl2.Time, TTxyl2.AverageCorrectedWindSpeedms, 1, TTxyl2.AverageCorrectedWindDirectionDeg)
ylabel('U$_{10}$ (m s$^{-1}$)')

c = colorbar;
c.Ticks = 0:90:360;
c.TickLabels = {'north', 'east', 'south', 'west', 'north'};
c.TickLabelInterpreter = 'latex';
c.FontSize = fontsize;
clim([0, 360])
colormap(hsv)

ax4 = nexttile;
scatter(TTxyl1.Time, TTxyl1.MRD01TEXELSignificantWaveHeightHm0mMotusNA, 1, TTxyl1.MRD01TEXELWaveMeanDirectionDegMMotusNA); hold on
scatter(TTxyl2.Time, TTxyl2.SignificantWaveHeightHm0m, 1, TTxyl2.WaveMeanDirectionDegM)
ylabel('H$_{m0}$ (m)')

set([ax1 ax2 ax3], 'Xticklabel',[]) 
xlim([ax1 ax2 ax3 ax4], [datetime('01-Jun-2019') datetime('31-Dec-2022')])
grid([ax1 ax2 ax3 ax4],'on')
grid([ax1 ax2 ax3 ax4],'minor')
linkaxes([ax1 ax2 ax3 ax4], 'x')
zoom xon

%% Visualisation
threshold1 = MHWS;
threshold2 = MLWS;
TToud.eta_m(~isfinite(TToud.eta_m)) = 0;

f1 = figure;
plot(TToud.Time, TToud.eta_m, 'Color','k'); hold on
% plot(TToud.Time(TToud.eta_m>threshold1), TToud.eta_m(TToud.eta_m>threshold1), '.', 'MarkerSize',1, 'Color','r')
% plot(TToud.Time(TToud.eta_m<threshold2), TToud.eta_m(TToud.eta_m<threshold2), '.', 'MarkerSize',1, 'Color','r')
text(datetime('03-Jan-2023'),MHWS, 'MHWS', 'FontSize',fontsize)
text(datetime('03-Jan-2023'),MLWS, 'MLWS', 'FontSize',fontsize)

[up,lo] = envelope(TToud.eta_m, 2000, 'peak');
hold on
plot(TToud.Time,up,'r', TToud.Time,lo,'r', 'linewidth',6)
% legend('q','up','lo')
hold off

% for n = 1:length(SurveyDates)
%     xregion(SurveyDates(n), SurveyDates(n)+day(7))
%     text(SurveyDates(n)+day(3.5),2.6, SurveyNames(n), 'FontSize',fontsize, 'HorizontalAlignment','center', 'Rotation',25)
% end
ylabel('$\eta$ (m +NAP)')

xlim([datetime('01-Jun-2019') datetime('31-Dec-2022')])
ylim([-2 2.5])
grid on
grid minor
zoom xon
box off
