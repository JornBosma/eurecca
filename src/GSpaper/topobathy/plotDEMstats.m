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

fieldNames = fieldnames(Area);
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


%% Visualisation: areas & volumes
figure2
tiledlayout('flow', 'TileSpacing','tight')

for i = 1:numel(fieldNames)
    nexttile

    % Find the indices of non-NaN values
    noNaN = ~isnan(TTarea.(fieldNames{i}));

    hold on
    plot(TTperimeter.Date(noNaN), TTarea.(fieldNames{i})(noNaN), ...
        '-+', 'LineWidth',2, 'Color',cbf.vermilion)
    plot(TTperimeter.Date(noNaN), TTvolume.(fieldNames{i})(noNaN), ...
        '-+', 'LineWidth',2, 'Color',cbf.blue)
    hold off

    title(fieldNames{i})
    legend('area (m^{2})', 'volume (m^{3})', 'Location','best')
    grid on
end


%% Visualise metrics of "fieldname"
fieldName = "Hook";

% Find the indices of non-NaN values
noNaN = ~isnan(TTarea.(fieldName));

figureRH;
tiledlayout(4,1)
sgtitle(fieldName, 'Fontsize',fontsize)

nexttile
plot(TTperimeter.Date(noNaN), TTperimeter.(fieldName)(noNaN), ...
    '-+', 'LineWidth',2, 'Color',cbf.yellow)
ylabel('P (m)')
xticklabels([])
grid on

nexttile
plot(TTperimeter.Date(noNaN), TTarea.(fieldName)(noNaN), ...
    '-+', 'LineWidth',2, 'Color',cbf.vermilion)
ylabel('A (m^{2})')
xticklabels([])
grid on

nexttile
plot(TTperimeter.Date(noNaN), TTvolume.(fieldName)(noNaN), ...
    '-+', 'LineWidth',2, 'Color',cbf.skyblue)
ylabel('V (m^{3})')
xticklabels([])
grid on

nexttile
plot(TTperimeter.Date(noNaN), TTvolume.(fieldName)(noNaN) ./ TTarea.(fieldName)(noNaN), ...
    '-+', 'LineWidth',2, 'Color',cbf.redpurp)
ylabel('V / A (m)')
grid on


%% Reproduce old figure

% Calculate the differences in volumes
dSouthBeach = [0; diff(TTvolume.SouthBeach)]; % Assuming initial difference is zero
dSpitBeach = [0; diff(TTvolume.SpitBeach)];
dHook = [0; diff(TTvolume.Hook)];
dTotal = dSouthBeach + dSpitBeach + dHook;

% Add the differences as a new column
TTvolume.dSouthBeach = dSouthBeach;
TTvolume.dSpitBeach = dSpitBeach;
TTvolume.dHook = dHook;
TTvolume.dTotal = dTotal;

% Filtering out dates without data gaps
noNaN = ~any(isnan(TTvolume{:, 13:15}), 2);

% Bar graphs
figureRH;
tiledlayout(2,1)

nexttile
b1 = bar(TTvolume.Date(noNaN), [TTvolume.dSouthBeach(noNaN), TTvolume.dSpitBeach(noNaN), TTvolume.dHook(noNaN)], 'stacked'); hold on
plot(TTvolume.Date([9 12]), TTvolume.dTotal([9 12]), 'r', 'LineWidth',4, 'LineStyle','--')
plot(TTvolume.Date, TTvolume.dTotal, 'r', 'LineWidth',4, 'LineStyle','-'); hold off

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

TTvolume.dSouthBeach = TTvolume.SouthBeach - TTvolume.SouthBeach(1);
TTvolume.dSpitBeach = TTvolume.SpitBeach - TTvolume.SpitBeach(1);
TTvolume.dHook = TTvolume.Hook - TTvolume.Hook(1);
TTvolume.dTotal = TTvolume.dSouthBeach + TTvolume.dSpitBeach + TTvolume.dHook;

nexttile
b2 = bar(TTvolume.Date(noNaN), [TTvolume.dSouthBeach(noNaN), TTvolume.dSpitBeach(noNaN), TTvolume.dHook(noNaN)], 'stacked'); hold on
plot(TTvolume.Date([9 11]), TTvolume.dTotal([9 11]), 'r', 'LineWidth',4, 'LineStyle','--')
plot(TTvolume.Date, TTvolume.dTotal, 'r', 'LineWidth',4, 'LineStyle','-'); hold off

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

TTvolume.dSouthBeach = [];
TTvolume.dSpitBeach = [];
TTvolume.dHook = [];
TTvolume.dTotal = [];


%% Visualisation: volumes (line plots)
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
legend(fieldNames(6:8), 'Location','best')
title([mat2str(contourLevels(2)), ' - ', mat2str(contourLevels(3)), ' m'], 'HorizontalAlignment','left')

