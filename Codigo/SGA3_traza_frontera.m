%SGA3_traza_frontera
%Obtiene el mejor de cada de SGA3
mostrar = false;
numiteraciones = 300;
fitn_champ = [];
outp_champ = [];
emis_champ = [];
for iparetos=1:1:numiteraciones
    SGA3
    [fitn_max,index] = max(bestf);
    if fitn_max>0.6
        fitn_champ = [fitn_champ fitn_max];
        outp_champ = [outp_champ besto(index)];
        emis_champ = [emis_champ beste(index)];
    end
    [iparetos fitn_max besto(index) beste(index)]
end
%Se ordenan por el fitness
[fitn_champ, k] = sort(fitn_champ,'descend');
outp_champ = outp_champ(k);
emis_champ = emis_champ(k);
plot(outp_champ(1:100),emis_champ(1:100),'g.')
hold on
plot(outp_champ(101:200),emis_champ(101:200),'b.')
plot(outp_champ(201:300),emis_champ(201:300),'r.')
legend('rank 1-100','rank 101-200','rank 201-300')
xlabel('output')
ylabel('emisiones')
grid on
axis([0 8000 0 11000])
p = polyfit(outp_champ,emis_champ,2);
x = 1:10:8000;
f = polyval(p,x);
plot(x,f,'.k')
hold off