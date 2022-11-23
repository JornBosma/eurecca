%% Initialisation
close all
clear
clc

[xl, yl, xt, yt, fontsize] = eurecca_init;
addpath('/Users/jwb/Desktop/OET/matlab/')

oetsettings('quiet')

% processed topo files
load('zSounding.mat')

data = {z_UTD_realisatie, z_2019_Q4, z_2020_Q1, z_2020_Q2, z_2020_Q3, z_2020_Q4, z_2021_Q1, z_2021_06, z_2021_09, z_2021_11};
names = {'2019 Q3', '2019 Q4', '2020 Q1', '2020 Q2', '2020 Q3', '2020 Q4', '2021 Q1', '2021-06', '2021-09', '2021-11'};

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

%% Visualisation: actual instrument locations
figure2('Name', names{10})

p(1) = scatter(data{10}.xRD, data{10}.yRD, [], data{10}.z, '.'); hold on
p(2) = plot(LxCxADV(:, 1), LxCxADV(:, 2), 'kx',...
'LineWidth', 2,...
'MarkerSize', 8);
p(3) = plot(LxCxPRES(:, 1), LxCxPRES(:, 2), 'ko',...
'LineWidth', 2,...
'MarkerSize', 8);

c = colorbar;
c.Label.String = 'm +NAP';
c.Label.Interpreter = 'latex';
c.TickLabelInterpreter = 'latex';
c.FontSize = fontsize;
clim([-5, 5]);

colormap(brewermap([], '*PuOr'))

xlim([xl(1), xl(2)])
ylim([yl(1), yl(2)])
axis equal

xticks(xt)
xticklabels(xt/1000)
yticks(yt)
yticklabels(yt/1000)

xlabel('easting [RD] (km)')
ylabel('northing [RD] (km)')

EHY_plot_satellite_map('localEPSG', 28992, 'FaceAlpha', 0.7)

legend([p(2) p(3)], {'ADV @ z $\sim$ -0.75m', 'press @ z $\sim$ -1.50m'}, 'Location', 'northwest', 'Box', 'on', 'Color', 'w')
grid on
% view(48, 90)

%% Visualisation: actual instrument locations
position = {'L1C1'; 'L2C5'; 'L3C1'; 'L4C1'; 'L5C1'; 'L6C1'};

figure2('Name', names{10})

p(1) = scatter(data{10}.xRD, data{10}.yRD, [], data{10}.z, '.'); hold on
p(2) = plot(LxCxADV([1 5 8:11], 1), LxCxADV([1 2 8:11], 2), 'kx',...
'LineWidth', 4,...
'MarkerSize', 10);
text(LxCxADV([1 5 8:11], 1)+30, LxCxADV([1 2 8:11], 2)+15, position, 'FontSize', fontsize)

c = colorbar;
c.Label.String = 'm +NAP';
c.Label.Interpreter = 'latex';
c.TickLabelInterpreter = 'latex';
c.FontSize = fontsize;
clim([-5, 5]);

colormap(brewermap([], '*PuOr'))

xlim([xl(1), xl(2)])
ylim([yl(1), yl(2)])
axis equal

xticks(xt)
xticklabels(xt/1000)
yticks(yt)
yticklabels(yt/1000)

xlabel('easting [RD] (km)')
ylabel('northing [RD] (km)')

EHY_plot_satellite_map('localEPSG', 28992, 'FaceAlpha', 0.7)

legend([p(2)], {'ADV + STM @ z $\sim$ -0.75m'}, 'Location', 'northwest', 'Box', 'on', 'Color', 'w')
grid on
% view(48, 90)
