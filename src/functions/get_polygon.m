function [pgns, inside] = get_polygon(DEM)

%% Polygon definitions
xv_N = [117260 117340 117330 117420 117500 117490 117380 117360 117260];
yv_N = [560100 560080 560020 559950 560100 560270 560290 560170 560100];

xv_spit = [116120 116200 117420 117330 116120];
yv_spit = [559060 558980 559950 560020 559060];

xv_S = [115110 115260 115780 116200 116120 115690 115110];
yv_S = [558000 558000 558650 558980 559060 558710 558000];

xv_beach = [115110 115230 115780 117420 117330 115690 115110];
yv_beach = [558000 558000 558650 559950 560020 558710 558000];

% merge into struct
pgns = table(xv_N, yv_N, xv_spit, yv_spit, xv_S, yv_S, xv_beach, yv_beach);

% find nodes that are inside polygon
xq = DEM.DEM.X;
yq = DEM.DEM.Y;

in_N = inpolygon(xq,yq, xv_N, yv_N);
in_spit = inpolygon(xq,yq, xv_spit, yv_spit);
in_S = inpolygon(xq,yq, xv_S, yv_S);
in_beach = inpolygon(xq,yq, xv_beach, yv_beach);

% merge into struct
inside = table(in_N, in_spit, in_S, in_beach);

end