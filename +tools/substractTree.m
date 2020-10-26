function res = substractTree(Z,n)
% Function substractTree(Z,n)
% substracts a sub-tree form the process Z
% having munber n

% Dimiar Atanasov, 2020
% datanasov@nbu.bg

I = find(Z(4,:) == n);

k=1;
res = [];
Parents = [];
Parents = sparse(Parents);
for l = I
    res(:,k) = Z(:,l);
    if l > 0
        Parents(l) = k;
    end;
    if Z(1,l) > 0
        res(1,k) = Parents(Z(1,l));
    else
        res(1,k) = 0;
    end;
    k = k + 1;
end;