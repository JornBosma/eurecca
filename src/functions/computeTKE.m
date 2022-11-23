% Fuction that computes the mean turbulence kinetic energy (TKE) from
% 3D timeseries of flow velocity

% by Jorn Bosma, Nov 2022

function k = computeTKE(U, V, W)

% INPUT:
%   U   velocity in X-direction
%   V   velocity in Y-direction
%   W   velocity in Z-direction

% INPUT:
%   k (or TKE)   turbulence kinetic energy [J/kg] = [m^2/s^2]

U_prime = zeros(length(U), 1);   
V_prime = U_prime; W_prime = U_prime;

U_bar = mean(U, 'omitnan');
V_bar = mean(V, 'omitnan');
W_bar = mean(W, 'omitnan');

% U_var = zeros(width(U), 1);
% V_var = U_var; W_var = U_var;

for j = 1:width(U)

    for k = 1:length(U)

        U_prime(k, j)= U(k, j)-U_bar(j); % fluctuation of velocity in X
        V_prime(k, j)= V(k, j)-V_bar(j); % fluctuation of velocity in Y
        W_prime(k, j)= W(k, j)-W_bar(j); % fluctuation of velocity in Z

    end

%     U_var(j) = sum((U_prime(:, j).^2), 'omitnan')/length(U);
%     V_var(j) = sum((V_prime(:, j).^2), 'omitnan')/length(V);
%     W_var(j) = sum((W_prime(:, j).^2), 'omitnan')/length(W);

end

U_var2 = rms(U_prime, 'omitnan').^2;
V_var2 = rms(V_prime, 'omitnan').^2;
W_var2 = rms(W_prime, 'omitnan').^2;

k = .5*(U_var2 + V_var2 + W_var2);