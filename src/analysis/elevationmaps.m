%% Initialisation
close all
clear
clc

[xl, yl, xt, yt, fontsize] = eurecca_init;

% processed topo files
load('zSounding.mat')
load d_2022_Q3-2019_Q3.mat

surveys = {z_UTD_realisatie, z_2019_Q4, z_2020_Q1, z_2020_Q2, z_2020_Q3, z_2020_Q4, z_2021_Q1, z_2021_06, z_2021_09, z_2021_11, z_2022_Q3};
names = {'2019 Q3', '2019 Q4', '2020 Q1', '2020 Q2', '2020 Q3', '2020 Q4', '2021 Q1', '2021-06', '2021-09', '2021-11', '2022 Q3'};

%% Calculations: topo-/bathymetric maps
z_UTD_realisatie_2 = table(z_2022_Q3.xRD, z_2022_Q3.yRD,...
    griddata(z_UTD_realisatie.xRD, z_UTD_realisatie.yRD, z_UTD_realisatie.z, z_2022_Q3.xRD, z_2022_Q3.yRD),...
    'VariableNames',{'xRD','yRD','z'});

%% Visualisation: topo-/bathymetric maps
% figure2('Name', 'Elevation maps')
% tiledlayout('flow', 'TileSpacing', 'Compact');
% for n = 1:numel(surveys)-1
%     ax(n) = nexttile;
%     scatter(surveys{n}.xRD, surveys{n}.yRD, [], surveys{n}.z, '.')
% %     p(2) = scatter(surveys{n}.xRD(surveys{n}.z==-1.6), surveys{n}.yRD(surveys{n}.z==-1.6), 4, 'g', 'filled');
%     text(117100, 558200, names{n}, 'FontSize', fontsize)
%     xticks(xt)
%     yticks(yt)
%     xlabel('xRD (m)')
%     ylabel('yRD (m)')
%     c = colorbar;
%     c.Label.String = 'm +NAP';
%     c.Label.Interpreter = 'latex';
%     c.TickLabelInterpreter = 'latex';
%     clim([-5 5]);
%     colormap(brewermap([], '*PuOr'))
% %     set(gca, 'Color', [.8 .8 .8])
% %     legend(p(2), 'NAP -1.6m', 'Location', 'northwest')
% %     axis([xl(1), xl(2), yl(1), yl(2)])
%     grid on
% %     axis equal
% %     camroll(-52.5)
% end
% linkaxes(ax)

%% Visualisation: topo-/bathymetric difference map
f = figure;
tiledlayout(1, 3);

ax(1) = nexttile;
scatter(z_UTD_realisatie_2.xRD(z_UTD_realisatie_2.z>0), z_UTD_realisatie_2.yRD(z_UTD_realisatie_2.z>0), [], z_UTD_realisatie_2.z(z_UTD_realisatie_2.z>0), '.')
title('Summer 2019')
crameri('cork', 'pivot', 0)

ax(2) = nexttile;
scatter(z_2022_Q3_raw.xRD(z_2022_Q3_raw.z>0), z_2022_Q3_raw.yRD(z_2022_Q3_raw.z>0), [], z_2022_Q3_raw.z(z_2022_Q3_raw.z>0), '.')
title('Summer 2022')
cb2 = colorbar;
cb2.Label.Interpreter = 'latex';
cb2.TickLabelInterpreter = 'latex';
cb2.Label.String = 'bed level (m + NAP)';
crameri('cork', 'pivot', 0)

ax(3) = nexttile;
scatter(dz_2022_Q3_2019_Q3.xRD(z_2022_Q3.z>0), dz_2022_Q3_2019_Q3.yRD(z_2022_Q3.z>0), [], dz_2022_Q3_2019_Q3.z(z_2022_Q3.z>0), '.')
title('Summer 2019-2022')
clim([-2 2]);
cb3 = colorbar;
cb3.Label.Interpreter = 'latex';
cb3.TickLabelInterpreter = 'latex';
cb3.Label.String = ['$<$ erosion (m) ', repmat('\ ', 1, 12), ' deposition (m) $>$'];
crameri('vik', 'pivot', 0)

