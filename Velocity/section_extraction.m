% SECTION_EXTRACTION
%
% Extract the velocity values along a vertical section from a data volume
% according to the paper "High-resolution 3-D P-wave model of the Alpine
% crust" by T. Diehl, S. Husen, E. Kissling and N. Deichmann published in
% Geophys. J. Int. in 2009
% -------------------------------------------------------------------------
% Input parameters:
% x1, y1, x2, y2 where:
% x1 Lon of first point  [degrees]
% y1 Lat of first point  [degrees]
% x2 Lon of second point [degrees]
% y2 Lat of second point [degrees]
%
% Output parameters:
% Image of vertical section (x-z, in km) of Vp values shown with the same 
% color scale of the paper of Diehl et al., 2009
% -------------------------------------------------------------------------
% Input files required:
% Diehl2009_vel_3D_regio.xyz (P-Velocity model)
% Diehl.mat (File with all variables)
%
% Input function required:
% project_new.m to transform coordinate system
% interp_pal.m  to interpolate color palette
%
% Input colorbar required - Reproduction of Tobias Diehl's color scale
% pal_start; [3-4 km/s]
% pal_mid;   [4-8 km/s]  
% pal_end;   [8-9 km/s] 
%
% LC-27 March 2017
% -------------------------------------------------------------------------
function section_extraction(x1,y1,x2,y2)
% -------------------------------------------------------------------------
% 1. READ INPUT FILE
% -------------------------------------------------------------------------
tic;
% File with all variables
load ('Diehl.mat');
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
% 5.1 REPRESENTATION - SELECTED POINTS TO VISUALIZE THE CHOSEN TRACK
% -------------------------------------------------------------------------
figure(1);
plot(lon(id_ok),lat(id_ok),'.');
% % Set title and labels
title ('\fontsize{13}\color{red} Points used to draw the vertical section');
xlabel('Longitude [{\circ}]');
ylabel('Latitude [{\circ}]');
% -------------------------------------------------------------------------
% 5.2 REPRESENTATION - VERTICAL VP SECTION
% -------------------------------------------------------------------------
figure(2)
tri = delaunay (XallKM(id_ok),z(id_ok));
trisurf(tri,XallKM(id_ok),YallKM(id_ok),z(id_ok),vp(id_ok));
view(0,0);
% Set colorbar
load pal_start;
load pal_mid;
load pal_end;
diehl3_4=interp_pal(pal_start,14);
diehl4_8=interp_pal(pal_mid,8);
diehl8_9=interp_pal(pal_end,14);
diehl_palette = [diehl3_4(1:end-1,:); diehl4_8(1:end-1,:); diehl8_9];
colormap(diehl_palette);
shading interp
c = colorbar;
colormap(diehl_palette);
caxis ([3 9]);
c.Label.String = 'Vp [km/s]';
c.Label.FontSize = 10;
c.Location='southoutside';
set(gca,'zdir','reverse');
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
end