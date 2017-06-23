% PLOT_MODELS
% Plot all/kept models from NA inversion (VP, VS, VP/VS)
% Use after read_nadG.m script
% 
% Original program written by György Hétenyi 24 Mar 2011
%--------------------------------------------------------------------------

%read_nadG;
nkeep=round(ne); %Original: nkeep=round(ne/10)
nkeep=50;
%--------------------------------------------------------------------------
disp(['Nkeep= ',num2str(nkeep)])
if nkeep==ne disp('(All models shown)'); end

clear H Vs1 Vs2 Vp1 Vp2 vpvs Vs Vp D VpVs;

[datas,i]=sort(data);
models=model(:,i);
%datas=fliplr(datas);
%models=fliplr(models);

nblay=round(nd/4);
dmax=sum(ranges(2,1:nblay-1));
for i=1:nkeep
   H(i,:)=models(1:nblay,i)';
   Vs1(i,:)=models(nblay+1:2*nblay,i)';
   Vs2(i,:)=models(2*nblay+1:3*nblay,i)';
   vpvs(i,:)=models(3*nblay+1:4*nblay,i)';
   
   Vp1(i,:)=Vs1(i,:).*vpvs(i,:);
   Vp2(i,:)=Vs2(i,:).*vpvs(i,:);
   
   d=cumsum(H(i,1:nblay-1));
   D(i,:)=[0 reshape([d;d],1,(nblay-1)*2) dmax];
   Vs(i,:)=reshape([Vs1(i,:);Vs2(i,:)],1,nblay*2);
   Vp(i,:)=reshape([Vp1(i,:);Vp2(i,:)],1,nblay*2);
   VpVs(i,:)=reshape([vpvs(i,:);vpvs(i,:)],1,nblay*2);
end

figure
for i=nkeep:-1:1
   subplot(1,3,1)
   hvp=plot(Vp(i,:),D(i,:));
   ic=.2+((datas(i)-datas(1))*.6/(datas(nkeep)-datas(1)));
   set(hvp,'color',[ic ic ic]);
   hold on
   axis('ij')
   if i==1,set(hvp,'color','b','linewidth',2);end

   subplot(1,3,2)
   hvs=plot(Vs(i,:),D(i,:));
   ic=.2+((datas(i)-datas(1))*.6/(datas(nkeep)-datas(1)));
   set(hvs,'color',[ic ic ic]);
   hold on
   axis('ij')
   if i==1,set(hvs,'color','b','linewidth',2);end
   
   subplot(1,3,3)
   hvp=plot(VpVs(i,:),D(i,:));
   ic=.2+((datas(i)-datas(1))*.6/(datas(nkeep)-datas(1)));
   set(hvp,'color',[ic ic ic]);
   hold on
   axis('ij')
   if i==1,set(hvp,'color','b','linewidth',2);end
end   

% Compute the mean model
clear mvpm mvpsm mvpvsm;

pas_d=1;
di=[0:pas_d:dmax];
vpm=zeros(size(di));vsm=zeros(size(di));vpvsm=zeros(size(di));
for i=1:nkeep
   d=cumsum(H(i,1:nblay-1));
   d=[0 reshape([d;d+.05],1,(nblay-1)*2) dmax];
   vpi=interp1(d,Vp(i,:),di);
   vsi=interp1(d,Vs(i,:),di);
   vpvsi=interp1(d,VpVs(i,:),di);
   vpm=vpm+vpi;
   vsm=vsm+vsi;
   vpvsm=vpvsm+vpvsi;
   mvpm(i)=mean(1/mean(1./vpi(1:floor(d(round((nblay*2-1)/pas_d))))));
   mvsm(i)=mean(1/mean(1./vsi(1:floor(d(round((nblay*2-1)/pas_d))))));
   mvpvsm(i)=mean(vpvsi(1:floor(d(round((nblay*2-1)/pas_d)))));
end
vpm=vpm/nkeep;
vsm=vsm/nkeep;   
vpvsm=vpvsm/nkeep;

subplot(1,3,1)
hvpm=plot(vpm,di,'r');set(hvpm,'LineWidth',2);
title(['mean Vp = ' num2str(mean(mvpm))])

subplot(1,3,2)
hvsm=plot(vsm,di,'r');set(hvsm,'LineWidth',2);
title(['mean Vs = ' num2str(mean(mvsm))])

subplot(1,3,3)
hvpvsm=plot(vpvsm,di,'r');set(hvpvsm,'LineWidth',2);
title(['mean Vp/Vs = ' num2str(mean(mvpvsm))])   