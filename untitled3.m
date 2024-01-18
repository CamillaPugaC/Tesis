positivos = 'Down';
negativos = 'healty';
archivos = dir(fullfile(positivos,'*jpg'));
archivos2 = dir(fullfile(negativos,'*jpg'));


detectorRostro = vision.CascadeObjectDetector();


minimo_positivo = 100;
maximo_positivo = 0;
minimo_negativo = 100;
maximo_negativo = 0;
for i = 1:length(archivos)
    ancho = [];
    distancia = [];
    porcentaje = [];
     nombre_imagen = fullfile(positivos,archivos(i).name);
    im = imread(nombre_imagen);
    imgris = rgb2gray(im);
    ima = imgaussfilt(imgris,2);
    imagen = imsharpen(ima);
    bbox =step(detectorRostro, imagen);
    if ~isempty(bbox)
      rostro = insertObjectAnnotation(imagen,'rectangle',bbox,'rostro');
      figure();
      imshow(rostro);
        if size (bbox,1)> 1 % si hay más de un rostro
          [x1, y1] = ginput(2);
          [x2, y2] = ginput(2);
          ancho =  sqrt((x1(2) - x1(1))^2 + (y1(2)-y1(1))^2);
          distancia = sqrt((x2(2) - x2(1))^2 + (y2(2)-y2(1))^2);
          porcentaje = (distancia * 100) / ancho;
          fprintf('Porcentaje encontrado: %.2f%%\n', porcentaje);
        else
         ancho = bbox(3)-bbox(1);
         [x, y] = ginput(2);
         distancia = sqrt((x(2) - x(1))^2 + (y(2)-y(1))^2);
         porcentaje = (distancia * 100) / ancho;
         fprintf('Porcentaje encontrado: %.2f%%\n', porcentaje);
        end
         if porcentaje <= minimo_positivo
           minimo_positivo = porcentaje;
        else
          if porcentaje >= maximo_positivo
          maximo_positivo = porcentaje;
          end
         end  
    else
     
        disp('no se detectaron rostros');
       
    end
    
end
%cambio de carpeta
disp('cambio de carpeta');
for i = 1:length(archivos2)
    ancho2 = [];
    distancia2 = [];
    porcentaje2 = [];
     nombre_imagen2 = fullfile(negativos,archivos2(i).name);
    im2 = imread(nombre_imagen2);
    imgris2 = rgb2gray(im2);
    ima2 = imgaussfilt(imgris2,2);
    imagen2 = imsharpen(ima2);
    bbox2 =step(detectorRostro, imagen2);
    if ~isempty(bbox2)
      rostro2 = insertObjectAnnotation(imagen2,'rectangle',bbox2,'rostro');
      figure();
      imshow(rostro2);
        if size (bbox2,1)> 1 % si hay más de un rostro
          [x1, y1] = ginput(2);
          [x2, y2] = ginput(2);
          ancho2 =  sqrt((x1(2) - x1(1))^2 + (y1(2)-y1(1))^2);
          distancia2 = sqrt((x2(2) - x2(1))^2 + (y2(2)-y2(1))^2);
          porcentaje2 = (distancia2 * 100) / ancho2;
          fprintf('Porcentaje encontrado: %.2f%%\n', porcentaje2);
        else
         ancho2 = bbox2(3)-bbox(1);
         [x, y] = ginput(2);
         distancia2 = sqrt((x(2) - x(1))^2 + (y(2)-y(1))^2);
         porcentaje2 = (distancia2 * 100) / ancho2;
         fprintf('Porcentaje encontrado: %.2f%%\n', porcentaje2);
        end
        if porcentaje2 <= minimo_negativo
           minimo_negativo = porcentaje2;
        else
          if porcentaje2 >= maximo_negativo
          maximo_negativo = porcentaje2;
          
          end
        end
    else
     
        disp('no se detectaron rostros');
       
    end
    
end
fprintf('Porcentaje máximo encontrado: %.2f%%\n', maximo_positivo);
fprintf('Porcentaje mínimo encontrado: %.2f%%\n', minimo_positivo);
disp('carpeta negativa');
fprintf('Porcentaje máximo encontrado: %.2f%%\n', maximo_negativo);
fprintf('Porcentaje mínimo encontrado: %.2f%%\n', minimo_negativo);