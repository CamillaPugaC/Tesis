function varargout = gui22(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui22_OpeningFcn, ...
                   'gui_OutputFcn',  @gui22_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function gui22_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
function varargout = gui22_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;
%etiquetas, textos y audios
handles.leyenda1 = 'SISTEMA DE RECONOCIMIENTO PARA NIÑOS CON SD';
    set(handles.text3,'String',handles.leyenda1);
 handles.leyenda2 = 'PROCESAMIENTO DE IMAGEN';
    set(handles.text2,'String',handles.leyenda2);
    handles.leyenda7 = 'IMAGEN';
    set(handles.imagen,'String',handles.leyenda7);
 handles.leyenda3 = 'Rango de porcentaje niños con SD: 22% - 36% ';
    set(handles.text4,'String',handles.leyenda3);
   %handles.leyenda4 = '22% - 36%';
    %set(handles.imagen,'String',handles.leyenda4);
handles.leyenda5 = 'Rango de porcentaje niños control: 12% -21% y 36%-100%  ';
    set(handles.text6,'String',handles.leyenda5);
   %handles.leyenda6 = '12%-21% - 36%-100%';
    %set(handles.text11,'String',handles.leyenda6);
     m = audioread('Recording_2.wav');
    sound(m,18000);%16000
    axes(handles.axes3);
        logo1 = imread('ipn2.jpg');
    imshow(logo1);
    axes(handles.axes4);
        logo2 = imread('esime2.jpeg');
    imshow(logo2);
%boton capturar
function capturar_Callback(hObject, eventdata, handles); 
    m1 = audioread('Recording_3.wav');
    sound(m1,18000);%16000
    handles.porcentaje = 0;
    % Inicializar la cámara
   cam = webcam;
    preview(cam); % Mostrar la vista previa de la cámara web
    % Capturar una imagen
    img = snapshot(cam);
    delete(cam);
    % Procesar la imagen capturada
    imgris = rgb2gray(img);
    ima = imgaussfilt(imgris, 2);
    imagen = imsharpen(ima);
    % Detectar rostros
    detectorRostro = vision.CascadeObjectDetector();
    bbox = step(detectorRostro, imagen);

    if ~isempty(bbox)
        
        rostros = insertObjectAnnotation(imagen,"rectangle",bbox,"rostro");
        axes(handles.axes2);
        imshow(rostros);
       
        if size(bbox, 1) > 1 % Si se detectan más de un rostro
           mensaje = 'Se detectó más de un rostro';
           mensaje2 = ' selecciona las coordenadas del rostro a trabajar';
            msg = text(10,20,mensaje,'Color','red','FontSize',12);
             msgg = text(10,60,mensaje2,'Color','red','FontSize',12);
            [x1, y1] = ginput(2);
            [x2, y2] = ginput(2);
            delete(msg);
            delete(msgg);
            ancho = sqrt((x1(2) - x1(1))^2 + (y1(2) - y1(1))^2);
            distancia = sqrt((x2(2) - x2(1))^2 + (y2(2) - y2(1))^2);
            handles.porcentaje = (distancia * 100) / ancho;
            %mensaje = sprintf('porcentaje:%.2f%% ', handles.porcentaje);
            %msg2 = text(10,20,mensaje,'Color','green','FontSize',12);
            set(handles.text13,'String',handles.porcentaje);
            axes(handles.axes1);
            imshow(rostros);  
        else % Si se detecta un solo rostro
              
            ancho = bbox(3);
            mensaje = 'selecciona los lagrimales';
            msg3 = text(10,20,mensaje,'Color','red','FontSize',12);
            [x, y] = ginput(2);
            distancia = sqrt((x(2) - x(1))^2 + (y(2) - y(1))^2);
            handles.porcentaje = (distancia * 100) / ancho;
             roi = imcrop(imagen,bbox);
            %rostro = insertObjectAnnotation(roi,'rectangle',bbox,'rostro');
            %rostro = insertObjectAnnotation(roi,'rectangle',bbox,'rostro');
            axes(handles.axes1);
            imshow(roi);
            %fprintf('Porcentaje encontrado: %.2f%%\n', porcentaje);
            delete(msg3);
            %mensaje = sprintf('porcentaje:%.2f%% ', porcentaje);
            %msg4 = text(10,20,mensaje,'Color','green','FontSize',12);
            set(handles.text13,'String',handles.porcentaje);
            
        end
         %m3 = audioread('Recording_6.wav');
         %sound(m3,18000);%16000
    if (handles.porcentaje >=22 && handles.porcentaje <= 36 )
        m4 = audioread('Recording_7.wav');
         sound(m4,18000);%16000
        handles.mensaje = 'Tiene síndrome de Down ';
        set(handles.text15,'String',handles.mensaje);
        %msg5 = text(20,70,handles.mensaje,'Color','red','FontSize',12);
    else
        m4 = audioread('Recording_8.wav');
         sound(m4,18000);%16000
        handles.mensaje2 = ' No tiene síndrome de Down ';
        set(handles.text15,'String',handles.mensaje2);
        %msg5 = text(20,70,handles.mensaje2,'Color','red','FontSize',12);
    
    end
      
    else
        axes(handles.axes1);
           imshow(imagen);
        mensaje = 'no se detectaron rostros ';
           msg5 = text(20,20,mensaje,'Color','red','FontSize',12);
           
    end
    %delete(msg4);
  
    %cla(handles.axes1); limpiar el axes
    handles.imagenCapturada = img;
    guidata(hObject, handles);

% --- Executes on button press in seleccionar.
function seleccionar_Callback(hObject, eventdata, handles)
% hObject    handle to seleccionar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 m2 = audioread('Recording_4.wav');
    sound(m2,18000);%16000
 [filename, filepath] = uigetfile({'.jpg;*.png;*.bmp'}, 'Seleccione una imagen');
    
    % Verificar si se seleccionó una imagen válida
    if isequal(filename, 0)
        disp('No se seleccionó ninguna imagen.');
        return;
    else
        disp(['Se seleccionó el archivo: ', fullfile(filepath, filename)]);
    end

    % Leer la imagen seleccionada
    img = imread(fullfile(filepath, filename));

    % Convertir la imagen a escala de grises
    img_gris = rgb2gray(img);

    % Aplicar filtro Gaussiano
    img_filt = imgaussfilt(img_gris, 1);

    % Aplicar filtro de nitidez
    img_nitidez = imsharpen(img_filt);

   detectorRostro = vision.CascadeObjectDetector();
    bbox = step(detectorRostro, img_nitidez);

    if ~isempty(bbox)
        rostros = insertObjectAnnotation(img_nitidez,"rectangle",bbox,"rostro");
        axes(handles.axes2);
        imshow(rostros);

        if size(bbox, 1) > 1 % Si se detectan más de un rostro
           mensaje = 'Se detectó más de un rostro';
           mensaje2 = 'selecciona las coordenadas del rostro a trabajar';
            msg = text(10,20,mensaje,'Color','red','FontSize',12);
            msgg = text(10,20,mensaje2,'Color','red','FontSize',12);
            [x1, y1] = ginput(2);
            [x2, y2] = ginput(2);
            delete(msg);
            delete(msgg);
            ancho = sqrt((x1(2) - x1(1))^2 + (y1(2) - y1(1))^2);
            distancia = sqrt((x2(2) - x2(1))^2 + (y2(2) - y2(1))^2);
            handles.porcentaje2 = (distancia * 100) / ancho;
            %mensaje = sprintf('porcentaje:%.2f%% ', porcentaje);
            %msg2 = text(10,20,mensaje,'Color','green','FontSize',12);
            set(handles.text13,'String',handles.porcentaje2);
            
        else % Si se detecta un solo rostro
            ancho = bbox(3);
            mensaje = 'selecciona los lagrimales';
            msg3 = text(10,20,mensaje,'Color','red','FontSize',12);
            [x, y] = ginput(2);
            distancia = sqrt((x(2) - x(1))^2 + (y(2) - y(1))^2);
            handles.porcentaje2 = (distancia * 100) / ancho;
            %fprintf('Porcentaje encontrado: %.2f%%\n', porcentaje);
            delete(msg3);
            %mensaje = sprintf('porcentaje:%.2f%% ', porcentaje2);
            %msg4 = text(10,20,mensaje,'Color','green','FontSize',12);
            set(handles.text13,'String',handles.porcentaje2);
        end
          roi = imcrop(img_nitidez,bbox);
         %rostro = insertObjectAnnotation(roi,'rectangle',bbox,'rostro');
         axes(handles.axes1);
         imshow(roi); 
        
    else
        mensaje = 'no se detectaron rostros ';
           msg5 = text(10,20,mensaje,'Color','red','FontSize',12);
            
    end
    %delete(msg4);
     %m3 = audioread('Recording_6.wav');
         %sound(m3,18000);%16000
    if (handles.porcentaje2 >=22 && handles.porcentaje2 <= 36 )
        m4 = audioread('Recording_7.wav');
         sound(m4,18000);%16000
        handles.mensaje = 'Tiene síndrome de Down ';
        set(handles.text15,'String',handles.mensaje);
        %msg5 = text(10,50,mensaje,'Color','red','FontSize',12);
    else
         m4 = audioread('Recording_8.wav');
         sound(m4,18000);%16000
        handles.mensaje = 'No tiene síndrome de Down ';
        set(handles.text15,'String',handles.mensaje);
        %msg5 = text(10,50,mensaje,'Color','red','FontSize',12);
    
    end
    %cla(handles.axes1); limpiar el axes
    handles.imagenCapturada = img;
    guidata(hObject, handles);


function automatico_Callback(hObject, eventdata, handles)
 m1 = audioread('Recording_3.wav');
    sound(m1,18000);%16000
    handles.porcentaje = 0;
    ojos = vision.CascadeObjectDetector('EyePairBig');
    ojoiz = vision.CascadeObjectDetector('LeftEye');
    ojoder = vision.CascadeObjectDetector('RightEye');
    % Inicializar la cámara
   cam = webcam;
    preview(cam); % Mostrar la vista previa de la cámara web
    % Capturar una imagen
    img = snapshot(cam);
    delete(cam);
    % Procesar la imagen capturada
    imgris = rgb2gray(img);
    ima = imgaussfilt(imgris, 2);
    imagen = imsharpen(ima);
    detectorRostro = vision.CascadeObjectDetector();
    bbox = step(detectorRostro, imagen);
    rostros = insertObjectAnnotation(imagen,"rectangle",bbox,"rostro");
        axes(handles.axes2);
        imshow(rostros);
     if ~isempty(bbox)
        
        rostros = insertObjectAnnotation(imagen,"rectangle",bbox,"rostro");
        axes(handles.axes2);
        imshow(rostros);
       
        if size(bbox, 1) > 1 % Si se detectan más de un rostro
           mensaje = 'Se detectó más de un rostro';
           mensaje2 = ' selecciona las coordenadas del rostro a trabajar';
            msg = text(10,20,mensaje,'Color','red','FontSize',12);
             msgg = text(10,60,mensaje2,'Color','red','FontSize',12);
            [x1, y1] = ginput(2);
            [x2, y2] = ginput(2);
            delete(msg);
            delete(msgg);
            ancho = sqrt((x1(2) - x1(1))^2 + (y1(2) - y1(1))^2);
            distancia = sqrt((x2(2) - x2(1))^2 + (y2(2) - y2(1))^2);
            handles.porcentaje = (distancia * 100) / ancho;
            %mensaje = sprintf('porcentaje:%.2f%% ', handles.porcentaje);
            %msg2 = text(10,20,mensaje,'Color','green','FontSize',12);
            set(handles.text13,'String',handles.porcentaje);
        else % Si se detecta un solo rostro
            ancho = bbox(3);
            roi = imcrop(imagen,bbox);
            bbox2 =step(ojos,roi);
            roi2 = imcrop(roi,bbox2);
            bbox3 = step(ojoiz,roi2);
            bbox4 = step(ojoder,roi2);
            lagrimal_izquierdo = [bbox3(1), bbox3(2)]; 
            lagrimal_derecho = [bbox4(1) + bbox4(3), bbox4(2)];
            distancia = sqrt((lagrimal_derecho(1) - lagrimal_izquierdo(1))^2 + (lagrimal_derecho(2) - lagrimal_izquierdo(2))^2);
            handles.porcentaje = (distancia * 100) / ancho;
            %fprintf('Porcentaje encontrado: %.2f%%\n', porcentaje);
            %mensaje = sprintf('porcentaje:%.2f%% ', porcentaje);
            %msg4 = text(10,20,mensaje,'Color','green','FontSize',12);
            set(handles.text13,'String',handles.porcentaje);
            
        end
         m3 = audioread('Recording_6.wav');
         sound(m3,18000);%16000
    if (handles.porcentaje >=22 && handles.porcentaje <= 36 )
        handles.mensaje = 'Tiene síndrome de Down ';
        set(handles.text15,'String',handles.mensaje);
        %msg5 = text(20,70,handles.mensaje,'Color','red','FontSize',12);
    else
        handles.mensaje2 = ' No tiene síndrome de Down ';
        set(handles.text15,'String',handles.mensaje2);
        %msg5 = text(20,70,handles.mensaje2,'Color','red','FontSize',12);
    
    end
       %roi = imcrop(imagen,bbox);
         %rostro = insertObjectAnnotation(roi,'rectangle',bbox,'rostro');
         %rostro = insertObjectAnnotation(roi,'rectangle',bbox,'rostro');
         axes(handles.axes1);
         imshow(roi);  
    else
        axes(handles.axes1);
           imshow(imagen);
        mensaje = 'no se detectaron rostros ';
           msg5 = text(20,20,mensaje,'Color','red','FontSize',12);
           
    end
    %delete(msg4);
  
    %cla(handles.axes1); limpiar el axes
    handles.imagenCapturada = img;
    guidata(hObject, handles);
