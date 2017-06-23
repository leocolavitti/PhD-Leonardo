function moho_extraction(x1,y1,x2,y2)
% MOHO EXTRACTION (x1,y1,x2,y2)
% Extract the moho values from 3 different plates and plot as a line
% 
% Input parameters:
% x1, y1, x2, y2 where:
% x1 Lon of first point  [degrees]
% y1 Lat of first point  [degrees]
% x2 Lon of second point [degrees]
% y2 Lat of second point [degrees]
%
% Output parameters:
% figure (1) Section chosen in a map view for the three different plates
% figure (2) Graph with the moho values in the section chosen
% 
% Input files required:
% - To read xyz data:
% moho_ADRIA_i.xyz   [ADRIA   PLATE]
% moho_EUROPE_i.xyz  [EUROPE  PLATE]
% moho_LIGURIA_i.xyz [LIGURIA PLATE]
% - To define plate boundaries:
% xadria,  yadria    [ADRIA   PLATE]
% xeurope, yeurope   [EUROPE  PLATE] 
% xliguria, yliguria [LIGURIA PLATE]
% 
% Input function required:
% project_new.m to transform coordinate system
%
% Leonardo Colavitti
% 27 March 2017
% -------------------------------------------------------------------------

tic; clf;
% -------------------------------------------------------------------------
% 1. READ INPUT FILE
% -------------------------------------------------------------------------
% Reading example XYZ Data [Adria, Europe, Liguria]
[xa,ya,za]=textread('moho_ADRIA_i.xyz','%f %f %f');
[xe,ye,ze]=textread('moho_EUROPE_i.xyz','%f %f %f');
[xl,yl,zl]=textread('moho_LIGURIA_i.xyz','%f %f %f');

% -------------------------------------------------------------------------
% 2. PUT VALIDITY CONDITIONS IN THE INPUT
% -------------------------------------------------------------------------
% Control on first input point
if x1 < min(xa) || y1 < min(ya) 
    fprintf('Boundary of First point wrong!\n')
    return
% Control on second input point 
elseif x2 > max(xa) || y2 > max(ya)
    fprintf('Boundary of Second point wrong!\n')
return
else
% Message: your input is fine!    
fprintf('Your input values are OK!\n')
end
% -------------------------------------------------------------------------
% 3. CREATION OF X AND Y ARRAY
% -------------------------------------------------------------------------
% Calculation of lat and lon with the function track2
[lat,lon] = track2(y1,x1,y2,x2);
% Compute X and Y
X = lon';
Y = lat';
% Projection of all lat, lon points in a new system 
% starting from y1,x1 and ending in y2, x2
[ latTa,lonTa,latTb,lonTb,latT,lonT ] = project_new(y1,x1,y2,x2,Y,X);
% Transform the lon coordinates from degrees into km
lonTbKM = 111.195*lonTb;
lonTKM  = 111.195*lonT;
% -------------------------------------------------------------------------
% 4. MAP VIEW REPRESENTATION
% -------------------------------------------------------------------------
% Plot map with 3 different tectonic plates
figure(1);
hold on;
grid on;
E=plot3(xe,ye,-ze,'r+');
A=plot3(xa,ya,-za,'b+');
L=plot3(xl,yl,-zl,'g+');
hold on;
% Plot the section line
plot(X,Y,'k','LineWidth',2);
% Plot features
title ('\fontsize{13}\color{red} Map view of track chosen');
xlabel('Longitude [{\circ}]');
ylabel('Latitude [{\circ}]');
zlabel('Moho [km]');
legend('Europe','Adria','Liguria','Track');
legend('Location','northeastoutside')
% -------------------------------------------------------------------------
% 5. DEFINE PLATES BOUNDARY
% -------------------------------------------------------------------------
% Load plate boundaries of Adria, Europe and Liguria defined by a polygon
% figure (3);
% hold on;
load xadria
load yadria
% plot(xadria,yadria,'b');      % check if the boundary is correct
load xeurope
load yeurope
% plot (xeurope,yeurope,'r');   % check if the boundary is correct
load xliguria
load yliguria
% plot (xliguria,yliguria,'g'); % check if the boundary is correct
% -------------------------------------------------------------------------
% Define index respect to a chosen trace
[indexADR]  = inpolygon(X,Y,xadria,yadria); 
[indexEUR]  = inpolygon(X,Y,xeurope,yeurope);
[indexLIG] = inpolygon(X,Y,xliguria,yliguria);
% -------------------------------------------------------------------------
% 6. INTERPOLATION
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
% 7. MOHO REPRESENTATION
% -------------------------------------------------------------------------
% Plot moho profile for Europe, Adria and Liguria plate
figure(2);
plot(lonTKM(indexEUR),ZE,'r-.','LineWidth',3);
hold on;
plot(lonTKM(indexADR),ZA,'b-.','LineWidth',3);
hold on;
plot(lonTKM(indexLIG),ZL,'g-.','LineWidth',3);
% -------------------------------------------------------------------------
% Plot features
title('\fontsize{13}\color{red} Moho values for different plates');
xlabel('Profile [km]');
ylabel('Moho [km]');
xlim ([0 ceil(lonTbKM)]);
set(gca, 'YDir', 'reverse');
ylim ([0 80]);
daspect ([2 1 2]);
legend('Europe','Adria','Liguria');
legend('Location','northeastoutside')
toc;
end