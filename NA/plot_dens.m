% PLOT_DENS
% Show sampling values between two variables, per layer
% H--VS1 , H--VS2 , VS1--VS2
% Use after read_nadG.m script
% 
% Original program written by György Hétenyi 24 Mar 2011
%--------------------------------------------------------------------------

nkeep=round(ne);
nkeep=50;
lrms=20;
ldens=20;
isvpvs=1;
colmap=flipud(bone); %flipud(gray);
close
%--------------------------------------------------------------------------
disp(['Nkeep= ',num2str(nkeep)])
if nkeep==ne disp('(All models shown)'); end

clear D H Vs1 Vs2 VpVs

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
rmsv=linspace(max(datas),min(datas),lrms+1);
dd=diff(rmsv);   dd=-dd(1);%/2;   % #### ???? ???? ????
rmsv=rmsv-dd;    rmsv=rmsv(1:lrms);

scrsz = get(0,'ScreenSize');

for i=1:nblay-1
   hf(i)=figure;
   set(hf(i),   'Position',[scrsz(3)/2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2],'Name',['layer ' num2str(i)],'NumberTitle','off');
   
   clear D;
   
   D(1).xx=linspace(ranges(1,i),ranges(2,i),ldens);             dx=diff(D(1).xx);D(1).dx=dx(1);
   D(1).yy=linspace(ranges(1,i+nblay),ranges(2,i+nblay),ldens); dy=diff(D(1).yy);D(1).dy=dy(1);   
   D(1).dens=zeros(length(D(1).xx),length(D(1).yy));
   
   D(2).xx=linspace(ranges(1,i),ranges(2,i),ldens);                 dx=diff(D(2).xx);D(2).dx=dx(1);
   D(2).yy=linspace(ranges(1,i+2*nblay),ranges(2,i+2*nblay),ldens); dy=diff(D(2).yy);D(2).dy=dy(1);   
   D(2).dens=zeros(length(D(2).xx),length(D(2).yy));
   
   D(3).xx=linspace(ranges(1,i),ranges(2,i),ldens);                 dx=diff(D(3).xx);D(3).dx=dx(1);
   D(3).yy=linspace(ranges(1,i+3*nblay),ranges(2,i+3*nblay),ldens); dy=diff(D(3).yy);D(3).dy=dy(1);   
   D(3).dens=zeros(length(D(3).xx),length(D(3).yy));
   
   D(4).xx=linspace(ranges(1,i+nblay),ranges(2,i+nblay),ldens);     dx=diff(D(4).xx);D(4).dx=dx(1);
   D(4).yy=linspace(ranges(1,i+2*nblay),ranges(2,i+2*nblay),ldens); dy=diff(D(4).yy);D(4).dy=dy(1);   
   D(4).dens=zeros(length(D(4).xx),length(D(4).yy));
   
   D(5).xx=linspace(ranges(1,i+nblay),ranges(2,i+nblay),ldens);     dx=diff(D(5).xx);D(5).dx=dx(1);
   D(5).yy=linspace(ranges(1,i+3*nblay),ranges(2,i+3*nblay),ldens); dy=diff(D(5).yy);D(5).dy=dy(1);   
   D(5).dens=zeros(length(D(5).xx),length(D(5).yy));
   
   D(6).xx=linspace(ranges(1,i+2*nblay),ranges(2,i+2*nblay),ldens); dx=diff(D(6).xx);D(6).dx=dx(1);
   D(6).yy=linspace(ranges(1,i+3*nblay),ranges(2,i+3*nblay),ldens); dy=diff(D(6).yy);D(6).dy=dy(1);   
   D(6).dens=zeros(length(D(6).xx),length(D(6).yy));
   
   for j=1:lrms
      irms=find(abs(datas-rmsv(j))<=dd);
      col=colmap(round(j*length(colmap)/lrms),:);

      ix=round((H(irms,i)-D(1).xx(1))/D(1).dx)+1;
      iy=round((Vs1(irms,i)-D(1).yy(1))/D(1).dy)+1;
      ind=sub2ind(size(D(1).dens),ix,iy);
      [ind,nind]=unique(ind);
      D(1).dens(ind)=D(1).dens(ind)+nind;

      ix=round((H(irms,i)-D(2).xx(1))/D(2).dx)+1;
      iy=round((Vs2(irms,i)-D(2).yy(1))/D(2).dy)+1;
      ind=sub2ind(size(D(2).dens),ix,iy);
      [ind,nind]=unique(ind);
      D(2).dens(ind)=D(2).dens(ind)+nind;

      if isvpvs==1
         ix=round((H(irms,i)-D(3).xx(1))/D(3).dx)+1;
         iy=round((VpVs(irms,i)-D(3).yy(1))/D(3).dy)+1;
         ind=sub2ind(size(D(3).dens),ix,iy);
         [ind,nind]=unique(ind);
         D(3).dens(ind)=D(3).dens(ind)+nind;
      end   

      ix=round((Vs1(irms,i)-D(4).xx(1))/D(4).dx)+1;
      iy=round((Vs2(irms,i)-D(4).yy(1))/D(4).dy)+1;
      ind=sub2ind(size(D(4).dens),ix,iy);
      [ind,nind]=unique(ind);
      D(4).dens(ind)=D(4).dens(ind)+nind;

      if isvpvs==1
         ix=round((Vs1(irms,i)-D(5).xx(1))/D(5).dx)+1;
         iy=round((VpVs(irms,i)-D(5).yy(1))/D(5).dy)+1;
         ind=sub2ind(size(D(5).dens),ix,iy);
         [ind,nind]=unique(ind);
         D(5).dens(ind)=D(5).dens(ind)+nind;
      end   
      if isvpvs==1
         ix=round((Vs2(irms,i)-D(6).xx(1))/D(6).dx)+1;
         iy=round((VpVs(irms,i)-D(6).yy(1))/D(6).dy)+1;
         ind=sub2ind(size(D(6).dens),ix,iy);
         [ind,nind]=unique(ind);
         D(6).dens(ind)=D(6).dens(ind)+nind;
      end
   end

   if isvpvs==1,subplot(2,3,1);else,subplot(2,2,1);end
   
   pcolor(D(1).xx,D(1).yy,D(1).dens')
   shading flat
   xlabel('H');ylabel('Vs1')
   
   if isvpvs==1,subplot(2,3,2);else,subplot(2,2,2);end

   pcolor(D(2).xx,D(2).yy,D(2).dens')
   shading flat
   xlabel('H');ylabel('Vs2')

   if isvpvs==1,subplot(2,3,3)
      pcolor(D(3).xx,D(3).yy,D(3).dens')
      shading flat
      xlabel('H');ylabel('VpVs')   
   end   

   if isvpvs==1,subplot(2,3,4);else,subplot(2,2,3);end
   
   pcolor(D(4).xx,D(4).yy,D(4).dens')
   shading flat
   xlabel('Vs1');ylabel('Vs2')
   
   if isvpvs==1,subplot(2,3,5)
      pcolor(D(5).xx,D(5).yy,D(5).dens')
      shading flat
      xlabel('Vs1');ylabel('VpVs')   
   end   
   
   if isvpvs==1,subplot(2,3,6)
      pcolor(D(6).xx,D(6).yy,D(6).dens')
      shading flat
      xlabel('Vs2');ylabel('VpVs')   
   end  
   
end