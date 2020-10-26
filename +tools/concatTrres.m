function res = concatTrres(Z1,Z2)
% Function concatTrres(Z1,Z2)
% concatenates two sample paths Z1 and Z2

% Dimitar Atanasov, 2020
% datanasov@nbu.bg

if ~isempty(Z1)
    last_tree = max(Z1(4,:));
    offset = size(Z1,2);
else
    last_tree = 0;
    offset = 0;
end;
if ~isempty(Z2)
    Z2(1,find(Z2(1,:) > 0)) = Z2(1, find(Z2(1,:) > 0)) + offset;
    Z2(4,:) = Z2(4,:) + last_tree;
end;
res = [Z1 Z2];

