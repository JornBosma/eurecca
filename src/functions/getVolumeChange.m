function [dQ, dz, dz_Beach, pgns] = getVolumeChange(A, B, ref)

% Calculates the volume difference between two DEMs inside predefined
% polygons.

% Example input
% ref = load('PHZ_2020_Q1','-mat');
% A = load('PHZ_UTD_realisatie.mat','-mat');
% B = load('PHZ_2021_11','-mat');

%% Polygon definitions
xq = ref.DEM.X;
yq = ref.DEM.Y;

xv_N = [117200 117420 117500 117490 117370 117330 117200];
yv_N = [560110 559950 560100 560260 560280 560180 560100];

xv_spit = [116120 116200 117420 117330 116120];
yv_spit = [559060 558980 559950 560020 559060];

xv_S = [115110 115320 115780 116200 116120 115690 115110];
yv_S = [558000 558080 558650 558980 559060 558710 558000];

xv_beach = [115110 115230 115780 117420 117330 115690 115110];
yv_beach = [558000 558000 558650 559950 560020 558710 558000];

% combine in struct
pgns = table(xv_N, yv_N, xv_spit, yv_spit, xv_S, yv_S, xv_beach, yv_beach);

% find nodes that are inside polygon
in_N = inpolygon(xq,yq, xv_N, yv_N);
in_spit = inpolygon(xq,yq, xv_spit, yv_spit);
in_S = inpolygon(xq,yq, xv_S, yv_S);
in_beach = inpolygon(xq,yq, xv_beach, yv_beach);

%% Calculations
% subtract DEMs to obtain difference map
dz = B.DEM.Z-A.DEM.Z;

% total area, including backshore and safety dune
dz_noNaN = dz;
dz_noNaN(isnan(dz)) = 0;

% region between +2 and -1 contours = foreshore/beach face
dz_fshore = dz_noNaN;
dz_fshore(ref.DEM.Z>2 | ref.DEM.Z<-1) = 0;

% accretive region at northern tip of the spit
dz_N = dz_fshore;
dz_N(~in_N) = 0;

dQ_N = trapz(ref.DEM.X(1,:), trapz(ref.DEM.Y(:,1), dz_N));

dz_N_pos = dz_N;
dz_N_pos(dz_N<0) = 0;

dQ_N_pos = trapz(ref.DEM.X(1,:), trapz(ref.DEM.Y(:,1), dz_N_pos));

dz_N_neg = dz_N;
dz_N_neg(dz_N>0) = 0;

dQ_N_neg = trapz(ref.DEM.X(1,:), trapz(ref.DEM.Y(:,1), dz_N_neg));

% beach face of spit
dz_spit = dz_fshore;
dz_spit(~in_spit) = 0;

dQ_spit = trapz(ref.DEM.X(1,:), trapz(ref.DEM.Y(:,1), dz_spit));

dz_spit_pos = dz_spit;
dz_spit_pos(dz_spit<0) = 0;

dQ_spit_pos = trapz(ref.DEM.X(1,:), trapz(ref.DEM.Y(:,1), dz_spit_pos));

dz_spit_neg = dz_spit;
dz_spit_neg(dz_spit>0) = 0;

dQ_spit_neg = trapz(ref.DEM.X(1,:), trapz(ref.DEM.Y(:,1), dz_spit_neg));

% southern beach in lee of harbour jetty, including mudflat
dz_S = dz_fshore;
dz_S(~in_S) = 0;

dQ_S = trapz(ref.DEM.X(1,:), trapz(ref.DEM.Y(:,1), dz_S));

dz_S_pos = dz_S;
dz_S_pos(dz_S<0) = 0;

dQ_S_pos = trapz(ref.DEM.X(1,:), trapz(ref.DEM.Y(:,1), dz_S_pos));

dz_S_neg = dz_S;
dz_S_neg(dz_S>0) = 0;

dQ_S_neg = trapz(ref.DEM.X(1,:), trapz(ref.DEM.Y(:,1), dz_S_neg));

% entire beach stretch
dz_beach = dz_fshore;
dz_beach(~in_beach) = 0;

