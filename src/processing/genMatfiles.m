%% Initialisation
close all
clear
clc

global basePath
eurecca_init

% %% Generate mat-files
% sampleShell = importfile3("190423_JDN.1712.PQF.81.03.nl.00_schelpenlaag strandhaak.xlsx",...
%     "overzicht zevingen", [7, 35]); % Q4 2018
% sampleDune = importfile4("190423_JDN.1712.PQF.81.03.nl.00_korrelverdeling VD en SL_EB.xlsx",...
%     "Veiligheidsduin", [10, 56]); % Q1 2019
% sampleArmor = importfile5("190423_JDN.1712.PQF.81.03.nl.00_korrelverdeling VD en SL_EB.xlsx",...
%     "Slijtlaag_Erosiebuffer", [10, 23]); % Q1 2019
% fileName = 'JDN_samples.mat';
% save([basePath 'data' filesep 'sediment' filesep 'temp' filesep fileName],...
%     'sampleShell', 'sampleDune', 'sampleArmor')

% TUD + UU: sediment samples
sampleData1 = importSampleGPS("Loc_2020-16-10.txt", [2, Inf]); % load iphone-gps data of 16/10/2020
sampleData2 = importSampleGPS("PHZDsed1.txt", [2, Inf]); % load rtk-gps data of 02/12/2020
sampleData3 = importSampleGPS("PHZDsed2.txt", [2, Inf]); % load rtk-gps data of 03/12/2020
% sampleData = [sampleData1; sampleData2; sampleData3]; % concatenate tables
fileName = 'sampleGPS.mat';
save([basePath 'data' filesep 'sediment' filesep 'temp' filesep fileName],...
    'sampleData1', 'sampleData2', 'sampleData3')

% % TUD + UU: topo- & bathymetry
% zProfiles_20201016 = importfile("PHZD01.txt", [2, Inf]); % load rtk-gps data
% zProfiles_20201016.z = zProfiles_20201016.z - 1.5; % adjust heights for pole length (= 1.5/1.2 m on wheel/pole)
% fileName = 'zProfiles_20201016.mat';
% save([basePath 'data' filesep 'elevation' filesep 'temp' filesep fileName],...
%     'zProfiles_20201016')

% % Jan De Nul: topo- & bathymetry
% z_UTD_realisatie = JDN_xyz('UTD_realisatie.pts', 1, inf); % +bathy
% z_2019_Q4 = JDN_xyz('2019_Q4.pts', 1, inf);
% z_2020_Q1 = JDN_xyz('2020_Q1.pts', 1, inf);
% z_2020_Q2 = JDN_xyz('2020_Q2.pts', 1, inf);
% z_2020_Q3 = JDN_xyz('2020_Q3.pts', 1, inf); % +bathy
% z_2020_Q4 = JDN_xyz('2020_Q4.xyz', 1, inf);
% z_2021_Q1 = JDN_xyz('2021_Q1.xyz', 1, inf);
% fileName = 'zSounding.mat';
% save([basePath 'data' filesep 'elevation' filesep 'temp' filesep fileName],...
%     'z_UTD_realisatie', 'z_2019_Q4', 'z_2020_Q1', 'z_2020_Q2',...
%     'z_2020_Q3', 'z_2020_Q4', 'z_2021_Q1')
% 
% %% Calculations
% % difference maps
% z_UTD_realisatie_2 = table(z_2020_Q3.xRD, z_2020_Q3.yRD,...
%     griddata(z_UTD_realisatie.xRD, z_UTD_realisatie.yRD, z_UTD_realisatie.z, z_2020_Q3.xRD, z_2020_Q3.yRD),...
%     'VariableNames',{'xRD','yRD','z'});
% diffMap = table(z_2020_Q3.xRD, z_2020_Q3.yRD, z_2020_Q3.z - z_UTD_realisatie_2.z,...
%     'VariableNames',{'xRD','yRD','z'});
% fileName = 'diffMap_Q3_2020-UTD.mat';
% save([basePath 'data' filesep 'elevation' filesep 'temp' filesep fileName],...
%     'diffMap')
