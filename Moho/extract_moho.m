% EXTRACT_MOHO
% Alternate SCRIPT to the function moho_extraction
% Extract the moho values from 3 different plates and plot as a line
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
% % Case Adria --------------------------------------------------------------
XA=reshape(xa,[l_x,l_y]);
YA=reshape(ya,[l_x,l_y]);
ZA=reshape(za,[l_x,l_y]);
% Case Europe -------------------------------------------------------------
XE=reshape(xe,[l_x,l_y]);
YE=reshape(ye,[l_x,l_y]);
ZE=reshape(ze,[l_x,l_y]);
% Case Liguria ------------------------------------------------------------
XL=reshape(xl,[l_x,l_y]);
YL=reshape(yl,[l_x,l_y]);
ZL=reshape(zl,[l_x,l_y]);
% -------------------------------------------------------------------------
% Plot map with 3 different tectonic plates
figure(1);
hold on;
grid on;
E=plot3(xe,ye,-ze,'r+');
A=plot3(xa,ya,-za,'b+');
L=plot3(xl,yl,-zl,'g+');
% [x,y]=track2(min(xa),min(ya),max(xa),max(ya));
% -------------------------------------------------------------------------
% Plot features
title ('\fontsize{13}\color{red} Surface Moho plot for different plates');
xlabel('Longitude [{\circ}]');
ylabel('Latitude [{\circ}]');
zlabel('Moho [km]');
% -------------------------------------------------------------------------
% 2. CREATION OF X AND Y ARRAY AND LINE PASSING IN 2 POINTS
% -------------------------------------------------------------------------
% Here goest the input: 
x1=5; y1=46.5; x2=8.5; y2=44.58;
% % Calculation of m and k
% m=(y2-y1)/(x2-x1);
% k=-m*x1+y1;
% % Write here the number of points
% % npts=100;
% % Define query points
% X=linspace(x1,x2);
% Y=m*X+k;

[latk,lonk] = track2(y1,x1,y2,x2);
Y = latk';
X = lonk';

% Plot the section line
plot(X,Y,'black','LineWidth',5)
% -------------------------------------------------------------------------
% 3. PUT INPUT VALIDITY CONDITION
% -------------------------------------------------------------------------
% Control on first input point   
% if x1 < min(x) || y1 < min(y) 
%     fprintf('Boundary of First point wrong!\n')
% return
% % Control on second input point
% elseif x2 > max(x) || y2 > max(y)
%     fprintf('Boundary of Second point wrong!\n')
% return
% else
% fprintf('Your input values are OK!\n')
% end
% -------------------------------------------------------------------------
% 4. DEFINE PLATES BOUNDARY
% -------------------------------------------------------------------------
% Load plate boundaries of Adria, Europe and Liguria defined by a polygon
% figure(1);
% hold on;
load xadria 
load yadria
% plot(xadria,yadria,'b');     check if the boundary is correct
load xeurope 
load yeurope
% plot(xeurope,yeurope,'r');   check if the boundary is correct
load xliguria
load yliguria
% plot(xliguria,yliguria,'g'); check if the boundary is correct
% -------------------------------------------------------------------------
% Define index respect to the chosen trace
[indexADR] = inpolygon(X,Y,xadria,yadria);
[indexEUR] = inpolygon(X,Y,xeurope,yeurope);
[indexLIG] = inpolygon(X,Y,xliguria,yliguria);
% -------------------------------------------------------------------------
% 5. INTERPOLATION
% -------------------------------------------------------------------------
% Set up interpolation for Europe, Adria and Liguria
interpZE = @(X,Y) griddata(xe,ye,ze,X,Y);
ZE = interpZE(X(indexEUR),Y(indexEUR));
hold on;
interpZA = @(X,Y) griddata(xa,ya,za,X,Y);
ZA = interpZA(X(indexADR),Y(indexADR));
hold on;
interpZL = @(X,Y) griddata(xl,yl,zl,X,Y);
ZL = interpZL(X(indexLIG),Y(indexLIG));
% -------------------------------------------------------------------------
% Plot moho profile for Europe, Adria and Liguria
figure(2);

% -------------------------------------------------------------------------
% Transform X axis in km
% -------------------------------------------------------------------------

% Y1_EUR = Y(indexEUR(1));
% X1_EUR = X(indexEUR(1));
% Y2_EUR = Y(indexEUR(end));
% X2_EUR = X(indexEUR(end));
% 
% [lat1EUR, lon1EUR, lat2EUR, lon2EUR, latEUR, lonEUR] = project_new(Y1_EUR,X1_EUR,Y2_EUR,X2_EUR,Y(indexEUR),X(indexEUR));
% 
% [lat1ADR, lon1ADR, lat2ADR, lon2ADR, latADR, lonADR] = project_new(y1,x1,y2,x2,Y(indexADR),X(indexADR));
% 
% [lat1LIG, lon1LIG, lat2LIG, lon2LIG, latLIG, lonLIG] = project_new(y1,x1,y2,x2,Y,X);
% 
% X(indexADR)
% 
% X(indexLIG)

% -------------------------------------------------------------------------
plot(X(indexEUR),-ZE,'r','LineWidth',5);
hold on;
plot(X(indexADR),-ZA,'b','LineWidth',5);
hold on;
plot(X(indexLIG),-ZL,'g','LineWidth',5);
% -------------------------------------------------------------------------
% Plot features
title('\fontsize{13}\color{red} 3D line Moho plot for different plates');
xlabel('Longitude [{\circ}]');
ylabel('Moho [km]');
toc;