%% Initialisation
close all
% clear
clc

startup

%% Particle size distribution
% sieve = xlsread('GrainSize','Sheet2','B3:B24'); % grain size axis [mu]
% D = xlsread('GrainSize','Sheet2','C3:S24');     % grain size fractions [%]
% D(:,10) = [];                                   % sample 10 appears incomplete
% D(D<0) = 0;                                     % remove negatives
% coor = xlsread('GrainSize','Sheet2','C27:S29'); % x;y;z coordinates (s16-17 missing)

sieve = Sieveanalysis16102020S1.SieveOpeningmm.*1000;
D = Sieveanalysis16102020S1.MassRetained;

Dcum = [sieve cumsum(D,'reverse')];
P50 = [sieve 50.*(ones(size(sieve)))];

DcumSm = zeros(size(Dcum));
for n = 2:size(Dcum, 2)-1
    DcumSm(:,n) = smooth(Dcum(:,n));
end
DcumSm(:,1) = Dcum(:,1);

% Calculations
int = zeros(16,2);
for n = 2:size(Dcum, 2)-1
    int(n-1,:) = InterX(Dcum(:,[1 n])',P50');
end

intSm = zeros(16,2);
for n = 2:size(Dcum, 2)-1
    intSm(n-1,:) = InterX(DcumSm(:,[1 n])',P50');
end

DcumM = [sieve median(Dcum(:,2),2)]; % only use samples [1:9 11 12]
D50 = InterX(DcumM',P50');

% Visualisation
figure2
yyaxis left
plot(Dcum(:,1),smooth(DcumM(:,2)),'o-','LineWidth',2)
line50 = yline(50,'--','LineWidth',2);
str = {['D_{50} ~ ',num2str(D50(1),'%.0f'),' \mum']};
text(25,54,str,'FontSize',16)
ylabel 'cumulative volume (%)'
yyaxis right
bar(sieve,median(D(:,1),2))
% ylim([0 60])
set(gca, 'XScale', 'log')
% title 'Mean particle size distribution (from MSL to foredune), 31 October 2017'
ylabel 'volume (%)'
xlabel 'particle diameter (\mum)'
xlim([10^1 10^4])
grid on
box off
