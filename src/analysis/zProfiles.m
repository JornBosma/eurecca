%% Initialisation
close all
clear
clc

eurecca_init

% processed topo files
load('zSounding.mat')
load('zProfiles_20201016.mat')

% processed sedi files
load('JDN_samples.mat')
load('sampleGPS.mat')

data = {z_UTD_realisatie, z_2019_Q4, z_2020_Q1, z_2020_Q2, z_2020_Q3, z_2020_Q4, z_2021_Q1, zProfiles_20201016};
names = {'2019 Q3', '2019 Q4', '2020 Q1', '2020 Q2', '2020 Q3', '2020 Q4', '2021 Q1', 'zProfiles 2020-10-16'};

% other settings
fontsize = 25;

%% Visualisation: topo-/bathymetric maps
% figure2('Name', 'Elevation maps')
% tiledlayout('flow', 'TileSpacing', 'Compact');
% for n = 1:numel(data)-1
%     ax(n) = nexttile;
%     scatter(data{n}.xRD, data{n}.yRD, [], data{n}.z, '.')
% %     p(2) = scatter(data{n}.xRD(data{n}.z==-1.6), data{n}.yRD(data{n}.z==-1.6), 4, 'g', 'filled');
%     text(117100, 558200, names{n}, 'FontSize', fontsize)
%     xticks(114000:1e3:118000)
%     yticks(558000:1e3:561000) 
%     xlabel('xRD (m)')
%     ylabel('yRD (m)')
%     c = colorbar;
%     c.Label.String = 'm +NAP';
%     c.Label.Interpreter = 'latex';
%     c.TickLabelInterpreter = 'latex';
%     caxis([-5 5]);
%     colormap(brewermap([], '*PuOr'))
% %     set(gca, 'Color', [.8 .8 .8])
% %     legend(p(2), 'NAP -1.6m', 'Location', 'northwest')
%     grid on
% %     axis([1.1695e5 1.1765e5 5.5976e5 5.6040e5])
% end
% set(ax, 'XLim', [114800, 118400]);
% set(ax, 'YLim', [557500, 560800]);
% linkaxes(ax)

%% Visualisation: topo-/bathymetric difference map
load('diffMap_Q3_2020-UTD.mat')
diffMap1 = diffMap;

% figure('Name', 'Q3 2020 - Q3 2019')
figure2
scatter(diffMap1.xRD, diffMap1.yRD, [], diffMap1.z, '.')
xlabel('xRD (m)')
ylabel('yRD (m)')
c = colorbar;
c.Label.Interpreter = 'latex';
c.TickLabelInterpreter = 'latex';
c.Label.String = ['$<$ Erosion (m) $', repmat('\ ', 1, 30), '$ Accretion (m) $>$'];
c.FontSize = fontsize;
caxis([-2 2]);
colormap(brewermap([], '*RdBu'))
% set(gca, 'Color', [.8 .8 .8])
% title('Q3 2020 - Q3 2019')
axis([1.1695e5 1.1765e5 5.5976e5 5.6040e5])
axis square

% load('diffMap_Q1_21-20.mat')
% diffMap2 = diffMap;
% clear diffMap

% figure2('Name', 'Q1 2021 - Q1 2020')
% scatter(diffMap2.xRD, diffMap2.yRD, [], diffMap2.z, '.')
% xlabel('xRD (m)')
% ylabel('yRD (m)')
% c = colorbar;
% c.Label.Interpreter = 'latex';
% c.TickLabelInterpreter = 'latex';
% c.Label.String = ['$<$ Erosion (m) $', repmat('\ ', 1, 30), '$ Accretion (m) $>$'];
% c.FontSize = fontsize;
% caxis([-2 2]);
% colormap(brewermap([], '*RdBu'))
% % set(gca, 'Color', [.8 .8 .8])
% % title('Q1 2021 - Q3 2019')
% axis([1.1695e5 1.1765e5 5.5976e5 5.6040e5])
% axis square

% %% Visualisation: cross-shore profiles
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
