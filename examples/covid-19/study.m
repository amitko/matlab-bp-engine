%% Load data
Data = readtable('data/byDate.csv');


%% For United_States_of_America

fld = 'United_States_of_America';

backwardPeriod = 30;
forecast = 5;


Y2 = table2array(Data(:,fld)); 

infection_day = min(find(Y2>0));

DAYS = infection_day:size(Y2,1);

Y2 = Y2(infection_day:end);

mHk = [];
mLk = [];
for k = 1:size(Y2,1)-1
    mHk(k) = bp.estimate.harris(Y2(1:k+1));
    mLk(k) = bp.estimate.LotkaNagaev(Y2(1:k+1));
end

%% Y

yyaxis left
plot(DAYS,Y2,'ko-','LineWidth',1.2);
ylabel('Daily observed cases','Color',[0.15 0.15 0.15])
set(gca,'YColor','k')

yyaxis right
plot(DAYS,cumsum(Y2,'omitnan'),'k*-','LineWidth',1.2);
legend({'Daily observed cases', 'Observed cases total'},'Location','NorthWest')
ylabel('Observed cases total','Color',[0.15 0.15 0.15])

set(gca,'YColor','k')
xlabel('Days after the start of the infection','Color',[0.15 0.15 0.15]);
set(gca,'XColor','k')
saveas(gcf,['Y2_Y2c_' fld '.jpg'],'jpg');
close(gcf);


%% m and alpha

t = 1:backwardPeriod;
m0 = Y2(end-backwardPeriod);

mH = mHk(end-backwardPeriod+1:end);


tt = t;
M1 = m0.*(mH.^(tt));

