function res=extractSubTree(Z, anc)
% extractSubTree(Z, anc)
%   returns the sub tree of Z with ancestor anc
%
%   The process Z is generated by bp.generate.process
%   Z(1,:) - vector of parent pointers
%   Z(2,:) - generation
%   Z(3,:) - type ot particle (1 - live, 2 - dead, 3 - immigrant)

% Dimitar Atanasov, 2020
% datanasov@nbu.bg

res = Z(:,anc);

%first generation
off = find(Z(1,:) == anc);

if ~isempty(off)
    t = Z(:,off);
    t(1,:) = 1;
    res = [res t];
end;

c = size(res,2);
while ~isempty(off)
    off2=[];
    for o = off
        off1 = find(Z(1,:) == o);
        if ~isempty(off1)
            t = Z(:,off1);
            t(1,:) = c;
            res = [res t];
            off2=[off2 off1];
        end;
        c = c + 1;
    end;
    off = off2;
end;

res(2,:) = res(2,:) - Z(2,anc);