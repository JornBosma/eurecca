%% Initialisation
close all
clear
clc

eurecca_init

% Jan De Nul: topo- & bathymetry
z_UTD_realisatie = JDN_xyz('UTD_realisatie.pts', 1, inf); % +bathy
z_2019_Q4 = JDN_xyz('2019_Q4.pts', 1, inf);
z_2020_Q1 = JDN_xyz('2020_Q1.pts', 1, inf);
z_2020_Q2 = JDN_xyz('2020_Q2.pts', 1, inf);
z_2020_Q3 = JDN_xyz('2020_Q3.pts', 1, inf); % +bathy
z_2020_Q4 = JDN_xyz('2020_Q4.xyz', 1, inf);
z_2021_Q1 = JDN_xyz('2021_Q1.xyz', 1, inf);

% sampleShell = importfile3("190423_JDN.1712.PQF.81.03.nl.00_schelpenlaag strandhaak.xlsx",...
%     "overzicht zevingen", [7, 35]); % Q4 2018
% sampleDune = importfile4("190423_JDN.1712.PQF.81.03.nl.00_korrelverdeling VD en SL_EB.xlsx",...
%     "Veiligheidsduin", [10, 56]); % Q1 2019
% sampleArmor = importfile5("190423_JDN.1712.PQF.81.03.nl.00_korrelverdeling VD en SL_EB.xlsx",...
%     "Slijtlaag_Erosiebuffer", [10, 23]); % Q1 2019
% save('JDN_samples.mat', 'sampleShell', 'sampleDune', 'sampleArmor')
load('JDN_samples.mat')

% TUD + UU: topo- & bathymetry
% zProfiles_20201016 = importfile("PHZD01.txt", [2, Inf]); % load rtk-gps data
% zProfiles_20201016.z = zProfiles_20201016.z - 1.5; % adjust heights for pole length (= 1.5/1.2 m on wheel/pole)
% save('zProfiles_20201016.mat', 'zProfiles_20201016')
load('zProfiles_20201016.mat')

% sedSamples1 = importfile6("PHZDsed1.txt", [2, Inf]); % load rtk-gps data of 02/12/2020
% sedSamples2 = importfile6("PHZDsed2.txt", [2, Inf]); % load rtk-gps data of 03/12/2020
% % sedSamples = [sedSamples1; sedSamples2]; % concatenate tables
% save('sedSamplesGPS.mat', 'sedSamples1', 'sedSamples2')
load('sedSamplesGPS.mat')

data = {z_UTD_realisatie, z_2019_Q4, z_2020_Q1, z_2020_Q2, z_2020_Q3, zProfiles_20201016};
names = {'UTD realisatie', '2019 Q4', '2020 Q1', '2020 Q2', '2020 Q3', 'zProfiles_20201016'};

%% Calculations
% z_UTD_realisatie_2 = table(z_2020_Q3.xRD, z_2020_Q3.yRD,...
%     griddata(z_UTD_realisatie.xRD, z_UTD_realisatie.yRD, z_UTD_realisatie.z, z_2020_Q3.xRD, z_2020_Q3.yRD),...
%     'VariableNames',{'xRD','yRD','z'});
% diffMap = table(z_2020_Q3.xRD, z_2020_Q3.yRD, z_2020_Q3.z - z_UTD_realisatie_2.z,...
%     'VariableNames',{'xRD','yRD','z'});
% save('diffMap_Q3_2020-UTD.mat', 'diffMap')
load('diffMap_Q3_2020-UTD.mat')

%% Visualisation: topo-/bathymetric maps
for n = 1:numel(data)
    figure2('Name', names{n})
    p(1) = scatter(data{n}.xRD, data{n}.yRD, [], data{n}.z, '.'); hold on
%     p(2) = scatter(data{n}.xRD(data{n}.z==-1.6), data{n}.yRD(data{n}.z==-1.6), 4, 'g', 'filled');
    xlim([114800 118400])
    ylim([557500 560800])
    xticks(114000:1e3:118000)
    yticks(557700:1e3:561000)
    xlabel('xRD (m)')
    ylabel('yRD (m)')
    c = colorbar;
    c.Label.String = 'm +NAP';
    caxis([-5 5]);
    colormap(brewermap([], '*RdBu'))
    set(gca, 'Color', [.8 .8 .8])
    title(names{n})
