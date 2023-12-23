%% Initialisation
close all
clear
clc

[basePath, fontsize, cbf, PHZ] = eurecca_init;

dataPath = [basePath 'results' filesep 'metrics' filesep];

% Load metrics for different zones
load([dataPath 'NAP_03_225_4_-16.mat']);

% Load survey info
load DEMsurveys.mat

% Remove contourLvls for practical reasons
Perimeter = rmfield(Perimeter, 'ContourLvls');
Area = rmfield(Area, 'ContourLvls');
Volume = rmfield(Volume, 'ContourLvls');

fieldNames = fieldnames(Volume);
contourLevels = [0.3, PHZ.AHW, 4, -1.6];

%% Create timetables
Tperimeter = struct2table(Perimeter);
Tperimeter.Date = DEMsurveys.survey_date;
TTperimeter = table2timetable(Tperimeter);

Tarea = struct2table(Area);
Tarea.Date = DEMsurveys.survey_date;
TTarea = table2timetable(Tarea);

Tvolume = struct2table(Volume);
Tvolume.Date = DEMsurveys.survey_date;
TTvolume = table2timetable(Tvolume);

clearvars dataPath Perimeter Area Volume Tperimeter Tarea Tvolume DEMsurveys


%% Expand timetables
TTvolume.TotSea = sum(TTvolume{:, 1:3}, 2);
TTvolume.TotInt = sum(TTvolume{:, 1:5}, 2);
TTvolume.TotDry = sum(TTvolume{:, 6:8}, 2);
TTvolume.TotTopo = TTvolume.TotInt + TTvolume.TotDry;
TTvolume.TotBathy = sum(TTvolume{:, 9:12}, 2);
TTvolume.Total = TTvolume.TotTopo + TTvolume.TotBathy;

TTvolume.dSouthBeach = TTvolume.SouthBeach - TTvolume.SouthBeach(1);
TTvolume.dSpitBeach = TTvolume.SpitBeach - TTvolume.SpitBeach(1);
TTvolume.dHook = TTvolume.Hook - TTvolume.Hook(1);
TTvolume.dLagoon = TTvolume.Lagoon - TTvolume.Lagoon(1);
TTvolume.dCeres = TTvolume.Ceres - TTvolume.Ceres(1);
TTvolume.dSouthUpper = TTvolume.SouthUpper - TTvolume.SouthUpper(1);
TTvolume.dSpitUpper = TTvolume.SpitUpper - TTvolume.SpitUpper(1);
TTvolume.dNorthUpper = TTvolume.NorthUpper - TTvolume.NorthUpper(1);
TTvolume.dSouthBathy = TTvolume.SouthBathy - TTvolume.SouthBathy(1);
TTvolume.dSpitBathy = TTvolume.SpitBathy - TTvolume.SpitBathy(1);
TTvolume.dNorthBathy = TTvolume.NorthBathy - TTvolume.NorthBathy(1);
TTvolume.dLagoonBathy = TTvolume.LagoonBathy - TTvolume.LagoonBathy(1);

TTvolume.dTotSea = TTvolume.TotSea - TTvolume.TotSea(1);
TTvolume.dTotInt = TTvolume.TotInt - TTvolume.TotInt(1);
TTvolume.dTotDry = TTvolume.TotDry - TTvolume.TotDry(1);
TTvolume.dTotTopo = TTvolume.TotTopo - TTvolume.TotTopo(1);
TTvolume.dTotBathy = TTvolume.TotBathy - TTvolume.TotBathy(1);
TTvolume.dTotal = TTvolume.Total - TTvolume.Total(1);

dfieldNames = fieldnames(TTvolume(:, 19:30));


%% Visualisation: area & volume
figure2
tiledlayout('flow', 'TileSpacing','tight')

ax = gobjects(1, numel(fieldNames));
for i = 1:numel(fieldNames)
    ax(i) = nexttile;

    % Find the indices of non-NaN values
    noNaN = ~isnan(TTarea.(fieldNames{i}));

    hold on
    plot(TTvolume.Date(noNaN), normalize(TTarea.(fieldNames{i})(noNaN)), ...
        '-+', 'LineWidth',2, 'Color',cbf.vermilion)
    plot(TTvolume.Date(noNaN), normalize(TTvolume.(fieldNames{i})(noNaN)), ...
        '-+', 'LineWidth',2, 'Color',cbf.blue)
    hold off

    title(fieldNames{i})
