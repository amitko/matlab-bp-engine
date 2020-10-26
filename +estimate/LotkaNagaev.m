function res=LotkaNagaev(Z,n)
% bp.estimate.LotkaNagaev(Z)
%   returns the Lotka-Nagaev Estimator for the process Z
%   Z is the vector of population sizes in different
%     generations

% Dimitar Atanasov, 2020
% datanasov@nbu.bg

Z = Z(~isnan(Z));

if nargin < 2
    n = length(Z);
end

if isempty(Z) || length(Z) < 2
    res = NaN;
    return;
end

res = Z(n)/Z(n-1);