%     legend(p(2), 'NAP -1.6m', 'Location', 'northwest')
    grid on
    axis equal
end

%% Visualisation: topo-/bathymetric difference map
figure2('Name', 'Q3 2020 - Q3 2019')
scatter(diffMap.xRD, diffMap.yRD, [], diffMap.z, '.')
xlim([114800 118400])
ylim([557500 560800])
xticks(114000:1e3:118000)
yticks(557700:1e3:561000)
xlabel('xRD (m)')
ylabel('yRD (m)')
c = colorbar;
c.Label.String = '< Erosion (m)                           Accretion (m) >';
caxis([-2 2]);
colormap(brewermap([], '*RdBu'))
set(gca, 'Color', [.8 .8 .8])
title('Q3 2020 - Q3 2019')
grid on
axis equal

%% Visualisation: sampling locations JdN
for n = 1
    figure2('Name', names{n})
    scatter(data{n}.xRD, data{n}.yRD, [], data{n}.z, '.'); hold on
    p(1) = plot(sampleShell.RDX, sampleShell.RDY, 'o',...
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerEdgeColor',[1,1,.5],...
    'MarkerFaceColor','k');
    p(2) = plot(sampleDune.Easting, sampleDune.Northing, 'o',...
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerEdgeColor',[.4,1,1],...
    'MarkerFaceColor','k');
    p(3) = plot(sampleArmor.Easting, sampleArmor.Northing, 'o',...
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerEdgeColor',[0,.8,0],...
    'MarkerFaceColor','k');
    xlim([114800 118400])
    ylim([557500 560800])
    xticks(114000:1e3:118000)
    yticks(557700:1e3:561000)
    xlabel('xRD (m)')
    ylabel('yRD (m)')
    c = colorbar;
    c.Label.String = 'm +NAP';
    caxis([-5 5]);
    colormap(brewermap([], '*RdBu'))
    set(gca, 'Color', [.8 .8 .8])
    title(names{n})
    legend([p(1) p(2) p(3)], {'Shell','Dune','Armor'}, 'Location', 'northwest')
    grid on
    axis equal
end

%% Visualisation: proposed sampling locations
a = [116542; 116557; 116572]; % reference x-coordinates
b = [559337; 559320; 559303]; % reference y-coordinates
shX = 120; % shift in x-direction
shY = 95; % shift in y-direction
xRD = [a-10*shX; a-8*shX; a-6*shX; a-4*shX; a-2*shX; a; a+2*shX; a+4*shX;...
    a+6*shX; a+7.1*shX]; % x transects
yRD = [b-11.4*shY; b-8.2*shY; b-6*shY; b-4*shY; b-2*shY; b; b+2*shY; b+4*shY;...
    b+6*shY; b+8*shY]; % y transects
