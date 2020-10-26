function res=variance_wls(Z,m)
% bp.estimate.harris(Z)
%   returns the Harris Estimator for the process Z
%   Z is the vector of population sizes in different
%     generations

% Dimitar Atanasov, 2010
% datanasov@nbu.bg

if nargin < 2
    m = bp.estimate.harris(Z);
end

    
Z = Z(~isnan(Z) & Z > 0);

Z1 = Z(1:end-1);
Z2 = Z(2:end);
res = mean(Z1.*(Z2 ./ Z1 - m).^2);
