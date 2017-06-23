% ROT_ALL
% Rotate ZNE traces to ZRT traces
% This script allows to rotate ZNE traces to ZRT traces for HH component
% Function requested: rotZNE2RT
% 
% EXAMPLE:
% 1 earthquake happened the 6 April 2010 at 22:54:06 (M=5.3) in Northern Sumatra, Indonesia
% Input:
% 100406T225406.AIGLE.Z.SAC
% 100406T225406.AIGLE.N.SAC
% 100406T225406.AIGLE.E.SAC
% Output:
% 100406T225406.AIGLE.Z.SAC
% 100406T225406.AIGLE.R.SAC
% 100406T225406.AIGLE.T.SAC
%
% Original program by György Hétenyi
% Edited by Leonardo Colavitti
% 21.06.2016
% -------------------------------------------------------------------------
clear; close all; clc;
% -------------------------------------------------------------------------
% SELECT TRACES 
% (Change the line below in the path where the traces are located!)
% -------------------------------------------------------------------------
% FDSNWS Switzerland
% dir0 = '/Users/lcolavit/Database/Data_Swiss/ZNE_file/';
% FDSNWS France
% dir0 = '/Users/lcolavit/Database/Data_Foreign/ZNE_file/FDSNWS/FR/';
% FDSNWS HH Italy
% dir0 = '/Users/lcolavit/Database/Data_Foreign/ZNE_file/FDSNWS/IT/HH/';
% FDSNWS HH Austria 
dir0 = '/Users/lcolavit/Database/Data_Foreign/ZNE_file/FDSNWS/OE/HH/';
% ARCLINK HH Italy, Civil Defense, Germany, Austria
% dir0 = '/Users/lcolavit/Database/Data_Foreign/ZNE_file/ARCLINK/HH/';

% -------------------------------------------------------------------------
% READING TRACES
% -------------------------------------------------------------------------
% Reading a text file with all traces information
% Change this line with the file of all traces for a single station
L=textread([dir0,'Rot_RETA'],'%s'); 
NL=length(L);
% Display check reading file
disp(['Processing ' num2str(NL) ' files...']);

% -------------------------------------------------------------------------
% ROTATION
% -------------------------------------------------------------------------
% Start loop on traces
for i=1:3:NL;
   if mod(i-1,300)==0; disp(i-1); end
   % Clear all parameters
   clear Z N E R T delta azeqst azsteq woutR woutT
   
   E=readsac(L{i});     % Read component E
   N=readsac(L{i+1});   % Read component N
   Z=readsac(L{i+2});   % Read component Z

   % Display error if trace lengths is different
   if (length(Z.trace)~=length(N.trace) || length(Z.trace)~=length(E.trace));
      disp('Different trace lengths!');
   else
   % Trace length is equal,use function [delaz] to compute earthquake/station distance and azimuth    
      [delta,azeqst,azsteq]=delaz(Z.evla,Z.evlo,Z.stla,Z.stlo,0);   
      
      % Display error if it is an Azimuth mismatch 
      % --- PROBLEM: AZIMUTH MISMATCH !!!
      if abs(Z.baz-azsteq)>1; 
      disp(['Azimuth mismatch:' num2str(Z.baz) ' ' num2str(azsteq)]);
      return
      
      % Do the rotation
      else
         Z.gcarc=delta; Z.az=azeqst; Z.baz=azsteq; % Z component
         N.gcarc=delta; N.az=azeqst; N.baz=azsteq; % N component       
         E.gcarc=delta; E.az=azeqst; E.baz=azsteq; % E component 
      
         [Z,R,T]=rotZNE2ZRT(Z,N,E);  
         woutR=L{i}; woutR(end-4)='R';  % Write out 'R' instead of 'N'
         woutT=L{i}; woutT(end-4)='T';  % Write out 'T' instead of 'E'
         
         R.cmpaz=Z.baz;
         R.kcmpnm='R';
         T.cmpaz=mod(Z.baz+90,360);
         T.kcmpnm='T';
         
         writesac(R,woutR); % write out R
         writesac(T,woutT); % write out T
      end 
   end 
end
disp('Rotations done') % Display check: Rotations computed!