function range_perc_above= perc_above_condition(T,range);
Te_10=[0.18 0.25];
Te_50=[0.28 0.79];
Te_90=[1.22 3.42];

range_perc_above.avg=mean(T(range,:,:),'omitnan');
range_perc_above.std=std(T(range,:,:),'omitnan');
range_perc_above.max=max(T(range,:,:));

for j=1:2
    for i=1:5
        id1 =find(T(range,i,j)>Te_10(j));
        id2 =find(T(range,i,j)>Te_50(j));
        id3 =find(T(range,i,j)>Te_90(j));
        idnan= find( isnan(T(range,i)));
    
        range_perc_above.D10(i,j)= length(id1) / ((length(range)-length(idnan))) *100;
        range_perc_above.D50(i,j)= (length(id2) / (length(range)-length(idnan))) *100;
        range_perc_above.D90(i,j)= (length(id3) / (length(range)-length(idnan))) *100;
    end
end
