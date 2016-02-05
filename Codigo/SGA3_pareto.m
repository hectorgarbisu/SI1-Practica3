%Evaluacion de la frontera de pareto
%Vamos a comparar el fitness con las emisiones y a comprobar si hay un
%patrón
tampop = 2000;
pop = pop_init(tampop);
[fitn,output,emision] = fitness(pop);
% plot3(output(:,:),emision(:,:),fitn(:,:),'*')
% zlabel('fitness')
% cameratoolbar
% emision = 1./emision;
plot(output(:,:),emision(:,:),'*k');
hold on
[maxval, maxind] = max(fitn(:,:));
% plot(output(:,:,maxind),emision(:,:,maxind),'og')
xlabel('output')
ylabel('emisiones')
p = polyfit(output(:,:),emision(:,:),2);
f = polyval(p,1:1:8000);
plot(1:1:8000,f,'.r');
hold off