% PLOT_MOHOS
% Script that plot Moho for different plates
%
% Figures:
% 1. Plot Moho as a 3D line plot
% 2. Plot Moho as a 3D line plot (2013 version)
% 3. Plot 2 Mohos plate-by-plate and find the differences
% 4. Plot Moho as a 3D volume
%
% Input files required:
% - To read xyz data:
% Moho_WesternAlps2013.txt                      [ALL MODEL] 
% Adriatic_Moho2013.txt, moho_ADRIA_i.xyz       [ADRIA   PLATE]
% European_Moho2013.txt, moho_EUROPE_i.xyz      [EUROPE  PLATE]
% Tyr-Cor_Moho2013.txt,  moho_LIGURIA_i.xyz     [LIGURIA PLATE]
% 
% Leonardo Colavitti
% 20.10.2016
% -------------------------------------------------------------------------

clear; close all; clc;
% -------------------------------------------------------------------------
% --- READING MODELS ------------------------------------------------------
% -------------------------------------------------------------------------
% ADRIA - EUROPE - LIGURIA ------------------------------------------------
% -------------------------------------------------------------------------
[lonA,latA,mohoA]=textread('moho_ADRIA_i.xyz','%f %f %f');
[lonE,latE,mohoE]=textread('moho_EUROPE_i.xyz','%f %f %f');
[lonL,latL,mohoL]=textread('moho_LIGURIA_i.xyz','%f %f %f');
% -------------------------------------------------------------------------
% MOHO VERSION 2013: EUROPE - ADRIA - TYRRENIA-CORSICA --------------------
% -------------------------------------------------------------------------
[lon13,lat13,moho13]=textread('Moho_WesternAlps2013.txt','%f %f %f');
[lonEU13,latEU13,mohoEU13]=textread('European_Moho2013.txt','%f %f %f');
[lonAD13,latAD13,mohoAD13]=textread('Adriatic_Moho2013.txt','%f %f %f');
[lonTC13,latTC13,mohoTC13]=textread('Tyr-Cor_Moho2013.txt','%f %f %f');
% -------------------------------------------------------------------------
% Length computation
% -------------------------------------------------------------------------
LONA=length(unique(lonA)); LATA=length(unique(latA));
LONE=length(unique(lonE)); LATE=length(unique(latE));
LONL=length(unique(lonL)); LATL=length(unique(latL));

LONAD13=length(unique(lonAD13)); LATAD13=length(unique(latAD13));
LONEU13=length(unique(lonEU13)); LATEU13=length(unique(lonEU13));
LONTC13=length(unique(lonTC13)); LATTC13=length(unique(lonTC13));
% -------------------------------------------------------------------------
% Moho meshgrid and Moho reshaping
% -------------------------------------------------------------------------
% [X,Y]=meshgrid((floor(min(lonA))):1:(ceil(max(lonA))), (floor(min(latA))):1:(ceil(max(latA))));
% axis([floor(min(lonA)) ceil(max(lonA)) floor(min(latA)) ceil(max(latA)) floor(min(mohoA)) ceil(max(mohoA))]);
% axis([floor(min(lonE)) ceil(max(lonE)) floor(min(latE)) ceil(max(latE)) floor(min(mohoE)) ceil(max(mohoE))]);

Moho_A=reshape(mohoA,[LONA, LATA]);
Moho_E=reshape(mohoE,[LONE, LATE]);
Moho_L=reshape(mohoL,[LONL, LATL]);

% Moho_AD13=reshape(mohoAD13,[LONAD13,LATAD13]);
% Moho_EU13=reshape(mohoEU13,[LONEU13,LATEU13]);
% Moho_TC13=reshape(mohoTC13,[LONTC13,LATTC13]);

% -------------------------------------------------------------------------
% ---PLOT MOHO AS A 3D LINE PLOT ------------------------------------------
% -------------------------------------------------------------------------
% 1. Plot Moho as a 3D line plot (*) for different plates
figure(1)
hold on;
grid on;
% -------------------------------------------------------------------------
% PLOT MOHO ADRIA
% A=plot3(lonA,latA,-mohoA,'b*');
% -------------------------------------------------------------------------
% PLOT MOHO EUROPE
% E=plot3(lonE,latE,-mohoE,'r*');
% % -------------------------------------------------------------------------
% % PLOT MOHO LIGURIA
 L=plot3(lonL,latL,-mohoL,'g*');