nexttile
hold on
for i = 11:12
    % Find the indices of non-NaN values
    noNaN = ~isnan(TTvolume.(fieldNames{i}));

    plot(TTvolume.Date(noNaN), TTvolume.(fieldNames{i})(noNaN), ...
        '-+', 'LineWidth',2)
end
hold off
ylim([0, 6e5])
legend(fieldNames(11:12), 'Location','best')
title([mat2str(contourLevels(4)), ' - ', mat2str(contourLevels(1)), ' m'], 'HorizontalAlignment','left')


%% Visualisation: volumes (line plots)
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
xticklabels([])
yticklabels([])
ylabel('normalised V')
legend(fieldNames(6:8), 'Location','eastoutside')
title([mat2str(contourLevels(2)), ' - ', mat2str(contourLevels(3)), ' m'])

nexttile
hold on
for i = 11:12
    % Find the indices of non-NaN values
    noNaN = ~isnan(TTvolume.(fieldNames{i}));

    plot(TTvolume.Date(noNaN), normalize(TTvolume.(fieldNames{i})(noNaN)), ...
        '-+', 'LineWidth',2)
end
hold off
yticklabels([])
legend(fieldNames(11:12), 'Location','eastoutside')
title([mat2str(contourLevels(4)), ' - ', mat2str(contourLevels(1)), ' m'])


%% Visualisation: areas (line plots)
figureRH;
tiledlayout(1,3)

nexttile
hold on
for i = 1:5
    % Find the indices of non-NaN values
    noNaN = ~isnan(TTarea.(fieldNames{i}));

    plot(TTarea.Date(noNaN), TTarea.(fieldNames{i})(noNaN), ...
        '-+', 'LineWidth',2)
end
hold off
ylabel('A (m^{2})')
legend(fieldNames(1:5), 'Location','best')
title([mat2str(contourLevels(1)), ' - ', mat2str(contourLevels(2)), ' m'], 'HorizontalAlignment','left')

nexttile
hold on
for i = 6:8
    % Find the indices of non-NaN values
    noNaN = ~isnan(TTarea.(fieldNames{i}));

    plot(TTarea.Date(noNaN), TTarea.(fieldNames{i})(noNaN), ...
        '-+', 'LineWidth',2)
end
hold off
legend(fieldNames(6:8), 'Location','best')
title([mat2str(contourLevels(2)), ' - ', mat2str(contourLevels(3)), ' m'], 'HorizontalAlignment','left')

nexttile
hold on
for i = 11:12
    % Find the indices of non-NaN values
    noNaN = ~isnan(TTarea.(fieldNames{i}));

    plot(TTarea.Date(noNaN), TTarea.(fieldNames{i})(noNaN), ...
        '-+', 'LineWidth',2)
end
hold off
ylim([0, 6e5])
legend(fieldNames(11:12), 'Location','best')
title([mat2str(contourLevels(4)), ' - ', mat2str(contourLevels(1)), ' m'], 'HorizontalAlignment','left')


%% Visualisation: areas (line plots)
figureRH;
tiledlayout(3,1)

nexttile
hold on
for i = 1:5
    % Find the indices of non-NaN values
    noNaN = ~isnan(TTarea.(fieldNames{i}));

    plot(TTarea.Date(noNaN), normalize(TTarea.(fieldNames{i})(noNaN)), ...
        '-+', 'LineWidth',2)
end
hold off
xticklabels([])
yticklabels([])
legend(fieldNames(1:5), 'Location','eastoutside')
title([mat2str(contourLevels(1)), ' - ', mat2str(contourLevels(2)), ' m'])

nexttile
hold on
for i = 6:8
    % Find the indices of non-NaN values
    noNaN = ~isnan(TTarea.(fieldNames{i}));

    plot(TTarea.Date(noNaN), normalize(TTarea.(fieldNames{i})(noNaN)), ...
        '-+', 'LineWidth',2)
end
hold off
xticklabels([])
yticklabels([])
ylabel('normalised A')
legend(fieldNames(6:8), 'Location','eastoutside')
title([mat2str(contourLevels(2)), ' - ', mat2str(contourLevels(3)), ' m'])

nexttile
hold on
for i = 11:12
    % Find the indices of non-NaN values
    noNaN = ~isnan(TTarea.(fieldNames{i}));

    plot(TTarea.Date(noNaN), normalize(TTarea.(fieldNames{i})(noNaN)), ...
        '-+', 'LineWidth',2)
end
hold off
yticklabels([])
legend(fieldNames(11:12), 'Location','eastoutside')
title([mat2str(contourLevels(4)), ' - ', mat2str(contourLevels(1)), ' m'])

