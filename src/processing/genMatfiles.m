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

% % TUD + UU: sediment samples
% sampleData1 = importSampleGPS("Loc_2020-16-10.txt", [2, Inf]); % load iphone-gps data of 16/10/2020
% sampleData2 = importSampleGPS("Loc_2020-02-12.txt", [2, Inf]); % load rtk-gps data of 02/12/2020
% sampleData3 = importSampleGPS("Loc_2020-03-12.txt", [2, Inf]); % load rtk-gps data of 03/12/2020
% sampleData4 = importSampleGPS("Loc_2021-04-08.txt", [2, Inf]); % load rtk-gps data of 08/04/2021
% % sampleData = [sampleData1; sampleData2; sampleData3]; % concatenate tables
% fileName = 'sampleGPS.mat';
% save([basePath 'data' filesep 'sediment' filesep 'temp' filesep fileName],...
%     'sampleData1', 'sampleData2', 'sampleData3', 'sampleData4')

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
% 
% z_2021_06 = JDN_txt("2021-06.txt", [1, Inf]);
% z_2021_09 = JDN_txt("2021-09.txt", [1, Inf]);
% z_2021_11 = JDN_txt("2021-11.txt", [1, Inf]);
% fileName = 'zSounding.mat';
% save([basePath 'data' filesep 'elevation' filesep 'temp' filesep fileName],...
%     'z_UTD_realisatie', 'z_2019_Q4', 'z_2020_Q1', 'z_2020_Q2',...
%     'z_2020_Q3', 'z_2020_Q4', 'z_2021_Q1', 'z_2021_06', 'z_2021_09', 'z_2021_11')

%% Difference maps
load('zSounding.mat')

% 2020 Q3 - 2019 Q3
% z_UTD_realisatie_2 = table(z_2020_Q3.xRD, z_2020_Q3.yRD,...
%     griddata(z_UTD_realisatie.xRD, z_UTD_realisatie.yRD, z_UTD_realisatie.z, z_2020_Q3.xRD, z_2020_Q3.yRD),...
%     'VariableNames',{'xRD','yRD','z'});
% diffMap = table(z_2020_Q3.xRD, z_2020_Q3.yRD, z_2020_Q3.z - z_UTD_realisatie_2.z,...
%     'VariableNames',{'xRD','yRD','z'});
% fileName = 'diffMap_Q3_2020-UTD.mat';
% save([basePath 'data' filesep 'elevation' filesep 'temp' filesep fileName],...
%     'diffMap')

% 2021 Q1 - 2020 Q1
% z_2021_Q1_2 = table(z_2020_Q1.xRD, z_2020_Q1.yRD,...
%     griddata(z_2021_Q1.xRD, z_2021_Q1.yRD, z_2021_Q1.z, z_2020_Q1.xRD, z_2020_Q1.yRD),...
%     'VariableNames',{'xRD','yRD','z'});
% diffMap = table(z_2020_Q1.xRD, z_2020_Q1.yRD, z_2021_Q1_2.z - z_2020_Q1.z,...
%     'VariableNames',{'xRD','yRD','z'});
% fileName = 'diffMap_Q1_21-20.mat';
% save([basePath 'data' filesep 'elevation' filesep 'temp' filesep fileName],...
%     'diffMap')

% z_2021_11 - z_UTD_realisatie
z_UTD_realisatie_2 = table(z_2021_11.xRD, z_2021_11.yRD,...
    griddata(z_UTD_realisatie.xRD, z_UTD_realisatie.yRD, z_UTD_realisatie.z, z_2021_11.xRD, z_2021_11.yRD),...
    'VariableNames',{'xRD','yRD','z'});
diffMap = table(z_2021_11.xRD, z_2021_11.yRD, z_2021_11.z - z_UTD_realisatie_2.z,...
    'VariableNames',{'xRD','yRD','z'});
fileName = 'diffMap_newest-oldest.mat';
save([basePath 'data' filesep 'elevation' filesep 'temp' filesep fileName],...
    'diffMap')

