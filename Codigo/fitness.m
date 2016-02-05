function [fitn,output,total_aceleraciones] = fitness(pop)
traza_semaforo = 0;
traza_terreno = 0;
traza_cola = 0;
traza_coches = 0;
traza_matriz_aceleraciones = 0;
traza_aceleraciones = 0;
%% Definicion del modelo
% Una serie de autómatas celulares
% 4 carreteras con 4 intersecciones
% Antes de cada intersección hay un semáforo
% Los semáforos que operan en la misma intersección
% tienen valores alternativos en cada momento

% Carreteras
% La columna 1 son las entradas
% La columna 14 son las salidas
% Las columnas 4 y 9 son semáforos
% Las columnas 5 y 10 son intersecciones
% Las columnas 6 y 11 son las salidas de las intersecciones
% Se presuponen carreteras vacías al comienzo
[numcarreteras,numpasos,numcromosomas] = size(pop);

% Terreno (se actualiza cada paso)
% 0 = no hay coche; 1 = hay coche
terreno = zeros(4,14,numcromosomas);

% Vector de "semaforos" (se actualiza cada 10 pasos)
% Es una matriz de 4x14 sonde sólo varían 8 celdas.
% A efectos prácticos, todas las celdas normales
% son semáforos en verde

puede_pasar = ones(numcarreteras,14,numcromosomas);
puede_pasar([1 3],4,:) = pop([1 2],1,:); 
puede_pasar([2 4],9,:) = pop([3 4],1,:); 
% Los semaforos cercanos tienen valores alternos
puede_pasar(2,4,:) = ~puede_pasar(3,4,:);
puede_pasar(4,4,:) = ~puede_pasar(2,9,:);
puede_pasar(1,9,:) = ~puede_pasar(4,9,:);
puede_pasar(3,9,:) = ~puede_pasar(1,4,:);

% Colas (se actualiza cada 5 pasos)
cola = ones(4,1,numcromosomas); %Se empieza con un coche en la cola

semstep = 1; % Paso del semaforo 

% Variables para el calculo de fitness
output = 0; %rendimiento
t_1 = terreno; %emisiones
t_2 = terreno;
total_aceleraciones = zeros(1,1,numcromosomas);
periodo_coches = 3;
%% Bucle de 2 horas simuladas
ciclos = 60; % Veces que se repite la secuencia de los cromosomas
for j=1:1:ciclos
%% Bucle de 2 minutos simulados
    for i=1:1:10*numpasos %% 10 segundos por paso
%% Cada periodo_coches segundos la cola incrementa
        if mod(i,periodo_coches)==0
            cola = cola+1;
        end
%% Cada 10 segundos los semaforos se actualizan
        if mod(i,10)==0
            semstep = mod(semstep,numpasos)+1;
            puede_pasar([1 3],4,:) = pop([1 2],semstep,:); 
            puede_pasar([2 4],9,:) = pop([3 4],semstep,:); 
            % Los semaforos cercanos tienen valores alternos
            puede_pasar(2,4,:) = ~puede_pasar(3,4,:);
            puede_pasar(4,4,:) = ~puede_pasar(2,9,:);
            puede_pasar(1,9,:) = ~puede_pasar(4,9,:);
            puede_pasar(3,9,:) = ~puede_pasar(1,4,:);
        end
%% Cada 1 segundo las celdas se actualizan
        [terreno,cola] = actualiza_terreno(terreno,cola,puede_pasar);
        
%% Calculo de fitness en funcion del estado actual
% Criterio 1
% Se suman todos los coches que están a punto de salir
        output = output+sum(terreno(:,14,:));
% Criterio 2
% Se calcula la cantidad total de aceleraciones que ha habido
% una aceleración es una transición a 0 tras dos iteraciones a 1
        matriz_aceleraciones = t_1.*t_2.*~terreno;
        aceleraciones = sum(sum(matriz_aceleraciones));
        total_aceleraciones = total_aceleraciones + aceleraciones;
        t_2 = t_1; %Avanza el tiempo
        t_1 = terreno;
%%      
        if traza_terreno
            disp(terreno)
        end
        if traza_semaforo
            disp(puede_pasar)
        end
        if (traza_cola)
            cola
        end    
        if traza_coches
            output
        end
        if traza_matriz_aceleraciones
            disp(matriz_aceleraciones)
        end
        if traza_aceleraciones
            aceleraciones
        end
    end
end
%metrica = coches por iteración y calle
max_output = 10*ciclos*numpasos*4/periodo_coches;
fout = output./max_output;
% 
% % cantidad de aceleraciones medias en todo el terreno
femi = total_aceleraciones/(10*numpasos*ciclos);
% %Teóricamente solo puede haber 6 aceleraciones simultaneas en un estado
% %(y es muy poco probable)
femi = femi./6;

fitn = 0.5*fout+0.5*(1-femi);
% fitn = fout.*(1-femi);

end