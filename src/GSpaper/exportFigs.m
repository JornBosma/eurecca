%% Initialisation
[basePath, ~, ~, ~] = eurecca_init;

locResults = [basePath 'results' filesep 'figures' filesep];
locMDPI = '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/MDPI_PHZ/Figures/';

%% elevationMap
exportgraphics(f1a, [locResults 'DEM_initial.png'])
% exportgraphics(f1b, [locResults 'DEM_2022_Q4.png'])
exportgraphics(f2, [locResults 'DOD_plus.png'])

%% roses
exportgraphics(f1, [locResults 'WindRoses' filesep 'wind_rose_1989.png'])
exportgraphics(f2, [locResults 'WindRoses' filesep 'wind_rose_2019.png'])
exportgraphics(f3, [locResults 'WindRoses' filesep 'wind_rose_SEDMEX.png'])

%% boundary
exportgraphics(f1, [locMDPI 'conditions_LT.png'])
exportgraphics(f2, [locMDPI 'conditions_ST.png'])

%% sediEvo
exportgraphics(f0, [locResults 'sediments' filesep 'sediL2prof.png'])
exportgraphics(f0b, [locResults 'sediments' filesep 'sediBedEvo.png'])
exportgraphics(f1, [locResults 'sediments' filesep 'M_20210920.png'])
exportgraphics(f2, [locResults 'sediments' filesep 'M_20210928.png'])
exportgraphics(f3, [locResults 'sediments' filesep 'M_20211001.png'])
exportgraphics(f4, [locResults 'sediments' filesep 'M_20211007.png'])
exportgraphics(f5, [locResults 'sediments' filesep 'M_20211015.png'])
exportgraphics(f1b, [locResults 'sediments' filesep 'S_20210920.png'])
exportgraphics(f2b, [locResults 'sediments' filesep 'S_20210928.png'])
exportgraphics(f3b, [locResults 'sediments' filesep 'S_20211001.png'])
exportgraphics(f4b, [locResults 'sediments' filesep 'S_20211007.png'])
exportgraphics(f5b, [locResults 'sediments' filesep 'S_20211015.png'])
exportgraphics(f6, [locResults 'sediments' filesep 'M_20210921b.png'])
exportgraphics(f7, [locResults 'sediments' filesep 'M_20210928b.png'])

%% currents
exportgraphics(f1, [locResults 'umag_eta.png'])

%% scraper
exportgraphics(f1, [locMDPI 'scraper.png'])