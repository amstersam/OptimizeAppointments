x=1:1:Nsample-1;
y=ReCheck(1,1:Nsample-1);
%hold on
%axis 'equal'
plot(x,y)
% hold off
% axis([0 1000000 0 1.2])
xlabel('Number of runs')
ylabel('Relative Error of estimator of total waiting times')


x2=1:1:Nsample-1;
y2=ObjtoExcelready(1,1:Nsample-1);
plot(x2,y2)
xlabel('Patient')
ylabel('Waiting time (in minutes)')
%% Plot Waiting times
x3=1:1:Nsample-1;
y3=WaittoExcelready(1,1:Nsample-1);
plot(x3,y3)
xlabel('Number of runs')
ylabel('Waiting times (in minutes)')

x4=1:1:Nsample-1;
y4=IdletoExcelready(1,1:Nsample-1);
plot(x4,y4)
xlabel('Number of runs')
ylabel('Idle times (in minutes)')

%% random day - waiting / idle times
Day=1;
x5=1:1:20;
y5=Wait(1:20,Day);
plot(x5,y5)
xlabel('Patient')
ylabel('Waiting time (in minutes)')

Day=1;
x5=1:1:20;
y5=Idle(1:20,Day);
plot(x5,y5)
xlabel('Doctor')
ylabel('Idle time (in minutes)')

%% plot Objective
NumberTest=1;
row=NumberTest;
x4=find(ObjcompareMatrix(row,:)==0); % find first 0 in the row 
x3=1:1:2999;
y3=ObjcompareMatrix(row,1:2999);
plot(x3,y3)
xlabel('Number of runs')
ylabel('Total expected waiting and idle times')