%% Initialisation
close all
clear
clc

[~, fontsize, cbf, PHZ] = eurecca_init;

% load DEMs
PHZ1 = load('PHZ_2019_Q2','-mat');
PHZ2 = load('PHZ_2022_Q4','-mat');

% load polygons
pgons = getPgons;


%% Edge coordinates
% a = [114850; 557860];
% b = [115108; 557772];
% c = [115500; 557700];
% d = [118060; 560044];
% e = [118062; 560520];
% f = [116950; 560526];
% g = [115450; 558000];
% h = [114960; 558000];
% i = [115090; 558000];
% j = [117090; 560526];
% % k = [115690; 558750];
% l = [115675; 558750];
% m = [116370; 559510];
% n = [117400; 560340];
% o = [117590; 560250]; 
% p = [117420; 559890];
% q = [115780; 558600];
% r = [115280; 558000];
% s = [115020; 557970];
% t = [115610; 558730];
% u = [116340; 559500];
% v = [117410; 560340];
% w = [117660; 560120];
% x = [115720; 558550];
% y = [117280; 560010];
% z = [115310; 558000];
% A = [115020; 558000];
% B = [115640; 558800];
% C = [117160; 560120];
% D = [116090; 559075];
% E = [115950; 559180];
% F = [117000; 560500];
% G = [117420; 560500];
% % H = [117410; 560530];
% % I = [117400; 560320];
% J = [117970; 560440];
% K = [118000; 560500];
% L = [115960; 559120];
% M = [116050; 559030];
% N = [117410; 560100];
% O = [117410; 560460];
% P = [116600; 559960];
% Q = [118060; 560520];
% R = [115418; 557782];
% S = [115552; 557776];
% T = [116030; 558646];
% U = [118060; 560214];
% V = [118060; 560282];
% W = [115984; 558702];
% X = [115440; 557970];
% Y = [115432; 557960];
% % Z = [];
% 
% edgeCoord = [a b c d e f g h i j l m n o p q r s t u v w x y z ...
%     A B C D E F G J K L M N O P Q R S T U V W X Y]';
% 
% edgeCoordString = ['a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z' ...
%     'A' 'B' 'C' 'D' 'E' 'F' 'G' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y']';
% 
% clearvars a b c d e f g h i j l m n o p q r s t u v w x y z ...
%     A B C D E F G J K L M N O P Q R S T U V W X Y
% 
% figureRH;
% scatter(edgeCoord(:,1), edgeCoord(:,2))
% text(edgeCoord(:,1), edgeCoord(:,2), edgeCoordString, 'FontSize',fontsize)
% axis on; axis vis3d
% view(46, 90)


%% Computations
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


%% Visualisation: all polygons
f1 = figureRH;
surf(PHZ1.DEM.X, PHZ1.DEM.Y, PHZ1.DEM.Z); hold on
% surf(PHZ2.DEM.X, PHZ2.DEM.Y, PHZ2.DEM.Z)
axis on; axis vis3d
view(46, 90)

light_gray = [0.8 0.8 0.8];
colormap(repmat(light_gray, 64, 1))
shading flat

plot(x, y, '-k', 'LineWidth', 1)

fn = fieldnames(pgons);
clrs = brewermap(numel(fn), 'Paired'); % cbf colour scheme
for k = 1:numel(fn)
    if( isnumeric(pgons.(fn{k})) )
        patch(pgons.(fn{k})(:,1), pgons.(fn{k})(:,2), clrs(k,:), 'FaceAlpha',.2, 'EdgeColor',clrs(k,:), 'LineWidth',3)
    end
end

ax = gca; ax.SortMethod = 'childorder';

lgnd = ['2019 Q0'; '2022 Q4'; string(fn)];
legend(lgnd)

% Narrow(fontsize)


%% Visualisation: subtidal polygons
pgons = getPgons;

f2 = figureRH;
surf(PHZ1.DEM.X, PHZ1.DEM.Y, PHZ1.DEM.Z); hold on
% surf(PHZ2.DEM.X, PHZ2.DEM.Y, PHZ2.DEM.Z)
axis on; axis vis3d
view(46, 90)

light_gray = [0.8 0.8 0.8];
colormap(repmat(light_gray, 64, 1))
shading flat    

plot(x, y, '-k', 'LineWidth', 1)

% fieldName1 = "platform";
fieldName2 = "lagoon_bathy";
fieldName3 = "chanwall";
fieldName4 = "south_bathy";
fieldName5 = "spit_bathy";
fieldName6 = "north_bathy";

% patch(pgons.(fieldName1)(:,1), pgons.(fieldName1)(:,2), 'm', 'FaceAlpha',.2, 'EdgeColor','m', 'LineWidth',3)
patch(pgons.(fieldName2)(:,1), pgons.(fieldName2)(:,2), 'r', 'FaceAlpha',.2, 'EdgeColor','r', 'LineWidth',3)
patch(pgons.(fieldName3)(:,1), pgons.(fieldName3)(:,2), 'k', 'FaceAlpha',.2, 'EdgeColor','k', 'LineWidth',3)
patch(pgons.(fieldName4)(:,1), pgons.(fieldName4)(:,2), 'b', 'FaceAlpha',.2, 'EdgeColor','b', 'LineWidth',3)
patch(pgons.(fieldName5)(:,1), pgons.(fieldName5)(:,2), 'y', 'FaceAlpha',.2, 'EdgeColor','y', 'LineWidth',3)
patch(pgons.(fieldName6)(:,1), pgons.(fieldName6)(:,2), 'g', 'FaceAlpha',.2, 'EdgeColor','g', 'LineWidth',3)

ax = gca; ax.SortMethod = 'childorder';

lgnd = ['2019 Q0'; '2022 Q4'; fieldName2; fieldName3; fieldName4; fieldName5; fieldName6];
legend(lgnd)

% Narrow(fontsize)


%% Visualisation: intertidal polygons
pgons = getPgons;

f3 = figureRH;
surf(PHZ1.DEM.X, PHZ1.DEM.Y, PHZ1.DEM.Z); hold on
% surf(PHZ2.DEM.X, PHZ2.DEM.Y, PHZ2.DEM.Z)
axis on; axis vis3d
view(46, 90)

light_gray = [0.8 0.8 0.8];
colormap(repmat(light_gray, 64, 1))
shading flat    

plot(x, y, '-k', 'LineWidth', 1)

fieldName1 = "south_beach";
fieldName2 = "spit_sea";
fieldName3 = "hook";
fieldName4 = "lagoon";
fieldName5 = "ceres";
% fieldName6 = "gate";
% fieldName7 = "harbour";

patch(pgons.(fieldName1)(:,1), pgons.(fieldName1)(:,2), 'b', 'FaceAlpha',.2, 'EdgeColor','b', 'LineWidth',3)
patch(pgons.(fieldName2)(:,1), pgons.(fieldName2)(:,2), 'y', 'FaceAlpha',.2, 'EdgeColor','y', 'LineWidth',3)
patch(pgons.(fieldName3)(:,1), pgons.(fieldName3)(:,2), 'r', 'FaceAlpha',.2, 'EdgeColor','r', 'LineWidth',3)
patch(pgons.(fieldName4)(:,1), pgons.(fieldName4)(:,2), 'c', 'FaceAlpha',.2, 'EdgeColor','c', 'LineWidth',3)
patch(pgons.(fieldName5)(:,1), pgons.(fieldName5)(:,2), 'm', 'FaceAlpha',.2, 'EdgeColor','m', 'LineWidth',3)
% patch(pgons.(fieldName6)(:,1), pgons.(fieldName6)(:,2), 'k', 'FaceAlpha',.2, 'EdgeColor','k', 'LineWidth',3)
% patch(pgons.(fieldName7)(:,1), pgons.(fieldName7)(:,2), 'k', 'FaceAlpha',.2, 'EdgeColor','k', 'LineWidth',3)

ax = gca; ax.SortMethod = 'childorder';

lgnd = ['2019 Q0'; '2022 Q4'; fieldName1; fieldName2; fieldName3; fieldName4; fieldName5];
legend(lgnd)

% Narrow(fontsize)


%% Visualisation: supratidal polygons
pgons = getPgons;

f4 = figureRH;
surf(PHZ1.DEM.X, PHZ1.DEM.Y, PHZ1.DEM.Z); hold on
% surf(PHZ2.DEM.X, PHZ2.DEM.Y, PHZ2.DEM.Z)
axis on; axis vis3d
view(46, 90)

light_gray = [0.8 0.8 0.8];
colormap(repmat(light_gray, 64, 1))
shading flat    

plot(x, y, '-k', 'LineWidth', 1)

fieldName1 = "south_beach";
fieldName2 = "spit";
fieldName3 = "NW_beach";

patch(pgons.(fieldName1)(:,1), pgons.(fieldName1)(:,2), 'y', 'FaceAlpha',.2, 'EdgeColor','y', 'LineWidth',3)
patch(pgons.(fieldName2)(:,1), pgons.(fieldName2)(:,2), 'r', 'FaceAlpha',.2, 'EdgeColor','r', 'LineWidth',3)
patch(pgons.(fieldName3)(:,1), pgons.(fieldName3)(:,2), 'b', 'FaceAlpha',.2, 'EdgeColor','b', 'LineWidth',3)

ax = gca; ax.SortMethod = 'childorder';

lgnd = ['2019 Q0'; '2022 Q4'; fieldName1; fieldName2; fieldName3];
legend(lgnd)

% Narrow(fontsize)


%% Visualisation: polygons
contourLevels = [0.3, PHZ.AHW, 4, -1.6];
pgons = getPgons;

f5 = figureRH;
tiledlayout("flow", "TileSpacing","tight")

% Supratidal
nexttile
surf(PHZ1.DEM.X, PHZ1.DEM.Y, PHZ1.DEM.Z); hold on
axis off equal
view(46, 90)

light_gray = [0.8, 0.8, 0.8];
colormap(repmat(light_gray, 64, 1))
shading flat

plot(x, y, '-k', 'LineWidth', 1)
ax = gca; ax.SortMethod = 'childorder';

patch(pgons.south_beach(:,1), pgons.south_beach(:,2), 'b', 'FaceAlpha',.2, 'EdgeColor','b', 'LineWidth',3)
patch(pgons.spit(:,1), pgons.spit(:,2), 'y', 'FaceAlpha',.2, 'EdgeColor','y', 'LineWidth',3)
patch(pgons.NW_beach(:,1), pgons.NW_beach(:,2), 'r', 'FaceAlpha',.2, 'EdgeColor','r', 'LineWidth',3)

legend('2019 Q0', '2022 Q4', 'south', 'spit', 'north', "Fontsize",fontsize/2, "Location","northwest")
text(1.155e5, 5.592e5, [mat2str(contourLevels(2)), ' \leq z < ', mat2str(contourLevels(3)), ' m'],...
    "Fontsize",fontsize/2, "FontWeight","bold")

% Intertidal
nexttile
surf(PHZ1.DEM.X, PHZ1.DEM.Y, PHZ1.DEM.Z); hold on
axis off equal
view(46, 90)

light_gray = [0.8, 0.8, 0.8];
colormap(repmat(light_gray, 64, 1))
shading flat

plot(x, y, '-k', 'LineWidth', 1)
ax = gca; ax.SortMethod = 'childorder';

patch(pgons.south_beach(:,1), pgons.south_beach(:,2), 'b', 'FaceAlpha',.2, 'EdgeColor','b', 'LineWidth',3)
patch(pgons.spit_sea(:,1), pgons.spit_sea(:,2), 'y', 'FaceAlpha',.2, 'EdgeColor','y', 'LineWidth',3)
patch(pgons.hook(:,1), pgons.hook(:,2), 'g', 'FaceAlpha',.2, 'EdgeColor','g', 'LineWidth',3)
patch(pgons.lagoon(:,1), pgons.lagoon(:,2), 'r', 'FaceAlpha',.2, 'EdgeColor','r', 'LineWidth',3)
patch(pgons.ceres(:,1), pgons.ceres(:,2), 'm', 'FaceAlpha',.2, 'EdgeColor','m', 'LineWidth',3)

legend('2019 Q0', '2022 Q4', 'south', 'spit', 'hook', 'lagoon', 'Ceres', "Fontsize",fontsize/2, "Location","northwest")
text(1.155e5, 5.592e5, [mat2str(contourLevels(1)), ' \leq z < ', mat2str(contourLevels(2)), ' m'],...
    "Fontsize",fontsize/2, "FontWeight","bold")

% Subtidal
nexttile
surf(PHZ1.DEM.X, PHZ1.DEM.Y, PHZ1.DEM.Z); hold on
axis off equal
view(46, 90)

light_gray = [0.8, 0.8, 0.8];
colormap(repmat(light_gray, 64, 1))
shading flat

plot(x, y, '-k', 'LineWidth', 1)
ax = gca; ax.SortMethod = 'childorder';

patch(pgons.south_bathy(:,1), pgons.south_bathy(:,2), 'b', 'FaceAlpha',.2, 'EdgeColor','b', 'LineWidth',3)
patch(pgons.spit_bathy(:,1), pgons.spit_bathy(:,2), 'y', 'FaceAlpha',.2, 'EdgeColor','y', 'LineWidth',3)
patch(pgons.north_bathy(:,1), pgons.north_bathy(:,2), 'g', 'FaceAlpha',.2, 'EdgeColor','g', 'LineWidth',3)
patch(pgons.lagoon_bathy(:,1), pgons.lagoon_bathy(:,2), 'r', 'FaceAlpha',.2, 'EdgeColor','r', 'LineWidth',3)

legend('2019 Q0', '2022 Q4', 'south', 'spit', 'north', 'lagoon', "Fontsize",fontsize/2, "Location","northwest")
text(1.155e5, 5.592e5, [mat2str(contourLevels(4)), ' \leq z < ', mat2str(contourLevels(1)), ' m'],...
    "Fontsize",fontsize/2, "FontWeight","bold")
