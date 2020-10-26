function res = Harris_ci(Z,cl,m,s)

% Funcion bp.estimate.Harris_ci(Z,cl,m,s)
% returns the confidence interval of the 
% harris estimator m with variance s^2 for 
% the process Z with confidence level cl 

% Dimitar Atanasov, 2010
% datanasov@nbu.bg

if nargin < 2
    cl = 0.95;
end

if nargin < 3
    m = bp.estimate.Harris(Z);
end

if nargin < 4
    s = sqrt(bp.estimate.variance_wls(Z,m));
end

Z = Z(~isnan(Z));

C = icdf('norm',(1+cl)/2,0,1);
res = [m-C*s/sqrt(sum(Z(1:end-1))) m+C*s/sqrt(sum(Z(1:end-1)))];
