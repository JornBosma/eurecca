%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize] = eurecca_init;

% combined; entire period
D10Cep = [59.4 48.4 42.3 43.5];
D50Cep = [41.7 41.7 41.7 41.7];
D90Cep = [7.2 16.4 23.3 21.4];

% combined; calm period
D10Ccp = [41.4 27.4 19.9 21.8];
D50Ccp = [28.6 28.6 28.6 28.6];
D90Ccp = [0.3 1.6 3.5 2.4];

% combined; stormy period
D10Csp = [85.2 75.3 69.3 70.0];
D50Csp = [60.2 60.2 60.2 60.2];
D90Csp = [16.1 34.3 42.9 40.1];

% waves; entire period
D10wep = [52.6 44.6 40.1 41.2];
D50wep = [39.4 39.4 39.4 39.4];
D90wep = [7.1 17.0 23.5 22.1];

% current; entire period
D10cep = [11.1 2.7 1.3 1.6];
D50cep = [1.8 1.8 1.8 1.8];
D90cep = [0.0 0.0 0.0 0.0];

%% Visualisation
f = figure;
tiledlayout(3, 1, 'TileSpacing', 'tight')

nexttile
bar([D10Cep; D50Cep; D90Cep])
legend('no HE', '\gamma = 0.50', '\gamma = 0.75', 'Fg^*', 'Location', 'northeast')
xticklabels({'D_{10}', 'D_{50}', 'D_{90}'})
ylim([0 100])
set(gca,'xticklabel',{[]})
title('combined')

nexttile
bar([D10wep; D50wep; D90wep])
ylabel('time (%) potential entrainment')
xticklabels({'D_{10}', 'D_{50}', 'D_{90}'})
ylim([0 100])
set(gca,'xticklabel',{[]})
title('waves only')

nexttile
bar([D10cep; D50cep; D90cep])
xticklabels({'D_{10}', 'D_{50}', 'D_{90}'})
ylim([0 100])
title('current only')

% exportgraphics(f, 'time_percent.png')
