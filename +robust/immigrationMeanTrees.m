function [res,st_err,w]=immigrationMeanTrees(L,k_tr,n,t,m,s,b)
% immigrationMeanTrees(L,k_tr,n,t,m,s,b)
%   returns the robust estimator \lambda_t(n)of the immigration mean
%   for the process Z with more tahn one tree  based on the assymptotic \
%   properties of Dion & Yanevs estimator.
%
%   The output is
%   res - the estimated value
%   st_err - the standard error of the estimator
%   w - the calculated weights
%
%   L - vector of estimates calculated by
%       bp_immigr_dy_est for all the trees
%
%   k_tr - the trimming factor of the WLTE (0,1)
%   t,n - vectors of paremeters of the
%       for any value of immigration estimate L
%   m - the offspting mean
%   s - the offspring variance
%   b - the immigration variance


% Dimitar Atanasov, 2020
% datanasov@nbu.bg

if size(L,1) > 1 | size(n,1) > 1 | size(t,1) > 1
    error('Wrong input parameters');
end;

x=[];
C={};
for k = 1:length(L)
        x(k) = L(k);
        C{1,k}.l = L(k);
        C{1,k}.n = n(k);
        C{1,k}.t = t(k);
end;

l_0 = mean(x);

[res,st_err,w] = wlte(round(k_tr*length(x)),...
                      x,...
                      min(x),max(x),l_0,...
                      'dy_est_den',[m s b],...
                      'ones',...
                      1e-4,...
                      C...
                  );