xRD_a = [115350; 117662; 117900; 117200; 116500]; % x additional
yRD_a = [558050; 560161.5; 560260; 560150; 559620]; % y additional
xRD_c = [115777; 116497; 117217]; % x cores
yRD_c = [558818; 559388; 559958]; % y cores
nSample = 3; % number of samples per transect
transectN = append('T', string(reshape(repmat((1:length(xRD)/nSample)', 1, nSample)', [], 1)));
sampleN = repmat({'S1';'S2';'S3'}, length(xRD)/nSample, 1);
sampleProp = table(transectN, sampleN, xRD, yRD);

for n = 5
    figure2('Name', names{n})
    p(1) = scatter(data{n}.xRD, data{n}.yRD, [], data{n}.z, '.'); hold on
%     p(2) = scatter(data{n}.xRD(data{n}.z==-1.6), data{n}.yRD(data{n}.z==-1.6), 4, 'g', 'filled');
    p(3) = plot([sampleProp.xRD; xRD_a], [sampleProp.yRD; yRD_a], 'o',...
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerEdgeColor',[1,1,.5],...
    'MarkerFaceColor','k');
    text(xRD(1:3:end)+20, yRD(1:3:end)+20, transectN(1:3:end), 'Color', 'k', 'FontSize',10)
    text(xRD_a+10, yRD_a+50, ['A1'; 'A2'; 'A3'; 'A4'; 'A5'], 'Color', 'k', 'FontSize',10)
    p(4) = plot(xRD_c, yRD_c, 'o',...
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','w');
    text([115777; 116497; 117217]+10, [558818; 559388; 559958]+50, ['C1'; 'C2'; 'C3'],...
        'Color', 'k', 'FontSize',10)
    xlim([114800 118400])
    ylim([557500 560800])
    xticks(114000:1e3:118000)
    yticks(557700:1e3:561000)
    xlabel('xRD (m)')
    ylabel('yRD (m)')
    c = colorbar;
    c.Label.String = 'm +NAP';
    caxis([-5 5]);
    colormap(brewermap([], '*RdBu'))
    set(gca, 'Color', [.8 .8 .8])
    title(names{n})
%     legend([p(2) p(3) p(4)], {'NAP -1.6m','Sample','Core'}, 'Location', 'northwest')
    legend([p(3) p(4)], {'Sample','Core'}, 'Location', 'northwest')
    grid on
    axis equal
end

%% Visualisation: actual sampling locations
for n = 5
    figure2('Name', names{n})
    p(1) = scatter(data{n}.xRD, data{n}.yRD, [], data{n}.z, '.'); hold on
%     p(2) = scatter(data{n}.xRD(data{n}.z==-1.6), data{n}.yRD(data{n}.z==-1.6), 4, 'g', 'filled');
    p(3) = plot(sedSamples1.xRD, sedSamples1.yRD, 'o',...
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerEdgeColor',[1,1,.5],...
    'MarkerFaceColor','k');
    p(4) = plot(sedSamples2.xRD, sedSamples2.yRD, 'o',...
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerEdgeColor',[1,1,.9],...
    'MarkerFaceColor','k');
    xlim([114800 118400])
    ylim([557500 560800])
    xticks(114000:1e3:118000)
    yticks(557700:1e3:561000)
    xlabel('xRD (m)')
    ylabel('yRD (m)')
    c = colorbar;
    c.Label.String = 'm +NAP';
    caxis([-5 5]);
    colormap(brewermap([], '*RdBu'))
    set(gca, 'Color', [.8 .8 .8])
    title(names{n})
%     legend([p(2) p(3) p(4)], {'NAP -1.6m','Sample','Sample_i'}, 'Location', 'northwest')
    legend([p(3) p(4)], {'Sample','Sample_i'}, 'Location', 'northwest')
    grid on
    axis equal
end

%% Visualisation: cross-shore profiles
transect_end = [find(diff(zProfiles_20201016.Time)>minutes(1)); length(zProfiles_20201016.Time)];
transect_start = [1; transect_end(1:end-1)+1];

for n = 1:numel(transect_start)
%     xd(n) = zeros(1, (transect_end(n)-transect_start(n))+1);
    nap(n) = find(zProfiles_20201016.z(transect_start(n):transect_end(n))<0, 1)+(transect_start(n)-1);
    for p = 1:(transect_end(n)-transect_start(n))+1
        xd{n}(p) = norm([zProfiles_20201016.xRD(nap(n)) zProfiles_20201016.yRD(nap(n))] - [zProfiles_20201016.xRD(transect_start(n)+(p-1)) zProfiles_20201016.yRD(transect_start(n)+(p-1))]);
        if transect_start(n)+(p-1) < nap(n)
            xd{n}(p) = -xd{n}(p);
        end
    end
end

figure2('Name', 'X-profiles')
labels = {'WL01', 'Tr00', 'Tr01', 'Tr02', 'Tr03', 'WL02', 'Tr04', 'WL03', 'Tr05', 'WL04', 'Tr06'};
p = 1;
tiledlayout(3, 3)
for n = [2:5 7 9 11]
%     subplot(3,3,p)
    nexttile
    plot(xd{n}, zProfiles_20201016.z(transect_start(n):transect_end(n)), 'LineWidth', 3)
    yline(0)
    xline(0)
    xlim([-100 200])
    ylim([-2 2])
    xlabel('d (m)')
    ylabel('z (m +NAP)')
    legend(labels(n))
    grid on
%     p = p + 1;
end
