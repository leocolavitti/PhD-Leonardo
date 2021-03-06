function [Z,R,T]=rotZNE2ZRT(Z,N,E,baz)
% [Z,R,T]=rotZNE2ZRT(Z,N,E,<baz>)
%
% Transforms a signal (or a group of signals) from Z-N-E system to Z-R-T system.
%
% Input:
% Z - vertical component
% N - North component
% E - East component
% baz - backazimuth (degrees) for the rotation
% Output:
% Z - vertical component
% R - radial component
% T - transverse component
% Notes:
% Signals are in SAC format.
% If the "baz" is not included, Z.baz will be used.
% 
% Original program by Gy�rgy H�tenyi
% Edited by Leonardo Colavitti
% 21.06.2016
% -------------------------------------------------------------------------
for i=1:length(Z);
   % Condition: if "baz" is not included
   if nargin<4;
      alpha=Z(i).baz*pi/180;
   % Condition: if "baz" is included
   else
         alpha=baz(i)*pi/180;
   end   
% -------------------------------------------------------------------------  
   % Compute Rotation Matrix
   
   % Define M
   M = [1       0           0,
        0 -cos(alpha) -sin(alpha),
        0  sin(alpha) -cos(alpha)];
   
   % Define S 
   S=M*[Z(i).trace';N(i).trace';E(i).trace'];
   
   R(i)=N(i); % Radial component
   T(i)=E(i); % Transverse component
   R(i).trace=S(2,:)'; % Radial trace component
   T(i).trace=S(3,:)'; % Transverse trace component  
end