% OBS-calibration for SEDMEX campaign
% J.W. Bosma, 2023

%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize, ~] = eurecca_init;

%% L2 (-0.75 m +NAP)

% too little calibration material for 100 g/L
TC_L2_075 = [-0.003 0.10 0.24 0.58 1.16 2.50 6.38 12.40 25.33 36.24 51.57]; % test concentration [g/L]

% reponse signal measuring instruments
L1C1STM = [3.919 6.967 10.68 19.67 35.73 71.93 165.9 335.4 650.1 939.3 1182.4]; % STM_12585
L2C3STM = [23.256 23.984 26.43 37.57 52.77 83.44 170.8 350.3 660.8 976.3 1272.4]; % STM_12586
L3C1STM = [4.205 6.852 9.35 17.19 30.98 59.60 147.1 284.6 565.0 841.2 1127.6]; % STM_12587
L5C1STM = [5.082 7.560 9.13 17.72 30.26 57.39 134.4 283.1 577.5 901.1 1255.6]; % STM_17486
L6C1STM = [4.660 6.985 11.33 19.14 33.50 65.79 156.3 318.9 612.1 943.3 1313.0]; % STM_17487
L2C7STM = [4.593 6.955 10.00 19.04 34.18 65.07 157.2 329.5 645.9 1041.0 1459.0]; % STM_17488
L2C5STM1 = [4.252 7.021 10.47 20.29 37.20 73.16 170.5 346.7 685.0 1001.5 1289.5]; % STM_1566
L2C5STM2 = [4.992 8.456 12.17 22.26 42.59 80.20 186.9 400.4 783.9 1183.4 1565.1]; % STM_1567

L4C1OBS1 = [17.992 18.647 21.84 26.31 37.37 58.93 96.1 218.7 421.7 777.6 1081.0]; % OBS_9012
L4C1OBS2 = [9.722 10.060 12.82 14.19 21.74 33.76 57.0 132.8 248.6 459.8 618.7]; % OBS_9205

L2C5STMarray1 = [7.299 8.050 9.78 11.86 18.40 28.81 52.2 116.1 224.7 441.3 677.8]; % STMarray_1
L2C5STMarray2 = [6.477 7.523 9.28 12.38 20.20 33.93 58.8 141.7 285.3 543.1 798.5]; % STMarray_2
L2C5STMarray3 = [7.385 8.301 10.80 14.98 23.82 40.34 75.4 171.7 346.2 669.5 980.0]; % STMarray_3
L2C5STMarray4 = [10.918 8.393 9.90 12.74 19.74 31.47 56.4 132.0 264.8 509.9 757.1]; % STMarray_4
L2C5STMarray5 = [5.591 5.995 7.88 10.20 16.23 27.21 50.0 116.3 231.6 450.9 667.4]; % STMarray_5

%% Write table

TC = [TC_L2_075; L1C1STM; L2C3STM; L3C1STM; L5C1STM; L6C1STM; L2C7STM; L2C5STM1; L2C5STM2; L4C1OBS1;...
    L4C1OBS2; L2C5STMarray1; L2C5STMarray2; L2C5STMarray3; L2C5STMarray4; L2C5STMarray5];
RowNames = {'sample_C'; 'L1C1STM'; 'L2C3STM'; 'L3C1STM'; 'L5C1STM'; 'L6C1STM'; 'L2C7STM';...
    'L2C5STM1'; 'L2C5STM2'; 'L4C1OBS1'; 'L4C1OBS2'; 'L2C5STMarray1';...
    'L2C5STMarray2'; 'L2C5STMarray3'; 'L2C5STMarray4'; 'L2C5STMarray5'};
Cal_L2_075 = array2table(TC, 'RowNames',RowNames);
writetable(Cal_L2_075,'/Users/jwb/Downloads/calib_L2_075.csv', 'WriteRowNames',true)

%% Calibration-curve coefficients

p_L1C1STM = polyfit(L1C1STM(2:11), TC_L2_075(2:11), 2); % STM_12585
p_L2C3STM = polyfit(L2C3STM(2:11), TC_L2_075(2:11), 2); % STM_12586
p_L3C1STM = polyfit(L3C1STM(2:11), TC_L2_075(2:11), 2); % STM_12587
p_L5C1STM = polyfit(L5C1STM(2:11), TC_L2_075(2:11), 2); % STM_17486
p_L6C1STM = polyfit(L6C1STM(2:11), TC_L2_075(2:11), 2); % STM_17487
p_L2C7STM = polyfit(L2C7STM(2:11), TC_L2_075(2:11), 2); % STM_17488
p_L2C5STM1 = polyfit(L2C5STM1(2:11), TC_L2_075(2:11), 2); % STM_1566
p_L2C5STM2 = polyfit(L2C5STM2(2:11), TC_L2_075(2:11), 2); % STM_1567

