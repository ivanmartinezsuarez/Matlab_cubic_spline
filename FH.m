clear all; clc
% Leemos los valores de voltaje (V) e intensidad (I) de dataVI.mat
load('dataVI.mat')
% Interpolamos los datos utilizando splines cubicos (CubicSpline.m)
% Obtenemos el spline en cada intervalo (s) y puntos para dibujar en esos
% intervalos (xxx e yyy)
[s,xxx,yyy] = CubicSpline(V,I);
hold on
xlabel('V_{ac} (V)'); ylabel('I_{amp} (nA)'); 
hold on
% Buscamos los extremos da curva V-I. Inicializamos dos vectores, Vr y
% Vrr
Vr = zeros(size(s,1),2); 
Vrr = Vr;
% El vector index servira para marcar la posicion de los extremos dentro
% de los datos originales, para luego poder evaluar las intensidades (I)
% en la posicion de los extremos de V
index = zeros(size(s,1),2);
% Calculamos las raices de la derivada del spline correspondiente a cada 
% uno de los intervalos, es decir, vemos donde se anula la pendiente del
% spline y por lo tanto hay un extremo (maximo o minimo).
% Pediremos que las raices de cada derivada pertenezcan al intervalo
% correspondiente y que sean reales (parte imaginaria menor que 10^-8),
% para que el calculo tenga sentido. Vr son las raices en general, Vrr 
% cumplen las restricciones anteriores. El siguiente bucle nos permite
% imponer estas condiciones sin ser demasiado exigentes.
for i = 1:size(s,1)
    for j = 1:2
        Vr(i,:) = (roots(polyder(s(i,:))))';
        if abs(imag(Vr(i,j))) <= 1E-8  && Vr(i,j) < V(i+1) && Vr(i,j) > V(i)
            Vrr(i,j) = Vr(i,j);
            index(i,j) = i;
        else Vrr(i,j) = 0; index(i,j) = 0;
        end
    end
end
% Sabemos, por la forma de la grafica, que el primer extremo es un maximo, 
% el segundo un minimo, y asi alternativamente.
Vext = sort(Vrr(Vrr~=0));
indexI = sort(index(index~=0));
Vmax = Vext(1:2:length(Vext));
Vmin = Vext(2:2:length(Vext));
% Calculamos el valor de I en los extremos, Iext, usando el vector index
% para saber con que spline se corresponden.
Iext = zeros(length(indexI),1);
for i = 1:length(indexI)
    Iext(i,1) = polyval(s(indexI(i),:),Vext(i));
end
% Dibujamos los puntos extremos y los imprimimos en pantalla.
plot(Vext,Iext,'*r')
legend('Spline cubico','Datos experimentales','Extremos','Location','northwest')
fprintf('Los extremos de la curva son:\n')
fprintf('Vmin(V)  Vmax(V) \n')
for i = 1:length(Vext)/2
    fprintf(' %.2f   ',Vmin(i))
    fprintf(' %.2f   \n',Vmax(i))
end