end

xticklabels(ax(1:6), [])
xtickformat(ax(7:10), "MMM yyyy")
xtickangle(ax(7:10), 20)
yticklabels(ax, [])
legend(ax(3), 'normalised A', 'normalised V', 'Location','best')
grid(ax, "off")
box(ax, "off")

clearvars ax

%% Visualisation: metrics of "fieldname"
fieldName = "Hook";

% Find the indices of non-NaN values
noNaN = ~isnan(TTarea.(fieldName));

figureRH;
tiledlayout(4,1)
sgtitle(fieldName, 'Fontsize',fontsize)

ax(1) = nexttile;
plot(TTperimeter.Date(noNaN), TTperimeter.(fieldName)(noNaN), ...
    '-+', 'LineWidth',2, 'Color',cbf.yellow)
ylabel('P (m)')

ax(2) = nexttile;
plot(TTperimeter.Date(noNaN), TTarea.(fieldName)(noNaN), ...
    '-+', 'LineWidth',2, 'Color',cbf.vermilion)
ylabel('A (m^{2})')

ax(3) = nexttile;
plot(TTperimeter.Date(noNaN), TTvolume.(fieldName)(noNaN), ...
    '-+', 'LineWidth',2, 'Color',cbf.skyblue)
ylabel('V (m^{3})')

ax(4) = nexttile;
plot(TTperimeter.Date(noNaN), TTvolume.(fieldName)(noNaN) ./ TTarea.(fieldName)(noNaN), ...
    '-+', 'LineWidth',2, 'Color',cbf.redpurp)
ylabel('V / A (m)')

xticklabels(ax(1:3), [])
grid(ax, "off")
box(ax, "off")


%% Visualisation: reproduce old figure

% Calculate the differences in volumes
diffSouthBeach = [0; diff(TTvolume.SouthBeach)]; % Assuming initial difference is zero
diffSpitBeach = [0; diff(TTvolume.SpitBeach)];
diffHook = [0; diff(TTvolume.Hook)];
diffTotal = diffSouthBeach + diffSpitBeach + diffHook;

% Add the differences as a new column
TTvolume.diffSouthBeach = diffSouthBeach;
TTvolume.diffSpitBeach = diffSpitBeach;
TTvolume.diffHook = diffHook;
TTvolume.diffTotal = diffTotal;

% Filtering out dates without data gaps
noNaN = ~any(isnan(TTvolume.diffTotal), 2);

% Bar graphs
figureRH;
tiledlayout(2,1, "TileSpacing","compact")

% V(i) - V(i-1)
nexttile; hold on
b1 = bar(TTvolume.Date(noNaN), [TTvolume.diffSouthBeach(noNaN), TTvolume.diffSpitBeach(noNaN), TTvolume.diffHook(noNaN)], 'stacked');
plot(TTvolume.Date, TTvolume.diffTotal, '-r', 'LineWidth',5)
plot(TTvolume.Date([9 12]), TTvolume.diffTotal([9 12]), '--r', 'LineWidth',5)
hold off

xregion(TTvolume.Date(1), TTvolume.Date(3)) % Initial rapid response
xregion(datetime('10-Sep-2021'), datetime('18-Oct-2021')) % SEDMEX

b1(1).FaceColor = 'flat';
b1(1).CData = cbf.blue;
b1(2).FaceColor = 'flat';
b1(2).CData = cbf.yellow;
b1(3).FaceColor = 'flat';
b1(3).CData = cbf.redpurp;

xticklabels([])
ylabel('\DeltaV (m^{3})')
legend('south beach', 'spit beach', 'hook', 'total', 'Location','northeastoutside')

% Remove useless variables;
TTvolume.diffSouthBeach = [];
TTvolume.diffSpitBeach = [];
TTvolume.diffHook = [];
TTvolume.diffTotal = [];


noNaN = ~any(isnan(TTvolume.dTotSea), 2);

% V(i) - V(1)
nexttile; hold on
b2 = bar(TTvolume.Date(noNaN), [TTvolume.dSouthBeach(noNaN), TTvolume.dSpitBeach(noNaN), TTvolume.dHook(noNaN)], 'stacked');
plot(TTvolume.Date, TTvolume.dTotSea, '-r', 'LineWidth',5)
plot(TTvolume.Date([9 11]), TTvolume.dTotSea([9 11]), '--r', 'LineWidth',5)
hold off

