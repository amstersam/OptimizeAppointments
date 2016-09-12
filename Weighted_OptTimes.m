clear all
clc;

tic;

n=20; %clients
input = load('input.txt');
pdW=fitdist(input, 'Weibull');
flag_control=0;
%Nsample=1;
MaxIter=250000;

ObjMatrix=zeros(11,MaxIter);
ObjIdleMatrix=zeros(11,MaxIter);
ObjWaitMatrix=zeros(11,MaxIter);
ObjcompareMatrix=zeros(11,MaxIter);
ObjIdle=zeros(11,MaxIter);
ObjWait=zeros(11,MaxIter);
IdlecompareMatrix=zeros(11,MaxIter);
WaitcompareMatrix=zeros(11,MaxIter);

bigloop=1;
%for bigloop=1:11 % for search of optimal m uncomment
rng(123);  

Nsample=1;
WaitMean=zeros(1,MaxIter);
S=zeros();
RE=zeros(1, MaxIter);
C=zeros(n,MaxIter);
Wait=zeros(n,MaxIter);
Idle=zeros(n,MaxIter);
IdleMean=zeros(1,MaxIter);
Wait(1,MaxIter)=0; % vector of wating times in each iteration
Idle(1,MaxIter)=0; % vector of idle times in each iteration
Ctemp=zeros(n,MaxIter);

A=zeros(20,MaxIter);
indControl=zeros();

%% W(k+1)=((Wk+Ck)-Ak+1) Ik+1 = (Ak+1-(Wk+Ck))
flag=0;

%% Objective = Min (0.75*Idle + 0.25*Wait)
Obj1=zeros();
objective_achieved=0;

while flag_control==0 || objective_achieved==0
    
    objective_achieved=0; % if it was true for previous iter it can mix things up
    flag_control=0;
    for j=1:20
        C(j,Nsample)=wblrnd(pdW.A,pdW.B);
    end
m=14;
 %   m=(pdW.A)*gamma(1+1/pdW.B);
    
%    Ctemp(:,Nsample)=cumsum(C(:,Nsample),1);
% deterministic changes of m 
%1  original idea      
%A(:,Nsample)=m; % original arrivals

% 2   first alternative check next consulting time and reduce or increase the current arrival 
%    for k=2:20
%         if C(k,Nsample)>m
%             A(k-1,Nsample)=0.9*m;
%         else
%              A(k-1,Nsample)=1.1*m;
%         end
%     end
% 3 
%  A(:,Nsample)=0.5*m;
% for k=1:2:20
%     A(k,Nsample)=1.5*m;
% end
% Method 4 - create arrival times with scenarios - not presented
% for k=2:20
%     if C(k,Nsample)>3*m   %% Nsample --> 1
%         A(k,Nsample)=4*m;  %% Nsample --> :
%     elseif C(k,Nsample)>2*m
%         A(k,Nsample)=3*m;
%     elseif C(k,Nsample)>1*m
%         A(k,Nsample)=2*m;
%     elseif C(k,Nsample)<1*m
%         A(k,Nsample)=m;
%     elseif C(k,Nsample)<0.5*m
%          A(k,Nsample)=0.5*m;
%     else
%          A(k,Nsample)=0.25*m;
%     end
% end
% 5
%f=0.1;
%m=(f*bigloop+0.4)*m;  %% f=0.1 --> accuracy and number of searches can be
%changed here and from bigloop interations

A(:,Nsample)=m;
% end of deterministic changes to m 
    
    for j=2:20
        Wait(j,Nsample)=max(0, (Wait(j-1,Nsample)+C(j-1,Nsample))-A(j,Nsample));        
    end
    for j=2:20
        Idle(j,Nsample)=max(0, (A(j,Nsample)-(Wait(j-1,Nsample)+C(j-1,Nsample))));
    end 
  
Obj1=0.25*sum(Wait,1)+0.75*sum(Idle,1);
ObjIdle=sum(Idle,1);
ObjWait=sum(Wait,1);    



AvgWait=mean(ObjWait(1,1:Nsample));
StDevWait=std(ObjWait(1,1:Nsample));
AvgIdle=mean(ObjIdle(1,1:Nsample));
StDevIdle=std(ObjIdle(1,1:Nsample));
ReCheck(1,Nsample)=StDevWait/(sqrt(Nsample)*AvgWait);


if ReCheck(1,Nsample)<=0.05
    %flag_control=1;
     flag=flag+1; % convergence indicator
%     indControl(1,flag)=Nsample;
end
 if flag>150
     flag_control=1; % from task 2, simple convergence is sufficient here
 end

    
if Obj1(1,Nsample)<40
    objective_achieved=1;
end  

Nsample=Nsample+1;    
toc;    
end
%plot(sum(Wait,2))
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
ObjIdleMatrix(bigloop,1:kkk)=ObjIdle(1,1:kkk);
ObjWaitMatrix(bigloop,1:kkk)=ObjWait(1,1:kkk);
ObjMatrix(bigloop,1:kkk)=Obj1(1,1:kkk);
ObjcompareMatrix(bigloop,1:kkk)=ObjtoExcelready;
WaitcompareMatrix(bigloop,1:kkk)=WaittoExcelready;
IdlecompareMatrix(bigloop,1:kkk)=IdletoExcelready;

upperBound=AvgWait+1.96*StDevWait/sqrt(Nsample-1);
lowerBound=AvgWait-1.96*StDevWait/sqrt(Nsample-1);
CI(bigloop,1:2)=[lowerBound, upperBound];
%end

%% find optimal m
% 
% for jj=1:10
%     ind=find(ObjcompareMatrix(jj,:)==0); %finds first zero element in
%     stored data
%     allind(jj,1)=ind(1,1)-1; % stores index
%     Min(jj,1)=ObjcompareMatrix(jj,ind(1,1)-1); % finds the point where
%     objective converges
%     mm(jj,1)=(0.1*jj+0.4)*11.37;
% end
% [minM indM]=min(Min);