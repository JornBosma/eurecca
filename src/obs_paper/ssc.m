% Suspended sediment concentrations during SEDMEX campaign
% J.W. Bosma, 2023

%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize, ~] = eurecca_init;

% colourblind-friendly colour palette
orange = [230/255, 159/255, 0];
blue = [86/255, 180/255, 233/255];
yellow = [240/255, 228/255, 66/255];
redpurp = [204/255, 121/255, 167/255];
bluegreen = [0, 158/255, 115/255];

%% Initialisation
load L2C10_eta_Hm0.mat

L1C1_L2_075 = load("L1C1_SSC_L2_075.mat");
L1C1_L2_120 = load("L1C1_SSC_L2_120.mat");
L2C3_L2_075 = load("L2C3_SSC_L2_075.mat");
L2C3_L2_120 = load("L2C3_SSC_L2_120.mat");
L3C1_L2_075 = load("L3C1_SSC_L2_075.mat");
L3C1_L2_120 = load("L3C1_SSC_L2_120.mat");
L4C1a_L2_120 = load("L4C1a_SSC_L2_120.mat");
L4C1b_L2_120 = load("L4C1b_SSC_L2_120.mat");
L5C1_L2_075 = load("L5C1_SSC_L2_075.mat");
L5C1_L5_075 = load("L5C1_SSC_L5_075.mat");
L6C1_L2_075 = load("L6C1_SSC_L2_075.mat");
L6C1_L5_075 = load("L6C1_SSC_L5_075.mat");

%% Visualisation
f0 = figure;
tiledlayout(8,1, 'TileSpacing','tight')

ax1 = nexttile;
plot(L1C1_L2_075.L1C1.Time, L1C1_L2_075.L1C1.SSC, 'LineWidth',2, 'Color',bluegreen); hold on
plot(L1C1_L2_120.L1C1.Time, L1C1_L2_120.L1C1.SSC, 'LineWidth',2, 'Color',orange); hold off
% ylabel('SSC (kg m$^{-3}$)')
legend('L1C1 (L2 -0.75m)', 'L1C1 (L2 -1.20m)')

ax2 = nexttile;
plot(L2C3_L2_075.L2C3.Time, L2C3_L2_075.L2C3.SSC, 'LineWidth',2, 'Color',bluegreen); hold on
plot(L2C3_L2_120.L2C3.Time, L2C3_L2_120.L2C3.SSC, 'LineWidth',2, 'Color',orange); hold off
ylabel('SSC (kg m$^{-3}$)')
legend('L2C3 (L2 -0.75m)', 'L2C3 (L2 -1.20m)')

ax3 = nexttile;
plot(L3C1_L2_075.L3C1.Time, L3C1_L2_075.L3C1.SSC, 'LineWidth',2, 'Color',bluegreen); hold on
plot(L3C1_L2_120.L3C1.Time, L3C1_L2_120.L3C1.SSC, 'LineWidth',2, 'Color',orange); hold off
% ylabel('SSC (kg m$^{-3}$)')
legend('L3C1 (L2 -0.75m)', 'L3C1 (L2 -1.20m)')

ax4 = nexttile;
plot(L4C1a_L2_120.L4C1a.Time, L4C1a_L2_120.L4C1a.SSC, 'LineWidth',2, 'Color',bluegreen); hold on
plot(L4C1b_L2_120.L4C1b.Time, L4C1b_L2_120.L4C1b.SSC, 'LineWidth',2, 'Color',orange); hold off
% ylabel('SSC (kg m$^{-3}$)')
legend('L4C1a (L2 -1.20m)', 'L4C1b (L2 -1.20m)')

ax5 = nexttile;
plot(L5C1_L2_075.L5C1.Time, L5C1_L2_075.L5C1.SSC, 'LineWidth',2, 'Color',bluegreen); hold on
plot(L5C1_L5_075.L5C1.Time, L5C1_L5_075.L5C1.SSC, 'LineWidth',2, 'Color',orange); hold off
ylabel('SSC (kg m$^{-3}$)')
legend('L5C1 (L2 -0.75m)', 'L5C1 (L5 -0.75m)')

ax6 = nexttile;
plot(L6C1_L2_075.L6C1.Time, L6C1_L2_075.L6C1.SSC, 'LineWidth',2, 'Color',bluegreen); hold on
plot(L6C1_L5_075.L6C1.Time, L6C1_L5_075.L6C1.SSC, 'LineWidth',2, 'Color',orange); hold off
% ylabel('SSC (kg m$^{-3}$)')
legend('L6C1 (L2 -0.75m)', 'L6C1 (L5 -0.75m)')

ax7 = nexttile;
plot(L2C10.Time, L2C10.eta, 'LineWidth',2, 'Color',blue)
ylabel('$\eta$ (m)')

ax8 = nexttile;
plot(L2C10.Time, L2C10.Hm0, 'LineWidth',2, 'Color',redpurp)
ylabel('H$_{m0}$ (m)')

xticklabels([ax1, ax2, ax3, ax4, ax5, ax6, ax7], [])
xlim([ax1, ax2, ax3, ax4, ax5, ax6, ax7, ax8], [datetime('2021-09-11') datetime('2021-10-19')])
ylim([ax1, ax2, ax3, ax4, ax5, ax6], [0, 60])
linkaxes([ax1, ax2, ax3, ax4, ax5, ax6, ax7, ax8], 'x')
zoom xon
