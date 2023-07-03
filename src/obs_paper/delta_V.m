%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize, basePath] = eurecca_init;

% colourblind-friendly colours
orange = [230/255, 159/255, 0];
blue = [86/255, 180/255, 233/255];
yellow = [240/255, 228/255, 66/255];
redpurp = [204/255, 121/255, 167/255];
bluegreen = [0, 158/255, 115/255];

% water levels
MHWS = 0.81; % mean high water spring [m]
MLWS = -1.07; % mean low water spring [m]
MSL = 0; % mean sea level [m]
NAP = MSL-0.1; % local reference datum [m]

% load DEMs
wb = waitbar(0, 'Loading DEMs');
wb.Children.Title.Interpreter = 'none';
DEMP = [basePath 'data' filesep 'elevation' filesep 'processed' filesep];
DEMS = dir(fullfile(DEMP,'PHZ*.mat'));
for k = 1:numel(DEMS)
    DEMS(k).data = load(DEMS(k).name);
    waitbar(k/numel(DEMS), wb, sprintf('Loading DEMs: %d%%', floor(k/numel(DEMS)*100)));
    pause(0.1)
end
close(wb)

load DEMsurveys.mat
SurveyDates = DEMsurveys.survey_date;

% settings
pgns = getPolygons;
contourLevels = [MHWS, MSL];

%% Calculations
totalVolume = NaN(length(DEMS), 1);
volumeChange = NaN(length(DEMS)-1, 1);

wb = waitbar(0, 'Computing volume changes');
wb.Children.Title.Interpreter = 'none';
for k = 2:numel(DEMS)
    % A = DEMS(1).data; % relative to first survey
    A = DEMS(k-1).data; % relative previous survey
    B = DEMS(k).data;

    totalVolume(k-1) = getVbetweenContoursInPolygon(A, contourLevels, pgns.north, 'sum');

    volumeChange(k-1) = getVbetweenContoursInPolygon(B, contourLevels, pgns.north, 'sum') - ...
               getVbetweenContoursInPolygon(A, contourLevels, pgns.north, 'sum');

    waitbar(k/numel(DEMS), wb, sprintf('Computing volume changes: %d%%', floor(k/numel(DEMS)*100)));
    pause(0.1)
end
close(wb)

%%
[dQ_Nspit,dQ_spit,dQ_Sbeach,dQ_beach,dQ_tot] = deal(nan(numel(dV), 1));
[dQ_Nspit_pos,dQ_spit_pos,dQ_Sbeach_pos,dQ_beach_pos,dQ_tot_pos] = deal(nan(numel(dV), 1));
[dQ_Nspit_neg,dQ_spit_neg,dQ_Sbeach_neg,dQ_beach_neg,dQ_tot_neg] = deal(nan(numel(dV), 1));

for k = 1:numel(dV)
    dQ_Nspit(k) = dV{k}.Net(1);
    dQ_spit(k) = dV{k}.Net(2);
    dQ_Sbeach(k) = dV{k}.Net(3);
    dQ_beach(k) = dV{k}.Net(4);
    dQ_tot(k) = dV{k}.Net(5);

    dQ_Nspit_pos(k) = dV{k}.Sedimentation(1);
    dQ_spit_pos(k) = dV{k}.Sedimentation(2);
    dQ_Sbeach_pos(k) = dV{k}.Sedimentation(3);
    dQ_beach_pos(k) = dV{k}.Sedimentation(4);
    dQ_tot_pos(k) = dV{k}.Sedimentation(5);

    dQ_Nspit_neg(k) = dV{k}.Erosion(1);
    dQ_spit_neg(k) = dV{k}.Erosion(2);
    dQ_Sbeach_neg(k) = dV{k}.Erosion(3);
    dQ_beach_neg(k) = dV{k}.Erosion(4);
    dQ_tot_neg(k) = dV{k}.Erosion(5);
end

dQ_Nspit = [0;dQ_Nspit];
dQ_spit = [0;dQ_spit];
dQ_Sbeach = [0;dQ_Sbeach];
dQ_beach = [0;dQ_beach];
dQ_tot = [0;dQ_tot];

T = table(SurveyDates, dQ_Nspit, dQ_spit, dQ_Sbeach, dQ_beach, dQ_tot);
TT = table2timetable(T);

