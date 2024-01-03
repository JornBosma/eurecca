% PHZ: analysis of morphologic change

%% Initialisation
close all
clear
clc

[basePath, fontsize, cbf, PHZ, SEDMEX] = eurecca_init;
% fontsize = 30; % ultra-wide screen

% Load metrics for different segments
dataPath = [basePath 'results' filesep 'metrics' filesep];
load([dataPath 'NAP_03_23_43_-16.mat']);

% Rearrange order of fieldnames within structures
C = {'SouthUpper','SpitUpper','NorthUpper','SouthBeach','SpitBeach',...
    'Hook','Lagoon','Ceres','SouthBathy','SpitBathy','NorthBathy','LagoonBathy'};
Perimeter = orderfields(Perimeter, C);
Area = orderfields(Area, C);
Volume = orderfields(Volume, C);
Polyshape = orderfields(Polyshape, C);

% Drop unreliable measurements from final survey
Perimeter.SouthBathy(end) = NaN;
Perimeter.SpitBathy(end) = NaN;
Perimeter.NorthBathy(end) = NaN;
Perimeter.LagoonBathy(end) = NaN;

Area.SouthBathy(end) = NaN;
Area.SpitBathy(end) = NaN;
Area.NorthBathy(end) = NaN;
Area.LagoonBathy(end) = NaN;

Volume.SouthBathy(end) = NaN;
Volume.SpitBathy(end) = NaN;
Volume.NorthBathy(end) = NaN;
Volume.LagoonBathy(end) = NaN;

Polyshape.SouthBathy(end) = {[]};
Polyshape.SpitBathy(end) = {[]};
Polyshape.NorthBathy(end) = {[]};
Polyshape.LagoonBathy(end) = {[]};

% Load survey info
load DEMsurveys.mat

% Load DEMs
PHZ1 = load('PHZ_2019_Q2','-mat');
PHZ2 = PHZ1;
% PHZ2 = load('PHZ_2022_Q4','-mat');

% Load polygons
pgons = getPgons;

% Extract fieldnames
segments = fieldnames(Polyshape);
polygons = fieldnames(pgons);

light_grey = [0.8, 0.8, 0.8];
grey = [0.6, 0.6, 0.6];


%% Process DEMs
PHZ1.DEM.Z(PHZ1.DEM.Z<0) = NaN;
mask_site = inpolygon(PHZ1.DEM.X, PHZ1.DEM.Y, pgons.site(:,1), pgons.site(:,2));
PHZ1.DEM.Z(~mask_site) = NaN;

mask_scope = inpolygon(PHZ2.DEM.X, PHZ2.DEM.Y, pgons.scope(:,1), pgons.scope(:,2));
PHZ2.DEM.Z(~mask_scope ) = NaN;

contourMatrix = contourc(PHZ2.DEM.X(1,:), PHZ2.DEM.Y(:,1), PHZ2.DEM.Z, [contourLevels(1) contourLevels(1)]);
x = contourMatrix(1, 2:end);
y = contourMatrix(2, 2:end);
x(x<min(PHZ2.DEM.X(1,:))) = NaN;
y(y<min(PHZ2.DEM.Y(:,1))) = NaN;

clearvars PHZ2 mask_site mask_scope contourMatrix


%% Visualisation: beach segmentation
f1 = figureRH;
f1.Theme = "light";

plot(x, y, '-k', 'LineWidth', 2); hold on
surf(PHZ1.DEM.X, PHZ1.DEM.Y, PHZ1.DEM.Z)
colormap(repmat(light_grey, 64, 1))
shading flat

axis off equal
view(48.1, 90)

% axis off vis3d
% view(55.4, 90)

% Invert the order of the polyshapes
ax = gca;
ax.SortMethod = "childorder";

