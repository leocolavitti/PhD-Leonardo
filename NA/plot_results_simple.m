% PLOT_RESULTS_SIMPLE
% Plot per-layer trade-offs between parameters
% VS1, VS2, H, VPVS; black only
% Use after read_nad
%
% Updated on 24 Mar 2011
% György Hétenyi
% -------------------------------------------------------------------------

nkeep=round(ne/10);
%nkeep=50;
lrms=20;
isvpvs=1;
colmap=flipud(bone); %flipud(gray);
close

%-------------------------------------------------------------
disp(['Nkeep= ',num2str(nkeep)])
if nkeep==ne disp('(All models shown)'); end

clear H Vs1 Vs2 VpVs;

[datas,i]=sort(data);
models=model(:,i);
nblay=round(nd/4);
dmax=sum(ranges(2,1:nblay-1));
for i=1:nkeep
   H(i,:)=models(1:nblay,i)';
   Vs1(i,:)=models(nblay+1:2*nblay,i)';
   Vs2(i,:)=models(2*nblay+1:3*nblay,i)';
   VpVs(i,:)=models(3*nblay+1:4*nblay,i)';
end

for i=1:nblay-1
   figure
   subplot(2,3,1)
   hp=plot(H(:,i),Vs1(:,i),'ko');set(hp,'MarkerFaceColor','k')
   axis([ranges(:,i)' ranges(:,i+nblay)'])
   xlabel('H');ylabel('Vs1');
   grid on
   subplot(2,3,2)
   hp=plot(H(:,i),Vs2(:,i),'ko');set(hp,'MarkerFaceColor','k')
   axis([ranges(:,i)' ranges(:,i+2*nblay)'])   
   xlabel('H');ylabel('Vs2');
   grid on
   subplot(2,3,3)
   hp=plot(H(:,i),VpVs(:,i),'ko');set(hp,'MarkerFaceColor','k')
   axis([ranges(:,i)' ranges(:,i+3*nblay)'])   
   xlabel('H');ylabel('Vp/Vs');
   grid on
   subplot(2,3,4)
   hp=plot(Vs1(:,i),Vs2(:,i),'ko');set(hp,'MarkerFaceColor','k')
   axis([ranges(:,i+nblay)' ranges(:,i+2*nblay)'])   
   xlabel('Vs1');ylabel('Vs2');
   grid on
   subplot(2,3,5)   
   hp=plot(Vs1(:,i),VpVs(:,i),'ko');set(hp,'MarkerFaceColor','k')
   axis([ranges(:,i+nblay)' ranges(:,i+3*nblay)'])   
   xlabel('Vs1');ylabel('VpVs');
   grid on
   subplot(2,3,6)   
   hp=plot(Vs2(:,i),VpVs(:,i),'ko');set(hp,'MarkerFaceColor','k')
   axis([ranges(:,i+2*nblay)' ranges(:,i+3*nblay)'])   
   xlabel('Vs2');ylabel('VpVs');   
   grid on
end