dQ_Nspit_pos = [0;dQ_Nspit_pos];
dQ_spit_pos = [0;dQ_spit_pos];
dQ_Sbeach_pos = [0;dQ_Sbeach_pos];
dQ_beach_pos = [0;dQ_beach_pos];
dQ_tot_pos = [0;dQ_tot_pos];

T_pos = table(SurveyDates, dQ_Nspit_pos, dQ_spit_pos, dQ_Sbeach_pos, dQ_beach_pos, dQ_tot_pos);
TT_pos = table2timetable(T_pos);

dQ_Nspit_neg = [0;dQ_Nspit_neg];
dQ_spit_neg = [0;dQ_spit_neg];
dQ_Sbeach_neg = [0;dQ_Sbeach_neg];
dQ_beach_neg = [0;dQ_beach_neg];
dQ_tot_neg = [0;dQ_tot_neg];

T_neg = table(SurveyDates, dQ_Nspit_neg, dQ_spit_neg, dQ_Sbeach_neg, dQ_beach_neg, dQ_tot_neg);
TT_neg = table2timetable(T_neg);

%% Visualisation
f0 = figure;
tiledlayout(1,2, 'TileSpacing','tight')

ax1 = nexttile;
plot(TT_pos.SurveyDates, TT_pos.dQ_beach_pos,'o:', 'Color',orange, 'LineWidth',4, 'MarkerSize',10, 'MarkerFaceColor','k'); hold on
plot(TT_pos.SurveyDates, TT_neg.dQ_beach_neg,'o:', 'Color',blue, 'LineWidth',4, 'MarkerSize',10, 'MarkerFaceColor','k')
area(TT_pos.SurveyDates, TT_pos.dQ_beach_pos, 'FaceColor',orange, 'FaceAlpha',0.2, 'EdgeColor','none')
area(TT_neg.SurveyDates, TT_neg.dQ_beach_neg, 'FaceColor',blue, 'FaceAlpha',0.2, 'EdgeColor','none')
yline(0, 'LineWidth',3)
% title('beach face')
legend('sedimentation', 'erosion', 'Location','northeast')

ax1.XColor = yellow;
ax1.YColor = yellow;
ax1.XRuler.Axle.LineWidth = 6;
ax1.YRuler.Axle.LineWidth = 6;
ylabel('$\Delta$Q (m$^3$)', 'Color','k')

ax2 = nexttile;
plot(TT_pos.SurveyDates, TT_pos.dQ_Nspit_pos,'o:', 'Color',orange, 'LineWidth',4, 'MarkerSize',10, 'MarkerFaceColor','k'); hold on
plot(TT_pos.SurveyDates, TT_neg.dQ_Nspit_neg,'o:', 'Color',blue, 'LineWidth',4, 'MarkerSize',10, 'MarkerFaceColor','k')
area(TT_pos.SurveyDates, TT_pos.dQ_Nspit_pos, 'FaceColor',orange, 'FaceAlpha',0.2, 'EdgeColor','none')
area(TT_neg.SurveyDates, TT_neg.dQ_Nspit_neg, 'FaceColor',blue, 'FaceAlpha',0.2, 'EdgeColor','none')
yline(0, 'LineWidth',3)
% title('northern tip spit')

ax2.XColor = redpurp;
ax2.YColor = redpurp;
ax2.XRuler.Axle.LineWidth = 6;
ax2.YRuler.Axle.LineWidth = 6;

xticks([ax1 ax2], [datetime('2019','Inputformat','yyyy') datetime('2020','Inputformat','yyyy') datetime('2021','Inputformat','yyyy') datetime('2022','Inputformat','yyyy') datetime('2023','Inputformat','yyyy')])
xtickformat([ax1 ax2], 'yyyy')
yticklabels(ax2, {})
linkaxes([ax1 ax2])

grid([ax1 ax2], 'on')
grid([ax1 ax2], 'minor')

%% Visualisation
f1 = figure;
b1 = bar(TT.SurveyDates, [TT_pos.dQ_Nspit_pos, TT_pos.dQ_spit_pos, TT_pos.dQ_Sbeach_pos], 'stacked'); hold on
b2 = bar(TT.SurveyDates, [TT_neg.dQ_Nspit_neg, TT_neg.dQ_spit_neg, TT_neg.dQ_Sbeach_neg], 'stacked');
plot(TT.SurveyDates, TT.dQ_tot, 'r', 'LineWidth',10); hold off

b1(1).FaceColor = 'flat';
b1(1).CData = redpurp;
b2(1).FaceColor = 'flat';
b2(1).CData = redpurp;

