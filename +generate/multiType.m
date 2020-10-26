function Z=multiType(n,initial_state,dist_function)
% Function Z=multiType(n,initial_state,dist_function) 
% returns vector of parent pointers for the multy type
% branching process
%
%   INPUTS:
%   n             - generations
%   initial_state - initial distribution of types
%   dist_function - this functions should return a matrix
%         of distribution of the offsprinngs
%       P = dist_function( parent_type, generation)
%           where parent_type is type of the parent particle
%           generation shoud be set in nonhomogenious case
%       P(:,1) is the parent type
%       P(:,2) is the probability a parent type particle P(:,1)
%       to have P(:,3:end) distributed offsprings.
%       For example P(1,:) = [1 0.3 0 2 1] means that particle
%       of type 1 have 0 child from type 1, 2 child from type 2
%       and 1 chals from type 3 with probability 0.3.
%       (see test_multi_type_gen for example) 
%
%   OUTPUT:
%   Z(1,:) - vector of parent pointers
%   Z(2,:) - generation
%   Z(3,:) - type ot particle
%   Z(4,:) - 0 : tree number

%  Dimitar Atanasov, 2020
%  datanasov@nbu.bg

parent = 0;
gen = 1;

k = size(initial_state,2);

for q=1:k
    for g=1:initial_state(1,q)
        parent = parent + 1;
        Z(1,parent) = 0;
        Z(2,parent) = gen;
        Z(3,parent) = q;
        Z(4,parent) = parent;
    end
end

parent = 1;
end_gen = 1;

while (gen < n+1) && (size(Z,2) <= 5000)
    gen = gen + 1;
    
    while parent <= end_gen
    
        P = feval(dist_function,Z(3,parent),gen);
        R = prepare_probabilities(P,Z(3,parent));
        
        offs = randsrc(1,1,[R.index; R.prob]);
        off_dist = P(offs,3:end);
        
        for q = 1:k
            for g=1:off_dist(1,q)
                T(1,1) = parent;
                T(2,1) = gen;
                T(3,1) = q;
                T(4,1) = Z(4,parent);
                Z = [Z T];
            end
        end
        
        parent = parent + 1;    
    end
    end_gen=size(Z,2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function R=prepare_probabilities(T,parent_type)

R.index = find(T(:,1) == parent_type)';
R.dist  = T(find(T(:,1) == parent_type ),3:end);
R.prob  = T(find(T(:,1) == parent_type ),2)';
if sum(R.prob) ~= 1 
    error(['Probabilities for type ' num2str(parent_type) ' not sums to 1']);
end