xregion(TTvolume.Date(1), TTvolume.Date(3)) % Initial rapid response
xregion(datetime('10-Sep-2021'), datetime('18-Oct-2021')) % SEDMEX

b2(1).FaceColor = 'flat';
b2(1).CData = cbf.blue;
b2(2).FaceColor = 'flat';
b2(2).CData = cbf.yellow;
b2(3).FaceColor = 'flat';
b2(3).CData = cbf.redpurp;

ylabel('\DeltaV (m^{3})')

% Formatting x-axis tick labels
xtickformat('dd MMM yy')


%% Visualisation: time series of volume wrt first survey
noNaN = ~any(isnan(TTvolume.dTotInt), 2);

figureRH;
tiledlayout(2,1, "TileSpacing","compact")

% Bar graph
ax1 = nexttile; hold on
bar(TTvolume.Date(noNaN), [TTvolume.dSouthBeach(noNaN),...
    TTvolume.dSpitBeach(noNaN), TTvolume.dHook(noNaN), TTvolume.dLagoon(noNaN),...
    TTvolume.dCeres(noNaN)], 'stacked')
plot(TTvolume.Date, TTvolume.dTotInt, '-r', 'LineWidth',5)
plot(TTvolume.Date([1 3]), TTvolume.dTotInt([1 3]), '--r', 'LineWidth',5)
plot(TTvolume.Date([5 8]), TTvolume.dTotInt([5 8]), '--r', 'LineWidth',5)
plot(TTvolume.Date([9 11]), TTvolume.dTotInt([9 11]), '--r', 'LineWidth',5)
hold off

xregion(TTvolume.Date(1), TTvolume.Date(3)) % Initial rapid response
xregion(datetime('10-Sep-2021'), datetime('18-Oct-2021')) % SEDMEX

xticklabels([])
ylabel('\DeltaV (m^{3})')
legend('south beach', 'spit beach', 'hook', 'lagoon', 'Ceres', 'total', 'Location','northeastoutside')


% Line graph
ax2 = nexttile; hold on
plot(TTvolume.Date, [TTvolume.dSouthBeach,...
    TTvolume.dSpitBeach, TTvolume.dHook, TTvolume.dLagoon,...
    TTvolume.dCeres], 'LineWidth',3, 'LineStyle','-')
plot(TTvolume.Date, TTvolume.dTotInt, '-r', 'LineWidth',5)
plot(TTvolume.Date([1 3]), TTvolume.dTotInt([1 3]), '--r', 'LineWidth',5)
plot(TTvolume.Date([5 8]), TTvolume.dTotInt([5 8]), '--r', 'LineWidth',5)
plot(TTvolume.Date([9 11]), TTvolume.dTotInt([9 11]), '--r', 'LineWidth',5)
plot(TTvolume.Date([9 11]), TTvolume.dSouthBeach([9 11]), 'Color',"#0072BD", 'LineWidth',3, 'LineStyle','--')
plot(TTvolume.Date([9 11]), TTvolume.dSpitBeach([9 11]), 'Color',"#D95319", 'LineWidth',3, 'LineStyle','--')
plot(TTvolume.Date([1 3]), TTvolume.dCeres([1 3]), 'Color',"#77AC30", 'LineWidth',3, 'LineStyle','--')
plot(TTvolume.Date([5 8]), TTvolume.dCeres([5 8]), 'Color',"#77AC30", 'LineWidth',3, 'LineStyle','--')
yline(0)
hold off

xregion(TTvolume.Date(1), TTvolume.Date(3)) % Initial rapid response
xregion(datetime('10-Sep-2021'), datetime('18-Oct-2021')) % SEDMEX

ylabel('\DeltaV (m^{3})')
legend('south beach', 'spit beach', 'hook', 'lagoon', 'Ceres', 'total', 'Location','northeastoutside')

% Formatting x-axis tick labels
xtickformat('MMM yyyy')

linkaxes([ax1, ax2])

clearvars noNaN ax2 ax2


%% Visualisation: absolute volume (line plots)
figureRH;
tiledlayout(1,3)

nexttile
hold on
for i = 1:5
    % Find the indices of non-NaN values
    noNaN = ~isnan(TTvolume.(fieldNames{i}));

    plot(TTvolume.Date(noNaN), TTvolume.(fieldNames{i})(noNaN), ...
        '-+', 'LineWidth',2)
