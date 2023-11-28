%% Initialisation
[basePath, ~, ~, ~] = eurecca_init;

locResults = [basePath 'results' filesep 'figures' filesep];
% locMDPI = '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/MDPI_PHZ/Figures/';
locMDPI = 'C:\Users\4156366\Dropbox\Apps\Overleaf\MDPI_PHZ\Figures\';

%% elevationMap
exportgraphics(f1a, [locMDPI 'DEM_initial.png'])
% exportgraphics(f1b, [locResults 'DEM_2022_Q4.png'])
exportgraphics(f2, [locMDPI 'DOD_plus.png'])

%% roses
exportgraphics(f1, [locResults 'WindRoses' filesep 'wind_rose_1989.png'])
exportgraphics(f2, [locResults 'WindRoses' filesep 'wind_rose_2019.png'])
exportgraphics(f3, [locResults 'WindRoses' filesep 'wind_rose_SEDMEX.png'])

%% boundary
exportgraphics(f1, [locMDPI 'conditions_LT.png'])
exportgraphics(f2, [locMDPI 'conditions_ST.png'])

%% currents
exportgraphics(f1, [locResults 'umag_eta.png'])

%% scraper
exportgraphics(f1, [locResults 'sediments' filesep 'scraper.png'])

%% PHZmean
exportgraphics(f1, [locResults 'sediments' filesep 'PHZ_M_2021.png'])
exportgraphics(f2, [locResults 'sediments' filesep 'PHZ_M_2022.png'])
exportgraphics(f3, [locResults 'sediments' filesep 'PHZ_M_2020.png'])

%% L2mean
exportgraphics(f1, [locResults 'sediments' filesep 'L2_M_20210920.png'])
exportgraphics(f2, [locResults 'sediments' filesep 'L2_M_20210928.png'])
exportgraphics(f3, [locResults 'sediments' filesep 'L2_M_20211001.png'])
exportgraphics(f4, [locResults 'sediments' filesep 'L2_M_20211007.png'])
exportgraphics(f5, [locResults 'sediments' filesep 'L2_M_20211015.png'])

%% L2std
exportgraphics(f1, [locResults 'sediments' filesep 'L2_S_20210920.png'])
exportgraphics(f2, [locResults 'sediments' filesep 'L2_S_20210928.png'])
exportgraphics(f3, [locResults 'sediments' filesep 'L2_S_20211001.png'])
exportgraphics(f4, [locResults 'sediments' filesep 'L2_S_20211007.png'])
exportgraphics(f5, [locResults 'sediments' filesep 'L2_S_20211015.png'])

%% L2profs
exportgraphics(f1, [locResults 'sediments' filesep 'L2_profiles.png'])
exportgraphics(f2, [locResults 'sediments' filesep 'L2_zSamples.png'])

%% L2high
exportgraphics(f1, [locResults 'sediments' filesep 'L2_M_20211009H.png'])
exportgraphics(f2, [locResults 'sediments' filesep 'L2_M_20201203H.png'])

%% L2deep
exportgraphics(f1, [locResults 'sediments' filesep 'L2_M_20210930_1013D.png'])

%% hookMean
exportgraphics(f1, [locResults 'sediments' filesep 'L2_M_20210408.png'])
exportgraphics(f2, [locResults 'sediments' filesep 'L2_M_20210606.png'])

%% LSmean
exportgraphics(f1, [locResults 'sediments' filesep 'LS_M_20210921.png'])
exportgraphics(f2, [locResults 'sediments' filesep 'LS_M_20210928.png'])
exportgraphics(f3, [locResults 'sediments' filesep 'LS_M_20210921_28_000m.png'])
exportgraphics(f4, [locResults 'sediments' filesep 'LS_M_20210921_28_075m.png'])

%% horLocs
exportgraphics(f1, [locResults 'sediments' filesep 'sampleLocs.png'])

%% deltaQ
exportgraphics(f4, [locMDPI 'dQ_bar_sub.png'])
