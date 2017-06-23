function [ latTa,lonTa,latTb,lonTb,latT,lonT ] = project_new(latA,lonA,latB,lonB,lat,lon )
% [latTa,lonTa,latTb,lonTb,latT,lonT] = PROJECT_NEW(latA,lonA,latB,lonB,lat,lon)
% Coordinate system transformation
%
% Inputs:
% latA, lonA coordinates of starting point (in degrees)
% latB, lonB coordinates of ending points  (in degrees)
% lat , lon  list of coordinates of ALL points to project (in degrees)
%
% Ouputs:
% latTa, lonTa transform coordinates of starting points (in degrees)
% latTb, lonTb transform coordinates of ending points (in degrees)
% latT , lonT  list of transformed coordinate of ALL points (in degrees)
%
% Leonardo Colavitti 
% 21 March 2017
% -------------------------------------------------------------------------

% System definition
alpha = azimuth(latA,lonA,latB,lonB,'degrees');
origin = newpole(90-latA,180+lonA);
origin(3)=90-alpha;
% Conversion
[latTa,lonTa] = rotatem(latA,lonA,origin,'forward','degrees');
[latTb,lonTb] = rotatem(latB,lonB,origin,'forward','degrees');
[latT ,lonT ] = rotatem(lat ,lon ,origin,'forward','degrees');
end