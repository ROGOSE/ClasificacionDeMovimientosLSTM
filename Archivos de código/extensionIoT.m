%% Preparacion del dispositivo y datos
% IMPORTANTE: si se queda el objeto m abierto, genera problemas, siendo necesario eliminarlo en  la línea de comandos haciendo: clear m
%% Borrado de objetos previos
if exist('m','var')
    clear m;
end

%% Crear objeto 
m = mobiledev;

%% Cargar la RedLSTM si no existe la variable
if not(exist('RedLSTM','var'))
    load RedLSTM;
    RedLSTM = net;
end

%% Determinar el número mínimo de datos capturados. FUENTES.
% Transmisión de datos de sensores:
% https://es.mathworks.com/help/matlabmobile/ug/sensor-data-streaming-tutorial.html
% Procesar datos registrados de sensores:
% https://es.mathworks.com/help/matlabmobile/ug/use-logged-sensor-data.html

%% Definición de los canales
% Canal: SensoresLSTM y usa 7 campos (Aceleraciones (3), Nº Movimientos/captura, Nº 'Sitting'/Captura, Activar, Clasificar
ChannelIDSensores1 = 2528440;
readAPIKeySensores1 = 'RT89ZBRNT29H4NWH';
writeAPIKeySensores1 = '8X8DLU5VZNY76E4S';

disp('Bienvenido. Te iré explicando que ocurre en cada momento:')
%% (FUNCIONA BIEN EL CLEAR) Antes de empezar, comprueba el numero de ejecuciones que se ha hecho (máx. 5)
%% y si ya hay 5, limpia el canal.
vectorEjec = thingSpeakRead(ChannelIDSensores1, 'Fields', 6, 'NumPoints', 1, 'Readkey', readAPIKeySensores1)
numEjec = numel(vectorEjec)
disp(['Se va a realizar la ejecución ', num2str(numEjec+1), '/5.'])
if (numEjec >= 4)
    UserAPIKey = '973TA4QPU6KLB4LH'; % This is available from https://thingspeak.com/account/profile
    url = sprintf('https://api.thingspeak.com/channels/%s/feeds.json?api_key=%s',num2str(ChannelIDSensores1),UserAPIKey)
    response = webwrite(url, weboptions('RequestMethod','delete'))
else 
    thingSpeakWrite(ChannelIDSensores1, numEjec+1, 'Fields', 6, 'Writekey', writeAPIKeySensores1);
end

%% Activar la habilitación para la captura de datos sensoriales durante el tiempo de espera
m.Logging = 1;
disp('Comienza la captura durante 20 segundos')

pause(2); % En mobile App sólo se admiten esperas con pause con 2 segundos como máximo
pause(2); pause(2); pause(2); pause(2); pause(2); %pause(2); pause(2); pause(2); pause(2); pause(2); %con esta linea son otros 20 segs
pause(2); pause(2); pause(2); pause(2);

%% Recuperar los datos almacenados en el objeto m, solo necesitamos aceleracion (y orientacion)
% [datos registrados (de aceleración), marcas de tiempo] = ...log(m)
[aceleracion, taceleracion] = accellog(m); % Logged acceleration data
%[vangular, tvangular] = angvellog(m); % Logged angular velocity data
%[orientacion, torientacion] = orientlog(m); % Logged orientation data

figure(2); plot(taceleracion, aceleracion) 
xlabel('Tiempo en segundos (s)');
ylabel('Aceleracion');
%legend(aceleracion(1),aceleracion(2),aceleracion(3))

%% Conexión a tiempos absolutos. Devuelve la hora actual en ese formato
tInit = datetime(m.InitialTimestamp, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss.SSS');
%disp(tInit)

%% Desactivar la captura
m.Logging = 0;
disp('Fin de la captura')

%% Creación de variables para trabajar con los datos: ThingSpeak y Representaciones gráficas
[M,N] = size(aceleracion);   %% son los M movimientos capturados y N=3 las coordenadas x,y,z


%% Escritura de datos en ThingSpeak
Ma = size(aceleracion); % en una ejec. 299. size devuelve en (1) M filas (numero de aceleraciones capturadas) y en (2) N=3 coordenadas
Mc = Ma(1); 
iter = 1;
MaxIter = Mc; %Máximo número de iteraciones (realmente es el minimo (si captamos datos de varios sensores))

%Inicializamos al tamaño maximo todas las graficas que vamos a representar (son matrices 1xMaxIter, e.d., vectores de long. MaxIter)
AceleracionX = zeros(1,MaxIter); 
AceleracionY = AceleracionX; 
AceleracionZ = AceleracionX;

% for i = 1:1:MaxIter
%     AceleracionX(iter) = aceleracion(iter,1);
%     AceleracionY(iter) = aceleracion(iter,2);
%     AceleracionZ(iter) = aceleracion(iter,3);
% 
%     iter = iter + 1;
% end

for i = 1:1:MaxIter
    AceleracionX(i) = aceleracion(i,1);
    AceleracionY(i) = aceleracion(i,2);
    AceleracionZ(i) = aceleracion(i,3);

    %iter = iter + 1;
end

% Datos de los Sensores para cargar en las variables de los campos 1 a 6
dataField1 = AceleracionX';
dataField2 = AceleracionY';
dataField3 = AceleracionZ';

%% Preparación de los datos para subirlos a ThingSpeak
%vector de timestamps desde (hora actual)-(MaxIter-1 segundos) hasta la hora actual, con un intervalo de un segundo entre cada marca de tiempo
Timestamps = datetime('now')-seconds(MaxIter-1):seconds(1):datetime('now');

%tabla donde la 1a col contiene las marcas de tiempo del vector Timestamps, y las columnas restantes (dataField1 a dataField3) datos asociados a ellas
dataTimeTable = table(Timestamps', dataField1, dataField2, dataField3); 

%se escribe la tabla en ThingSpeak
disp('Escribiendo tabla en ThingSpeak')
respuesta = thingSpeakWrite(ChannelIDSensores1, dataTimeTable, 'Writekey', writeAPIKeySensores1);

% Esperar para consolidar la escritura de datos en el Canal
pause(2); pause(2); pause(2); pause(2); pause(2); pause(2); pause(2); pause(2); pause(2)

%se leen los datos que hemos escrito en ThingSpeak, para comprobar que ha ido bien  
disp('Leyendo tabla de ThingSpeak')
[datosDescargados, infoCanal] = thingSpeakRead(ChannelIDSensores1, 'Fields', [1,2,3], 'NumPoints', MaxIter, 'Output', 'table', 'Readkey', readAPIKeySensores1);
%disp(datosDescargados) %imprime el tiempo de captura y las aceleraciones x y z correspondientes
%disp(infoCanal) %imprime info del canal
%% GUARDADAS CAPTURAS EN WHATSAPP

% Se comprueba que la última entrada se corresponde con el número de iteraciones, para comprobar que la copia ha sido correcta
[NumDatos, s] = size(datosDescargados);
if NumDatos == MaxIter
    disp('Numero Datos copiados CORRECTO')

    %% Se escribe el valor 0 en el Field8, para proceder a la clasificación de la acción
    Clasificar = 0;
    disp('Escribir Field8 = 0')
    respuesta1 = thingSpeakWrite(ChannelIDSensores1, Clasificar, 'Fields', 8, 'WriteKey', writeAPIKeySensores1);

    %% Esperar para consolidar la escritura en el Canal 
    % (asegurar que se ha escrito field8=0 pues al activar el react, el código comprueba que field8=0 para empezar la clasificacion)
    pause(2); pause(2); pause(2); pause(2); pause(2); pause(2); pause(2); pause(2); pause(2);

    %% Activar React de ThingSpeak al escribir Field7 = 1, espera 15 segundos y el React lee Field8=0, cuyo codigo espera 15 secs y escribe 100 en Field8
    Activar = 1;
    disp('Activar React mediante Field7 = 1')
    respuesta2 = thingSpeakWrite(ChannelIDSensores1, Activar, 'Fields', 7, 'WriteKey', writeAPIKeySensores1);

    %% Esperar para consolidar la escritura en el Canal 
    pause(2); pause(2); pause(2); pause(2); pause(2); pause(2); pause(2); pause(2); pause(2);

else
    NumDatos;
    disp('Numero Datos copiados INCORRECTO')
end

%% Permanecer en escucha hasta que el React ponga un valor distinto de cero (100) en el Field 8 (lo leo en Clasificar)
Contador = 0;
NumeroMaximoIter = 20;
disp('Escuchar Field8 hasta recibir el 100.')
while (Clasificar == 0) && (Contador < NumeroMaximoIter)
    pause(2); pause(2); pause(2);
    %leo el Field8 por si acaso ya esta listo el 100 (salgo del bucle cuando Clasificar = 100)
    Clasificar = thingSpeakRead(ChannelIDSensores1, 'Fields', 8, 'NumPoints', 1,'Readkey', readAPIKeySensores1);
    Contador = Contador + 1;
    disp('Recibido 100. Comienza la clasificación.')
end

%% Clasificación de los movimientos (Acciones) realizadas con la RedLSTM
if Clasificar == 100
    disp('Clasificando...')
    X = aceleracion';
    Actividades = classify(RedLSTM,X)
    %actividades es un array 1x97 con las categorías. Lo suyo seria contar
    %todos los sittings que haya y pasarlo a una grafica de ThingSpeak en
    %la que se van poniendo el numero de veces que esta sentado en cada
    %captura. Si en alguna de las ejecuciones numero de veces sentado >
    %numero total movs/2 entonces mandamos un correo diciendo que tiene qeu
    %moverse más. Hacer con x segundos y decir que lo suyo seria con un
    %dia o 8 horas o  algo asi.
    
    numActividades = numel(Actividades);
    cont = 0;
    for i = 1:numActividades
        if (Actividades(i) == 'Sitting')
            % Incrementar el contador
            cont = cont + 1;
        end
    end    

        % Mostrar el resultado
    disp(['El número total de movimientos es: ', num2str(numActividades)])
    disp(['El número de veces que aparece "Sitting" es: ', num2str(cont)])

    %% PAUSA PARA QUE NO SE RALLE THINGSPEAK Y ESCRIBIRLO EN SU GRÁFICA
    pause(2); pause(2); pause(2);pause(2); pause(2);
    thingSpeakWrite(ChannelIDSensores1, [cont, numActividades], 'Fields', [4,5], 'WriteKey', writeAPIKeySensores1);
    %ADEMAS EL REACT DEL CORREO SE ACTIVA CUANDO FIELD 6 (NUM sitting.) > 100



    %% Esperar para consolidar la escritura en el Canal 
    pause(2); pause(2); pause(2); pause(2); pause(2); pause(2); pause(2); pause(2); pause(2);


end

% Eliminar los datos del objeto m
discardlogs(m);

%% Guardar los datos en la variable AccOrienMagn para representar los datos mediante el programa FusionSensores
% previa carga en el drive del PC
%save AccOrienMagn aceleracion orientacion magnetico position
