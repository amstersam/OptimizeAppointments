clear all
clc;

load input.txt;
test1 = input(:,1);

pdLN=fitdist(input, 'Lognormal');
pdW=fitdist(input, 'Weibull');
 
cdfdataL=cdf('Lognormal', input,pdLN.mu, pdLN.sigma); % create cdf to be used as input for the KS test
h=kstest(input, 'cdf', [input, cdfdataL])
[h,p,ksstat,cv]=kstest(input, 'cdf', [input, cdfdataL]);

cdfdataW=cdf('Weibull', input,pdW.A, pdW.B);
h=kstest(input, 'cdf', [input, cdfdataW])
[h,p,ksstat,cv]=kstest(input, 'cdf', [input, cdfdataW]);
% x1 = wblrnd(pdW.A,pdW.B,1,50);
% x2 = wblrnd(pdW.A,pdW.B,1,50);
%h = kstest2(test1(1:50,1),x2)
% h = kstest2(x1,x2)
% [h,p] = kstest2(x1,x2,'Alpha',0.01)