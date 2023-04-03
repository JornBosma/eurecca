%% Initialisation
close all
clear
clc

basePath = '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/GitHub/eurecca-wp2/';

[~, ~, ~, ~, ~] = eurecca_init;

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
% z_2019_Q3 = JDN_xyz('UTD_realisatie.pts', 1, inf); % +bathy
% z_2019_Q4 = JDN_xyz('2019_Q4.pts', 1, inf);
% z_2020_Q1 = JDN_xyz('2020_Q1.pts', 1, inf);
% z_2020_Q2 = JDN_xyz('2020_Q2.pts', 1, inf);
% z_2020_Q3 = JDN_xyz('2020_Q3.pts', 1, inf); % +bathy
% z_2020_Q4 = JDN_xyz('2020_Q4.xyz', 1, inf);
% z_2021_Q1 = JDN_xyz('2021_Q1.xyz', 1, inf);
% z_2021_Q2 = JDN_txt("2021-06.txt", [1, Inf]);
% z_2021_Q3 = JDN_txt("2021-09.txt", [1, Inf]);
% z_2021_Q4 = JDN_txt("2021-11.txt", [1, Inf]);
% z_2022_Q1 = JDN_xyz('2022_Q1.txt', 1, inf);
% z_2022_Q2 = JDN_xyz('2022_Q2.txt', 1, inf);
% z_2022_Q3 = JDN_xyz('2022_Q3.xyz', 1, inf);
% z_2022_Q3 = JDN_xyz('2022_Q3_ruw.xyz', 1, inf);
% z_2022_Q3_grass = JDN_xyz('2022_Q3_helmgras.xyz', 1, inf);
% z_2022_Q4 = JDN_xyz('2022_Q4.txt', 1, inf);

% fileName = 'zSounding.mat';

% save([basePath 'data' filesep 'elevation' filesep 'temp' filesep fileName],...
%     'z_2019_Q3', 'z_2019_Q4', 'z_2020_Q1', 'z_2020_Q2',...
%     'z_2020_Q3', 'z_2020_Q4', 'z_2021_Q1', 'z_2021_Q2',...
%     'z_2021_Q3', 'z_2021_Q4', 'z_2022_Q1', 'z_2022_Q2',...
%     'z_2022_Q3', 'z_2022_Q3_grass', 'z_2022_Q4')

% save([basePath 'data' filesep 'elevation' filesep 'temp' filesep fileName],...
%     'z_2022_Q2','-append')

%% Difference maps
load('zSounding.mat')
z_2022_Q3 = [z_2022_Q3; z_2022_Q3_grass];

% 2020 Q3 - 2019 Q3
z_2019_Q3 = table(z_2020_Q3.xRD, z_2020_Q3.yRD,...
    griddata(z_UTD_realisatie.xRD, z_UTD_realisatie.yRD, z_UTD_realisatie.z, z_2020_Q3.xRD, z_2020_Q3.yRD),...
    'VariableNames',{'xRD','yRD','z'});
dz_2020_Q3_2019_Q3 = table(z_2020_Q3.xRD, z_2020_Q3.yRD, z_2020_Q3.z - z_2019_Q3.z,...
    'VariableNames',{'xRD','yRD','z'});
fileName = 'd_2020_Q3-2019_Q3.mat';
save([basePath 'data' filesep 'elevation' filesep 'processed' filesep fileName],...
    'dz_2020_Q3_2019_Q3')

% 2021_Q3 - 2019 Q3
z_2019_Q3 = table(z_2021_09.xRD, z_2021_09.yRD,...
    griddata(z_UTD_realisatie.xRD, z_UTD_realisatie.yRD, z_UTD_realisatie.z, z_2021_09.xRD, z_2021_09.yRD),...
    'VariableNames',{'xRD','yRD','z'});
dz_2021_09_2019_Q3 = table(z_2021_09.xRD, z_2021_09.yRD, z_2021_09.z - z_2019_Q3.z,...
    'VariableNames',{'xRD','yRD','z'});
fileName = 'd_2021_Q3_2019_Q3.mat';
save([basePath 'data' filesep 'elevation' filesep 'processed' filesep fileName],...
    'dz_2021_09_2019_Q3')

% 2022_Q3 - 2019 Q3
z_2019_Q3 = table(z_2022_Q3.xRD, z_2022_Q3.yRD,...
    griddata(z_UTD_realisatie.xRD, z_UTD_realisatie.yRD, z_UTD_realisatie.z, z_2022_Q3.xRD, z_2022_Q3.yRD),...
    'VariableNames',{'xRD','yRD','z'});
dz_2022_Q3_2019_Q3 = table(z_2022_Q3.xRD, z_2022_Q3.yRD, z_2022_Q3.z - z_2019_Q3.z,...
    'VariableNames',{'xRD','yRD','z'});
fileName = 'd_2022_Q3-2019_Q3.mat';
save([basePath 'data' filesep 'elevation' filesep 'processed' filesep fileName],...
    'dz_2022_Q3_2019_Q3')

% % 2021 Q1 - 2020 Q1
% z_2021_Q1_2 = table(z_2020_Q1.xRD, z_2020_Q1.yRD,...
%     griddata(z_2021_Q1.xRD, z_2021_Q1.yRD, z_2021_Q1.z, z_2020_Q1.xRD, z_2020_Q1.yRD),...
%     'VariableNames',{'xRD','yRD','z'});
% diffMap = table(z_2020_Q1.xRD, z_2020_Q1.yRD, z_2021_Q1_2.z - z_2020_Q1.z,...
%     'VariableNames',{'xRD','yRD','z'});
% fileName = 'diffMap_Q1_21-20.mat';
% save([basePath 'data' filesep 'elevation' filesep 'temp' filesep fileName],...
%     'diffMap')

