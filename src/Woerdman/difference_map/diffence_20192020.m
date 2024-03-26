close all
clear all


sedmexInit;
global basePath;

load("diffmap.mat")
arrays=load('arrays.mat');
sed_sample=load('sed_sample.mat');
sample_loc=load('sample_loc.mat');

%% array locations and sample locations
loc_x=arrays.loc_x;
loc_y=arrays.loc_y;
sample_x=sample_loc.sample_loc_x;
sample_y=sample_loc.sample_loc_y;
%%
x=downsample(diffMap.xRD,2);
y=downsample(diffMap.yRD,2);
z=downsample(diffMap.z,2);

colormap(redblue(250)), colorbar
figure(1)
tiledlayout(3,2);
set(gcf,'position' ,[100 50 1200 700], 'color','white');

nexttile(1,[2 2]);
cb = colorbar;
label=({'L1';'L2';'L3';'L4';'L5';'L6';});
label_sample=({'S6';'S4';'S34';'S2';'S1'});
scatter3(x, y, z,5, z,'filled');hold on
    for i=1:6
        scatter3(loc_x{i},loc_y{i},ones(1,length(loc_x{i}))*10,'.k'); hold on
        textscatter3(loc_x{i}(end)+35,loc_y{i}(end),ones(1,length(loc_x{i}(end)))*10,label(i));
    end
    for j=1:5
        scatter3(sample_x{j},sample_y{j},ones(1,length(sample_x{j}))*10,'ok'); hold on
        textscatter3(sample_x{j}(end)+35,sample_y{j}(end)+70,ones(1,length(sample_x{j}(end)))*10,label_sample(j));
    end
grid off
title('Bed level change Q3,2020 - Q3, 2019');
view(2)
colorbar('eastoutside');caxis([-2,2]); 
colorbar.Label.String='Bed level change (m)';
xlabel('RD-coord x (m)')
ylabel('RD-coord y (m)')
xlim([114800 118000]);
ylim([557775 560600]);
set(gca,'fontsize',10,'FontWeight','bold');


%%
D10=sed_sample.D10;
D50=sed_sample.D50;
D90=sed_sample.D90;
n=1:5;

nexttile(5);
    scatter(n,D10,'diamond','filled');hold on
    scatter(n,D50,'diamond','filled');
    scatter(n,D90,'diamond','filled');
legend('D10','D50','D90',Location='northwest'); legend box off
xticks(n); xticklabels(label_sample);
set(gca, 'YScale', 'log','fontweight','bold');
xlabel('Sample Locations');
ylabel('Grainsize (\mum)');
title('Grainsize Distribution');
grid on

%%

T=load('bed_shear_stresses.mat');
Tcw=T.Tcw;

average_Tcw(:,1)= mean(Tcw(:,:,1),'omitnan');
average_Tcw(:,2)= mean(Tcw(:,:,2),'omitnan');
label={'L1','L2','L4','L5','L6'};

nexttile(6)
scatter((1:5),average_Tcw(:,1),'diamond','filled','SizeData',45);hold on
scatter((1:5),average_Tcw(:,2),'diamond','filled','SizeData',45);hold on
    yline(0.18,'--','\tau_{e, D = 272 \mum}',FontWeight='bold');hold on 
    yline(0.28,'--','\tau_{e, D = 557 \mum}',FontWeight='bold');
    xticks(1:5); xticklabels(label);
    set(gca, 'Xdir', 'reverse','fontweight','bold');
    xlim([0 6]);
    ylim([0 0.35]);
    legend('Medium coarse','Coarse',Location='southeast'); legend box off
title('(mean) combined bed shear stress');
ylabel({'Transect averaged';'total bed shear (N/m^2)'});
xlabel('Transects');
set(gca,'fontsize',10,'FontWeight','bold');

saveas(figure(1),[basePath 'analysis\difference_map\diff_map.fig']);
saveas(figure(1),[basePath 'analysis\difference_map\diff_map.png']);