%% Initialisation
close all
clear
clc

[~, fontsize, cbf, ~] = eurecca_init;

dataPath = [filesep 'Volumes' filesep 'T7 Shield' filesep 'DataDescriptor'...
    filesep 'hydrodynamics' filesep 'ADV' filesep 'L2C10VEC' filesep' 'tailored_L2C10VEC.nc'];

info = ncinfo(dataPath);
t = ncread(dataPath, 't'); % minutes since 2021-09-10 00:00:00
eta = ncread(dataPath, 'zs'); % water depth [m]
umag = ncread(dataPath, 'umag'); % flow velocity magnitude [m/s]
ulm = ncread(dataPath, 'ulm'); % longshore flow velocity [m/s] (flood tide = negative)

ulm = -ulm; % flood = positive; ebb = negative

validIndices = ~isnan(eta) & ~isnan(umag);

% t = t(validIndices);
eta = eta(validIndices);
umag = umag(validIndices);
ulm = ulm(validIndices);

%% Discretization
numBins = 100;
[discIndicesEta, binEdgesEta] = discretize(eta, numBins);
[binCountEta, ~] = histcounts(eta, numBins);

[discIndicesUmag, binEdgesUmag] = discretize(umag, numBins);
[binCountUmag, ~] = histcounts(umag, numBins);

[discIndicesUlm, binEdgesUlm] = discretize(ulm, numBins);
[binCountUlm, ~] = histcounts(ulm, numBins);

etaBin = binEdgesEta(discIndicesEta);
umagBin = binEdgesUmag(discIndicesUmag);
ulmBin = binEdgesUlm(discIndicesUlm);

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

%% Computations
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

%% Visualisation: umag
f1 = figureRH;
scatter(etaBin, umagBin, 'sq', 'Color',cbf.blue); hold on
plot(etaBin_unique, movmean(umagBin_mean, k), 'r-', 'Color', cbf.vermilion, 'LineWidth',5)

xline(maxValX, ':k', 'LineWidth',5)
text(maxValX-.21, .42, ['\eta_{u,max} \approx ', mat2str(maxValX,2), ' m'], 'FontSize',fontsize)

xlabel('water level [\eta] (m)')
ylabel('flow velocity [u_{mag}] (m s^{-1})')
legend(['bins [N = ',mat2str(numBins),']'], ['median fit [k = ',mat2str(k),']'])

%% Visualisation: ulm
f2 = figureRH;
scatter(etaBin, ulmBin, 'sq', 'Color',cbf.blue)

xlabel('water level [\eta] (m)')
ylabel('longshore flow velocity [u_{lm}] (m s^{-1})')

%% Visualisation: time series eta & ulm
t = ncread(dataPath, 't'); % minutes since 2021-09-10 00:00:00
eta = ncread(dataPath, 'zs'); % water depth [m]
ulm = ncread(dataPath, 'ulm'); % longshore flow velocity [m/s] (flood tide = negative)

ulm = -ulm; % flood = positive; ebb = negative
time = datetime('2021-09-10 00:00:00','Format','yyyy-MM-dd HH:mm:ss') + minutes(t);

f3 = figureRH;
plot(time, movmean(eta, 10), 'Color',cbf.blue); hold on
plot(time, movmean(ulm, 10), 'Color',cbf.vermilion); hold off

% xlabel('time')
legend('water level [\eta] (m)','longshore flow velocity [u_{lm}] (m s^{-1})')