dQ_beach = trapz(ref.DEM.X(1,:), trapz(ref.DEM.Y(:,1), dz_beach));

dz_beach_pos = dz_beach;
dz_beach_pos(dz_beach<0) = 0;

dQ_beach_pos = trapz(ref.DEM.X(1,:), trapz(ref.DEM.Y(:,1), dz_beach_pos));

dz_beach_neg = dz_beach;
dz_beach_neg(dz_beach>0) = 0;

dQ_beach_neg = trapz(ref.DEM.X(1,:), trapz(ref.DEM.Y(:,1), dz_beach_neg));

% entire beach face + spit tip
dz_Beach = dz_fshore;
dz_Beach(~in_beach & ~in_N) = 0;

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

%% Visualisation
% figure
% surf(A.DEM.X, A.DEM.Y, dz); hold on
% xlabel('easting [RD] (m)')
% ylabel('northing [RD] (m)')
% zlabel('z (m +NAP)')
% cb = colorbar;
% cb.TickLabelInterpreter = 'latex';
% cb.Label.Interpreter = 'latex';
% cb.Label.String = ['$<$ erosion (m)', repmat('\ ', 1, 26), 'deposition (m) $>$'];
% cb.FontSize = fontsize;
% clim([-2 2])
% shading flat
% crameri('vik', 11, 'pivot', 0)
% view(0,90)
% axis vis3d
% 
% xlim([1.15e5 1.18e5])
% ylim([5.58e5 5.605e5])
% 
% % plot polygons and volumes
% patch(xv_N,yv_N,'g','FaceAlpha',.2, 'EdgeColor','g')
% text(mean([xv_N(2) xv_N(3)])+40, mean([yv_N(2) yv_N(3)]),...
%     ['$\Delta$Q = ', mat2str(dQ_N,2),' m$^3$'], 'FontSize',fontsize/1.3)
% 
% patch(xv_beach,yv_beach,'y','FaceAlpha',.2, 'EdgeColor','y')
% text(mean([xv_beach(2) xv_beach(4)])+20, mean([yv_beach(2) yv_beach(4)]),...
%     ['$\Delta$Q = ', mat2str(dQ_beach,2),' m$^3$'], 'FontSize',fontsize/1.3)
% 
% %%%%%%%%%%%%%%%%%%
% figure
% [C,h] = contour(A.DEM.X, A.DEM.Y, A.DEM.Z, 0:.5:4, 'k'); hold on
% xlabel('easting [RD] (m)')
% ylabel('northing [RD] (m)')
% zlabel('z (m +NAP)')
% 
% v = 0:.5:3;
% clabel(C,h,v, 'FontSize',15, 'Color','red', 'FontWeight','bold', 'LabelSpacing', 1000)
% h.LabelFormat = '%0.1f m';
% 
% view(0,90)
% % view(48.5,90)
% pbaspect(daspect())
% 
% xlim([1.15e5 1.18e5])
% ylim([5.58e5 5.605e5])
% 
% Zsub2m = A.DEM.Z;
% Zsub2m(Zsub2m>2) = NaN;
% [M,c] = contourf(A.DEM.X, A.DEM.Y, Zsub2m, 0:.5:2, 'FaceAlpha',.25);
% crameri('-hawaii')
% 
% % plot polygons and volumes
% patch(xv_N,yv_N,'g','FaceAlpha',.2, 'EdgeColor','g')
% text(mean([xv_N(2) xv_N(3)])+40, mean([yv_N(2) yv_N(3)]),...
%     ['$\Delta$Q = ', mat2str(dQ_N,2),' m$^3$'], 'FontSize',fontsize/1.3)
% 
% patch(xv_beach,yv_beach,'y','FaceAlpha',.2, 'EdgeColor','y')
% text(mean([xv_beach(2) xv_beach(4)])+20, mean([yv_beach(2) yv_beach(4)]),...
%     ['$\Delta$Q = ', mat2str(dQ_beach,2),' m$^3$'], 'FontSize',fontsize/1.3)
