function res=HarrisEst(Z)
% HarrisEst(Z)
%   returns the Harris Estimator for the process Z
%
%    The process Z is generated by bp.benerate.process
%   Z(1,:) - vector of parent pointers
%   Z(2,:) - generation
%   Z(3,:) - type ot particle (1 - live, 2 - dead)


% Dimitar Atanasov, 2020
% datanasov@nbu.bg

[m,n] = size(Z);
Z
if m >= 4
    kt = distinct(Z(4,:));
else
    kt = 1;
    Z(4,:) = ones(1,size(Z,2));
end;

res = [];
for k = kt
    Zt = Z(:,find(Z(4,:) == k));
    T = bp.tools.countChilds(Zt);
    res = [res bp.estimate.Harris(T) ];
end;