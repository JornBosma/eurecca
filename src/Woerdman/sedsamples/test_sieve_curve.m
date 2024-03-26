A=cumsum(S.L0928.per);

% 
% dates=[2,5,7,9,11,13];
% plot(S.L0928.sieve/1000,cumsum(S.L0928.per(:,dates),1,"reverse")); hold on
% plot(S.L0928.sieve/1000,cumsum(mean(S.L0928.per(:,dates),2),1,"reverse"),'--k');hold on
% xline(mean(S.L0928.D10(dates))/1000); hold on
% xline(mean(S.L0928.D50(dates))/1000); hold on
% xline(mean(S.L0928.D90(dates))/1000); hold on
% set(gca,'Xscale','log')


% dates=[2,5,7,9,11,13];
plot(S.C0920.sieve/1000,cumsum(S.C0920.per,1,"reverse")); hold on
plot(S.C0920.sieve/1000,cumsum(mean(S.C0920.per,2),1,"reverse"),'--k');hold on
xline(mean(S.C0920.D10)/1000); hold on
xline(mean(S.C0920.D50)/1000); hold on
xline(mean(S.C0920.D90)/1000); hold on
set(gca,'Xscale','log')