%% Calculate expected total waiting and idle times
clear all
clc;
rng(123);

n=20; %clients
input = load('input.txt');
pdW=fitdist(input, 'Weibull');

flag_control=0;
Nsample=1;
MaxIter=3000;
mean_Wait=zeros();
S=zeros();
RE=zeros();
C=zeros(n,MaxIter);
Wait=zeros(n,MaxIter);
Idle=zeros(n,MaxIter);
Wait(1,MaxIter)=0;
Idle(1,MaxIter)=0;

A=zeros(20,MaxIter);
indControl=zeros();

%% W(k+1)=((Wk+Ck)-Ak+1) Ik+1 = (Ak+1-(Wk+Ck))
flag=0;

while flag_control==0
    for j=1:20
        C(j,Nsample)=wblrnd(pdW.A,pdW.B);
    end

    m=(pdW.A)*gamma(1+1/pdW.B);
    
    A(:,Nsample)=m;
    
    for j=2:20
        Wait(j,Nsample)=max(0, (Wait(j-1,Nsample)+C(j-1,Nsample))-A(j,Nsample));        
    end
    for j=2:20
        Idle(j,Nsample)=max(0, (A(j,Nsample)-(Wait(j-1,Nsample)+C(j-1,Nsample))));
    end 
    
%S=sqrt(var(Wait));    

Obj1=sum(Wait,1)+sum(Idle,1);
ObjIdle=sum(Idle,1);
ObjWait=sum(Wait,1);

AvgWait=mean(ObjWait(1,1:Nsample));
StDevWait=std(ObjWait(1,1:Nsample));
AvgIdle=mean(ObjIdle(1,1:Nsample));
StDevIdle=std(ObjIdle(1,1:Nsample));

ReCheck(1,Nsample)=StDevWait/(sqrt(Nsample)*AvgWait);


if ReCheck(1,Nsample)<=0.05
    
    flag=flag+1; % convergence indicator
    indControl(1,flag)=Nsample;
end
if flag>2705 % additional loop to simulate more times even if RE<0.05
    flag_control=1;
end

Nsample=Nsample+1;  
  
    
end
% Store results to matrices to plot graphs and create results
ObjtoExcel=zeros(1,Nsample-1);
ObjtoExcelready=zeros(1,Nsample-1);
ObjtoExcel(1,1)=Obj1(1,1);
IdletoExcel=zeros(1,Nsample-1);
IdletoExcelready=zeros(1,Nsample-1);
IdletoExcel(1,1)=ObjIdle(1,1);
WaittoExcel=zeros(1,Nsample-1);
WaittoExcelready=zeros(1,Nsample-1);
WaittoExcel(1,1)=ObjWait(1,1);


for jjj=2:Nsample-1    
    ObjtoExcel(1,jjj)=ObjtoExcel(1,jjj-1)+Obj1(1,jjj);
    IdletoExcel(1,jjj)=IdletoExcel(1,jjj-1)+ObjIdle(1,jjj);
    WaittoExcel(1,jjj)=WaittoExcel(1,jjj-1)+ObjWait(1,jjj);
end
for kkk=1:Nsample-1
    ObjtoExcelready(1,kkk)=ObjtoExcel(1,kkk)/kkk;
    IdletoExcelready(1,kkk)=IdletoExcel(1,kkk)/kkk;
    WaittoExcelready(1,kkk)=WaittoExcel(1,kkk)/kkk;
end
disp(m); 
ObjIdleMatrix(1,1:kkk)=ObjIdle(1,1:kkk);
ObjWaitMatrix(1,1:kkk)=ObjWait(1,1:kkk);
ObjMatrix(1,1:kkk)=Obj1(1,1:kkk);
ObjcompareMatrix(1,1:kkk)=ObjtoExcelready;
WaitcompareMatrix(1,1:kkk)=WaittoExcelready;
IdlecompareMatrix(1,1:kkk)=IdletoExcelready;

% construct confidence intervals
upperBound=AvgWait+1.96*StDevWait/sqrt(Nsample-1);
lowerBound=AvgWait-1.96*StDevWait/sqrt(Nsample-1);

upperBoundIdle=AvgIdle+1.96*StDevIdle/sqrt(Nsample-1);
lowerBoundIdle=AvgIdle-1.96*StDevIdle/sqrt(Nsample-1);
%plot(sum(Wait,2))
CI=[lowerBound, upperBound];
IdleCI=[lowerBoundIdle, upperBoundIdle];