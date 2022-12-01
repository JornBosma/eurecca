function [STMnoBackground background] = removeOffsetSTM(STM,N)
% REMOVEOFFSETSTM produces a smooth time series of background mV in STM
% signal. This offset has to be removed from the mV signal prior to the
% actual calibration to concentration in kg/m3. During this calibration,
% the "offset" value in P should be set to 0.
%
% INPUT
%   STM, timeseries in mV, [nObs x 1]
%   N, blocksize (in sampling units)
% OUTPUT
%   STMnoBackground, STM with offset/background removed, [nObs x 1]
%   background, timeseries in mV of background concentration, [nObs x 1]
%
% Gerben Ruessink, v1, 23-8-2012

% number of observation
nObs = size(STM,1);

% return immediately if STM is NaNs completely
if sum(isnan(STM)) == nObs
   STMnoBackground = STM;
   background = STM;
   return;
end;
    
% "time" axis
t = 1:nObs;

% how many blocks?
id = 1:N:nObs;
id(end) = nObs;
nBlocks = length(id)-1;

% prepare intermediate output
minmV = NaN(nBlocks,1);
tminmV = minmV;

% estimate minumum and its location for each block
for b = 1:nBlocks
    idRange = id(b):id(b+1)-1;
    [minmV(b) idMin] = min(STM(idRange));
    tminmV(b) = t(idRange(idMin));
end;

% % remove NaNs
% id = find(isnan(minmV));
% minmV(id) = [];
% tminmV(id) = [];
% if isempty(minmV),
%     STMnoBackground = STM*NaN;
%     background = STMnoBackground;
%     return;
% end;

% for smooth handling at begin and end of series repeat first and last
% value
minmV = [minmV(1); minmV; minmV(end)];
tminmV = [t(1)-round(N/2); tminmV; t(end)+round(N/2)];

% estimate background using spline function
background = interp1(tminmV,minmV,t(:),'spline');

% and subtract from STM with a minumum of 0 mV
STMnoBackground = STM - background;
STMnoBackground(STMnoBackground<0) = 0;

end % ready

