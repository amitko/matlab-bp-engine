function res=bp_ln_est(Z)
% bp_ln_est(Z)
%   returns the Lotka-Nagaev Estimator for the process Z
%
%    The process Z is generated by gen_bp
%   Z(1,:) - vector of parent pointers
%   Z(2,:) - generation
%   Z(3,:) - type ot particle (1 - live, 2 - dead)


% Dimitar Atanasov, 2010
% datanasov@nbu.bg

T = bp.tools.countPopulation(Z);

res = bp.estimate.LotkaNagaev(T);