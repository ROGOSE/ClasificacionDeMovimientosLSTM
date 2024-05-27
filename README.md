# Técnicas de Aprendizaje Profundo para reconocimiento de acciones de movimiento mediante los sensores de aceleración de un dispositivo móvil.
Repositorio del Trabajo de Fin de Grado de Ingeniería Infórmatica UCM 2023/2024. Rodrigo Gómez Serrano y Miguel Manzano Rodriguez.

A continuación se muestra un resumen del trabajo y se explica cómo ejecutar el código aportado.

# Resumen
Clasificar acciones de movimiento mediante Aprendizaje Profundo es un problema desafiante y en constante desarrollo, y es un tema de investigación en diversos
campos como deportes y rehabilitación. En este trabajo, se presenta un tipo de redes neuronales, las LSTM (Long Short Term Memory), y se muestra una visión general
de su aplicación a la hora de reconocer acciones de movimiento capturados mediante los sensores de aceleración de un dispositivo móvil. Con esto en mente, se emplea
la plataforma de programación y cálculo numérico MATLAB para desarrollar dos vertientes de investigación para abordar un espectro más amplio. En primer lugar,
se elabora la aplicación estática, que permite entrenar las redes neuronales y clasificar los datos de movimiento que estén previamente almacenados en el ordenador.
A continuación, se introduce la aplicación dinámica, que clasifica datos de movimiento recogidos en el momento por los sensores de aceleración del movil mediante
MATLAB Mobile. También se comparan varios resultados del entrenamiento de redes LSTM para resaltar la importancia que conlleva la elección de los parámetros.
Por útlimo, se plantea un enfoque global acerca de la comunicación entre un dispositivo móvil, encargado de registrar acciones de movimiento, y una aplicación en la
"nube", responsable de almacenar, procesar e incluso interpretar estas acciones de manera remota. Para ello se emplea una plataforma de Internet de las cosas llamada
ThingSpeak que esta integrada con MATLAB.

# Código 
Se proporciona a los lectores una guía para ejecutar las distintas aplicaciones del trabajo correctamente.

**Material necesario** \\
En primer lugar, debe contar con un dispositivo inteligente Smartphone y un PC (Computador Personal).
Además, es necesario instalar en el ordenador los programas MATLAB (disponible en ssii.ucm.es), válido tanto en PC como On-Line y MATLAB Drive Connector
(disponible en es.mathworks.com). Esto último proporciona acceso a MATLAB Drive, que lleva a cabo la comunicación entre la aplicación y el programa principal de
Matlab.
También debe instalar en el dispositivo móvil la aplicación MATLAB Mobile.
Para la nube, debe tener acceso a ThingSpeak (thingspeak.com).

**Aplicación estática**
Para ejecutar esta aplicación hay que abrir MATLAB en el ordenador y abrir App Designer. Para ello la opción más sencilla es escribir appdesigner en la línea de
comandos (aunque también se puede acceder desde Apps, pestaña que se ubica en la parte superior.
Una vez el usuario se encuentra en App Designer, hay que abrir los archivos _pantallaInicio.mlapp_, _pantallaTest.mlapp_, _pantallaTrain.mlapp_, _pantallaResultados.mlapp_
y _pantallaParametros.mlapp_. Los archivos se abren en la parte superior izquierda de la interfaz, pinchando en el icono _Open_.

A continuación, hay que situarse en el archivo _pantallaInicio.mlapp_ y para ello, se debe pinchar en la pestaña correspondiente. Una vez ahí, se pulsa el botón _Run_ en la
parte superior izquierda de la interfaz, lo que desencadena el inicio de la aplicación.
En la sección 3.2 se desarrolla paso a paso y se explica con detalle la funcionalidad de la aplicación.

Es importante mencionar que entre que se abre una pestaña y la siguiente pueden discurrir unos segundos.

**Aplicación dinámica**
Para ejecutar este programa son necesarios al menos los siguientes toolboxes: _Image Processing_, _Computer Vision_ y _Deep Learning_. 
Si se requiere de algún toolbox más, ya lo pide el propio MATLAB y lo instala, siempre con la cuenta institucional.
Se requiere la cuenta institucional de la UCM.

Una vez tenemos la app MATLAB Mobile instalada, la abrimos. En ella, pulsamos en el icono superior izquierdo que son tres barras horizontales para desplegar
un menú con varias opciones. Elegimos Sensores y una vez ahí seleccionamos:
- Transmitir a → MATLAB (para transmitir en tiempo real a MATLAB).
- Registro de sensores → Configurar → Acceso a sensores (activar al menos la aceleración).

En la carpeta MATLAB Drive tiene que haber un fichero con el modelo de red entrenada, como por ejemplo, RedLSTM.mat, que está pre-entrenada para las
siguientes acciones Dancing, Running, Sitting, Standing, Walking. El otro ejemplo de red es red_ejemplo_entrenada.mat. Ambos archivos se encuentran en el repositorio
del trabajo.

En esta misma carpeta hay que copiar el fichero _TrabajoFinalLSTM.m_, que contiene el código a ejecutar y en el cuál hay que modificar las dos siguientes líneas según
la red que se quiera utilizar. En concreto hay que cambiar la cadena ’RedLSTM’ y el archivo que se carga meidante load.
      
      if not(exist(’RedLSTM’,’var’))
          load RedLSTM;

Una vez ejecutado el código, se muestra por la pantalla del dispositivo el resultado, es decir, aparece la clasificación correspondiente a cada una de las acciones.

**Aplicación en la nube**
Para ejecutar este programa son necesarios al menos los siguientes toolboxes: _Image Processing_, _Computer Vision_ y _Deep Learning_. 
Si se requiere de algún toolbox más, ya lo pide el propio MATLAB y lo instala, siempre con la cuenta institucional.
Se requiere la cuenta institucional de la UCM. 
Además, en este caso es necesario contar con _MATLAB Support Package for Android Sensors_ o _MATLAB Support Package for Apple iOS Sensors_.

Una vez tenemos la app MATLAB Mobile instalada, la abrimos. En ella, pulsamos en el icono superior izquierdo que son tres barras horizontales para desplegar
un menú con varias opciones. Elegimos Sensores y una vez ahí seleccionamos:
- Transmitir a → MATLAB (para transmitir en tiempo real a MATLAB).
- Registro de sensores → Configurar → Acceso a sensores (activar al menos la
aceleración).

En la carpeta MATLAB Drive tiene que haber un fichero con el modelo de red entrenada, como por ejemplo,_ RedLSTM.mat_, que está pre-entrenada para las
siguientes acciones Dancing, Running, Sitting, Standing, Walking. El otro ejemplo de red es _red_ejemplo_entrenada.mat_. Ambos archivos se encuentran en el repositorio
del trabajo.
En esta misma carpeta hay que copiar el fichero _extensionIoT.m_, que contiene el código a ejecutar y en el cuál hay que modificar las dos siguientes líneas según la
red que se quiera utilizar. En concreto hay que cambiar la cadena ’RedLSTM’ y el archivo que se carga mediante _load_.

          if not(exist(’RedLSTM’,’var’))
              load RedLSTM;
              
Según se ejecuta el código, se muestra por la pantalla del dispositivo varias indicaciones de lo que está ocurriendo y, por último, el resultado, es decir, aparece
la clasificación correspondiente a cada una de las acciones.



