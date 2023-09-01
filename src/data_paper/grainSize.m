% Grain-size distributions from the PHZ beach
% J.W. Bosma, 2023

%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize, ~] = eurecca_init;

% colourblind-friendly colour palette
orange = [230/255, 159/255, 0];
blue = [86/255, 180/255, 233/255];
yellow = [240/255, 228/255, 66/255];
redpurp = [204/255, 121/255, 167/255];
bluegreen = [0, 158/255, 115/255];

% load data
folderPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor' filesep 'grainsizes'];
dataPath = [folderPath filesep 'GS_20211007.csv'];

opts = detectImportOptions(dataPath);
opts = setvaropts(opts,'Date_ddMMyyyy','InputFormat','dd/MM/yyyy');

GS_20211007 = readtable(dataPath, opts);

% prepare data
sieveSizes = [8000, 4000, 2000, 1000, 710, 500, 425, 355, 300, 250, 180, 125, 63, 0];
massRetained = GS_20211007{2, 16:end}; % first sample

% calculate total mass
totalMass = sum(massRetained);

% calculate cumulative mass
cumulativeMass = cumsum(massRetained);

% normalize cumulative mass
normalizedMass = cumulativeMass / totalMass;

%% Calculate percentage for each size class
percentageSizes = (massRetained / totalMass) * 100; % uncorrected

% correct for differences in size range between sieves
sieveSizesTemp = [16e3, sieveSizes];
sieveRange = nan(size(sieveSizes));
for n = 1:length(sieveSizes)
    sieveRange(n) = sieveSizesTemp(n) - sieveSizesTemp(n+1);
end
sievePortion = sieveRange / sum(sieveRange);
massRetainedRel = massRetained ./ sievePortion;
percentageSizesRel = (massRetainedRel / sum(massRetainedRel)) * 100;

% correct for differences in particle mass per size (assume spherical
% quartz grains?)
...

%% Visualisation
f0 = figure;

ax1 = axes;
plot(ax1, sieveSizes, normalizedMass*100, '-', 'Color',redpurp,...
    'LineWidth',4); hold on
scatter(ax1, sieveSizes, normalizedMass*100, 200, 'MarkerEdgeColor',blue,...
    'MarkerFaceColor',blue, 'Marker','square')

D90 = interp1(normalizedMass(1:end-3)*100, sieveSizes(1:end-3), 10, 'pchip');
D50 = interp1(normalizedMass(1:end-3)*100, sieveSizes(1:end-3), 50, 'pchip');
D10 = interp1(normalizedMass(1:end-3)*100, sieveSizes(1:end-3), 90, 'pchip');
% text(145, 90, ['D$_{10}$ = ',num2str(D10, 3),' $\mu$m'], 'FontSize',fontsize)
% text(250, 50, ['D$_{50}$ = ',num2str(D50, 3),' $\mu$m'], 'FontSize',fontsize)
% text(900, 10, ['D$_{90}$ = ',num2str(D90, 4),' $\mu$m'], 'FontSize',fontsize)
text(145, 90, ['d_{10} = ',num2str(D10, 3),' \mum'], 'FontSize',fontsize) % tex
text(250, 50, ['d_{50} = ',num2str(D50, 3),' \mum'], 'FontSize',fontsize) % tex
text(850, 10, ['d_{90} = ',num2str(D90, 4),' \mum'], 'FontSize',fontsize) % tex

ax1.XScale = 'log';
xlim(ax1, [min(sieveSizes) max(sieveSizes)])

% xlabel('particle diameter ($\mu$m)')
% ylabel('cumulative mass retained ($\%$)')
xlabel('particle diameter [\mum]') % tex
ylabel('cumulative mass retained [%]') % tex

grid on
grid minor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
position = [0.52 0.58 0.32 0.32];  % [x y width height]
ax2 = axes('Position', position);

boundaries = [fliplr(sieveSizes), 16e3];
h = stairs(boundaries, [fliplr(percentageSizesRel), 0], 'LineStyle','none'); hold on

x = repelem(h.XData(2:end), 2);
y = repelem(h.YData(1:end-1), 2);
x(end) = []; y(1) = [];
fill([x, fliplr(x)], [y, min(h.YData)*ones(size(y))], blue, 'LineWidth',1)

for n = 1:length(h.XData)
    line([h.XData(n), h.XData(n)], [0, h.YData(n)], 'Color','k', 'LineWidth',1)
end

% bar(ax2, log10(sieveSizes), percentageSizes, 'FaceColor',blue, 'EdgeColor',blue)
% xticks(ax2, 2:4)
% xticklabels(ax2, 10.^get(ax2, 'Xtick'))
% xlim(ax2, [2 4])

% bar(ax2, sieveSizes, massRetained, 'FaceColor',blue, 'EdgeColor',blue)
% xticks([1e2 1e3 1e4])
% xlim([1e2 1e4])

ax2.XScale = 'log';
ax2.XAxisLocation = 'bottom';
ax2.YAxisLocation = 'right';
ax2.Color = [0.5 0.5 0.5 .2];
ax2.FontSize = fontsize*.9;

% xlabel('particle diameter ($\mu$m)', 'FontSize',fontsize*.8)
% ylabel('class weight ($\%$)', 'FontSize',fontsize*.8)
xlabel('particle diameter [\mum]', 'FontSize',fontsize*.9) % tex
ylabel('class weight [%]', 'FontSize',fontsize*.9) % tex

axis padded
