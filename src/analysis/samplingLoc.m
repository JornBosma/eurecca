%% Initialisation
close all
clear
clc

eurecca_init

% processed topo files
load('zSounding.mat')

% processed sedi files
load('JDN_samples.mat')
load('sampleGPS.mat')

data = {z_UTD_realisatie, z_2019_Q4, z_2020_Q1, z_2020_Q2, z_2020_Q3, z_2020_Q4, z_2021_Q1};
names = {'UTD realisatie', '2019 Q4', '2020 Q1', '2020 Q2', '2020 Q3', '2020 Q4', '2021 Q1'};

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
     'MarkerEdgeColor',[.8, 0, 0],...
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
    yticks(558000:1e3:561000) 
    xlabel('xRD (m)')
    ylabel('yRD (m)')
    c = colorbar;
    c.Label.String = 'm +NAP';
    c.Label.Interpreter = 'latex';
    c.TickLabelInterpreter = 'latex';
    caxis([-5 5]);
    colormap(brewermap([], '*PuOr'))
    set(gca, 'Color', [.8 .8 .8])
    text(117100, 558200, names{n}, 'FontSize', 16)
%     legend([p(2) p(3) p(4)], {'NAP -1.6m','Sample','Core'}, 'Location', 'northwest')
    legend([p(3) p(4)], {'Sample','Core'}, 'Location', 'northwest')
    grid on
    axis equal
end

%% Visualisation: actual sampling locations
figure2('Name', 'Sampling overview')
tl = tiledlayout('flow', 'TileSpacing', 'Compact');

ax1 = nexttile;
scatter(data{1}.xRD, data{1}.yRD, [], data{1}.z, '.'); hold on
p(1) = plot(sampleShell.RDX, sampleShell.RDY, 'o',...
'LineWidth',2,...
'MarkerSize',5,...
 'MarkerEdgeColor',[.8, 0, 0],...
'MarkerFaceColor','k');
p(2) = plot(sampleDune.Easting, sampleDune.Northing, 'o',...
'LineWidth',2,...
'MarkerSize',5,...
'MarkerEdgeColor',[.4, 1, 1],...
'MarkerFaceColor','k');
p(3) = plot(sampleArmor.Easting, sampleArmor.Northing, 'o',...
'LineWidth',2,...
'MarkerSize',5,...
'MarkerEdgeColor',[0, .8, 0],...
'MarkerFaceColor','k');
xticks(114000:1e3:118000)
yticks(558000:1e3:561000) 
xlabel('xRD (m)')
ylabel('yRD (m)')
c = colorbar;
c.Label.String = 'm +NAP';
c.Label.Interpreter = 'latex';
c.TickLabelInterpreter = 'latex';
caxis([-5 5]);
colormap(brewermap([], '*PuOr'))
set(gca, 'Color', [.8 .8 .8])
text(117100, 558200, '23 Apr 2019 \newline (Jan De Nul)', 'FontSize', 16)
legend([p(1) p(2) p(3)], {'Shell layer','Dune layer','Armor layer'}, 'Location', 'northwest')
grid on
axis equal

ax2 = nexttile;
p(1) = scatter(data{5}.xRD, data{5}.yRD, [], data{5}.z, '.'); hold on
p(2) = plot(sampleData1.xRD, sampleData1.yRD, 'o',...
'LineWidth',2,...
'MarkerSize',5,...
 'MarkerEdgeColor',[0, .8, 0],...
'MarkerFaceColor','k');
xticks(114000:1e3:118000)
yticks(558000:1e3:561000) 
xlabel('xRD (m)')
ylabel('yRD (m)')
c = colorbar;
c.Label.String = 'm +NAP';
c.Label.Interpreter = 'latex';
c.TickLabelInterpreter = 'latex';
caxis([-5 5]);
colormap(brewermap([], '*PuOr'))
set(gca, 'Color', [.8 .8 .8])
text(117100, 558200, '16 Oct 2020 (iPhone)', 'FontSize', 16)
legend(p(2), 'Sample', 'Location', 'northwest')
grid on
axis equal

ax3 = nexttile;
p(1) = scatter(data{5}.xRD, data{5}.yRD, [], data{5}.z, '.'); hold on
p(2) = plot(sampleData2.xRD, sampleData2.yRD, 'o',...
'LineWidth',2,...
'MarkerSize',5,...
 'MarkerEdgeColor',[0, .8, 0],...
'MarkerFaceColor','k');
p(3) = plot(sampleData3.xRD, sampleData3.yRD, 'o',...
'LineWidth',2,...
'MarkerSize',5,...
'MarkerEdgeColor',[.8, 0, 0],...
'MarkerFaceColor','k');
xticks(114000:1e3:118000)
yticks(558000:1e3:561000)
xlabel('xRD (m)')
ylabel('yRD (m)')
c = colorbar;
c.Label.String = 'm +NAP';
c.Label.Interpreter = 'latex';
c.TickLabelInterpreter = 'latex';
caxis([-5 5]);
colormap(brewermap([], '*PuOr'))
set(gca, 'Color', [.8 .8 .8])
text(117100, 558200, '2/3 Dec 2020', 'FontSize', 16)
legend([p(2) p(3)], {'Sample','Sample$_i$'}, 'Location', 'northwest')
grid on
axis equal

ax4 = nexttile;
p(1) = scatter(data{5}.xRD, data{5}.yRD, [], data{5}.z, '.'); hold on
p(2) = plot(sampleData1.xRD, sampleData1.yRD, 'o',...
'LineWidth',2,...
'MarkerSize',5,...
 'MarkerEdgeColor',[0, .8, 0],...
'MarkerFaceColor','k');
xticks(114000:1e3:118000)
yticks(558000:1e3:561000) 
xlabel('xRD (m)')
ylabel('yRD (m)')
c = colorbar;
c.Label.String = 'm +NAP';
c.Label.Interpreter = 'latex';
c.TickLabelInterpreter = 'latex';
caxis([-5 5]);
colormap(brewermap([], '*PuOr'))
set(gca, 'Color', [.8 .8 .8])
text(117100, 558200, '8 Apr 2021', 'FontSize', 16)
legend(p(2), 'Sample', 'Location', 'northwest')
grid on
axis equal

ax5 = nexttile;
p(1) = scatter(data{5}.xRD, data{5}.yRD, [], data{5}.z, '.'); hold on
p(2) = plot(sampleData1.xRD, sampleData1.yRD, 'o',...
'LineWidth',2,...
'MarkerSize',5,...
 'MarkerEdgeColor',[0, .8, 0],...
'MarkerFaceColor','k');
xticks(114000:1e3:118000)
yticks(558000:1e3:561000) 
xlabel('xRD (m)')
ylabel('yRD (m)')
c = colorbar;
c.Label.String = 'm +NAP';
c.Label.Interpreter = 'latex';
c.TickLabelInterpreter = 'latex';
caxis([-5 5]);
colormap(brewermap([], '*PuOr'))
set(gca, 'Color', [.8 .8 .8])
text(117100, 558200, '6 June 2021 (iPhone)', 'FontSize', 16)
legend(p(2), 'Sample', 'Location', 'northwest')
grid on
axis equal

set([ax1, ax2, ax3, ax4, ax5], 'XLim', [114800, 118400]);
set([ax1, ax2, ax3, ax4, ax5], 'YLim', [557500, 560800]);
linkaxes([ax1, ax2, ax3, ax4, ax5]);
