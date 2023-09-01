% OBS-calibration for SEDMEX campaign
% J.W. Bosma, 2023

%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize] = eurecca_init;

%% L2 (-0.75 m +NAP)
% too little calibration material for 100 g/L

CS_L2_075 = [-0.003 0.10 0.24 0.58 1.16 2.50 6.38 12.40 25.33 36.24 51.57]; % testconcentraties [g/L]

% reponse signal measuring instruments
STM_12585 = [3.919 6.967 10.68 19.67 35.73 71.93 165.9 335.4 650.1 939.3 1182.4]; % L1C1 Vector #1
STM_12586 = [23.256 23.984 26.43 37.57 52.77 83.44 170.8 350.3 660.8 976.3 1272.4]; % L2C3 Vector #2
STM_12587 = [4.205 6.852 9.35 17.19 30.98 59.60 147.1 284.6 565.0 841.2 1127.6]; % L3C1 Vector #3
% STM_17486 = [5.082 7.560 9.13 17.72 30.26 57.39 134.4 283.1 577.5 901.1 1255.6]; % L5C1 Vector #4
% STM_17487 = [4.660 6.985 11.33 19.14 33.50 65.79 156.3 318.9 612.1 943.3 1313.0]; % L6C1 Vector #5
% STM_17488 = [4.593 6.955 10.00 19.04 34.18 65.07 157.2 329.5 645.9 1041.0 1459.0]; % L2C7 HR profiler
STM_1566 = [4.252 7.021 10.47 20.29 37.20 73.16 170.5 346.7 685.0 1001.5 1289.5]; % L2C5 TV STM #1
STM_1567 = [4.992 8.456 12.17 22.26 42.59 80.20 186.9 400.4 783.9 1183.4 1565.1]; % L2C5 TV STM #2

OBS_9012 = [17.992 18.647 21.84 26.31 37.37 58.93 96.1 218.7 421.7 777.6 1081.0]; % L4C1 OBS3+
OBS_9205 = [9.722 10.060 12.82 14.19 21.74 33.76 57.0 132.8 248.6 459.8 618.7]; % L4C1 OBS3+

STMarray_1 = [7.299 8.050 9.78 11.86 18.40 28.81 52.2 116.1 224.7 441.3 677.8]; % L2C5 TV STM array #1
STMarray_2 = [6.477 7.523 9.28 12.38 20.20 33.93 58.8 141.7 285.3 543.1 798.5]; % L2C5 TV STM array #2
STMarray_3 = [7.385 8.301 10.80 14.98 23.82 40.34 75.4 171.7 346.2 669.5 980.0]; % L2C5 TV STM array #3
STMarray_4 = [10.918 8.393 9.90 12.74 19.74 31.47 56.4 132.0 264.8 509.9 757.1]; % L2C5 TV STM array #4
STMarray_5 = [5.591 5.995 7.88 10.20 16.23 27.21 50.0 116.3 231.6 450.9 667.4]; % L2C5 TV STM array #5

%%
% coefficients calibration curves
P_STM_12585 = polyfit(STM_12585(2:11), CS_L2_075(2:11), 2);
P_STM_12586 = polyfit(STM_12586(2:11), CS_L2_075(2:11), 2);
P_STM_12587 = polyfit(STM_12587(2:11), CS_L2_075(2:11), 2);
% P_STM_17486 = polyfit(STM_17486(2:11), c_L2_075(2:11), 2);
% P_STM_17487 = polyfit(STM_17487(2:11), c_L2_075(2:11), 2);
% P_STM_17488 = polyfit(STM_17488(2:11), c_L2_075(2:11), 2);
P_STM_1566 = polyfit(STM_1566(2:11), CS_L2_075(2:11), 2);
P_STM_1567 = polyfit(STM_1567(2:11), CS_L2_075(2:11), 2);

P_OBS_9012 = polyfit(OBS_9012(2:11), CS_L2_075(2:11), 2);
P_OBS_9205 = polyfit(OBS_9205(2:11), CS_L2_075(2:11), 2);

