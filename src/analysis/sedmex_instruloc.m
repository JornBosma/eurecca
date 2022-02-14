%% Initialisation
close all
clear
clc

eurecca_init

% processed topo files
load('zSounding.mat')

data = {z_UTD_realisatie, z_2019_Q4, z_2020_Q1, z_2020_Q2, z_2020_Q3, z_2020_Q4, z_2021_Q1};
names = {'UTD realisatie', '2019 Q4', '2020 Q1', '2020 Q2', '2020 Q3', '2020 Q4', '2021 Q1'};

%% Deployments coordinates
% L1 [xRD, yRD]
L1C1 = [117421.461, 560053.687]; % vector
L1C2 = [117445.356, 560044.640]; % ossi

% L2 [xRD, yRD]
L2C1 = [117157.618, 559855.384]; % keller
L2C2 = [117192.969, 559821.816]; % vector
L2C3 = [117193.927, 559819.944]; % vector
L2C4 = [117196.516, 559818.148]; % vector
L2C5 = [117199.347, 559816.116]; % 3D-sonar
L2C6 = [117201.857, 559812.393]; % ossi
L2C7 = [117204.882, 559809.741]; % adcp
L2C8 = [117208.564, 559805.816]; % ossi
L2C9 = [117221.716, 559793.067]; % ossi
L2C10 = [117234.837, 559781.217]; % vector

% L3 [xRD, yRD]
L3C1 = [116838.947, 559536.489]; % vector

% L4 [xRD, yRD]
L4C1 = [116103.892, 558946.574]; % 3D-sonar
L4C2 = [116107.257, 558941.216]; % echo
L4C3 = [116124.834, 558917.274]; % ossi

% L5 [xRD, yRD]
L5C1 = [115670, 558603.7]; % vector
L5C2 = [115715.8, 558560.3]; % ossi

% L6 [xRD, yRD]
L6C1 = [115401.5, 558224.5]; % vector
L6C2 = [115469.5, 558176.4]; % ossi

% concatenated
LxCx = [L1C1;L1C2;L2C1;L2C2;L2C3;L2C4;L2C5;L2C6;L2C7;L2C8;L2C9;L2C10;...
    L3C1;L4C1;L4C2;L4C3;L5C1;L5C2;L6C1;L6C2];
LxCxADV = [L1C1;L2C2;L2C3;L2C4;L2C5;L2C7;L2C10;L3C1;L4C1;L5C1;L6C1];
LxCxPRES = [L1C2;L2C1;L2C2;L2C4;L2C5;L2C6;L2C8;L2C9;L2C10;...
    L4C1;L4C3;L5C2;L6C2];

% other settings
fontsize = 25;
xl = [11693 11759];
yl = [559650 560250];

%% Visualisation: actual instrument locations
for n = 5
    figure2('Name', names{n})
    p(1) = scatter(data{n}.xRD, data{n}.yRD, [], data{n}.z, '.'); hold on
    p(2) = plot(LxCxADV(:,1), LxCxADV(:,2), 'kx',...
    'LineWidth',2,...
    'MarkerSize',8);
    p(3) = plot(LxCxPRES(:,1), LxCxPRES(:,2), 'ko',...
    'LineWidth',2,...
    'MarkerSize',8);

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
    c.FontSize = fontsize;
    caxis([-5 5]);
    colormap(brewermap([], '*PuOr'))
    set(gca, 'Color', [.8 .8 .8])
    legend([p(2) p(3)], {'ADV @ z $\sim$ -0.75m', 'press @ z $\sim$ -1.50m'}, 'Location', 'northwest')
    grid on
    axis equal
    view(48, 90)
end
