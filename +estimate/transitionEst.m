function res=transitionEst(Z, h, ct)
% Function res=transitionEst(Z, h, ct )
%   Returns a estimation of an transaction probabilities
%   for a stochastic multi type branching processes Z.
%   By default the process is considered as non-
%   homegenious one. If the Process is homogenious set
%   h = 1.
% 
%   Input:
%       Z(1,:) - vector of parent pointers
%       Z(2,:) - generation
%       Z(3,:) - type ot particle
%       Z(4,:) - 0 : tree number
%
%       h      - Homogenious indicator - default 1
%       
%       ct      - if c=1 counts instead of probabilities 
%                are reported.
%
%   Output:
%   In homogenious case
%       res - matrix
%           res(:,1) is the type ot the particle
%           res(:,2) is the probability (or count)
%           a particle res(:,1) to have offspring
%           distribution res(:,3:end).
%       For example:
%               1.0000    0.1789         0    1.0000
%               2.0000    0.2222    1.0000         0
%           means that particle of type 1 with probability
%           0.1789 have 0 offsprings of type 1 and 1 offspring 
%           of type 2; particle of type 2 with probability 0.2222
%           have 1 child of type 1 and zero of type 2.
%
%   In nonhomogenious case
%       The same as in homogenious case, except that second column
%       gives the generation (all other are shifted right).
%       For example:
%           1.0000    4.0000    0.2857    1.0000         0
%           2.0000    5.0000    0.2667    1.0000         0
%           means that particle of type 1 in the 4-th generation 
%           with probability 0.2857 have 1 child of type 1 and
%           no child of type 2; particle of type 2 in the 5-th 
%           generation have 1 child of type 1 and zero child 
%           of type 2 with probability 0.2667. 

% Dimitar Atanasov, 02.2020
% datanasov@nbu.bg

if nargin == 1
    h = 1;
    ct = 0;
elseif nargin == 2
    ct = 0;
end;
    
k = size(unique(Z(3,:)),2);
trees = unique(Z(4,:));
gen = unique(Z(2,:));

cnt = 1;

res = [];
% for each tree
for tree = trees
    gen = sort ( unique(Z(2,find( Z(4,:) == tree))) );
    for g = [0 gen(1:end-1)]
        
        I = find( Z(2,:) == g & Z(4,:) == tree );
        
        
        for r = I
            C = Z(:, find( Z(1,:) == r ) );
            
            R = zeros(1,k);
            
            for c=C
                R( c(3,1) ) = R( c(3,1) ) + 1;
            end;
            
            if h == 1 %homogenious case
                if isempty(res)
                    res = [1 0 R];
                end;
                fl = 0;
                for rw = 1:size(res,1)
                    if isequal(res(rw,[1 3:end]),[Z(3,r) R])
                        fl = rw;
                    end;
                end;
                if fl > 0
                   res(fl,2) = res(fl,2) + 1;
                else
                   res = [res' [Z(3,r) 1 R]']';
                end;
             elseif  h ==0 % non homogenious case
                if isempty(res)
                    res = [1 g 0 R];
                end;
                fl = 0;
                for rw = 1:size(res,1)
                    if isequal(res(rw,[1 2 4:end]),[Z(3,r) g R])
                        fl = rw;
                    end;
                end;
                if fl > 0
                   res(fl,3) = res(fl,3) + 1;
                else
                   res = [res' [Z(3,r) g 1 R]']';
                end;

            end; 
        end;
    end;
end;

% Compute probabilities
if ct == 1
    return;
end;

types = unique(res(:,1)');
if h == 1 % HOMOGENIOUS CASE
    for t = types
        I = find(res(:,1) == t);
        res(I,2) = res(I,2)./sum(res(I,2));
    end;
elseif h == 0
    for t = types
        I = find(res(:,1) == t);
        gens = unique(res(I,2)');
        for g = gens
            Ig = find(res(:,1) == t & res(:,2) == g);
            res(Ig,3) = res(Ig,3)./sum(res(Ig,3));
        end;
    end;
end;    

