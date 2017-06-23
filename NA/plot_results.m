% PLOT_RESULTS
% Plot per-layer trade-offs between parameters
% VS1, VS2, H, VPVS; black and gray dots
% Use after read_nad
%
% Updated on 24 Mar 2011
% György Hétenyi
% -------------------------------------------------------------------------

nkeep=round(ne); %Original: nkeep=round(ne/10)
nkeep=50;
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

datas=datas(1:nkeep);
rms=linspace(max(datas),min(datas),lrms+1);
dd=diff(rms);dd=-dd(1)/2;
rms=rms-dd;rms=rms(1:lrms);

scrsz = get(0,'ScreenSize');

for i=1:nblay-1
   hf(i)=figure;
   set(hf(i),   'Position',[scrsz(3)/2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2],'Name',['layer ' num2str(i)],'NumberTitle','off');
   
   for j=1:lrms
   irms=find(abs(datas-rms(j))<=dd);
   col=colmap(round(j*length(colmap)/lrms),:);
   
   if isvpvs==1,subplot(2,3,1);else,subplot(2,2,1);end
   hp=plot(H(irms,i),Vs1(irms,i),'ko');set(hp,'MarkerFaceColor',col,'MarkerEdgeColor',col)
   hold on
   axis([ranges(:,i)' ranges(:,i+nblay)'])
   xlabel('H');ylabel('Vs1');
   grid on
      
   if isvpvs==1,subplot(2,3,2);else,subplot(2,2,2);end
   hp=plot(H(irms,i),Vs2(irms,i),'ko');set(hp,'MarkerFaceColor',col,'MarkerEdgeColor',col)
   hold on
   axis([ranges(:,i)' ranges(:,i+2*nblay)'])   
   xlabel('H');ylabel('Vs2');
   grid on
   if isvpvs==1
      subplot(2,3,3);
      hp=plot(H(irms,i),VpVs(irms,i),'ko');set(hp,'MarkerFaceColor',col,'MarkerEdgeColor',col)
      hold on
      axis([ranges(:,i)' ranges(:,i+3*nblay)'])   
      xlabel('H');ylabel('Vp/Vs');
      grid on
   end   
   if isvpvs==1,subplot(2,3,4);else,subplot(2,2,3);end
   hp=plot(Vs1(irms,i),Vs2(irms,i),'ko');set(hp,'MarkerFaceColor',col,'MarkerEdgeColor',col)
   hold on
   axis([ranges(:,i+nblay)' ranges(:,i+2*nblay)'])   
   xlabel('Vs1');ylabel('Vs2');
   grid on
   if isvpvs==1
      subplot(2,3,5)
      hp=plot(Vs1(irms,i),VpVs(irms,i),'ko');set(hp,'MarkerFaceColor',col,'MarkerEdgeColor',col)
      hold on
      axis([ranges(:,i+nblay)' ranges(:,i+3*nblay)'])   
      xlabel('Vs1');ylabel('VpVs');
      grid on
   end   
   if isvpvs==1
      subplot(2,3,6)
      hp=plot(Vs2(irms,i),VpVs(irms,i),'ko');set(hp,'MarkerFaceColor',col,'MarkerEdgeColor',col)
      hold on
      axis([ranges(:,i+2*nblay)' ranges(:,i+3*nblay)'])   
      xlabel('Vs2');ylabel('VpVs');   
      grid on
   end
   end
   drawnow
end