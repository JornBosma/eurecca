%% Initialisation
close all
clear
clc

[~, ~, ~, ~, ~, ~] = eurecca_init;

%% study site
study_site
%%
figloc1 = '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/GitHub/eurecca-wp2/results/figures/';
figloc2 = '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/MDPI_PHZ/Figures/';

exportgraphics(f0, [figloc2 'study_site.png'])

%% location maps
loc_map
%%
figloc1 = '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/GitHub/eurecca-wp2/results/figures/';
figloc2 = '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/MDPI_PHZ/Figures/';

exportgraphics(f0, [figloc2 'greymap_tracks.png'])
exportgraphics(f1, [figloc2 'greymap_locs.png'])

%% elevation maps
z_map
%%
figloc1 = '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/GitHub/eurecca-wp2/results/figures/';
figloc2 = '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/MDPI_PHZ/Figures/';

% exportgraphics(f0, [figloc2 'greymap_poly.png'])
exportgraphics(f1, [figloc2 'z_map_poly.png'])

%% elevation change
delta_z
%%
figloc1 = '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/GitHub/eurecca-wp2/results/figures/';
figloc2 = '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/MDPI_PHZ/Figures/';

% exportgraphics(f0, [figloc2 'dz_map.png'])
exportgraphics(f1, [figloc2 'dz_map_poly.png'])

%% volume change
delta_Q
%%
figloc1 = '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/GitHub/eurecca-wp2/results/figures/';
figloc2 = '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/MDPI_PHZ/Figures/';

% exportgraphics(f0, [figloc2 'dQ_line.png'])
exportgraphics(f1, [figloc2 'dQ_bar.png'])
exportgraphics(f2, [figloc2 'dQ_bar_cum.png'])
exportgraphics(f3, [figloc2 'dQ_bar_sub.png'])

%% cross-shore profile change
xprofs
%%
figloc1 = '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/GitHub/eurecca-wp2/results/figures/';
figloc2 = '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/MDPI_PHZ/Figures/';

exportgraphics(f0, [figloc2 'xprofs.png'])
exportgraphics(f1, [figloc2 'xprofs_b.png'])
exportgraphics(f2, [figloc2 'xprofs_slopes.png'])
exportgraphics(f3, [figloc2 'xprofs_L1_L4.png'])
exportgraphics(f4, [figloc2 'xprofs_L1_L4_b.png'])

%% cross-shore profile change
xprofs_sedmex
%%
figloc1 = '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/GitHub/eurecca-wp2/results/figures/';
figloc2 = '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/MDPI_PHZ/Figures/';

exportgraphics(f0, [figloc2 'xprofs_sedmex.png'])
exportgraphics(f1, [figloc2 'xprofs_sedmex_b.png'])
exportgraphics(f2, [figloc2 'xprofs_slopes_sedmex.png'])

%% grain-size distributions
gs_dist
%%
figloc1 = '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/GitHub/eurecca-wp2/results/figures/';
figloc2 = '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/MDPI_PHZ/Figures/';

exportgraphics(f0, [figloc2 'GS_dist.png'])
exportgraphics(f1, [figloc2 'GS_time.png'])
exportgraphics(f2, [figloc2 'GS_error.png'])

%% longshore hydrodynamics
lshore_hydro
%%
figloc1 = '/Users/jwb/Library/CloudStorage/OneDrive-UniversiteitUtrecht/GitHub/eurecca-wp2/results/figures/';
figloc2 = '/Users/jwb/Library/CloudStorage/Dropbox/Apps/Overleaf/MDPI_PHZ/Figures/';

% exportgraphics(f0, [figloc2 'hydro_C4.png'])
exportgraphics(f1, [figloc2 'hydro_box_C10.png'])
