% EXTRACT_MOHO_GINPUT
% Alternate SCRIPT to the function moho_extraction
% using the input data from the mouse with ginput
%
% Extract the moho values from 3 different plates and plot different moho as a line
%
% Input files required:
% moho_ADRIA_i.xyz,   xadria,   yadria      [ADRIA   PLATE]
% moho_EUROPE_i.xyz,  xeurope,  yeurope     [EUROPE  PLATE]
% moho_LIGURIA_i.xyz, xliguria, yliguria    [LIGURIA PLATE]
%
% Input parameters:
% lon1, lat1, lon2, lat2
%
% Output parameters:
% figure (1) Section chosen in a map view 
% figure (2) Graph with the moho values in the section chosen
%
% Leonardo Colavitti
% 08 March 2017
% -------------------------------------------------------------------------

tic;
clear; close all; clc;
% -------------------------------------------------------------------------
% 1. READ INPUT FILE
% -------------------------------------------------------------------------
% Reading example XYZ Data [Adria, Europe, Liguria]
[xa,ya,za]=textread('moho_ADRIA_i.xyz','%f %f %f');
[xe,ye,ze]=textread('moho_EUROPE_i.xyz','%f %f %f');
[xl,yl,zl]=textread('moho_LIGURIA_i.xyz','%f %f %f');
% Build the base grid
l_x=length(unique(xa));
l_y=length(unique(ya));
% -------------------------------------------------------------------------
% Plot map with 3 different tectonic plates
figure(1)
hold on;
grid on;
E=plot3(xe,ye,-ze,'r+');
A=plot3(xa,ye,-za,'b+');
L=plot3(xl,yl,-zl,'g+');
[x,y]=track2(min(xa),min(ya),max(xa),max(ya));
% -------------------------------------------------------------------------
% Plot features
title('\fontsize{13}\color{red} 3D line Moho plot for different plates');
xlabel('Longitude [{\circ}]');
ylabel('Latitude [{\circ}]');
zlabel('Moho [km]');
legend('Europa','Adria','Liguria');
legend('Location','northeast')
% -------------------------------------------------------------------------
% 2. CREATION OF X AND Y ARRAY AND LINE PASSING IN 2 POINTS
% -------------------------------------------------------------------------
% Draw the section in map with the chosen input 
% grid on;
% uiwait(msgbox('Click 2 points'));
[x,y] = ginput(2);
plot(x,y);
% Calculation of m and k
m=(y(2)-y(1))/(x(2)-x(1));
k=-m*x(1)+y(1);
% Write here the number of points
% npts=100;
% Define query points
X=linspace(x(1),x(2));
Y=m*X+k;
% Plot the section line
plot(X,Y,'black','LineWidth',5)
% -------------------------------------------------------------------------
% 3. INTERPOLATION
% -------------------------------------------------------------------------
% Set up interpolation for Europe, Adria and Liguria
interpZE = @(X,Y) griddata(xe,ye,ze,X,Y);
ZE  = interpZE(X,Y);
hold on;
interpZA = @(X,Y) griddata(xa,ya,za,X,Y);
ZA = interpZA(X,Y);
hold on;
interpZL = @(X,Y) griddata(xl,yl,zl,X,Y);
ZL  = interpZL(X,Y);
% -------------------------------------------------------------------------
% Plot moho profile for Europe, Adria and Liguria
figure(2);
plot(X,-ZE,'r','LineWidth',5);
hold on;
plot(X,-ZA,'b','LineWidth',5);
hold on;
plot(X,-ZL,'g','LineWidth',5);
% -------------------------------------------------------------------------
% Plot features
title('\fontsize{13}\color{red} 3D line Moho plot for different plates');
xlabel('Longitude [{\circ}]');
ylabel('Moho [km]');
axis ([x(1) x(2) -60 0]);
legend('Europe','Adria','Liguria');
legend('Location','northeast');
toc;