b1(2).FaceColor = 'flat';
b1(2).CData = yellow;
b2(2).FaceColor = 'flat';
b2(2).CData = yellow;

b1(3).FaceColor = 'flat';
b1(3).CData = blue;
b2(3).FaceColor = 'flat';
b2(3).CData = blue;

ylabel('$\Delta$Q (m$^3$)')
legend('spit tip','spit beach','south beach','','','','total')

%% Visualisation
f2 = figure;
b1 = bar(TT.SurveyDates, [cumsum(TT_pos.dQ_Nspit_pos), cumsum(TT_pos.dQ_spit_pos), cumsum(TT_pos.dQ_Sbeach_pos)], 'stacked'); hold on
b2 = bar(TT.SurveyDates, [cumsum(TT_neg.dQ_Nspit_neg), cumsum(TT_neg.dQ_spit_neg), cumsum(TT_neg.dQ_Sbeach_neg)], 'stacked');
plot(TT.SurveyDates, cumsum(TT.dQ_tot), 'r', 'LineWidth',10); hold off

b1(1).FaceColor = 'flat';
b1(1).CData = redpurp;
b2(1).FaceColor = 'flat';
b2(1).CData = redpurp;

b1(2).FaceColor = 'flat';
b1(2).CData = yellow;
b2(2).FaceColor = 'flat';
b2(2).CData = yellow;

b1(3).FaceColor = 'flat';
b1(3).CData = blue;
b2(3).FaceColor = 'flat';
b2(3).CData = blue;

ylabel('$\Delta$Q (m$^3$)')
legend('spit tip','spit beach','south beach','','','','total')

%% Visualisation
f3 = figure;
tiledlayout(2,1, 'TileSpacing','tight')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nexttile
b1 = bar(TT.SurveyDates, [TT_pos.dQ_Nspit_pos, TT_pos.dQ_spit_pos, TT_pos.dQ_Sbeach_pos], 'stacked'); hold on
b2 = bar(TT.SurveyDates, [TT_neg.dQ_Nspit_neg, TT_neg.dQ_spit_neg, TT_neg.dQ_Sbeach_neg], 'stacked');
plot(TT.SurveyDates, TT.dQ_tot, 'r', 'LineWidth',10); hold off
xticklabels({})

xregion(TT.SurveyDates(1), TT.SurveyDates(3)) % initial rapid response
xregion(datetime('10-Sep-2021'), datetime('18-Oct-2021')) % SEDMEX

b1(1).FaceColor = 'flat';
b1(1).CData = redpurp;
b2(1).FaceColor = 'flat';
b2(1).CData = redpurp;

b1(2).FaceColor = 'flat';
b1(2).CData = yellow;
b2(2).FaceColor = 'flat';
b2(2).CData = yellow;

b1(3).FaceColor = 'flat';
b1(3).CData = blue;
b2(3).FaceColor = 'flat';
b2(3).CData = blue;

ylabel('$\Delta$Q (m$^3$)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nexttile
b1 = bar(TT.SurveyDates, [cumsum(TT_pos.dQ_Nspit_pos), cumsum(TT_pos.dQ_spit_pos), cumsum(TT_pos.dQ_Sbeach_pos)], 'stacked'); hold on
b2 = bar(TT.SurveyDates, [cumsum(TT_neg.dQ_Nspit_neg), cumsum(TT_neg.dQ_spit_neg), cumsum(TT_neg.dQ_Sbeach_neg)], 'stacked');
plot(TT.SurveyDates, cumsum(TT.dQ_tot), 'r', 'LineWidth',10); hold off

xregion(TT.SurveyDates(1), TT.SurveyDates(3)) % initial rapid response
xregion(datetime('10-Sep-2021'), datetime('18-Oct-2021')) % SEDMEX

b1(1).FaceColor = 'flat';
b1(1).CData = redpurp;
b2(1).FaceColor = 'flat';
b2(1).CData = redpurp;

b1(2).FaceColor = 'flat';
b1(2).CData = yellow;
b2(2).FaceColor = 'flat';
b2(2).CData = yellow;

b1(3).FaceColor = 'flat';
b1(3).CData = blue;
b2(3).FaceColor = 'flat';
b2(3).CData = blue;

ylabel('$\Delta$Q (m$^3$)')
legend('spit tip','spit beach','south beach','','','','total','')
