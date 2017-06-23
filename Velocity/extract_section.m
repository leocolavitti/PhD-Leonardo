% EXTRACT_SECTION
% Alternative SCRIPT to the function section_extraction
% Extract the velocity values along a vertical section from a data volume
% 
% Reference paper: "High-resolution 3-D P-wave model of the Alpine crust"
% by T. Diehl, S. Husen, E. Kissling and N. Deichmann published in
% Geophys. J. Int. in 2009
%
% Input files required:
% Diehl2009_vel_3D_regio.xyz (P-Velocity model)
%
% Input parameters:
% lon1, lat1, lon2, lat2 (Extreme of the section you want to see, in degrees)
%
% Output parameters:
% Vertical section (x-z, in km) of Vp values shown with the same scale of
% the paper of Diehl et al., 2009
%
% Leonardo Colavitti
% 22 March 2017
% -------------------------------------------------------------------------

% Clear command window and workspace
tic;
clear; close all; clc;
% -------------------------------------------------------------------------
% 1. READ INPUT FILE
% -------------------------------------------------------------------------
% File with all variables
load ('Diehl.mat');
% Here goest the input 
x1=7.23; y1=48.0; x2=10.39; y2=44.0;
% Define boundaries
minlon=unique(min(lon));
maxlon=unique(max(lon));
minlat=unique(min(lat));
maxlat=unique(max(lat));
minz  =unique(min(z));
maxz  =unique(max(z));
% -------------------------------------------------------------------------
% 2. PUT INPUT VALIDITY CONDITION
% -------------------------------------------------------------------------
% Control on first input point   
if x1 < minlon || y1 < minlat 
    fprintf('Boundary of First point wrong!\n')
return
% Control on second input point
elseif x2 > maxlon || y2 > maxlat
    fprintf('Boundary of Second point wrong!\n')
return
else
fprintf('Your input values are OK!\n')
end
% -------------------------------------------------------------------------
% 3. INPUT CREATION
% -------------------------------------------------------------------------
% Define grid spacing [use lat]
ulat=unique(lat);
space=mean(diff(ulat));
% Control if grid spacing is homogeneous
if max(diff(ulat))>2*space || min(diff(ulat))<0.5*space;
    disp('Spacing of latitudes is not really homogeneous!');
    pause % If the spacing is not homogeneous, the program ends here
end
% Covert grid spacing in km
spaceKM=space*111.195;
% -------------------------------------------------------------------------
% 4. SELECT POINTS
% -------------------------------------------------------------------------
% Initialize the output
Yall=nan(size(lat)); Xall=Yall;
% Projection of all lat, lon points in a new system 
% starting from y1,x1 and ending in y2, x2
[y1t,x1t,y2t,x2t,Yall,Xall] = project_new(y1,x1,y2,x2,lat,lon);
% Conversion of outputs in km
YallKM=Yall*111.195;
XallKM=Xall*111.195;
% Point Selection
id_ok=find( abs(YallKM) < 1*spaceKM*sqrt(2)  &  Xall>=x1t  &  Xall<=x2t );
% -------------------------------------------------------------------------
% 5. REPRESENTATION
% -------------------------------------------------------------------------
% Representation of selected points
figure(1);
plot(lon(id_ok),lat(id_ok),'.');
% Set title and labels
title ('\fontsize{13}\color{red} Points used to draw the vertical section');
xlabel('Longitude [{\circ}]');
ylabel('Latitude [{\circ}]');
% -------------------------------------------------------------------------
% Representation of vertical Vp section
figure(2);
tri = delaunay (XallKM(id_ok),z(id_ok));
trisurf(tri,XallKM(id_ok),YallKM(id_ok),z(id_ok),vp(id_ok));
view(0,0);
% Set colorbar and relative limits
hold on;
shading interp;
c=colorbar;
c.Label.String = 'Vp [km/s]';
c.Label.FontSize = 10;
c.Limits = [3 9];
set(gca,'zdir','reverse');
load velocity_diehl;
colormap(velocity_diehl);
velocity2_diehl=interp_pal(velocity_diehl,10);
colormap(velocity2_diehl);
hold on;
% Set title, limits, labels and aspect 
title ('\fontsize{13}\color{red} Vertical velocity section');
xlabel('Longitude [km]');
zlabel('Moho [km]');
xlim ([0 ceil(max(XallKM(id_ok)))]);
zlim ([0 80]);
axis equal;
daspect ([2 2 1]);
toc;