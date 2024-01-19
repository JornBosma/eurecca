%% Initialisation
[basePath, ~, ~, ~] = eurecca_init;

locResults = [basePath 'results' filesep 'figures' filesep];
locMDPI = '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/MDPI_PHZ/Figures/';
% locMDPI = 'C:\Users\4156366\Dropbox\Apps\Overleaf\MDPI_PHZ\Figures\';  % UU-computer


%% Figure 2
exportgraphics(f1, [locResults 'WindRoses' filesep 'wind_rose_1989.png'])


%% Figure 3
exportgraphics(f1, [locResults 'sediments' filesep 'exsample.png'])


%% Figure 4
exportgraphics(f1, [locMDPI 'conditions_LT.png'])


%% Figure 5
exportgraphics(f2, [locResults 'hydrometeo' filesep 'conditions_ST.png'])
% exportgraphics(f2, [locResults 'hydrometeo' filesep 'conditions_ST_lgnd.png'])


%% Figure 6
exportgraphics(f1, [locMDPI 'DEM_2019_Q2.png'])
% exportgraphics(f2, [locMDPI 'DEM_2022_Q2.png'])
exportgraphics(f3, [locMDPI 'DoD_22-19.png'])


%% Figure 7
exportgraphics(f1, [locResults 'morphology' filesep 'V_segments.png'])
% exportgraphics(f1, [locResults 'morphology' filesep 'V_segments_lgnd.png'])
exportgraphics(f2, [locResults 'morphology' filesep 'dV_lines.png'])
% exportgraphics(f2, [locResults 'morphology' filesep 'dV_lines_lgnd.png'])
exportgraphics(f3, [locResults 'morphology' filesep 'hook_dev.png'])


%% Figure 8
exportgraphics(f1, [locResults 'sediments' filesep 'M_20211008.png'])
exportgraphics(f2, [locMDPI 'S_20211008.png'])
exportgraphics(f3, [locMDPI 'Sk_20211008.png'])
exportgraphics(f4, [locMDPI 'K_20211008.png'])
exportgraphics(f5, [locResults 'sediments' filesep 'M_20221026.png'])
exportgraphics(f6, [locResults 'sediments' filesep 'M_diff.png'])
exportgraphics(f7, [locResults 'sediments' filesep 'sample_locs.png'])


%% Figure 8 hydro
exportgraphics(f1, [locResults 'hydrometeo' filesep 'Hm0_OSSI_140.png'])
exportgraphics(f2, [locResults 'hydrometeo' filesep 'U_rose_ADV_075.png'])


%% Figure 9
exportgraphics(f1, [locMDPI 'L2_sample_locs.png'])
exportgraphics(f2, [locMDPI 'L2_samples.png'])


%% Figure 9 appendix
exportgraphics(f2a, [locResults 'sediments' filesep 'M_20210920.png'])
exportgraphics(f2b, [locResults 'sediments' filesep 'S_20210920.png'])
exportgraphics(f2c, [locResults 'sediments' filesep 'Sk_20210920.png'])
exportgraphics(f2d, [locResults 'sediments' filesep 'K_20210920.png'])
exportgraphics(f3a, [locResults 'sediments' filesep 'M_20210928.png'])
exportgraphics(f3b, [locResults 'sediments' filesep 'S_20210928.png'])
exportgraphics(f3c, [locResults 'sediments' filesep 'Sk_20210928.png'])
exportgraphics(f3d, [locResults 'sediments' filesep 'K_20210928.png'])
exportgraphics(f4a, [locResults 'sediments' filesep 'M_20211007.png'])
exportgraphics(f4b, [locResults 'sediments' filesep 'S_20211007.png'])
exportgraphics(f4c, [locResults 'sediments' filesep 'Sk_20211007.png'])
exportgraphics(f4d, [locResults 'sediments' filesep 'K_20211007.png'])


%% Figure 10
exportgraphics(f1, [locMDPI 'M_scraper.png'])
exportgraphics(f2, [locResults 'sediments' filesep 'S_scraper.png'])


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

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


%% deltaV
exportgraphics(f1, [locMDPI 'dV_line.png'])


%% wind roses
exportgraphics(f1, [locResults 'WindRoses' filesep 'wind_rose_1989.png'])
exportgraphics(f2, [locResults 'WindRoses' filesep 'wind_rose_2019.png'])
exportgraphics(f3, [locResults 'WindRoses' filesep 'wind_rose_SEDMEX.png'])

