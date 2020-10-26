function res=CrumpHove(Z,N)
% bp.estimate.CrumpHove(Z)
%   returns the Crump-Hove Estimator for the process Z
%   Z is the vector of population sizes in different
%     generations

% Dimitar Atanasov, 2020
% datanasov@nbu.bg

Z = Z(~isnan(Z));

n = length(Z);

if nargin < 3
    N = 5;
end

if n < N+1
    res = NaN;
    return;
end

res = bp.estimate.Harris(Z(n-N:n));