end
hold off
ylim([0 8.2e5])
ylabel('V (m^{3})')
legend(fieldNames(1:5), 'Location','best')
title([mat2str(contourLevels(1)), ' - ', mat2str(contourLevels(2)), ' m'], 'HorizontalAlignment','left')

nexttile
hold on
for i = 6:8
    % Find the indices of non-NaN values
    noNaN = ~isnan(TTvolume.(fieldNames{i}));

    plot(TTvolume.Date(noNaN), TTvolume.(fieldNames{i})(noNaN), ...
        '-+', 'LineWidth',2)
end
hold off
ylim([0 8.2e5])
legend(fieldNames(6:8), 'Location','best')
title([mat2str(contourLevels(2)), ' - ', mat2str(contourLevels(3)), ' m'], 'HorizontalAlignment','left')

nexttile
hold on
for i = 9:12
    % Find the indices of non-NaN values
    noNaN = ~isnan(TTvolume.(fieldNames{i}));

    plot(TTvolume.Date(noNaN), TTvolume.(fieldNames{i})(noNaN), ...
        '-+', 'LineWidth',2)
end
hold off
ylim([0, 8.2e5])
legend(fieldNames(9:12), 'Location','best')
title([mat2str(contourLevels(4)), ' - ', mat2str(contourLevels(1)), ' m'], 'HorizontalAlignment','left')


%% Visualisation: normalised volume (line plots)
figureRH;
tiledlayout(3,1)

nexttile
hold on
for i = 1:5
    % Find the indices of non-NaN values
    noNaN = ~isnan(TTvolume.(fieldNames{i}));

    plot(TTvolume.Date(noNaN), normalize(TTvolume.(fieldNames{i})(noNaN)), ...
        '-+', 'LineWidth',2)
end
hold off
ylim([-3 3])
xticklabels([])
yticklabels([])
legend(fieldNames(1:5), 'Location','eastoutside')
title([mat2str(contourLevels(1)), ' - ', mat2str(contourLevels(2)), ' m'])

nexttile
hold on
for i = 6:8
    % Find the indices of non-NaN values
    noNaN = ~isnan(TTvolume.(fieldNames{i}));

    plot(TTvolume.Date(noNaN), normalize(TTvolume.(fieldNames{i})(noNaN)), ...
        '-+', 'LineWidth',2)
end
hold off
ylim([-3 3])
xticklabels([])
yticklabels([])
ylabel('normalised V')
legend(fieldNames(6:8), 'Location','eastoutside')
title([mat2str(contourLevels(2)), ' - ', mat2str(contourLevels(3)), ' m'])

nexttile
hold on
for i = 9:12
    % Find the indices of non-NaN values
    noNaN = ~isnan(TTvolume.(fieldNames{i}));

    plot(TTvolume.Date(noNaN), normalize(TTvolume.(fieldNames{i})(noNaN)), ...
        '-+', 'LineWidth',2)
end
hold off
ylim([-3 3])
yticklabels([])
legend(fieldNames(9:12), 'Location','eastoutside')
title([mat2str(contourLevels(4)), ' - ', mat2str(contourLevels(1)), ' m'])


%% Visualisation: volume/area (line plots)
figureRH;
tiledlayout(3,1)

nexttile
hold on
for i = 1:5
    % Find the indices of non-NaN values
    noNaN = ~isnan(TTvolume.(fieldNames{i}));

    plot(TTvolume.Date(noNaN), TTvolume.(fieldNames{i})(noNaN)./TTarea.(fieldNames{i})(noNaN), ...
        '-+', 'LineWidth',2)
end
hold off
% ylim([2.5 3.5])
xticklabels([])
legend(fieldNames(1:5), 'Location','eastoutside')
title([mat2str(contourLevels(1)), ' - ', mat2str(contourLevels(2)), ' m'])

nexttile
hold on
for i = 6:8
    % Find the indices of non-NaN values
    noNaN = ~isnan(TTvolume.(fieldNames{i}));

    plot(TTvolume.Date(noNaN), TTvolume.(fieldNames{i})(noNaN)./TTarea.(fieldNames{i})(noNaN), ...
        '-+', 'LineWidth',2)
end
hold off
% ylim([4 5])
xticklabels([])
ylabel('V/A (m^{3}/m^{2})')
legend(fieldNames(6:8), 'Location','eastoutside')
title([mat2str(contourLevels(2)), ' - ', mat2str(contourLevels(3)), ' m'])