p_L4C1OBS1 = polyfit(L4C1OBS1(2:11), TC_L2_075(2:11), 2); % OBS_9012
p_L4C1OBS2 = polyfit(L4C1OBS2(2:11), TC_L2_075(2:11), 2); % OBS_9205

p_L2C5STMarray1 = polyfit(L2C5STMarray1(2:11), TC_L2_075(2:11), 2); % STMarray_1
p_L2C5STMarray2 = polyfit(L2C5STMarray2(2:11), TC_L2_075(2:11), 2); % STMarray_2
p_L2C5STMarray3 = polyfit(L2C5STMarray3(2:11), TC_L2_075(2:11), 2); % STMarray_3
p_L2C5STMarray4 = polyfit(L2C5STMarray4(2:11), TC_L2_075(2:11), 2); % STMarray_4
p_L2C5STMarray5 = polyfit(L2C5STMarray5(2:11), TC_L2_075(2:11), 2); % STMarray_5

%% Write table

p = [p_L1C1STM; p_L2C3STM; p_L3C1STM; p_L5C1STM; p_L6C1STM; p_L2C7STM;...
    p_L2C5STM1; p_L2C5STM2; p_L4C1OBS1; p_L4C1OBS2; p_L2C5STMarray1;...
    p_L2C5STMarray2; p_L2C5STMarray3; p_L2C5STMarray4; p_L2C5STMarray5];
RowNames_p = {'L1C1STM'; 'L2C3STM'; 'L3C1STM'; 'L5C1STM'; 'L6C1STM'; 'L2C7STM';...
    'L2C5STM1'; 'L2C5STM2'; 'L4C1OBS1'; 'L4C1OBS2'; 'L2C5STMarray1';...
    'L2C5STMarray2'; 'L2C5STMarray3'; 'L2C5STMarray4'; 'L2C5STMarray5'};
Coef_L2_075 = array2table(p, 'RowNames',RowNames_p);
writetable(Coef_L2_075,'/Users/jwb/Downloads/coef_L2_075.csv', 'WriteRowNames',true)

%%
BG_L2_075 = 0.48; % background concentration [g/L]

L1C1STM_bg = 592.4; % STM_12585
L2C3STM_bg = 759.5; % STM_12586
L3C1STM_bg = 623.2; % STM_12587
L5C1STM_bg = 708.0; % STM_17486
L6C1STM_bg = 611.9; % STM_17487
L2C7STM_bg = 756.3; % STM_17488
L2C5STM1_bg = 701.6; % STM_1566
L2C5STM2_bg = 819.5; % STM_1567

L4C1OBS1_bg = 1374.5; % OBS_9012
L4C1OBS2_bg = 772.7; % OBS_9205

L2C5STMarray1_bg = 919.8; % STMarray_1
L2C5STMarray2_bg = 1051.9; % STMarray_2
L2C5STMarray3_bg = 1275.4; % STMarray_3
L2C5STMarray4_bg = 999.9; % STMarray_4
L2C5STMarray5_bg = 872.0; % STMarray_5

%% Write table

BC = [BG_L2_075; L1C1STM_bg; L2C3STM_bg; L3C1STM_bg; L5C1STM_bg; L6C1STM_bg;...
    L2C7STM_bg; L2C5STM1_bg; L2C5STM2_bg; L4C1OBS1_bg; L4C1OBS2_bg; L2C5STMarray1_bg;...
    L2C5STMarray2_bg; L2C5STMarray3_bg; L2C5STMarray4_bg; L2C5STMarray5_bg];
RowNames_bg = {'background_C'; 'L1C1STM'; 'L2C3STM'; 'L3C1STM'; 'L5C1STM'; 'L6C1STM'; 'L2C7STM';...
    'L2C5STM1'; 'L2C5STM2'; 'L4C1OBS1'; 'L4C1OBS2'; 'L2C5STMarray1';...
    'L2C5STMarray2'; 'L2C5STMarray3'; 'L2C5STMarray4'; 'L2C5STMarray5'};
CalBG_L2_075 = array2table(BC, 'RowNames',RowNames_bg);
writetable(CalBG_L2_075,'/Users/jwb/Downloads/bg_L2_075.csv', 'WriteRowNames',true)
