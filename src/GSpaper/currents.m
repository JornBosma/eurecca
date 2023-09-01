%% Initialisation
close all
clear
clc

[~, ~, ~, ~, fontsize, cbf, ~] = eurecca_init;

dataPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor'...
    filesep 'hydrodynamics' filesep 'ADV' filesep 'L2C10VEC' filesep' 'tailored_L2C10VEC.nc'];

info = ncinfo(dataPath);
% t = ncread(dataPath, 't'); % minutes since 2021-09-10 00:00:00
eta = ncread(dataPath, 'zs'); % water depth [m]
umag = ncread(dataPath, 'umag'); % water depth [m/s]

validIndices = ~isnan(eta) & ~isnan(umag);

eta = eta(validIndices);
umag = umag(validIndices);

%% Discretization
numBins = 100;
[discIndicesEta, binEdgesEta] = discretize(eta, numBins);
[binCountEta, ~] = histcounts(eta, numBins);

[discIndicesUmag, binEdgesUmag] = discretize(umag, numBins);
[binCountUmag, ~] = histcounts(umag, numBins);

etaBin = binEdgesEta(discIndicesEta);
umagBin = binEdgesUmag(discIndicesUmag);

% etaBin = NaN(length(eta), 1);
% umagBin = NaN(length(umag), 1);
% for n = 1:length(eta)
% 
%     % if isnan(discIndicesEta(n))
%     %     etaBin(n) = NaN;
%     % else
%         etaBin(n) = binEdgesEta(discIndicesEta(n));
%     % end
% 
%     % if isnan(discIndicesUmag(n))
%     %     umagBin(n) = NaN;
%     % else
%         umagBin(n) = binEdgesUmag(discIndicesUmag(n));
%     % end
% 
% end

% Identify bins with enough counts
validBins = binCountEta >= 4;

% Create a function to calculate the median
medianFunction = @(data) median(data);

% Find unique x-values and their corresponding indices
[etaBin_unique, ~, idx] = unique(etaBin(validBins));

% Use splitapply to calculate the mean y-value for each unique x-value
umagBin_mean = splitapply(medianFunction, umagBin(validBins), idx');

% Find water level corresponding to peak flow velocity
k = 10; % moving average window length
[maxValY, maxIdx] = max(movmean(umagBin_mean, k));
maxValX = etaBin_unique(maxIdx);

%% Visualisation
figure
scatter(etaBin, umagBin, 'sq', 'Color',cbf.skyblue); hold on
plot(etaBin_unique, movmean(umagBin_mean, k), 'r-', 'Color', cbf.vermilion, 'LineWidth',5)

xline(maxValX, ':k', 'LineWidth',5)
text(maxValX-.17, .42, ['\eta_{u,max}   \approx ', mat2str(maxValX,2), ' m'], 'FontSize',fontsize)

xlabel('water level [\eta] (m)')
ylabel('flow velocity [u_{mag}] (m s^{-1})')
legend(['bins [N = ',mat2str(numBins),']'], ['median fit [k = ',mat2str(k),']'])

%%
figure
binscatter(eta, umag, numBins/2)

ylim([0, .45])

xlabel('water level [\eta] (m)')
ylabel('flow velocity [u_{mag}] (m s^{-1})')
