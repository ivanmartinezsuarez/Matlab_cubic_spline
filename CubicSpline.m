function [s,xxx,yyy] = CubicSpline(x,w)
%function [s] = CubicSpline(x,w)
% Funcion de interpolacion de splines cubicos.
% INPUT pares de puntos (x,w)
% OUTPUT s: Polinomio de spline cubico en cada intervalo (matriz)
%        xxx: Puntos para dibujar (coordenada x)
%        yyy: Puntos para dibujar (coordenada y)
%        Grafica de la interpolacion
% En primer lugar tenemos que crear el sistema de ecuaciones a resolver. 
% Comenzamos por las h_i:
for i = 1:length(x)-1
   h(i) = x(i+1)-x(i); 
end
% Construimos la matriz del sistema, M, a partir de las h_i:
M = zeros(length(x)-2);
for j = 1:length(x)-2;
   M(j,j) = 2*(h(j)+h(j+1)); 
   if j<= length(x)-3
   M(j,j+1) = h(j);
   M(j+1,j) = h(j);
   end
end
% Construimos el vector de terminos independientes, v. Previamente es 
% necesario c.
c = zeros(length(x),1);
% Imponemos la condicion de splines cubicos naturales, que en este caso
% particular ya viene impuesta en la linea anterior.
c(1) = 0; c(end) = 0; 
v = zeros(length(x)-2,1);
% El primer y el ultimo elemento de v se definen, para splines genericos,
% de forma diferente al resto de elementos.
for i = 2:length(x)-1;
    v(i-1,1) = 6*((w(i+1)-w(i))/h(i) - (w(i)-w(i-1))/h(i-1)); 
    v(1) = v(1) - c(1)*h(1);
    v(end) = v(end) - c(end)*h(end);
end
% Resolvemos el sistema y calculamos los coeficientes c_i. En principio
% el algoritmo de Thomas sera una buena opcion, por ser la matriz M
% tridiagonal. De todas formas, usamos el comando \ de MATLAB.
c(2:end-1) = M\v;
% Definimos el spline cubico para cada intervalo (limitado por cada par de 
% puntos consecutivos) en las filas de s. La formula es la vista en clase.
s = zeros(length(x)-1,4);
for i=1:length(x)-1;
    s(i,:) = -(c(i)/(6*h(i)))*poly([x(i+1) x(i+1) x(i+1)]) + ...
    + (c(i+1)/(6*h(i)))*poly([x(i) x(i) x(i)]) + ...
    - [0 0 (w(i)/h(i)-c(i)*h(i)/6)*poly(x(i+1))] + ...
    + [0 0 (w(i+1)/h(i)-c(i+1)*h(i)/6)*poly(x(i))];
end
% De cara a la representacion grafica, tomamos 10 puntos equiespaciados en
% cada intervalo.
xx = zeros(length(x)-1,10);
yy = zeros(length(x)-1,10);
for i = 1:length(x)-1;
   xx(i,:) = linspace(x(i),x(i+1),10);
   yy(i,:) = polyval(s(i,:),xx(i,:));
end
% CubicSpline tendra como salida un vector de puntos xxx y otro yyy, ademas
% de la grafica correspondiente.
xxx = reshape(xx',[],1);
yyy = reshape(yy',[],1);
plot(xxx,yyy,'-b');
hold on;
plot(x,w,'ok');