alpha = Y2(end-backwardPeriod+1:end)./(M1(1:end) + Y2(end-backwardPeriod+1:end)')';

figure()

yyaxis left
plot(DAYS(end-backwardPeriod+1:end),mHk(end-backwardPeriod+1:end),'ko-','LineWidth',1.2)
ylabel('Harris estimator $m$','Color',[0.15 0.15 0.15],'Interpreter','latex')
set(gca,'YColor','k')

yyaxis right
plot(DAYS(end-backwardPeriod+1:end),alpha(end-backwardPeriod+1:end),'k*-');
ylabel('$\alpha$','Color',[0.15 0.15 0.15],'Interpreter','latex');
set(gca,'YColor','k');

l1 = legend({'proportion $\alpha (n)$ of the registered infected individuals', 'mean value $m$ of the infected individuals'},'Location','NorthWest');
set(l1,'Interpreter','latex')
xlabel('Days after the start of the infection');
legend
saveas(gcf,['m_alpha_' fld '.jpg'],'jpg');


%% M1 and A1


tt = t;
M1 = m0.*(mH.^(tt));
%A1 = m0*mH.*(mH.^(t) - 1)./ (mH - 1);
if mH > 1
    A1 = M1(1).*mH.^(tt) + (mH.*(mH.^tt))/(mH - 1);
else
    A1 = M1(1).*mH.^(tt)
end

ciH = bp.estimate.harris_ci(Y2,0.95,mH);

yyaxis left
plot(DAYS(end-backwardPeriod+1:end),M1,'k*-',DAYS(end-backwardPeriod+1:end),A1,'ko-')
set(gca,'YColor','k')
ylabel('Expected number of unobserved cases $M_1(n)$ and $A_1(n)$','Interpreter','latex')

yyaxis right
plot(DAYS(end-backwardPeriod+1:end),mHk(end-backwardPeriod+1:end),'k.--','LineWidth',1.2)
set(gca,'YColor','k')
ylabel('Harris estimator of the growth rate $\tilde m_n$','Interpreter','latex')

legend({'without immigration $M_1(n)$','with immigration $A_1(n)$','growth rate $\tilde m_n$'},'Location','NorthWest','Interpreter','latex')
xlabel('Days after the start of the infection','Color',[0.15 0.15 0.15]);


saveas(gcf,['A1_M1_m_' fld '.jpg'],'jpg');

Result = table({'---'}, [0], [0] ,[0], [0], [0],[0], [0],'VariableNames',{'Country','k','m','ci_l','ci_u', 'alpha' ,'M1','A1'});


    for k = 5:-1:1
        rr = size(Result,1);
        Result(rr+1,'Country') = {fld};
        Result(rr+1,'k') = num2cell(k-1);
        Result(rr+1,'m') = num2cell(mH(end-k+1));
        ciH = bp.estimate.harris_ci(Y2(1:end-k-1),0.95,mH(end-k+1));
        Result(rr+1,'ci_l') = num2cell(ciH(1));
        Result(rr+1,'ci_u') = num2cell(ciH(2));        
        Result(rr+1,'A1') = num2cell(round(A1(end-k-1)));        
        Result(rr+1,'M1') = num2cell(round(M1(end-k-1)));        
        Result(rr+1,'alpha') = num2cell(alpha(end-k-1));        
    end

 table2latex(Result,['table1-' fld '.tex'])


%% Forecast

mHH = mH(end)
ciH = bp.estimate.harris_ci(Y2,0.95,mHH)

M1_forecast = M1(end)*(mHH .^ ([1:forecast] ));
M1_forecast_l = M1(end)*(ciH(1) .^ [1:forecast]);
M1_forecast_u = M1(end)*(ciH(2) .^ [1:forecast]);

A1_forecast = M1(end) .* mHH .* ((mHH .^ ([1:forecast] ) - 1) ./ (mHH - 1))
A1_forecast_l = M1(end) .* ciH(1) .* ((ciH(1) .^ ([1:forecast] ) - 1) ./ (ciH(1) - 1))
A1_forecast_u = M1(end) .* ciH(2) .* ((ciH(2) .^ ([1:forecast] ) - 1) ./ (ciH(2) - 1))



BR = table( [1:5]', M1_forecast', M1_forecast_l', M1_forecast_u', A1_forecast', A1_forecast_l', A1_forecast_u')

table2latex(BR,['table2-forecast_' fld '.tex'])

%% For Number of countries

Flds = { 'Italy', 'France', 'Spain','Germany', 'Bulgaria', }

Result = table({'---'}, [0] , [0], [0], [0], [0],[0],'VariableNames',{'Country','m','ci_l','ci_u', 'alpha' ,'M1','A1'});

for f = Flds
    fld = f{1};    
    %fld = 'Spain'
    %fld = 'Italy';
    backwardPeriod = 30;
    forecast = 5;

    Y2 = table2array(Data(:,fld)); 

    infection_day = min(find(Y2>0));

    DAYS = infection_day:size(Y2,1);

    Y2 = Y2(infection_day:end);

    mHk = [];
    for k = 1:size(Y2,1)-1
        mHk(k) = bp.estimate.harris(Y2(1:k+1));
    end


    t = 1:backwardPeriod;
    m0 = Y2(end-backwardPeriod);

    %mH = movsum(mHk,[3 0])./3;
    mH = mHk(end-backwardPeriod+1:end);


    tt = t;
    M1 = m0.*(mH.^(tt));
    %A1 = m0*mH.*(mH.^(t) - 1)./ (mH - 1);
    if mH > 1
        A1 = M1(1).*mH.^(tt) + (mH.*(mH.^tt))/(mH - 1);
    else
        A1 = M1(1).*mH.^(tt)
    end
    
    alpha = Y2(end-backwardPeriod+1:end)./(M1(1:end) + Y2(end-backwardPeriod+1:end)')';

    ciH = bp.estimate.harris_ci(Y2(1:end),0.95,mH(end));

    rr = size(Result,1);
    Result(rr+1,'Country') = f;
    Result(rr+1,'m') = num2cell(mHk(end));
    Result(rr+1,'ci_l') = num2cell(ciH(1));
    Result(rr+1,'ci_u') = num2cell(ciH(2));  
    Result(rr+1,'alpha') = num2cell(alpha(end));  
    Result(rr+1,'A1') = num2cell(round(A1(end)));        
    Result(rr+1,'M1') = num2cell(round(M1(end)));        
end

table2latex(Result,'table3.tex')

%%  Sort the countries according their reproduction mean Harris



Flds = Data.Properties.VariableNames;

ResultS = table({'---'}, [0], [0], [0], 'VariableNames',{'Country','H','cl','cu'});

k = 1;
for f = Flds
fld = f{1};    

    Y2 = table2array(Data(:,fld)); 

    if iscell(Y2)
        continue;
    end
    
    if sum(~isnan(Y2)) < 30
        continue;
    end
    
    mH = bp.estimate.harris(Y2);
    mL = bp.estimate.LotkaNagaev(Y2);
    ciH = bp.estimate.harris_ci(Y2,0.95,mH);
    
    if mH < 0.001
        continue
    end
    ResultS(end+1,:) = {fld, [mH], [ciH(1)], [ciH(2)]};

    
    k = k + 1;
end

ResultS = ResultS(2:end,:)
[S,I] = sort(ResultS.H)

best = 10;
resT = ResultS([I(1:best) I(end-best+1:end)],:)

table2latex(resT,'table4.tex')