nexttile
hold on
for i = 9:12
    % Find the indices of non-NaN values
    noNaN = ~isnan(TTvolume.(fieldNames{i}));

    plot(TTvolume.Date(noNaN), TTvolume.(fieldNames{i})(noNaN)./TTarea.(fieldNames{i})(noNaN), ...
        '-+', 'LineWidth',2)
end
hold off
% ylim([0.5 1.5])
legend(fieldNames(9:12), 'Location','eastoutside')
title([mat2str(contourLevels(4)), ' - ', mat2str(contourLevels(1)), ' m'])


%% Visualisation: volume wrt first survey (line plots)
f1 = figureRH;
tiledlayout(3,1, "TileSpacing","compact")

% Dry beach
ax1 = nexttile; hold on

plot(TTvolume.Date, [TTvolume.dSouthUpper,...
    TTvolume.dSpitUpper, TTvolume.dNorthUpper], 'LineWidth',3)
plot(TTvolume.Date, TTvolume.dTotDry, '-r', 'LineWidth',5)

yline(0)
hold off

legend('south upper', 'spit upper', 'north upper', 'total', 'Location','northeastoutside')

% Beachface
ax2 = nexttile; hold on

p1 = plot(TTvolume.Date, [TTvolume.dSouthBeach,...
    TTvolume.dSpitBeach, TTvolume.dHook, TTvolume.dLagoon,...
    TTvolume.dCeres], 'LineWidth',3);
plot(TTvolume.Date, TTvolume.dTotInt, '-r', 'LineWidth',5)
plot(TTvolume.Date([1 3]), TTvolume.dTotInt([1 3]), '--r', 'LineWidth',5)
plot(TTvolume.Date([5 8]), TTvolume.dTotInt([5 8]), '--r', 'LineWidth',5)
plot(TTvolume.Date([9 11]), TTvolume.dTotInt([9 11]), '--r', 'LineWidth',5)
plot(TTvolume.Date([9 11]), TTvolume.dSouthBeach([9 11]), 'Color',p1(1).Color, 'LineWidth',3, 'LineStyle','--')
plot(TTvolume.Date([9 11]), TTvolume.dSpitBeach([9 11]), 'Color',p1(2).Color, 'LineWidth',3, 'LineStyle','--')
plot(TTvolume.Date([1 3]), TTvolume.dCeres([1 3]), 'Color',p1(5).Color, 'LineWidth',3, 'LineStyle','--')
plot(TTvolume.Date([5 8]), TTvolume.dCeres([5 8]), 'Color',p1(5).Color, 'LineWidth',3, 'LineStyle','--')

yline(0)
hold off

% xregion(TTvolume.Date(1), TTvolume.Date(3)) % Initial rapid response
% xregion(datetime('10-Sep-2021'), datetime('18-Oct-2021')) % SEDMEX

ylabel('\DeltaV (m^{3})')
legend('south beach', 'spit beach', 'hook', 'lagoon', 'Ceres', 'total', 'Location','northeastoutside')

% Platform
ax3 = nexttile; hold on

noNaN = ~isnan(TTvolume.dSouthBathy);
plot(TTvolume.Date(noNaN), [TTvolume.dSouthBathy(noNaN),...
    TTvolume.dSpitBathy(noNaN), TTvolume.dNorthBathy(noNaN)], '--', 'LineWidth',3)
plot(TTvolume.Date(noNaN), TTvolume.dTotBathy(noNaN), '--r', 'LineWidth',5)

yline(0)
hold off

legend('south bathy', 'spit bathy', 'north bathy', 'total', 'Location','northeastoutside')

% Formatting axes
xtickformat('MMM yyyy')
xticklabels([ax1, ax2], [])

grid([ax1, ax2, ax3], "on")
linkaxes([ax1, ax2, ax3], "x")
ylim(ax1, [-15e4, 2e4])
ylim([ax2, ax3], [-4e4, 6e4])

clearvars noNaN ax1 ax2 ax3


%% Computations

% Load DEMs
PHZ1 = load('PHZ_2019_Q0','-mat');
PHZ2 = load('PHZ_2022_Q4','-mat');

% Load polygons
pgons = getPgons;