for i = 1:numel(segments)

    % waitforbuttonpress

    plot(Polyshape.(segments{i}){12}, "FaceColor",cbf.custom12(i,:)', "FaceAlpha",1, "EdgeColor","none", "LineWidth",1)
    
end
plot(x, y, '-k', 'LineWidth',2, 'HandleVisibility','off')
hold off

% legend([string(DEMsurveys.survey_date(1), "MMM uuuu"); "Dune/Harbour"; cellstr(segments)], "Location","eastoutside")


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

clearvars dataPath Perimeter Area Volume Tperimeter Tarea Tvolume


%% Expand timetables: Volume
% TTvolume.TotSea = sum(TTvolume{:, 4:6}, 2);
TTvolume.TotInt = sum(TTvolume{:, 4:8}, 2);
TTvolume.TotDry = sum(TTvolume{:, 1:3}, 2);
% TTvolume.TotTopo = TTvolume.TotInt + TTvolume.TotDry;
TTvolume.TotBathy = sum(TTvolume{:, 9:12}, 2);
TTvolume.Total = TTvolume.TotInt + TTvolume.TotDry + TTvolume.TotBathy;

TTvolume.dSouthUpper = TTvolume.SouthUpper - TTvolume.SouthUpper(1);
TTvolume.dSpitUpper = TTvolume.SpitUpper - TTvolume.SpitUpper(1);
TTvolume.dNorthUpper = TTvolume.NorthUpper - TTvolume.NorthUpper(1);
TTvolume.dSouthBeach = TTvolume.SouthBeach - TTvolume.SouthBeach(1);
TTvolume.dSpitBeach = TTvolume.SpitBeach - TTvolume.SpitBeach(1);
TTvolume.dHook = TTvolume.Hook - TTvolume.Hook(1);
TTvolume.dLagoon = TTvolume.Lagoon - TTvolume.Lagoon(1);
TTvolume.dCeres = TTvolume.Ceres - TTvolume.Ceres(1);
TTvolume.dSouthBathy = TTvolume.SouthBathy - TTvolume.SouthBathy(1);
TTvolume.dSpitBathy = TTvolume.SpitBathy - TTvolume.SpitBathy(1);
TTvolume.dNorthBathy = TTvolume.NorthBathy - TTvolume.NorthBathy(1);
TTvolume.dLagoonBathy = TTvolume.LagoonBathy - TTvolume.LagoonBathy(1);

% TTvolume.dTotSea = TTvolume.TotSea - TTvolume.TotSea(1);
TTvolume.dTotInt = TTvolume.TotInt - TTvolume.TotInt(1);
TTvolume.dTotDry = TTvolume.TotDry - TTvolume.TotDry(1);
% TTvolume.dTotTopo = TTvolume.TotTopo - TTvolume.TotTopo(1);
TTvolume.dTotBathy = TTvolume.TotBathy - TTvolume.TotBathy(1);
TTvolume.dTotal = TTvolume.Total - TTvolume.Total(1);

dpolygons = "d" + polygons;


%% Expand timetables: Area
% TTarea.TotSea = sum(TTarea{:, 4:6}, 2);
TTarea.TotInt = sum(TTarea{:, 4:8}, 2);
TTarea.TotDry = sum(TTarea{:, 1:3}, 2);
% TTarea.TotTopo = TTarea.TotInt + TTarea.TotDry;
TTarea.TotBathy = sum(TTarea{:, 9:12}, 2);
TTarea.Total = TTarea.TotInt + TTarea.TotDry + TTarea.TotBathy;

TTarea.dSouthUpper = TTarea.SouthUpper - TTarea.SouthUpper(1);
TTarea.dSpitUpper = TTarea.SpitUpper - TTarea.SpitUpper(1);
TTarea.dNorthUpper = TTarea.NorthUpper - TTarea.NorthUpper(1);
TTarea.dSouthBeach = TTarea.SouthBeach - TTarea.SouthBeach(1);
TTarea.dSpitBeach = TTarea.SpitBeach - TTarea.SpitBeach(1);
TTarea.dHook = TTarea.Hook - TTarea.Hook(1);
TTarea.dLagoon = TTarea.Lagoon - TTarea.Lagoon(1);
TTarea.dCeres = TTarea.Ceres - TTarea.Ceres(1);
TTarea.dSouthBathy = TTarea.SouthBathy - TTarea.SouthBathy(1);
TTarea.dSpitBathy = TTarea.SpitBathy - TTarea.SpitBathy(1);
TTarea.dNorthBathy = TTarea.NorthBathy - TTarea.NorthBathy(1);
TTarea.dLagoonBathy = TTarea.LagoonBathy - TTarea.LagoonBathy(1);

% TTarea.dTotSea = TTarea.TotSea - TTarea.TotSea(1);
TTarea.dTotInt = TTarea.TotInt - TTarea.TotInt(1);
TTarea.dTotDry = TTarea.TotDry - TTarea.TotDry(1);
% TTarea.dTotTopo = TTarea.TotTopo - TTarea.TotTopo(1);
TTarea.dTotBathy = TTarea.TotBathy - TTarea.TotBathy(1);
TTarea.dTotal = TTarea.Total - TTarea.Total(1);


%% Computations

% Calculate the elapsed time from the reference date
timeDiffs = TTvolume.Date-TTvolume.Date(1);

% Convert the time difference to years
% The conversion accounts for leap years by using 365.25 days per year
yearsElapsed = years(timeDiffs);

% Perform linear regression, handling NaN values in y-data
pV = nan(15, 2);
pA = nan(15, 2);
for i = 1:15

    % Extract the current column's y-data
    volumeData = TTvolume{:, i+16};
    areaData = TTarea{:, i+16};

    % Find indices where yData is not NaN
    validIndices = ~isnan(volumeData);

    % Perform linear regression using only the valid y-data
    if sum(validIndices) > 1  % Ensure there are at least two data points
        pV(i, :) = polyfit(yearsElapsed(validIndices), volumeData(validIndices), 1);
        pA(i, :) = polyfit(yearsElapsed(validIndices), areaData(validIndices), 1);
    end

end

% Extract the slopes
slopeV = round(pV(:, 1));
slopeA = round(pA(:, 1));

% Calculating percentage change
percentage_dV = round((slopeV' ./ TTvolume{1, 1:15}) * 100, 1);
percentage_dA = round((slopeA' ./ TTvolume{1, 1:15}) * 100, 1);


%% Visualisation: volume wrt first survey (line plots)
f2 = figure("Position",[2071 294 940 819]);
tiledlayout(3,1, "TileSpacing","compact")

% Dry beach
ax(1) = nexttile; hold on

plot(TTvolume.Date, TTvolume.dSouthUpper, '-', 'Color',cbf.custom12(1,:)', 'LineWidth',4)
plot(TTvolume.Date, TTvolume.dSpitUpper, '-', 'Color',cbf.custom12(2,:)', 'LineWidth',4)
plot(TTvolume.Date, TTvolume.dNorthUpper, '-', 'Color',cbf.custom12(3,:)', 'LineWidth',4)
plot(TTvolume.Date, TTvolume.dTotDry, '-k', 'LineWidth',5)

yline(0)
hold off

% Beachface
ax(2) = nexttile; hold on

plot(TTvolume.Date, TTvolume.dSouthBeach, '-', 'Color',cbf.custom12(4,:)', 'LineWidth',4)
plot(TTvolume.Date, TTvolume.dSpitBeach, '-', 'Color',cbf.custom12(5,:)', 'LineWidth',4)
plot(TTvolume.Date, TTvolume.dHook, '-', 'Color',cbf.custom12(6,:)', 'LineWidth',4)
plot(TTvolume.Date, TTvolume.dLagoon, '-', 'Color',cbf.custom12(7,:)', 'LineWidth',4)
plot(TTvolume.Date, TTvolume.dCeres, '-', 'Color',cbf.custom12(8,:)', 'LineWidth',4)
plot(TTvolume.Date, TTvolume.dTotInt, '-k', 'LineWidth',5)
plot(TTvolume.Date([1 3]), TTvolume.dTotInt([1 3]), '--k', 'LineWidth',5)
plot(TTvolume.Date([5 8]), TTvolume.dTotInt([5 8]), '--k', 'LineWidth',5)
plot(TTvolume.Date([9 11]), TTvolume.dTotInt([9 11]), '--k', 'LineWidth',5)
plot(TTvolume.Date([9 11]), TTvolume.dSouthBeach([9 11]), '--', 'Color',cbf.custom12(4,:)', 'LineWidth',4)
plot(TTvolume.Date([9 11]), TTvolume.dSpitBeach([9 11]), '--', 'Color',cbf.custom12(5,:)', 'LineWidth',4)
plot(TTvolume.Date([1 3]), TTvolume.dCeres([1 3]), '--', 'Color',cbf.custom12(8,:)', 'LineWidth',4)
plot(TTvolume.Date([5 8]), TTvolume.dCeres([5 8]), '--', 'Color',cbf.custom12(8,:)', 'LineWidth',4)

yline(0)
hold off

ylabel('\DeltaV (m^{3})')

% Platform
ax(3) = nexttile; hold on

noNaN = ~isnan(TTvolume.dSouthBathy);
plot(TTvolume.Date(noNaN), TTvolume.dSouthBathy(noNaN), '-', 'Color',cbf.custom12(9,:)', 'LineWidth',4)
plot(TTvolume.Date(noNaN), TTvolume.dSpitBathy(noNaN), '-', 'Color',cbf.custom12(10,:)', 'LineWidth',4)
plot(TTvolume.Date(noNaN), TTvolume.dNorthBathy(noNaN), '-', 'Color',cbf.custom12(11,:)', 'LineWidth',4)
plot(TTvolume.Date(noNaN), TTvolume.dLagoonBathy(noNaN), '-', 'Color',cbf.custom12(12,:)', 'LineWidth',4)
plot(TTvolume.Date(noNaN), TTvolume.dTotBathy(noNaN), '-k', 'LineWidth',5)

yline(0, "HandleVisibility","off")
hold off

% legend('south', 'spit', 'hook/north', 'lagoon', 'Ceres', 'total',...
%     'FontSize',fontsize', 'Orientation','horizontal', 'Position',[0.1942,0.9396,0.69663,0.039823])
% legend('SouthBathy', 'SpitBathy', 'NorthBathy', 'LagoonBathy', 'Total', "Location","eastoutside", "FontSize",fontsize*.8)

% Group settings
xtickformat(ax, "MM/''yy")
xticklabels([ax(1), ax(2)], [])
% xtickangle(ax(3), 10)
ylim(ax(1), [-13e4, 3e4])
ylim([ax(2), ax(3)], [-5e4, 5e4])

grid(ax, "on")
grid(ax, "minor")
linkaxes(ax, "x")

clearvars noNaN ax


%% Visualisation: beach segment development
% cbf.custom122 = crameri('-roma', height(DEMsurveys));
% cbf.custom122 = cmocean('tarn', height(DEMsurveys));

alpha_values = linspace(0.2, 1, height(DEMsurveys));

segment = string(segments(6));
pgon = string(polygons(12));

f3 = figureRH;
f3.Theme = "light";

hold on
for i = 1:height(DEMsurveys)
    plot(Polyshape.(segment){i}, "FaceAlpha",0, "EdgeColor",cbf.custom12(6,:),...
        "EdgeAlpha",alpha_values(i), "LineWidth",4)

    axis off equal
    view(48.1, 90)
    % legend(cellstr(DEMsurveys.survey_date(1:i)), "Location","east")

    waitforbuttonpress

end
hold off

% Invert the order of the polyshapes
ax = gca;
ax.Children = ax.Children(numel(ax.Children):-1:1);

% Add polygon shape
% patch(pgons.(pgon)(:,1), pgons.(pgon)(:,2), 'k', 'FaceAlpha',0, 'EdgeColor','k', 'LineWidth',2, 'HandleVisibility','off')

