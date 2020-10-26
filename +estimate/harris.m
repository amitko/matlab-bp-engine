function res=Harris(Z)
% bp.estimate.harris(Z)
%   returns the Harris Estimator for the process Z
%   Z is the vector of population sizes in different
%     generations

% Dimitar Atanasov, 2020
% datanasov@nbu.bg

Z = Z(~isnan(Z));
res = sum(Z((2:end)))/sum(Z((1:end - 1)));