PHZ1.DEM.Z(PHZ1.DEM.Z<0) = NaN;
mask_site = inpolygon(PHZ1.DEM.X, PHZ1.DEM.Y, pgons.site(:,1), pgons.site(:,2));
PHZ1.DEM.Z(~mask_site) = NaN;

% PHZ2.DEM.Z(PHZ2.DEM.Z<0) = NaN;
mask_site = inpolygon(PHZ2.DEM.X, PHZ2.DEM.Y, pgons.site(:,1), pgons.site(:,2));
PHZ2.DEM.Z(~mask_site) = NaN;

% mask_north = inpolygon(PHZ2.DEM.X, PHZ2.DEM.Y, pgns.north(:,1), pgns.north(:,2));
% PHZ2.DEM.Z(~mask_north) = NaN;
mask_harbour = inpolygon(PHZ2.DEM.X, PHZ2.DEM.Y, pgons.harbour(:,1), pgons.harbour(:,2));
PHZ2.DEM.Z(mask_harbour) = NaN;

contourMatrix = contourc(PHZ2.DEM.X(1,:), PHZ2.DEM.Y(:,1), PHZ2.DEM.Z, [0 0]);
x = contourMatrix(1, 2:end);
y = contourMatrix(2, 2:end);
x(x<min(PHZ2.DEM.X(1,:))) = NaN;
y(y<min(PHZ2.DEM.Y(:,1))) = NaN;

clearvars PHZ2 mask_site mask_harbour contourMatrix


%% Visualisation: volume wrt first survey (line plots)
light_gray = [0.8, 0.8, 0.8];

f2 = figure;
tiledlayout(3,2, "TileSpacing","compact")

% % Dry beach
ax1(1) = nexttile; hold on

plot(TTvolume.Date, TTvolume.dSouthUpper, '-b', 'LineWidth',3)
plot(TTvolume.Date, TTvolume.dSpitUpper, '-y', 'LineWidth',3)
plot(TTvolume.Date, TTvolume.dNorthUpper, '-g', 'LineWidth',3)
plot(TTvolume.Date, TTvolume.dTotDry, '-k', 'LineWidth',5)

yline(0)
hold off

ax2(1) = nexttile;
surf(PHZ1.DEM.X, PHZ1.DEM.Y, PHZ1.DEM.Z); hold on
colormap(repmat(light_gray, 64, 1))
shading flat

plot(x, y, '-k', 'LineWidth', 1)

patch(pgons.south_beach(:,1), pgons.south_beach(:,2), 'b', 'FaceAlpha',.2, 'EdgeColor','b', 'LineWidth',3)
patch(pgons.spit(:,1), pgons.spit(:,2), 'y', 'FaceAlpha',.2, 'EdgeColor','y', 'LineWidth',3)
patch(pgons.NW_beach(:,1), pgons.NW_beach(:,2), 'r', 'FaceAlpha',.2, 'EdgeColor','r', 'LineWidth',3)
hold off

text(1.155e5, 5.592e5, [mat2str(contourLevels(2)), ' \leq z < ', mat2str(contourLevels(3)), ' m'],...
    "Fontsize",fontsize, "FontWeight","bold")
Narrow(fontsize)

% Beachface
ax1(2) = nexttile; hold on

plot(TTvolume.Date, TTvolume.dSouthBeach, '-b', 'LineWidth',3)
plot(TTvolume.Date, TTvolume.dSpitBeach, '-y', 'LineWidth',3)
plot(TTvolume.Date, TTvolume.dHook, '-g', 'LineWidth',3)
plot(TTvolume.Date, TTvolume.dLagoon, '-r', 'LineWidth',3)
plot(TTvolume.Date, TTvolume.dCeres, '-m', 'LineWidth',3)
plot(TTvolume.Date, TTvolume.dTotInt, '-k', 'LineWidth',5)
plot(TTvolume.Date([1 3]), TTvolume.dTotInt([1 3]), '--k', 'LineWidth',5)
plot(TTvolume.Date([5 8]), TTvolume.dTotInt([5 8]), '--k', 'LineWidth',5)
plot(TTvolume.Date([9 11]), TTvolume.dTotInt([9 11]), '--k', 'LineWidth',5)
plot(TTvolume.Date([9 11]), TTvolume.dSouthBeach([9 11]), '--b', 'LineWidth',3)
plot(TTvolume.Date([9 11]), TTvolume.dSpitBeach([9 11]), '--y', 'LineWidth',3)
plot(TTvolume.Date([1 3]), TTvolume.dCeres([1 3]), '--m', 'LineWidth',3)
plot(TTvolume.Date([5 8]), TTvolume.dCeres([5 8]), '--m', 'LineWidth',3)