P_STMarray_1 = polyfit(STMarray_1(2:11), CS_L2_075(2:11), 2);
P_STMarray_2 = polyfit(STMarray_2(2:11), CS_L2_075(2:11), 2);
P_STMarray_3 = polyfit(STMarray_3(2:11), CS_L2_075(2:11), 2);
P_STMarray_4 = polyfit(STMarray_4(2:11), CS_L2_075(2:11), 2);
P_STMarray_5 = polyfit(STMarray_5(2:11), CS_L2_075(2:11), 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stagnant water, background noise suspended load

c_silt_L2_075 = 0.48;

STM_12585_silt = 592.4;
STM_12586_silt = 759.5;
STM_12587_silt = 623.2;
% STM_17486_silt = 708.0;
% STM_17487_silt = 611.9;
% STM_17488_silt = 756.3;
STM_1566_silt = 701.6;
STM_1567_silt = 819.5;

OBS_9012_silt = 1374.5;
OBS_9205_silt = 772.7;

STMarray_1_silt = 919.8;
STMarray_2_silt = 1051.9;
STMarray_3_silt = 1275.4;
STMarray_4_silt = 999.9;
STMarray_5_silt = 872.0;

%% L2 (-1.20 m +NAP)

c_L2_120 = [0.009 0.10 0.18 0.44 0.90 1.78 4.58 9.20 18.63 28.16 37.54 47.40 67.52 97.24]; % testconcentraties [g/L]

% reponse signal measuring instruments
% STM_12585 = [6.912 11.993 19.57 39.91 73.88 141.64 325.8 584.9 932.2 1087.4 1072.5 943.9 637.7 287.5]; % L1C1 Vector #1
% STM_12586 = [19.271 25.195 32.53 54.71 89.56 160.84 354.2 636.1 1050.5 1238.2 1257.2 1160.9 815.6 378.3]; % L2C3 Vector #2
% STM_12587 = [6.172 11.674 19.06 38.41 70.93 136.91 319.5 568.1 963.3 1159.1 1210.4 1136.7 834.5 475.6]; % L3C1 Vector #3
% STM_17486 = [9.827 14.200 23.18 43.32 78.76 149.34 350.7 657.3 1189.5 1601.5 1840.7 1962.7 1856.9 1481.4]; % L5C1 Vector #4
% STM_17487 = [8.262 13.372 22.08 43.72 79.84 152.54 361.2 665.3 1200.6 1589.0 1820.6 1906.1 1767.6 1300.2]; % L6C1 Vector #5
STM_17488 = [7.440 13.392 22.39 44.48 84.15 166.38 393.4 738.7 1336.7 1767.2 2049.8 2163.2 2014.2 1500.5]; % L2C7 HR profiler
% STM_1566 = [7.427 13.113 21.69 44.48 82.24 157.97 365.6 668.2 1096.5 1296.0 1302.9 1192.6 841.4 425.5]; % L2C5 TV STM #1
% STM_1567 = [8.137 15.404 25.38 52.87 98.12 187.80 438.4 791.7 1304.8 1543.6 1582.3 1454.4 1037.8 512.7]; % L2C5 TV STM #2

% OBS_9012 = [18.645 24.328 31.95 52.40 87.66 158.06 346.2 611.6 1047.5 1402.1 1665.6 1894.6 2260.7 2590.5]; % L4C1 OBS3+
% OBS_9205 = [10.817 14.493 18.82 31.01 52.41 93.75 200.6 352.9 599.1 788.3 944.6 1067.8 1267.8 1474.2]; % L4C1 OBS3+

% STMarray_1 = [9.792 14.539 20.67 36.67 63.64 119.93 274.6 492.7 832.5 1014.7 1061.9 993.6 732.4 393.0]; % L2C5 TV STM array #1
% STMarray_2 = [9.398 14.895 21.98 41.03 73.68 137.86 313.2 552.2 895.5 1027.6 1021.1 892.2 571.4 261.0]; % L2C5 TV STM array #2
% STMarray_3 = [11.176 18.146 26.90 50.25 90.90 170.10 389.3 692.0 1118.0 1289.9 1274.7 1121.4 743.7 333.5]; % L2C5 TV STM array #3
% STMarray_4 = [8.606 14.076 20.75 38.42 69.31 130.36 295.5 521.7 848.2 982.7 967.0 852.6 550.6 245.8]; % L2C5 TV STM array #4
% STMarray_5 = [7.952 12.555 18.28 34.10 60.84 113.27 258.7 460.1 745.9 867.3 847.8 758.5 510.7 233.3]; % L2C5 TV STM array #5

% coefficients calibration curves
% P_STM_12585 = polyfit(STM_12585(2:10), c_L2_120(2:10), 2); % up to 30 g/L (including larger c deteriorates very small c)
% P_STM_12586 = polyfit(STM_12586(2:10), c_L2_120(2:10), 2);
% P_STM_12587 = polyfit(STM_12587(2:10), c_L2_120(2:10), 2);
% P_STM_17486 = polyfit(STM_17486(2:10), c_L2_120(2:10), 2);
% P_STM_17487 = polyfit(STM_17487(2:10), c_L2_120(2:10), 2);
P_STM_17488 = polyfit(STM_17488(2:10), c_L2_120(2:10), 2);
% P_STM_1566 = polyfit(STM_1566(2:10), c_L2_120(2:10), 2);
% P_STM_1567 = polyfit(STM_1567(2:10), c_L2_120(2:10), 2);

% P_OBS_9012 = polyfit(OBS_9012(2:10), c_L2_120(2:10), 2);
% P_OBS_9205 = polyfit(OBS_9205(2:10), c_L2_120(2:10), 2);

% P_STMarray_1 = polyfit(STMarray_1(2:10), c_L2_120(2:10), 2);
% P_STMarray_2 = polyfit(STMarray_2(2:10), c_L2_120(2:10), 2);
% P_STMarray_3 = polyfit(STMarray_3(2:10), c_L2_120(2:10), 2);
% P_STMarray_4 = polyfit(STMarray_4(2:10), c_L2_120(2:10), 2);
% P_STMarray_5 = polyfit(STMarray_5(2:10), c_L2_120(2:10), 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% silt, 1 L door filter
c_silt_L2_120 = 0.73;

% STM_12585_silt = 1193.8;
% STM_12586_silt = 1512.8;
% STM_12587_silt = 1340.0;
% STM_17486_silt = 1710.7;
% STM_17487_silt = 1527.6;
STM_17488_silt = 1850.7;
% STM_1566_silt = 1563.3;
% STM_1567_silt = 1866.5;

% OBS_9012_silt = 1242.9;
% OBS_9205_silt = 653.0;

% STMarray_1_silt = 1358.3;
% STMarray_2_silt = 1349.4;
% STMarray_3_silt = 1748.8;
% STMarray_4_silt = 1282.2;
% STMarray_5_silt = 1143.8;

%% L5 (-0.75 m +NAP)
% too little calibration material for 100 g/L

c_L5_075 = [-0.006 0.08 0.16 0.39 0.84 1.71 4.36 9.00 18.41 27.91 36.95 46.47 58.08 70.47 93.92]; % testconcentraties [g/L]

% reponse signal measuring instruments
% STM_12585 = [3.229 8.534 13.76 28.51 54.80 105.31 247.5 464.6 771.3 941.2 1011.2 1006.4 914.5 786.1 517.0]; % L1C1 Vector #1
% STM_12586 = [26.616 32.344 37.67 53.54 78.88 131.62 280.3 515.2 862.4 1072.7 1175.1 1204.9 1120.6 984.3 692.8]; % L2C3 Vector #2
% STM_12587 = [3.541 8.383 13.50 27.13 50.30 96.26 234.3 436.1 760.8 975.1 1086.5 1130.8 1086.9 972.8 733.0]; % L3C1 Vector #3
STM_17486 = [3.979 9.704 15.16 30.66 57.10 109.55 264.7 511.4 949.8 1303.0 1554.8 1743.9 1848.4 1877.5 1695.8]; % L5C1 Vector #4
STM_17487 = [3.790 9.384 14.77 29.98 56.90 110.20 268.7 523.1 951.3 1280.0 1542.7 1705.8 1777.2 1767.2 1554.6]; % L6C1 Vector #5
% STM_17488 = [3.991 9.859 15.61 32.38 61.48 118.36 285.0 558.7 1032.4 1440.5 1707.9 1906.7 2019.7 1996.1 1780.4]; % L2C7 HR profiler
% STM_1566 = [3.635 9.507 15.50 31.46 59.76 116.67 275.9 526.6 903.6 1134.0 1250.9 1266.2 1195.3 1045.0 726.4]; % L2C5 TV STM #1
% STM_1567 = [4.259 11.378 18.08 37.42 69.58 138.27 326.3 625.8 1074.5 1361.4 1516.0 1553.2 1468.6 1290.7 948.1]; % L2C5 TV STM #2

% STMarray_1 = [7.463 11.789 15.63 26.78 46.90 85.62 197.3 386.4 646.1 831.4 935.3 963.8 929.9 845.7 622.1]; % L2C5 TV STM array #1
% STMarray_2 = [6.631 11.801 16.55 29.83 53.17 99.54 232.7 433.1 726.2 902.0 969.0 954.7 881.6 738.9 482.6]; % L2C5 TV STM array #2
% STMarray_3 = [8.038 14.386 20.43 38.09 66.74 126.74 293.4 547.1 915.9 1129.7 1205.2 1199.5 1099.5 920.4 606.1]; % L2C5 TV STM array #3
% STMarray_4 = [373.755 412.404 318.80 436.64 409.70 95.09 220.8 731.6 1166.9 1307.3 920.4 906.9 834.7 707.5 472.5]; % L2C5 TV STM array #4
% STMarray_5 = [6.088 10.085 13.94 25.28 44.69 83.13 191.5 358.7 599.5 749.4 804.7 796.6 735.3 625.5 414.6]; % L2C5 TV STM array #5

% coefficients calibration curves
% P_STM_12585 = polyfit(STM_12585(2:10), c_L5_075(2:10), 2); % up to 30 g/L (including larger c deteriorates very small c)
% P_STM_12586 = polyfit(STM_12586(2:10), c_L5_075(2:10), 2);
% P_STM_12587 = polyfit(STM_12587(2:10), c_L5_075(2:10), 2);
P_STM_17486 = polyfit(STM_17486(2:10), c_L5_075(2:10), 2);
P_STM_17487 = polyfit(STM_17487(2:10), c_L5_075(2:10), 2);
% P_STM_17488 = polyfit(STM_17488(2:10), c_L5_075(2:10), 2);
% P_STM_1566 = polyfit(STM_1566(2:10), c_L5_075(2:10), 2);
% P_STM_1567 = polyfit(STM_1567(2:10), c_L5_075(2:10), 2);

% P_STMarray_1 = polyfit(STMarray_1(2:10), c_L5_075(2:10), 2);
% P_STMarray_2 = polyfit(STMarray_2(2:10), c_L5_075(2:10), 2);
% P_STMarray_3 = polyfit(STMarray_3(2:10), c_L5_075(2:10), 2);
% P_STMarray_4 = polyfit(STMarray_4(2:10), c_L5_075(2:10), 2);
% P_STMarray_5 = polyfit(STMarray_5(2:10), c_L5_075(2:10), 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% silt, 1 L door filter
c_silt_L5_075 = 0.53;

% STM_12585_silt = 955.8;
% STM_12586_silt = 1137.2;
% STM_12587_silt = 1060.4;
STM_17486_silt = 1281.6;
STM_17487_silt = 1072.0;
% STM_17488_silt = 1411.5;
% STM_1566_silt = 1202.3;
% STM_1567_silt = 1433.5;

% STMarray_1_silt = 988.1;
% STMarray_2_silt = 1014.8;
% STMarray_3_silt = 1299.1;
% STMarray_4_silt = 963.0;
% STMarray_5_silt = 842.4;

%% Visualisation
figure
tiledlayout(3, 1, 'TileSpacing', 'tight')

ax(1) = nexttile;
plot(CS_L2_075, [STM_12585; STM_12586; STM_12587; STM_1566; STM_1567], '-o'); hold on
plot(c_L2_120, STM_17488, '-o')
plot(c_L5_075, [STM_17486; STM_17487], '-o')
legend({'STM 12585' 'STM 12586' 'STM 12587' 'STM 1566' 'STM 1567' 'STM 17488' 'STM 17486' 'STM 17487'}, 'Location','eastoutside')

ax(2) = nexttile;
plot(CS_L2_075, [OBS_9012; OBS_9205], '-o')
legend({'OBS 9012' 'OBS 9205'}, 'Location','eastoutside')
ylabel('signal (mV)')

ax(3) = nexttile;
plot(CS_L2_075, [STMarray_1; STMarray_2; STMarray_3; STMarray_4; STMarray_5], '-o')
legend({'STMarray 1' 'STMarray 2' 'STMarray 3' 'STMarray 4' 'STMarray 5'}, 'Location','eastoutside')
xlabel('concentration (g/L)')

%% Calibration test
overdrachtsfactor = 0.5; % conversion measured 'counts' to mV
offset = 0; % intercept
slope = 1;

% conc = offset + slope * (rawConcentrations/overdrachtsfactor);
% conc = polyval(P1, conc); % proper calibration

% data location; change to correct location!
dataPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'Data Descriptor'];
ADVpath = [filesep 'ADV' filesep 'L1C1VEC' filesep 'raw_netcdf' filesep];

% netcdf contents
adv_info = ncinfo([dataPath ADVpath filesep 'L1C1VEC_20210928.nc']);

% minutes since 2021-09-28 00:00:00 (along columns)
adv_t = ncread([dataPath ADVpath filesep 'L1C1VEC_20210928.nc'], 't');

% measuring frequency [Hz] (along rows)
adv_sf = ncread([dataPath ADVpath filesep 'L1C1VEC_20210928.nc'], 'sf');

% turbidity ['mV' counts] 
L1C1_STMraw = ncread([dataPath ADVpath filesep 'L1C1VEC_20210928.nc'], 'anl1');

% next step makes use of function script included in the folder
[STMnoBackground, background] = removeOffsetSTM(L1C1_STMraw, 16*60);

L1C1_STM = offset + slope * (STMnoBackground/overdrachtsfactor);
L1C1_STM = polyval(P_STM_12586, L1C1_STM);

taxis = linspace(0, length(L1C1_STM)/adv_sf, length(L1C1_STM));

figure
plot(taxis, L1C1_STM(:, 1)); hold on
plot(taxis, movmean(L1C1_STM(:, 1), adv_sf*60), 'r', 'LineWidth',2)
legend('raw signal','minute mean')
ylim([0 60])
xlabel('time (s)')
ylabel('concentration (kg m$^{-3}$) (g L$^{-1}$)', 'Interpreter','latex')
