%% Initialisation
close all
clear
clc

eurecca_init

% processed topo files
load('zSounding.mat')

% other settings
fontsize = 20;

% axis limits and ticks
xl = [1.148e+05, 1.1805e+05]; % PHZD
yl = [5.5775e+05, 5.6065e+05];
xt = 114000:1e3:118000;
yt = 558000:1e3:561000;
% xl = [1.1695e+05, 1.1765e+05]; % spit hook zoom-in
% yl = [5.5976e+05, 5.6040e+05];

%% Calculation
map = z_2021_06;
x = map.xRD;
y = map.yRD;
z = map.z;
resolution = 600;

xq = linspace(xl(1), xl(2), resolution);
yq = linspace(yl(1), yl(2), resolution);
[X, Y] = meshgrid(xq, yq);
Z = griddata(x, y, z, X, Y, 'natural');

%% Remove filled in data gaps
% Find coordinates inside hole
xh = x((z==0));
yh = y((z==0));

% Define bounding polygon
p = boundary(xh, yh);

% Find and remove pts inside polygon and plot
in = inpolygon(X, Y, xh(p), yh(p));
Z(~in) = NaN;

%% Visualisation
figure2
pcolor(X, Y, Z); hold on
[~, NAP_0] = contour3(X, Y, Z, [0, 0], 'LineWidth', 1, 'LineColor', 'm');
legend(NAP_0, 'MSL')
xlabel('easting - RD (m)')
ylabel('northing - RD (m)')

c = colorbar;
c.Label.String = 'm +NAP';
c.Label.Interpreter = 'latex';
c.TickLabelInterpreter = 'latex';
c.FontSize = fontsize;
colormap(brewermap([], '*PuOr'))
caxis([-5, 5]);

set(gca, 'Color', [.8 .8 .8])
shading interp
axis equal
grid on
