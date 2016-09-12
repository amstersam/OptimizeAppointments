x=1:1:Nsample;
y=Obj1(1,1:Nsample);
%hold on
%axis 'equal'
plot(x,y)
%axis([0 Nsample 0 0.00000000001])


x2=1:1:Nsample-1;
y2=toExcelready(1,1:Nsample-1);
plot(x2,y2)

%hold on
%axis 'equal'
%plot(x,y)
% hold off
% axis([0 1000000 0 1.2])
x=1:1:Nsample;
y=RE(1,1:Nsample);
%hold on
%axis 'equal'
plot(x,y)

NumberTest=1;
row=NumberTest;
%% plot Objective
%row=7;
x4=find(ObjcompareMatrix(row,:)==0); % find first 0 in the row 
x3=1:1:x4-1;
y3=ObjcompareMatrix(row,1:x4-1);
plot(x3,y3)
xlabel('Number of runs')
ylabel('Weightef sum of expected waiting and idle times')

%% plot Wait
%row=7;
x4=find(WaitcompareMatrix(row,:)==0); % find first 0 in the row 
x3=1:1:x4-1;
y3=WaitcompareMatrix(row,1:x4-1);
plot(x3,y3)

%% plot Idle
%row=7;
x4=find(IdlecompareMatrix(row,:)==0); % find first 0 in the row 
x3=1:1:x4-1;
y3=IdlecompareMatrix(row,1:x4-1);
plot(x3,y3)