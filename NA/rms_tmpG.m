% RMS_TMPG
% Represent all model's rms, sorted, and cutoff level with red star
%
% Updated on 24 Mar 2011
% Gy�rgy H�tenyi
% -------------------------------------------------------------------------

tmp=sort(RMSV);
figure
plot(tmp); hold on; 
h=plot(nkeep,tmp(nkeep),'r*');
set(h,'markersize',12)
disp('press any key to continue')
pause
close
