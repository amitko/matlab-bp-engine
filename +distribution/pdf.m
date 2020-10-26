function res=pdf(Pk,p_h,Th_add,cell_opt)
% pdf(Pk,p_h,cell_opt)
%   returns pdf of the transforned individual distributions
%   with the normal asumption. Used in the robust parameter
%   estimation.
%
%   Pk is the theoretical probability
%   p_h is the observed probability
%   Th_add not used
%   cell_opt is cell array of parameters pased to WLTE
%        (see wlte)
%        cell_opt{1,:} are trees
%
%   Used with WLTE functions (wlte.m)

% Dimitar Atanasov, 2020
% datanasov@nbu.bg

Z = cell_opt{1,cell_opt{2,1}};

P = bp.tools.countPopulation(Z);
ft = sum(P(1:length(P)-1));

st_n = p_h - Pk;
st_d = (1-Pk).*Pk;
res = (ft * (st_n.^2 / st_d ))/2;