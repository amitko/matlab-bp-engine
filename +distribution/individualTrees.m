function res=individualTrees(Z)
% individualTrees(Z)
%   returns the individual distribution estimator
%   for the process Z for more than one tree.
%
%    The process Z is generated by bp.generate.process
%   Z(1,:) - vector of parent pointers
%   Z(2,:) - generation
%   Z(3,:) - type ot particle (1 - live, 2 - dead)
%   Z(4,:) - tree number



% Dimitar Atanasov, 2010
% datanasov@nbu.bg

if size(Z,1) < 4
    error('Wrong size of the input parameter Z. Try individual!!!');
end;

Tr = distinct(Z(4,:));
if length(Tr) == 1
    warning('There is only one tree. Better use individual!!!');
end;

Ch = [];
for t = Tr
    ch = bp.tools.countChilds(Z(1:3,find(Z(4,:) == t)));
    Ch(t,1:length(ch)) = ch;
    T = bp.tools.countPopulation(Z(1:3,find(Z(4,:) == t)));
    S_den(t) = sum(T([1:length(T) - 1]));
end;

res = sum(Ch)./sum(S_den);