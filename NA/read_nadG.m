% READ_NADG
% This script reads na.nad result file of the NA inversion
%
% Original program by György Hétenyi
% Edited by Leonardo Colavitti
% 19.12.2016
% -------------------------------------------------------------------------

clear all;
% Write here the path of your access directory
rep='/Users/lcolavit/NA/NA/data/Model12/';
% Make everything clean
%clear A a am ans avg data fichnad fidnad huser i model mopt moptm mul nd ne nh nha
%clear nhu nr ns ns1 ranges scales

% -------------------------------------------------------------------------
i=strfind(rep,'/');
disp([ 'Reading: ' rep(i(end-1)+1:end-1) ]);
fichnad=[ rep 'na.nad.Model12'];
fidnad=fopen(fichnad,'rb');

A=fread(fidnad,4,'int32');
if A(1)>0   %single record
   mul=0; nd=A(1); ne=A(2); nh=A(3); nhu=A(4);
else
   mul=-A(1); nd=A(2); ne=A(3); nh=A(4);
   nhu=fread(fidnad,1,'int32');
end

% Read header
A=fread(fidnad,3,'int');
ns1=A(1); ns=A(2); nr=A(3);
ranges=fread(fidnad,nd*2,'float'); ranges=reshape(ranges,2,nd);
scales=fread(fidnad,nd+1,'float');

huser=fread(fidnad,nhu,'char');

if mul>0
   %header=fread(fidnad,nh,'char');
   A=fread(fidnad,1,'float');
   while A<1e-5
      A=fread(fidnad,1,'float');
   end   
   for i=1:ne
      if i==1
         model(1,i)=A;
         model(2:nd,i)=fread(fidnad,nd-1,'float');
      else   
         model(:,i)=fread(fidnad,nd,'float');
      end   
      data(i)=fread(fidnad,1,'float');
   end      
else
   %header=fread(fidnad,nh,'char');
   model=fread(fidnad,nd*ne,'float');   
   data=fread(fidnad,ne,'float');   
end
fclose(fidnad);

nha = nh - nhu;
disp(' Summary of nad file read in:____________')
disp([' Number of variables                  = ',num2str(nd)])
disp([' Number of models                     = ',num2str(ne)])
%disp([' Total length of header               = ',num2str(nh)])
%disp([' Length of reserved header            = ',num2str(nha)])
%disp([' Length of user header                = ',num2str(nhu)])
disp(' ')

[a,mopt]=min(data);
[am,moptm]=max(data);
avg=mean(data);

disp([' Minimum misfit value                 = ',num2str(a)])
disp([' Maximum misfit value                 = ',num2str(am)])
disp([' Average misfit over all models       = ',num2str(avg)])
%disp([' Model with minimum misfit value      = ',num2str(mopt)])
%disp([' Model with maximum misfit value      = ',num2str(moptm)])
disp(' ')

disp([' Number of iterations                 = ',num2str((ne-ns1)/ns)])
disp([' Number of samples in first iteration = ',num2str(ns1)])
disp([' Number of samples in other iterations= ',num2str(ns)])
disp([' Number of resampled cells            = ',num2str(nr)])
%disp([' Scale parameter                      = ',num2str(scales(1))])

disp([' Boundaries of parameter space:'])
for i=1:nd
fprintf('%2i  %5.2f  %5.2f  %5.2f\n', i, ranges(1,i), ranges(2,i), scales(i+1))
end
%hold on; plot(sort(data))