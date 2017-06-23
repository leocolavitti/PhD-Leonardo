% FAB_MOD_BEST
% Write best velocity-model into a file to make synthetic RF
% Based on the best velocity profile obtained after plot_models
%
% Updated on 6 Apr 2006
% György Hétenyi
% -------------------------------------------------------------------------

fic_model=[rep 'model.best.Model12'];
qa=1450;
qb=600;

fid=fopen(fic_model,'w');

fprintf(fid,'%2i\n',nblay);
for i=1:nblay
   fprintf(fid,' %2i  %5.2f  %5.2f  %5.2f  %5.2f %5.0f. %5.0f.\n',i,H(1,i),Vs1(1,i),Vs2(1,i),vpvs(1,i),qa,qb);
end	
fclose(fid)