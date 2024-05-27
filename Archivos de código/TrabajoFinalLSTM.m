%% Preparacion del dispositivo y datos

% IMPORTANTE: si se queda el objeto m abierto, genera problemas, siendo necesario eliminarlo en 
% la línea de comandos haciendo: clear m

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


%% Determinar el número mínimo de datos capturados
% https://es.mathworks.com/help/matlabmobile/ug/sensor-data-streaming-tutorial.html
% https://es.mathworks.com/help/matlabmobile/ug/use-logged-sensor-data.html

%% Activar la habilitación para la captura de datos sensoriales durante el tiempo que dura el bucle
m.Logging = 1;

t = 3;
for i = 0:1:t
    pause(1); % MATLAB Mobile solo permite pausas de máximo 2 segundos
end



%% Desactivar la captura
m.Logging = 0;

%% Recuperar los datos almacenados
[aceleracion, taceleracion] = accellog(m);   % Logged acceleration data


% yAcc = aceleracion(:,1);
% plot(taceleracion, yAngVel);
% legend('Velocidad Angular Y');
% xlabel('Tiempo relativo (s)');


%% Clasificación de la acción mediante el sensor aceleración
[M,N] = size(aceleracion);

if M == 0
  disp('No se han capturado datos: repetir');
else
  X = aceleracion';
  Actividades = classify(RedLSTM,X)
end

discardlogs(m);



