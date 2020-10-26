function P=test_multi_type_gen(parent_type,generation)

% If parent_type is geven the output matrix P can be 
% different for different types of particles. Alternatively
% P can be one for all type of particles (as in this example)
%
% P can be different for any generations as well.
%
% The values of parent_type and generation are
% passed from gen_multi_type_bp.

%  Dimitar Atanasov, 02.2010
%  datanasov@nbu.bg


% for test
% parent_type probability [ offspring distribution ]

%P = [
%1 0.2 1 0
%1 0.2 0 1
%1 0.4 2 0
%1 0.2 0 2
%2 0.2 1 0
%2 0.2 1 1
%2 0.3 2 0
%2 0.3 0 2
%];

P = [ 1 0.3 1 0
1 0.2 1 1
1 0.2 0 2
1 0.3 1 2
2 0.2 2 0
2 0.3 1 1
2 0.3 1 0
2 0.2 0 0
];