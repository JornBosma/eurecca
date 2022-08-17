function profile = profile_finder(daynumber)
% this function will read the string in the first table column looking for
% profile name (e.g. L1 00001 ...). After which structures will be created
% for each profile location. Saved per day per profile location


TF_L1 = startsWith(daynumber.(1),'L1'); % Find the data for the cross section
count_TF_L1= sum(TF_L1);
if count_TF_L1 > 0
A1 = find(TF_L1==1);
idx1_b = A1(1); % First data point 
idx1_e = A1(end); % Last data point
L1x= daynumber(idx1_b:idx1_e,[4:6]); % Create arrays for the x,y,z of the cross section
L1 = table2array(L1x);
else L1(:,1:3)= NaN;
end 

TF_L2 = startsWith(daynumber.(1),'L2'); % Find the data for the cross section
count_TF_L2= sum(TF_L2);
if count_TF_L2 > 0
A2 = find(TF_L2==1);
idx2_b = A2(1); % First data point 
idx2_e = A2(end); % Last data point
L2x = daynumber(idx2_b:idx2_e,[4:6]); % Create arrays for the x,y,z of the cross section
L2 = table2array(L2x);
else L2(:,1:3)= NaN;
end

TF_L3 = startsWith(daynumber.(1),'L3'); % Find the data for the cross section
count_TF_L3= sum(TF_L3);
if count_TF_L3 > 0
A3 = find(TF_L3==1);
idx3_b = A3(1); % First data point 
idx3_e = A3(end); % Last data point
L3x = daynumber(idx3_b:idx3_e,[4:6]); % Create arrays for the x,y,z of the cross section
L3 = table2array(L3x);
else L3(:,1:3)= NaN;
end

TF_L4 = startsWith(daynumber.(1),'L4'); % Find the data for the cross section
count_TF_L4= sum(TF_L4);
if count_TF_L4 > 0
A4 = find(TF_L4==1);
idx4_b = A4(1); % First data point 
idx4_e = A4(end); % Last data point
L4x = daynumber(idx4_b:idx4_e,[4:6]); % Create arrays for the x,y,z of the cross section
L4 = table2array(L4x);
else L4(:,1:3)= NaN;
end

TF_L5 = startsWith(daynumber.(1),'L5'); % Find the data for the cross section
count_TF_L5= sum(TF_L5);
if count_TF_L5 > 0
A5 = find(TF_L5==1);
idx5_b = A5(1); % First data point 
idx5_e = A5(end); % Last data point
L5x = daynumber(idx5_b:idx5_e,[4:6]); % Create arrays for the x,y,z of the cross section
L5 = table2array(L5x);
else L5(:,1:3)= NaN;
end

TF_L6 = startsWith(daynumber.(1),'L6'); % Find the data for the cross section
count_TF_L6= sum(TF_L6);
if count_TF_L6 > 0
A6 = find(TF_L6==1);
idx6_b = A6(1); % First data point 
idx6_e = A6(end); % Last data point
L6x = daynumber(idx6_b:idx6_e,[4:6]); % Create arrays for the x,y,z of the cross section
L6 = table2array(L6x);
else L6(:,1:3)= NaN;
end

profile = struct('L1',L1,'L2',L2,'L3',L3,'L4',L4,'L5',L5,'L6',L6);