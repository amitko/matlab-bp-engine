function res=multiType(n,t,Dist,Immigr,Life)
% Function Z = multiType(n,t,Dist,Immigr,Life) returns
%   the vector of parent pointers and the generation level for a
%   BGW process with more than one trees with same theoretical
%   distribution.
%
%   INPUT:
%   n - generations
%   t - number of trees
%
%   Dist - Structure of Distribution and parameters
%   Dist.dist - distribution
%   Dist.par1 - parameter1
%   Dist.par2 - parameter2
%   Dist.par3 - parameter3
%
%   If Dist.dist = 'custom' an custom distribution has to be
%       provided.
%       Dist.values are independently chosen entries
%       Dist.probabilities are corresponding probabilities
%
%   Immigr - the structure of immigration parameters
%   Immigr.dist - Immigration distribution
%   Immigr.par1 - Immigration parameter
%   Immigr.par2 - Immigration parameter
%   Immigr.par3 - Immigration parameter
%
%   If Immigr.dist = 'custom' an custom distribution has to be
%       provided.
%       Immigr.values are independently chosen entries
%       Immigr.probabilities are corresponding probabilities
%
%   Life.dist - distribution of lifespan
%   Life.par1 - parameter1
%   Life.par2 - parameter2
%   Life.par3 - parameter3
%
%   OUTPUT:
%   Z(1,:) - vector of parent pointers
%   Z(2,:) - generation
%   Z(3,:) - type ot particle (1 - live, 2 - dead, 3-immigrant)
%   Z(4,:) - tree number
%   Z(5,:) - Lifespan of particle if Life exists

%  Dimitar Atanasov, 2020
%  datanasov@nbu.bg

if t == 1
    warning('There is only one tree. Better use gen_bp or gen_bp_immigr!!!');
end;

res  = [];
h = waitbar(0,'Please wait...');

if nargin == 3
    Life = [];
    Immigr = [];
elseif nargin == 4
    Life = [];
end;

for T = 1:t
    if ~isstruct(Immigr)
        Z = bp.generate.process(n,Dist,Life);
    else
        Z = bp.generate.immigration(n,Dist,Immigr,Life);
    end;

    waitbar(T/t);

    Z(4,:) = ones(1,size(Z,2))*T;

    res = [res Z];
end;
close(h) ;

