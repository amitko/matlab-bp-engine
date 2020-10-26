function res=multiTypeRelariveFreq(Z)
% function res=multiTypeRelariveFreq(Z)
% Returns the observed relative frequences of the
% particles in the population
%
%   Input:
%       Z(1,:) - vector of parent pointers
%       Z(2,:) - generation
%       Z(3,:) - type ot particle
%       Z(4,:) - 0 : tree number
%
%   Output:
%       res    - the relative frequences
%           res(i,j) is the relative frequence
%           of the particles of type j in the i-th
%           generation

% Dimitar Atanasov, 2010
% datanasov@nbu.bg


gen = unique(Z(2,:));
types = unique(Z(3,:));

res=[];
for g = gen
    z = Z(:,find(Z(2,:) == g));
    U = size(z,1);
    for t = types
        res(g,t) = size(find(z(3,:) == t),1) / U;
    end;
end;