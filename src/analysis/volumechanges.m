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
% ref = DEMS(1).data; % 2020 Q1
for k = 2:numel(DEMS)
    A = DEMS(1).data; % relative to first survey
%     A = DEMS(k-1).data; % relative to previous survey
    B = DEMS(k).data;
    % ref = B; % dynamic shoreline reference
    % [dQ{k-1}, dz{k-1}, ~, pgns] = getVolumeChange(A, B, ref);
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

% T = table(SurveyDates(2:end), dQ_Nspit, dQ_spit, dQ_Sbeach, dQ_beach, dQ_tot);
% T = renamevars(T,'SurveyDates','Date');
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
figure
bar([dQ_Nspit, dQ_spit, dQ_Sbeach, dQ_beach, dQ_tot])
legend('spit tip','spit','south beach','beach','total', 'Location','southwest')

figure
bar([dQ_Nspit, dQ_spit, dQ_Sbeach], 'stacked')
legend('spit tip','spit','south beach')

%%
f1 = figure;
plot(TT.SurveyDates, TT.dQ_beach,'yo:', TT.SurveyDates, TT.dQ_Nspit,'go:',...
    'LineWidth',4, 'MarkerSize',10, 'MarkerFaceColor','k'); hold on
area(TT.SurveyDates, TT.dQ_beach, 'FaceColor',yellow, 'FaceAlpha',0.2, 'EdgeColor','none')
area(TT.SurveyDates, TT.dQ_Nspit, 'FaceColor',redpurp, 'FaceAlpha',0.2, 'EdgeColor','none')

yline(0, 'LineWidth',3)
% yline(dQ_net.Net(1:3))

datetick('x','yyyy')
ylabel('$\Delta$Q (m$^3$)')
legend('beach face', 'spit tip', 'Location','northwest')
grid on

% exportgraphics(f1, '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/MDPI Article 1 (draft)/Figures/dQ.png')

%%
f2 = figure;
tiledlayout(2,2)

ax1 = nexttile;
plot(TT_pos.SurveyDates, TT_pos.dQ_Nspit_pos,'o:', 'Color',orange, 'LineWidth',4, 'MarkerSize',10, 'MarkerFaceColor','k'); hold on
plot(TT_pos.SurveyDates, TT_neg.dQ_Nspit_neg,'o:', 'Color',blue, 'LineWidth',4, 'MarkerSize',10, 'MarkerFaceColor','k')
area(TT_pos.SurveyDates, TT_pos.dQ_Nspit_pos, 'FaceColor',orange, 'FaceAlpha',0.2, 'EdgeColor','none')
area(TT_neg.SurveyDates, TT_neg.dQ_Nspit_neg, 'FaceColor',blue, 'FaceAlpha',0.2, 'EdgeColor','none')
yline(0, 'LineWidth',3)
title('northern tip spit')

ax1.XColor = redpurp;
ax1.YColor = redpurp;
ax1.XRuler.Axle.LineWidth = 6;
ax1.YRuler.Axle.LineWidth = 6;
ylabel('$\Delta$Q (m$^3$)', 'Color','k')

ax2 = nexttile;
plot(TT_pos.SurveyDates, TT_pos.dQ_spit_pos,'o:', 'Color',orange, 'LineWidth',4, 'MarkerSize',10, 'MarkerFaceColor','k'); hold on
plot(TT_pos.SurveyDates, TT_neg.dQ_spit_neg,'o:', 'Color',blue, 'LineWidth',4, 'MarkerSize',10, 'MarkerFaceColor','k')
area(TT_pos.SurveyDates, TT_pos.dQ_spit_pos, 'FaceColor',orange, 'FaceAlpha',0.2, 'EdgeColor','none')
area(TT_neg.SurveyDates, TT_neg.dQ_spit_neg, 'FaceColor',blue, 'FaceAlpha',0.2, 'EdgeColor','none')
yline(0, 'LineWidth',3)
title('beach face spit')
legend('sedimentation', 'erosion', 'Location','northwest')

ax2.XColor = yellow;
ax2.YColor = yellow;
ax2.XRuler.Axle.LineWidth = 6;
ax2.YRuler.Axle.LineWidth = 6;

ax3 = nexttile;
plot(TT_pos.SurveyDates, TT_pos.dQ_Sbeach_pos,'o:', 'Color',orange, 'LineWidth',4, 'MarkerSize',10, 'MarkerFaceColor','k'); hold on
plot(TT_pos.SurveyDates, TT_neg.dQ_Sbeach_neg,'o:', 'Color',blue, 'LineWidth',4, 'MarkerSize',10, 'MarkerFaceColor','k')
area(TT_pos.SurveyDates, TT_pos.dQ_Sbeach_pos, 'FaceColor',orange, 'FaceAlpha',0.2, 'EdgeColor','none')
area(TT_neg.SurveyDates, TT_neg.dQ_Sbeach_neg, 'FaceColor',blue, 'FaceAlpha',0.2, 'EdgeColor','none')
yline(0, 'LineWidth',3)
ylabel('$\Delta$Q (m$^3$)')
title('southern beach face')