% -------------------------------------------------------------------------
% Plot features
view(3)
title('\fontsize{13}\color{red} 3D line Moho plot for different plates');
xlabel('Longitude [{\circ}]');
ylabel('Latitude [{\circ}]');
zlabel('Moho [km]');
legend('Adria','Europa','Liguria');
legend('Location','northeast')

% -------------------------------------------------------------------------
% 2. Plot Moho as a 3D line plot (-.) 2013 Version
% -------------------------------------------------------------------------
figure(2)
grid on;
hold on;
% -------------------------------------------------------------------------
% PLOT WHOLE MOHO
% plot3(lon13,lat13,-moho13,'y.-.');
% -------------------------------------------------------------------------
% PLOT MOHO ADRIA 2013
A13=plot3(lonAD13,latAD13,-mohoAD13,'b.');
% -------------------------------------------------------------------------
% PLOT MOHO EUROPE 2013
E13=plot3(lonEU13,latEU13,-mohoEU13,'r.');
% -------------------------------------------------------------------------
% % PLOT MOHO TYRRENIA-CORSICA 2013
L13=plot3(lonTC13,latTC13,-mohoTC13,'g.');
% -------------------------------------------------------------------------
% Plot features
view(3)
title('\fontsize{13}\color{red} 3D line Moho plot for different plates 2013 version');
xlabel('Longitude [{\circ}]');
ylabel('Latitude [{\circ}]');
zlabel('Moho [km]');
legend('Adria','Europa','Tyrrenia-Corsica');
legend('Location','northeast')
legend('boxoff')

% -------------------------------------------------------------------------
% 3. Plot all Mohos to find the differences
% -------------------------------------------------------------------------
% set(gcf,'NextPlot','add');
% axes;
% h = title('MyTitle');
% set(gca,'Visible','off');
% set(h,'Visible','on');
figure(3);
subplot(3,1,1)
view(0,0)
grid on;
hold on;
A=plot3(lonA,latA,-mohoA,'c.')
A13=plot3(lonAD13,latAD13,-mohoAD13,'b.');
axis([floor(min(lonAD13)) ceil(max(lonAD13)) floor(min(latAD13)) ceil(max(latAD13))])
title('ADRIA')
xlabel('Longitude [{\circ}]');
ylabel('Latitude [{\circ}]');
zlabel('Moho [km]');

subplot(3,1,2)
view(0,0)
grid on;
hold on;
E=plot3(lonE,latE,-mohoE,'c.');
E13=plot3(lonEU13,latEU13,-mohoEU13,'b.');
axis([floor(min(lonEU13)) ceil(max(lonEU13)) floor(min(latEU13)) ceil(max(latEU13))])
title('EUROPE')
xlabel('Longitude [{\circ}]');
ylabel('Latitude [{\circ}]');
zlabel('Moho [km]');

subplot(3,1,3)
view(0,0)
grid on;
hold on;
L=plot3(lonL,latL,-mohoL,'b.');
L13=plot3(lonTC13,latTC13,-mohoTC13,'c.');
axis([floor(min(lonTC13)) ceil(max(lonTC13)) floor(min(latTC13)) ceil(max(latTC13))])
title('LIGURIA')
xlabel('Longitude [{\circ}]');
ylabel('Latitude [{\circ}]');
zlabel('Moho [km]');

% -------------------------------------------------------------------------
% 4. Plot all Mohos as a surface
% -------------------------------------------------------------------------
figure(4); 
hold on;
grid on;
% Plot contours
contour3(-Moho_A,'-.k');
contour3(-Moho_E,'-.k');
contour3(-Moho_L,'-.k');
% -------------------------------------------------------------------------
% PLOT MOHO ADRIA
surf(-Moho_A);
% -------------------------------------------------------------------------
% PLOT MOHO EUROPE
surf(-Moho_E);
% -------------------------------------------------------------------------
% PLOT MOHO LIGURIA
surf(-Moho_L);
% -------------------------------------------------------------------------
% Plot features
view(-45,75);
shading interp;
load moho;
colormap(moho);
c=colorbar;
c.Label.String = 'Moho Depth [km]';
c.Label.FontSize = 10;
title ('\fontsize{13}\color{red} Surface Moho plot for different plates');
xlabel('Longitude [{\circ}]');
ylabel('Latitude [{\circ}]');
zlabel('Moho [km]');
x=linspace(min(lonA),max(lonA),length(unique(lonA)));
y=linspace(min(latA),max(latA),length(unique(latA)));