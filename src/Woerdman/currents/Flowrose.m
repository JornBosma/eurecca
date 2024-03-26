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
      end
            
L1C1VEC= ref_files{1,1}.L1C1VEC(:,:);
L2C10VEC=ref_files{1,2}.L2C10VEC;
L3C1VEC= ref_files{1,3}.L3C1VEC(:,:);
L4C1VEC= ref_files{1,4}.L4C1VEC(:,:);
L5C1VEC= ref_files{1,5}.L5C1VEC(:,:);
L6C1VEC= ref_files{1,6}.L6C1VEC(:,:);
%%
flowvel(:,1)=L1C1VEC(:,11);
flowvel(:,2)=L2C10VEC(:,11);
flowvel(:,3)=L3C1VEC(:,11);
flowvel(:,4)=L4C1VEC(:,11);
flowvel(:,5)=L5C1VEC(:,11);
flowvel(:,6)=L6C1VEC(:,11);

flowdir(:,1)=L1C1VEC(:,12);
flowdir(:,2)=L2C10VEC(:,12);
flowdir(:,3)=L3C1VEC(:,12);
flowdir(:,4)=L4C1VEC(:,12);
flowdir(:,5)=L5C1VEC(:,12);
flowdir(:,6)=L6C1VEC(:,12);


t_start = datetime(2021,09,11,00,00,00);
t_end = datetime(2021,10,18,10,00,00);
ref_time = (t_start:minutes(10):t_end)';

%% current roses entire period
Options = {'anglenorth', 0, 'angleeast', 90, 'labels', {'N', 'E', 'S', 'W'},...
        'legendtype',1,'cmap','jet','lablegend','U (m/s)','freqlabelangle',...
        -45,'gridstyle', ':', 'gridcolor', 'k', 'gridwidth', 2, 'gridalpha', 0.5};
string= {'L1','L2','L3','L4','L5','L6'};
shoreline={2.07,1,0.84,0.91,1.15,1.42};
x= -1:1;
for i=1:6
        id= find(flowvel(:,i)>=0 |flowvel(:,i)<=0  );
        %     ax(i) = subplot(2,3,i);
        [figure_handle,count,speeds,directions,Table] = FlowRose(flowdir(id,i), flowvel(id,i),[Options]);
        y=shoreline{i}*x;
        plot(x,y,'--k',LineWidth=2);
        set(gcf, 'color', 'white');
        % set(gca,'fontsize',10,'FontWeight','bold');
        set(colorbar,'visible','off')
        text(0.025,0.90,string{i},'Units','normalized','FontSize',24);hold on
        filename=['flowrose_' string{i}];
end
saveas(figure(i),[basePath '\analysis\currents\figures\' filename '.png']);
saveas(figure(i),[basePath '\analysis\currents\figures\' filename '.fig']);



