function Z = immigration(n,Dist,Immigr,Life)
% Function Z = immigration(n,Dist,Immigr,Life) returns
%   the vector of parent pointers and the generation level for a
%   BGW process with immigration.
%
%   INPUT:
%   n - generations
%
%
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
%   Z(3,:) - type ot particle (1 - live, 2 - dead,3 - immigrant)
%   Z(5,:) - Lifespan of particle if Life exists

%  Dimitar Atanasov, 2020
%  datanasov@nbu.bg

if nargin ~= 4
  Life = [];
end;

Z=[];
for gen=1:n

    Im = 0;
    Z_t = [];

    if ~strcmp(Immigr.dist,'custom') % standard distribution
Immigr
        if isfield(Immigr,'par1') & ~isfield(Immigr,'par2') & ~isfield(Immigr,'par3')
            Im = random(Immigr.dist,Immigr.par1,1,1);
        elseif isfield(Immigr,'par1') & isfield(Immigr,'par2') & ~isfield(Immigr,'par3')
            Im = random(Immigr.dist,Immigr.par1,Immigr.par2,1,1);
        elseif isfield(Immigr,'par1') & isfield(Immigr,'par2') & isfield(Immigr,'par3')
            Im = random(Immigr.dist,Immigr.par1,Immigr.par2,Immigr.par3,1,1);
        else
            error('Wrong number of Immigration parameters!!!');
        end;

    else %custom distribution
         if ~isfield(Immigr,'values') | ~isfield(Immigr,'probabilities') | sum(Immigr.probabilities) ~= 1
             error('Wrong custom immigration distribution');
         end;
         Im = randsrc(1,1,[Immigr.values Immigr.probabilities]);
     end;

    if Im > 0
    for k=1:Im

            Z_t = gen_bp(n - gen,Dist,Life);

        popul_size = size(Z,2);
        Z_t(1,:) = Z_t(1,:) + popul_size;
        Z_t(2,:) = Z_t(2,:) + gen - 1;
        Z_t(3,1) = 3; %Immigrant
        Z_t(1,1) = 0; %Ancestor

        Z=[Z Z_t];
    end;
    end;
end;