yline(0)
hold off

ylabel('\DeltaV (m^{3})')
legend('south', 'spit', 'hook/north', 'lagoon', 'Ceres', 'total', 'Location','eastoutside')

ax2(2) = nexttile;
surf(PHZ1.DEM.X, PHZ1.DEM.Y, PHZ1.DEM.Z); hold on
colormap(repmat(light_gray, 64, 1))
shading flat

plot(x, y, '-k', 'LineWidth', 1)

patch(pgons.south_beach(:,1), pgons.south_beach(:,2), 'b', 'FaceAlpha',.2, 'EdgeColor','b', 'LineWidth',3)
patch(pgons.spit_sea(:,1), pgons.spit_sea(:,2), 'y', 'FaceAlpha',.2, 'EdgeColor','y', 'LineWidth',3)
patch(pgons.hook(:,1), pgons.hook(:,2), 'g', 'FaceAlpha',.2, 'EdgeColor','g', 'LineWidth',3)
patch(pgons.lagoon(:,1), pgons.lagoon(:,2), 'r', 'FaceAlpha',.2, 'EdgeColor','r', 'LineWidth',3)
patch(pgons.ceres(:,1), pgons.ceres(:,2), 'm', 'FaceAlpha',.2, 'EdgeColor','m', 'LineWidth',3)
hold off

legend('2019 Q0', '2022 Q4', "Location","westoutside")
text(1.155e5, 5.592e5, [mat2str(contourLevels(1)), ' \leq z < ', mat2str(contourLevels(2)), ' m'],...
    "Fontsize",fontsize, "FontWeight","bold")

% Platform
ax1(3) = nexttile; hold on

noNaN = ~isnan(TTvolume.dSouthBathy);
plot(TTvolume.Date(noNaN), TTvolume.dSouthBathy(noNaN), '--b', 'LineWidth',3)
plot(TTvolume.Date(noNaN), TTvolume.dSpitBathy(noNaN), '--y', 'LineWidth',3)
plot(TTvolume.Date(noNaN), TTvolume.dNorthBathy(noNaN), '--g', 'LineWidth',3)
plot(TTvolume.Date(noNaN), TTvolume.dLagoonBathy(noNaN), '--r', 'LineWidth',3)
plot(TTvolume.Date(noNaN), TTvolume.dTotBathy(noNaN), '--k', 'LineWidth',5)

yline(0)
hold off

ax2(3) = nexttile;
surf(PHZ1.DEM.X, PHZ1.DEM.Y, PHZ1.DEM.Z); hold on
colormap(repmat(light_gray, 64, 1))
shading flat

plot(x, y, '-k', 'LineWidth', 1)

patch(pgons.south_bathy(:,1), pgons.south_bathy(:,2), 'b', 'FaceAlpha',.2, 'EdgeColor','b', 'LineWidth',3)
patch(pgons.spit_bathy(:,1), pgons.spit_bathy(:,2), 'y', 'FaceAlpha',.2, 'EdgeColor','y', 'LineWidth',3)
patch(pgons.north_bathy(:,1), pgons.north_bathy(:,2), 'g', 'FaceAlpha',.2, 'EdgeColor','g', 'LineWidth',3)
patch(pgons.lagoon_bathy(:,1), pgons.lagoon_bathy(:,2), 'r', 'FaceAlpha',.2, 'EdgeColor','r', 'LineWidth',3)
hold off

text(1.155e5, 5.592e5, [mat2str(contourLevels(4)), ' \leq z < ', mat2str(contourLevels(1)), ' m'],...
    "Fontsize",fontsize, "FontWeight","bold")

xticklabels([ax1(1), ax1(2)], [])
ylim(ax1(1), [-15e4, 2e4])
ylim([ax1(2), ax1(3)], [-4e4, 6e4])

ax2(1).SortMethod = 'childorder';
ax2(2).SortMethod = 'childorder';
ax2(3).SortMethod = 'childorder';

axis(ax2, 'off')
axis(ax2, 'equal')
view(ax2, 46, 90)
grid(ax1, "on")
linkaxes(ax1, "x")

clearvars noNaN ax1 ax2 light_gray

