clc;

load input.txt;
test1 = input(:,1);

pdLN=fitdist(input, 'Lognormal');
pdW=fitdist(input, 'Weibull');

figure;
a1=histfit(input,40,'Lognormal');
set(a1(2),'color','r');
hold on;
a2=histfit(input,40,'Weibull');
%hold on;
set(a2(1),'facecolor','g'); set(a2(2),'color','b')
axis tight
l=legend([a1(2),a2(2)],'Lognormal','Weibull');
set(l,'Interpreter','latex','FontSize',14)
legend boxoff
box off;


