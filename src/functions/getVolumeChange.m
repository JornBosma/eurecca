function [dQ, dz, dz_Beach] = getVolumeChange(A, B)

% Calculates the volume difference between two DEMs inside predefined
% polygons.

%% water levels
% MHWS = 0.81; % mean high water spring [m]
% MLWS = -1.07; % mean low water spring [m]
% MSL = 0; % mean sea level [m]
% NAP = MSL-0.1; % local reference datum [m]

%% Polygon definitions
[~, inside] = get_polygon(A);

%% Calculations
% subtract DEMs to obtain difference map
dz = B.DEM.Z-A.DEM.Z;

% total area, including backshore and safety dune
dz_noNaN = dz;
dz_noNaN(isnan(dz)) = 0;

% region between +2 and -1 contours = foreshore/beach face
dz_fshore = dz_noNaN;
dz_fshore(A.DEM.Z>3 | B.DEM.Z<-.5) = 0;

% accretive region at northern tip of the spit
dz_N = dz_fshore;
dz_N(~inside.in_N) = 0;

dQ_N = trapz(A.DEM.X(1,:), trapz(A.DEM.Y(:,1), dz_N));

dz_N_pos = dz_N;
dz_N_pos(dz_N<0) = 0;

dQ_N_pos = trapz(A.DEM.X(1,:), trapz(A.DEM.Y(:,1), dz_N_pos));

dz_N_neg = dz_N;
dz_N_neg(dz_N>0) = 0;

dQ_N_neg = trapz(A.DEM.X(1,:), trapz(A.DEM.Y(:,1), dz_N_neg));

% beach face of spit
dz_spit = dz_fshore;
dz_spit(~inside.in_spit) = 0;

dQ_spit = trapz(A.DEM.X(1,:), trapz(A.DEM.Y(:,1), dz_spit));

dz_spit_pos = dz_spit;
dz_spit_pos(dz_spit<0) = 0;

dQ_spit_pos = trapz(A.DEM.X(1,:), trapz(A.DEM.Y(:,1), dz_spit_pos));

dz_spit_neg = dz_spit;
dz_spit_neg(dz_spit>0) = 0;

dQ_spit_neg = trapz(A.DEM.X(1,:), trapz(A.DEM.Y(:,1), dz_spit_neg));

% southern beach in lee of harbour jetty, including mudflat
dz_S = dz_fshore;
dz_S(~inside.in_S) = 0;

dQ_S = trapz(A.DEM.X(1,:), trapz(A.DEM.Y(:,1), dz_S));

dz_S_pos = dz_S;
dz_S_pos(dz_S<0) = 0;

dQ_S_pos = trapz(A.DEM.X(1,:), trapz(A.DEM.Y(:,1), dz_S_pos));

dz_S_neg = dz_S;
dz_S_neg(dz_S>0) = 0;

dQ_S_neg = trapz(A.DEM.X(1,:), trapz(A.DEM.Y(:,1), dz_S_neg));

% entire beach stretch
dz_beach = dz_fshore;
dz_beach(~inside.in_beach) = 0;

dQ_beach = trapz(A.DEM.X(1,:), trapz(A.DEM.Y(:,1), dz_beach));

dz_beach_pos = dz_beach;
dz_beach_pos(dz_beach<0) = 0;

dQ_beach_pos = trapz(A.DEM.X(1,:), trapz(A.DEM.Y(:,1), dz_beach_pos));

dz_beach_neg = dz_beach;
dz_beach_neg(dz_beach>0) = 0;

dQ_beach_neg = trapz(A.DEM.X(1,:), trapz(A.DEM.Y(:,1), dz_beach_neg));

% entire beach face + spit tip
dz_Beach = dz_fshore;
dz_Beach(~inside.in_beach & ~inside.in_N) = 0;

% total
dQ_tot_pos = dQ_N_pos+dQ_beach_pos;
dQ_tot_neg = dQ_N_neg+dQ_beach_neg;
dQ_tot = dQ_N+dQ_beach;

%% Store data
Regions = {'N_spit';'Spit';'S_beach';'Beach';'Total'};
Sedimentation = [dQ_N_pos;dQ_spit_pos;dQ_S_pos;dQ_beach_pos;dQ_tot_pos];
Erosion = [dQ_N_neg;dQ_spit_neg;dQ_S_neg;dQ_beach_neg;dQ_tot_neg];
Net = [dQ_N;dQ_spit;dQ_S;dQ_beach;dQ_tot];
dQ = table(Regions,Sedimentation,Erosion,Net);

end
