%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize, basePath] = eurecca_init;

wb = waitbar(0, 'Loading DEMs');
wb.Children.Title.Interpreter = 'none';
DEMP = [basePath 'data' filesep 'elevation' filesep 'processed' filesep];
DEMS = dir(fullfile(DEMP,'PHZ*.mat'));
for k = 1:numel(DEMS)
    DEMS(k).data = load(DEMS(k).name);
    waitbar(k/numel(DEMS), wb, sprintf('Loading DEMs: %d %%', floor(k/numel(DEMS)*100)));
    pause(0.1)
end
close(wb)

% colourblind-friendly colours
orange = [230/255, 159/255, 0];
blue = [86/255, 180/255, 233/255];
yellow = [240/255, 228/255, 66/255];
redpurp = [204/255, 121/255, 167/255];
bluegreen = [0, 158/255, 115/255];

%% Calculations
dQ = cell(numel(DEMS)-1, 1);
wb = waitbar(0, 'Computing volume changes');
wb.Children.Title.Interpreter = 'none';
for k = 2:numel(DEMS)
    A = DEMS(1).data; % relative to first survey
    B = DEMS(k).data;
    [dQ{k-1}, dz{k-1}, dz_Beach{k-1}, pgns] = getVolumeChange2(A, B);
    waitbar(k/numel(DEMS), wb, sprintf('Computing volume changes: %d %%', floor(k/numel(DEMS)*100)));
    pause(0.1)
end
close(wb)

[dQ_Nspit,dQ_spit,dQ_Sbeach,dQ_beach,dQ_tot] = deal(nan(numel(dQ), 1));
[dQ_Nspit_pos,dQ_spit_pos,dQ_Sbeach_pos,dQ_beach_pos,dQ_tot_pos] = deal(nan(numel(dQ), 1));
[dQ_Nspit_neg,dQ_spit_neg,dQ_Sbeach_neg,dQ_beach_neg,dQ_tot_neg] = deal(nan(numel(dQ), 1));

for k = 1:numel(dQ)
    dQ_Nspit(k) = dQ{k}.Net(1);
    dQ_spit(k) = dQ{k}.Net(2);
    dQ_Sbeach(k) = dQ{k}.Net(3);
    dQ_beach(k) = dQ{k}.Net(4);
    dQ_tot(k) = dQ{k}.Net(5);

    dQ_Nspit_pos(k) = dQ{k}.Sedimentation(1);
    dQ_spit_pos(k) = dQ{k}.Sedimentation(2);
    dQ_Sbeach_pos(k) = dQ{k}.Sedimentation(3);
    dQ_beach_pos(k) = dQ{k}.Sedimentation(4);
    dQ_tot_pos(k) = dQ{k}.Sedimentation(5);

    dQ_Nspit_neg(k) = dQ{k}.Erosion(1);
    dQ_spit_neg(k) = dQ{k}.Erosion(2);
    dQ_Sbeach_neg(k) = dQ{k}.Erosion(3);
    dQ_beach_neg(k) = dQ{k}.Erosion(4);
    dQ_tot_neg(k) = dQ{k}.Erosion(5);
end

SurveyDates = ['2019-09';'2019-11';'2020-03';'2020-06';'2020-09';'2020-11';'2021-03';'2021-06';...
    '2021-09';'2021-11';'2022-03';'2022-05';'2022-09';'2022-12'];
SurveyDates = datetime(SurveyDates, 'InputFormat','yyyy-MM');

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

legend('spit tip','spit beach','south beach','','','','total')

%% Export figures
% exportgraphics(f0, '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/GitHub/eurecca-wp2/results/figures/dQ_line.png')
% exportgraphics(f1, '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/GitHub/eurecca-wp2/results/figures/dQ_bar.png')