set(ax([2, 3]), 'YTickLabel', [])
% set(ax([1, 2]), 'clim', [-2, 8])

xlabel(ax, 'easting - RD (m)')
ylabel(ax(1), 'northing - RD (m)')

box(ax, 'on')
grid(ax, 'on')

% axis(ax, [xl(1), xl(2), yl(1), yl(2)]) 
% axis(ax, 'equal')

% exportgraphics(f, 'fig1.pdf')

%% Visualisation
f = figure;
scatter(dz_2022_Q3_2019_Q3.xRD(z_2022_Q3.z>0), dz_2022_Q3_2019_Q3.yRD(z_2022_Q3.z>0), [], dz_2022_Q3_2019_Q3.z(z_2022_Q3.z>0), '.')
clim([-2 2]);
cb = colorbar;
cb.Label.Interpreter = 'latex';
cb.TickLabelInterpreter = 'latex';
cb.Label.String = ['$<$ erosion (m) ', repmat('\ ', 1, 12), ' deposition (m) $>$'];
% cb.Position([1 2 3 4])
set(cb,'position',[.85 .5 .05 .2])
crameri('vik', 'pivot', 0)
view(48, 90)
axis off

% exportgraphics(f, '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/MDPI Article 1 (draft)/Figures/fig7.pdf')

%% Calculations: interp map
survey = z_2020_Q3;
threshold = survey.z>=-1;

x = survey.xRD(threshold);
y = survey.yRD(threshold);
z = survey.z(threshold);

tri = delaunay(x, y);

%% Visualisation: interp map
f = figure;
trisurf(tri, x, y, z)
axis vis3d
axis off
view(61, 90)
shading interp
colorbar
crameri('vik', 'pivot', 0)

% l = light('Position',[-50 -15 29]);
% set(gca,'CameraPosition',[208 -50 7687])
% lighting phong

%% Visualisation: contour map A
% f = figure;
% [C, h] = tricontour(tri, x, y, z, 0:1:4);
% % clabel(C)
% axis vis3d
% axis off
% view(0, 90)
% shading interp
% colorbar
% crameri('vik', 'pivot', 0)

%% Visualisation: contour map B
% f = figure;
% [C, h] = tricont(x, y, tri, z, 0:1:4);
% % clabel(C)
% axis vis3d
% axis off
% view(0, 90)
% shading interp
% colorbar
% crameri('vik', 'pivot', 0)

%% Visualisation: cross-shore profiles
% load('zProfiles_20201016.mat')
% 
% transect_end = [find(diff(zProfiles_20201016.Time)>minutes(1)); length(zProfiles_20201016.Time)];
% transect_start = [1; transect_end(1:end-1)+1];
% 
% for n = 1:numel(transect_start)
% %     xd(n) = zeros(1, (transect_end(n)-transect_start(n))+1);
%     nap(n) = find(zProfiles_20201016.z(transect_start(n):transect_end(n))<0, 1)+(transect_start(n)-1);
%     for p = 1:(transect_end(n)-transect_start(n))+1
%         xd{n}(p) = norm([zProfiles_20201016.xRD(nap(n)) zProfiles_20201016.yRD(nap(n))] - [zProfiles_20201016.xRD(transect_start(n)+(p-1)) zProfiles_20201016.yRD(transect_start(n)+(p-1))]);
%         if transect_start(n)+(p-1) < nap(n)
%             xd{n}(p) = -xd{n}(p);
%         end
%     end
% end
% 
% figure2('Name', 'X-profiles')
% labels = {'WL01', 'Tr01', 'Tr02', 'Tr03', 'Tr04', 'WL02', 'Tr05', 'WL03', 'Tr06', 'WL04', 'Tr07'};
% p = 1;
% tiledlayout(3, 3)
% for n = [2:5 7 9 11]
% %     subplot(3,3,p)
%     nexttile
%     plot(xd{n}, zProfiles_20201016.z(transect_start(n):transect_end(n)), 'LineWidth', 3)
%     yline(0)
%     xline(0)
%     xlim([-100 200])
%     ylim([-2 2])
%     xlabel('d (m)')
%     ylabel('z (m +NAP)')
%     legend(labels(n))
%     grid on
% %     p = p + 1;
% end
