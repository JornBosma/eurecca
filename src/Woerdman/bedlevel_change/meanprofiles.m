function [profile_z,profile_mean,profile_std,xaxis] = meanprofiles(profile);
% computes: - interpolated profiles
%           - Mean profile
%           - Standard deviation at each interpolated location
%           - x axis

% Made by Martijn klein Obbink      25-01-2022
n_profiles = size(profile);
minx = min(min(profile(:,1,:)));
maxx = max(max(profile(:,1,:)));

xaxis = [minx:0.1:maxx];
profile_z = NaN((length(xaxis)),(n_profiles(1,3)));

for i = 1:n_profiles(1,3)
profileX = profile(:,1,i);
profileZ = profile(:,2,i);
if length(profileX) == sum(isnan(profileX))
    continue
else

profileX2 = profileX(~isnan(profileX));
profileZ2 = profileZ(~isnan(profileZ));

profile_z(:,i) = interp1(profileX2,profileZ2,xaxis);

end 
end
profile_mean = mean(profile_z,2,'omitnan'); 
profile_std = std(profile_z,0,2,'omitnan');


