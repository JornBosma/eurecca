%% Initialisation
close all
clear
clc

eurecca_init

% processed sedi files
load('JDN_samples.mat')
load('sampleGPS.mat')

% 3 Dec 2020
D50x = [1.018 0.460 2.089 0.687 1.125 1.004 0.673 1.009 1.369 0.423];
D90x = [5.320 2.656 6.253 4.707 3.666 4.068 2.754 3.473 4.369 5.349];
stdx = [1.757 1.313 1.792 1.581 1.389 1.374 1.252 1.234 1.350 1.718];

sampleData3.D50 = D50x';

for n = 1:length(D50x)
    labelsX{n} = ['Ti', num2str(n)];
end

% low-water line (x.1)
D50y1 = [0.910 0.670 0.926 1.070 1.177 0.710 0.483 1.343];
D90y1 = [2.524 2.473 3.164 3.084 3.375 1.865 1.670 2.853];

for n = 1:length(D50y1)
    labelsY1{n} = ['LW', num2str(n)];
end

% runnel (x.2)
D50y2 = [0.441 0.946 1.579 0.565 1.834 0.439 1.088];
D90y2 = [1.472 2.568 3.960 2.396 6.000 3.312 3.901];

for n = 1:length(D50y2)
    labelsY2{n} = ['R', num2str(n)];
end

% high-water line (x.3)
D50y3 = [0.337 0.817 0.924 0.831 2.365 0.559 0.448];
D90y3 = [0.487 2.132 3.566 3.095 4.758 2.224 1.439];

for n = 1:length(D50y3)
    labelsY3{n} = ['HW', num2str(n)];
end

% other (x.0)
D50y0 = [0.387 0.296 0.272];
D90y0 = [1.060 0.437 0.415];

labelsY0 = {'lagoon', 'TF7', 'TF8'};

%% Visualisation: cross-shore transect
figure
bar([D50x;D90x]', 'grouped')
legend('D$_{50}$', 'D$_{90}$')
xticks(1:length(D50x))
xticklabels(labelsX)
ylim([0 7])
xlabel('sample')
ylabel('grain size (mm)')
title('Cross-shore, 3 Dec 2020')

%% Visualisation: longshore transects
figure('Name', 'Longshore transects')
tl = tiledlayout('flow', 'TileSpacing', 'Compact');

ax(1) = nexttile;
bar([D50y1;D90y1]', 'grouped')
legend('D$_{50}$', 'D$_{90}$')
xticks(1:length(D50y1))
xticklabels(labelsY1)
ylim([0 7])
xlabel('sample')
ylabel('grain size (mm)')
title('Low-water line, 16 Oct 2020')

ax(2) = nexttile;
bar([D50y2;D90y2]', 'grouped')
legend('D$_{50}$', 'D$_{90}$')
xticks(1:length(D50y2))
xticklabels(labelsY2)
ylim([0 7])
xlabel('sample')
ylabel('grain size (mm)')
title('Runnel, 16 Oct 2020')

ax(3) = nexttile;
bar([D50y3;D90y3]', 'grouped')
legend('D$_{50}$', 'D$_{90}$')
xticks(1:length(D50y3))
xticklabels(labelsY3)
ylim([0 7])
xlabel('sample')
ylabel('grain size (mm)')
title('High-water line, 16 Oct 2020')

ax(4) = nexttile;
bar([D50y0;D90y0]', 'grouped')
legend('D$_{50}$', 'D$_{90}$')
xticks(1:length(D50y0))
xticklabels(labelsY0)
ylim([0 7])
xlabel('sample')
ylabel('grain size (mm)')
title('Lagoon and tidal flat, 16 Oct 2020')
