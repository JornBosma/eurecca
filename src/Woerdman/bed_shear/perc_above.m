function perc_above= perc_above(T);
Te_10=[0.18 0.25];
Te_50=[0.28 0.79];
Te_90=[1.22 3.42];

for j=1:2
    for i=1:5
        id1 =find(T(:,i,j)>Te_10(j));
        id2 =find(T(:,i,j)>Te_50(j));
        id3 =find(T(:,i,j)>Te_90(j));
        idnan= find( isnan(T(:,i)));
    
        perc_above.D10(i,j)= length(id1) / ((length(T)-length(idnan))) *100;
        perc_above.D50(i,j)= (length(id2) / (length(T)-length(idnan))) *100;
        perc_above.D90(i,j)= (length(id3) / (length(T)-length(idnan))) *100;
    end
end
