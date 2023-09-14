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

%% devGS
exportgraphics(f1, [locResults 'GSdev.png'])

%% currents
exportgraphics(f1, [locResults 'umag_eta.png'])

%% scraper
exportgraphics(f1, [locMDPI 'scraper.png'])