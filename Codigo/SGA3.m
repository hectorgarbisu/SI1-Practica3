%% Metaparámetros
% mostrar = true;
% Numero de generaciones
ngeneraciones = 10;
% Tamaño de la poblacion
tampop = 60;
% Cantidad de individuos reproductores
repro = 42; 
% elitismo
elite = 2;
% probabilidad de mutacion
pmut = 0.1;
% metodo de seleccion
% sel = ['truncamiento' 'rwsr' 'sus' 'torneo'];
selo = 'sus';
% metodo de cruce
% cruce = ['onepoint' 'twopoint' 'uniforme' 'semiuniforme'];
cruceo = 'uniforme';
% metodo de mutacion
% muta = ['bitstring' 'boundary' 'hipermut']
mutao = 'bitstring';
% metodo de escalado
% esca = ['lineal' 'sigma' 'boltzman' 'lrank' 'nrank' 'pnrank'];
escao = 'lineal';
% Registro
bestf = [];
avrgf = [];
beste = [];
besto = [];
%% Inicialización
% Cromosomas
pop = pop_init(4,12,tampop);    
% iv = zeros(1,size(pop,3)); %vector de indices
%% 
if mostrar
    tic
end
for i=1:1:ngeneraciones
    %% Calculo de fitness
    [fitn,output,emision] = fitness(pop);
    [fitn,iv] = sort(fitn,'descend');
    emision = emision(:,:,iv);
    output = output(:,:,iv);
    pop = pop(:,:,iv);
    %% Selección
    pop = sele(pop,fitn,repro,elite,selo,i,ngeneraciones);
    %% Cruce
    pop = cruza(pop,repro,cruceo,elite);
    %% Mutación
    pop = muta(pop,pmut,mutao,i,ngeneraciones);
    %% Recopilacion
%     [i fitn(1)]
%     pop(:,:,i)
    if mostrar
        if tampop>2
            [i fitn(1) fitn(2) fitn(3)]
        elseif tampop>1
            [i fitn(1) fitn(2)]
        else
            [i fitn(1)]
        end
    end
    bestf = [bestf fitn(1)];
    beste = [beste emision(1)];
    besto = [besto output(1)];
    avrgf = [avrgf mean(fitn)];
end
%%
% Muestra resultados
if mostrar
    toc
    plot(1:ngeneraciones,bestf,'r-',1:ngeneraciones,avrgf,'b-');
    grid on
    legend('maximo','media','Location','EastOutside');
    xlabel('generacion')
    ylabel('fitness')
    axis([1 ngeneraciones 0 1]);
end
%% Fin