function res = immigrationDummy(Z)
% function res = immigrationDummy(Z)
%
%   Returns dummy estimator of the immigrantion variance
%
%

% Dimitar Atanasov, 2020
% datanasov@nbu.bg

[l,q]=bp.estimate.immigration(Z(1:3,:));

x = 0:(length(q) - 1);

res = sum(((x - l).^2).*q);
