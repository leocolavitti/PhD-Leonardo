% FAB_MOD_MEAN
% Write best velocity-model into a file to make synthetic RF
% Based on the mean velocity profile obtained after plot_models
%
% Updated on 6 Apr 2006
% György Hétenyi
% -------------------------------------------------------------------------

fic_model=[rep 'model.mean.Model12'];
qa=1450;
qb=600;

fid=fopen(fic_model,'w');

fprintf(fid,'%2i\n',length(di)-3);
for i=1:length(di)-3
   fprintf(fid,' %2i  %5.2f  %5.2f  %5.2f  %5.2f %5.0f. %5.0f.\n',i,pas_d,vsi(i),vsi(i+1),vpvs(i),qa,qb);
end	
fclose(fid)