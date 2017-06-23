function Cout=interp_pal(Cin,n);
% Cout=INTERP_PAL(Cin,n)
% Interpolation of a color-palette "Cin" by a factor n
% Revised 08 Apr 2008
% -------------------------------------------------------------------------

xCin=[0:size(Cin,1)-1]*n;
xCout=[0:max(xCin)];
%size(Cin)
Cout1=interp1(xCin,Cin(:,1),xCout);
Cout2=interp1(xCin,Cin(:,2),xCout);
Cout3=interp1(xCin,Cin(:,3),xCout);
Cout=[Cout1;Cout2;Cout3];
Cout=Cout';