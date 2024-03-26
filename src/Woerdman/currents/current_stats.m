
clear all;
close all;

sedmexInit;
global basePath;

%% Open result data BaseParameters
myFolder = [basePath, 'results'];
filePattern = fullfile(myFolder, '*VEC*.mat');
matFiles = dir(filePattern);
      for i = 1:length(matFiles)
          baseFileName = fullfile(myFolder, matFiles(i).name);
          ref_files{i} = load(baseFileName);
          vars = fieldnames(ref_files{i});
          varnames{i}=fieldnames(ref_files{i});
             for j = 1:length(vars)
            assignin('base', vars{j}, ref_files{i}.(vars{j}));
            end
      end
%%
L1C1VEC(1957:3747,2)= NaN
stats.L1= current_peaks(datetime(eurecca2METtime(L1C1VEC(:,1))),L1C1VEC(:,3));


stats.L2= current_peaks(datetime(eurecca2METtime(L2C10VEC(:,1))),L2C10VEC(:,3));


stats.L3= current_peaks(datetime(eurecca2METtime(L3C1VEC(:,1))),L3C1VEC(:,3));


stats.L4= current_peaks(datetime(eurecca2METtime(L4C1VEC(:,1))),L4C1VEC(:,3));


stats.L5= current_peaks(datetime(eurecca2METtime(L5C1VEC(:,1))),L5C1VEC(:,3));


stats.L6= current_peaks(datetime(eurecca2METtime(L6C1VEC(:,1))),L6C1VEC(:,3));


t =datetime(eurecca2METtime(L4C1VEC(:,1)));                                                         % Time Vector
y =L4C1VEC(:,2) ;                                                        % Signal
zci = @(v) find(v(:).*circshift(v(:), [-1 0]) <= 0);                    % Returns Zero-Crossing Indices Of Argument Vector
zx = zci(y);                                                            % Approximate Zero-Crossing Indices
figure(1)
plot(t, y, '-r')
hold on
plot(t(zx), y(zx), 'bp')
hold off
grid
legend('Signal', 'Approximate Zero-Crossings')

TF = islocalmax(y,'MinSeparation',hours(10),'SamplePoints',t);
plot(t,y,t(TF),y(TF),'r*')
xline(t(TF)); hold on

TF = islocalmin(y,'MinSeparation',hours(10),'SamplePoints',t);
plot(t,y,t(TF),y(TF),'b*')
xline(t(TF),'--'); hold on
xlim([t(1) t(6*24)])
yline(0)



%% mean and std currents
stats.L1.avg=mean(L1C1VEC(:,2),'omitnan');
stats.L1.std=std(L1C1VEC(:,13),'omitnan');
stats.L2.avg=mean(L2C10VEC(:,2),'omitnan');
stats.L2.std=std(L2C10VEC(:,13),'omitnan');
stats.L3.avg=mean(L3C1VEC(:,2),'omitnan');
stats.L3.std=std(L3C1VEC(:,13),'omitnan');
stats.L4.avg=mean(L4C1VEC(:,2),'omitnan');
stats.L4.std=std(L4C1VEC(:,13),'omitnan');
stats.L5.avg=mean(L5C1VEC(:,2),'omitnan');
stats.L5.std=std(L5C1VEC(:,13),'omitnan');
stats.L6.avg=mean(L6C1VEC(:,2),'omitnan');
stats.L6.std=std(L6C1VEC(:,13),'omitnan');






