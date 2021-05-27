%% Initialisation
close all
clear
clc

startup

D50x = [1.020 0.461 2.089 0.688 1.125 1.004 0.673 1.008 1.368 0.423];
D90x = [5.322 2.656 6.253 4.708 3.666 4.068 2.754 3.473 4.369 5.350];

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
legend('D_{50}', 'D_{90}')
xticks(1:length(D50x))
xticklabels(labelsX)
xlabel('sample')
ylabel('grain size (mm)')
title('Cross-shore, 3 Dec 2020')

%% Visualisation: longshore transects
figure
bar([D50y1;D90y1]', 'grouped')
legend('D_{50}', 'D_{90}')
xticks(1:length(D50y1))
xticklabels(labelsY1)
xlabel('sample')
ylabel('grain size (mm)')
title('Low-water line, 16 Oct 2020')

figure
bar([D50y2;D90y2]', 'grouped')
legend('D_{50}', 'D_{90}')
xticks(1:length(D50y2))
xticklabels(labelsY2)
xlabel('sample')
ylabel('grain size (mm)')
title('Runnel, 16 Oct 2020')

figure
bar([D50y3;D90y3]', 'grouped')
legend('D_{50}', 'D_{90}')
xticks(1:length(D50y3))
xticklabels(labelsY3)
xlabel('sample')
ylabel('grain size (mm)')
title('High-water line, 16 Oct 2020')

figure
bar([D50y0;D90y0]', 'grouped')
legend('D_{50}', 'D_{90}')
xticks(1:length(D50y0))
xticklabels(labelsY0)
xlabel('sample')
ylabel('grain size (mm)')
title('Lagoon and tidal flat, 16 Oct 2020')
