function [res,st_err,w]=immigrationMean(l,k_tr,m,s,b)
% immigrationMean(Z,k_tr,m,s,b)
%   returns the robust estimator \lambda_t(n)of the immigration mean
%   for the process Z based on the assymptotic properties
%   of Dion & Yanevs estimator.
%
%   The output is
%   res - the estimated value
%   st_err - the standard error of the estimator
%   w - the calculated weights
%
%
%   l is the matrix for Dion-Yanev estimators given by  bp_immigr_dy_est
%   k_tr - the trimming factor of the WLTE (0,1)
%   m - the offspting mean
%   s - the offspring variance
%   b - the immigration variance
%
%   uses wlte.m

% Dimitar Atanasov, 2010
% datanasov@nbu.bg

[N,T] = size(l);
x=[];
C={};
k = 1;
for n = 1:N
    for t = 1:T
        if l(n,t) > 0
            x(k) = l(n,t);
            C{1,k}.l = l(n,t);
            C{1,k}.n = n;
            C{1,k}.t = t;
            k = k + 1;
        end;
    end;
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

