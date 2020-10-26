function Z = process(n,Dist,Life)
% Function Z = process(n,Dist,Life) returns
%   the vector of parent pointers and the generation level for a
%   BGW process.
%
%   INPUT:
%   n - generations
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
%   Life.dist - distribution of lifespan
%   Life.par1 - parameter1
%   Life.par2 - parameter2
%   Life.par3 - parameter3
%
%   OUTPUT:
%   Z(1,:) - vector of parent pointers
%   Z(2,:) - generation
%   Z(3,:) - type ot particle (1 - live, 2 - dead)
%   Z(5,:) - Lifespan of particle if Life exists

%  Dimitar Atanasov, 2020
%  datanasov@nbu.bg

parent = 1;
gen = 1;
%ind = 1;
if nargin ~= 3
  Life = [];
end;

Z(1,parent) = 0;
Z(2,parent) = gen;
Z(3,parent) = 1;
Z(4,parent) = 0;
Z(5,parent) = lifespan(Life,1);

end_gen = 1;
dead = 0;

while (gen < n+1) & (size(Z,2) <= 5000)
gen = gen + 1;

dist = Dist.dist;
    while parent <= end_gen

    % calculating the number of offsprings
        if Z(3,parent)~= 2 %if is alive

         if ~strcmp(dist,'custom') % standard distribution

             if isfield(Dist,'par1') & ~isfield(Dist,'par2') & ~isfield(Dist,'par3')
                 offspr = random(dist,Dist.par1,1,1);
             elseif isfield(Dist,'par1') & isfield(Dist,'par2') & ~isfield(Dist,'par3')
                 offspr = random(dist,Dist.par1,Dist.par2,1,1);
             elseif isfield(Dist,'par1') & isfield(Dist,'par2') & isfield(Dist,'par3')
                 offspr = random(dist,Dist.par1,Dist.par2,Dist.par3,1,1);
             else
                 error('Wrong stucture of parameters disribution');
             end; %if

         else %custom distribution
             if ~isfield(Dist,'values') | ~isfield(Dist,'probabilities') | sum(Dist.probabilities) ~= 1
                 error('Wrong custom distribution');
             end;
             offspr = randsrc(1,1,[Dist.values; Dist.probabilities]);
         end;

        if offspr > 0
            lifesp = zeros(offspr,1);
        else
            lifesp = 0;
        end;

        if isstruct(Life) & offspr > 0% Random lifespan
          lifesp = lifespan(Life,offspr);
        end;

         if offspr > 0
            Z_add = [ones(offspr,1)*parent ones(offspr,1)*gen ones(offspr,1) zeros(offspr,1) lifesp + Z(5,parent)]';
            dead = 0;
        else
            Z_add = [ones(1,1)*parent ones(1,1)*gen 2 0 Z(5,parent)]';
            dead = 1;
        end;


            Z = [Z Z_add];
        end; %end alive

        parent = parent + 1;

    end %while parent

    end_gen = size(Z,2);
end; %while gen

%------------------------------

function R=lifespan(Life,offspr)
  if isstruct(Life)
    if isfield(Life,'par1') & ~isfield(Life,'par2') & ~isfield(Life,'par3')
        R = random(Life.dist,Life.par1,offspr,1);
    elseif isfield(Life,'par1') & isfield(Life,'par2') & ~isfield(Life,'par3')
        R = random(Life.dist,Life.par1,Life.par2,offspr,1);
    elseif isfield(Life,'par1') & isfield(Life,'par2') & isfield(Life,'par3')
        R = random(Life.dist,Life.par1,Life.par2,Life.par3,offspr,1);
    else
        error ('Wrong Lifespan parameters!!!');
    end; %if

  else
    R = zeros(offspr,1);
  end;