ax4 = nexttile;
plot(TT_pos.SurveyDates, TT_pos.dQ_tot_pos,'o:', 'Color',orange, 'LineWidth',4, 'MarkerSize',10, 'MarkerFaceColor','k'); hold on
plot(TT_pos.SurveyDates, TT_neg.dQ_tot_neg,'o:', 'Color',blue, 'LineWidth',4, 'MarkerSize',10, 'MarkerFaceColor','k')
area(TT_pos.SurveyDates, TT_pos.dQ_tot_pos, 'FaceColor',orange, 'FaceAlpha',0.2, 'EdgeColor','none')
area(TT_neg.SurveyDates, TT_neg.dQ_tot_neg, 'FaceColor',blue, 'FaceAlpha',0.2, 'EdgeColor','none')
yline(0, 'LineWidth',3)
title('total beach face')

xticks([ax1 ax2 ax3 ax4], datetime('2020','Inputformat','yyyy'):years(1):datetime('2023','Inputformat','yyyy'))
xtickformat([ax3 ax4], 'yyyy')
xticklabels([ax1 ax2], {})
yticklabels([ax2 ax4], {})
linkaxes([ax1 ax2 ax3 ax4])
axis tickaligned

grid([ax1 ax2 ax3 ax4], 'on')
grid([ax1 ax2 ax3 ax4], 'minor')

% exportgraphics(f2, '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/manuscript_observation/Figures/dQ_pos_neg.png')

%%
% TT_neg.dQ_beach_neg(10) = NaN;

f2 = figure;
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

% exportgraphics(f2, '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/Events/NCK/2023/poster/figures/volume.png')

%% Visualisation
n = length(dQ)-1;

figure
surf(A.DEM.X, A.DEM.Y, dz_Beach{n}); hold on
xlabel('easting [RD] (m)')
ylabel('northing [RD] (m)')
zlabel('z (m +NAP)')
cb = colorbar;
cb.TickLabelInterpreter = 'latex';
cb.Label.Interpreter = 'latex';
cb.Label.String = ['$<$ erosion (m)', repmat('\ ', 1, 26), 'deposition (m) $>$'];
cb.FontSize = fontsize;
clim([-2 2])
shading flat
crameri('vik', 11, 'pivot', 0)
view(0,90)
axis vis3d

xlim([1.15e5 1.18e5])
ylim([5.58e5 5.605e5])

% polygons and volumes
patch(pgns.xv_N,pgns.yv_N,redpurp,'FaceAlpha',.2, 'EdgeColor',redpurp)
text(mean([pgns.xv_N(2) pgns.xv_N(3)])+40, mean([pgns.yv_N(2) pgns.yv_N(3)]),...
    ['$\Delta$Q = ', mat2str(dQ{n}.Net(1),2),' m$^3$'], 'FontSize',fontsize/1.3)
patch(pgns.xv_beach,pgns.yv_beach,yellow,'FaceAlpha',.2, 'EdgeColor',yellow)
text(mean([pgns.xv_beach(2) pgns.xv_beach(4)])+20, mean([pgns.yv_beach(2) pgns.yv_beach(4)]),...
    ['$\Delta$Q = ', mat2str(dQ{n}.Net(4),2),' m$^3$'], 'FontSize',fontsize/1.3)

%% Visualisation
figure
[C,h] = contour(A.DEM.X, A.DEM.Y, B.DEM.Z, 0:.5:4, 'k'); hold on
xlabel('easting [RD] (m)')
ylabel('northing [RD] (m)')
zlabel('z (m +NAP)')

v = 0:.5:3;
clabel(C,h,v, 'FontSize',15, 'Color','red', 'FontWeight','bold', 'LabelSpacing', 1000)
h.LabelFormat = '%0.1f m';

view(0,90)
% view(48.5,90)
pbaspect(daspect())

xlim([1.15e5 1.18e5])
ylim([5.58e5 5.605e5])

Zsub2m = A.DEM.Z;
Zsub2m(Zsub2m>2) = NaN;
[M,c] = contourf(A.DEM.X, A.DEM.Y, Zsub2m, 0:.5:2, 'FaceAlpha',.25);
crameri('-hawaii')

% polygons and volumes
patch(pgns.xv_N,pgns.yv_N,redpurp,'FaceAlpha',.2, 'EdgeColor',redpurp)
text(mean([pgns.xv_N(2) pgns.xv_N(3)])+40, mean([pgns.yv_N(2) pgns.yv_N(3)]),...
    ['$\Delta$Q = ', mat2str(dQ{n}.Net(1),2),' m$^3$'], 'FontSize',fontsize/1.3)
patch(pgns.xv_beach,pgns.yv_beach,yellow,'FaceAlpha',.2, 'EdgeColor',yellow)
text(mean([pgns.xv_beach(2) pgns.xv_beach(4)])+20, mean([pgns.yv_beach(2) pgns.yv_beach(4)]),...
    ['$\Delta$Q = ', mat2str(dQ{n}.Net(4),2),' m$^3$'], 'FontSize',fontsize/1.3)

% plot polygons and volumes
% patch(xv_N,yv_N,redpurp,'FaceAlpha',.2, 'EdgeColor',redpurp)
% text(mean([xv_N(2) xv_N(3)])+40, mean([yv_N(2) yv_N(3)]),...
%     ['$\Delta$Q = ', mat2str(dQ_N,2),' m$^3$'], 'FontSize',fontsize/1.3)
% 
% patch(xv_beach,yv_beach,yellow,'FaceAlpha',.2, 'EdgeColor',yellow)
% text(mean([xv_beach(2) xv_beach(4)])+20, mean([yv_beach(2) yv_beach(4)]),...
%     ['$\Delta$Q = ', mat2str(dQ_beach,2),' m$^3$'], 'FontSize',fontsize/1.3)
