% BIAIS
% Plot all trade-offs between all possible couples of parameters
%
% Updated on 24 Mar 2011
% György Hétenyi
% -------------------------------------------------------------------------

nkeep=round(ne); % nkeep=round(ne/100) LC
Nlayer=nd/4-1;
onlyH=0;

% -------------------------------------------------------------------------
RMSV=data;
%rms_tmpG   % to represent rms-values and where the cutoff is
clear RMSV
% -------------------------------------------------------------------------
% make everything clean
clear D H Vs1 Vs2 VpVs;

[datas,i]=sort(data);
models=model(:,i);
nblay=nd/4;

for i=1:nkeep
   H(i,:)=models(1:nblay,i)';
   Vs1(i,:)=models(nblay+1:2*nblay,i)';
   Vs2(i,:)=models(2*nblay+1:3*nblay,i)';
   VpVs(i,:)=models(3*nblay+1:4*nblay,i)';
end
datas=datas(1:nkeep);

DMIN=min(datas); DMAX=max(datas);

C=hsv; close;
%C=C(1:length(C)/2,:);

for i=1:nkeep
   dat(i)=(length(C)-1)*((datas(i)-DMIN)/(DMAX-DMIN));
   datdens(i)=round(dat(i))+1;
end

for i=1:nkeep
      X(1,i)=H(i,1);  X(2,i)=Vs1(i,1);  X(3,i)=Vs2(i,1);  X(4,i)=VpVs(i,1);
   if Nlayer>=2
      X(5,i)=H(i,2);  X(6,i)=Vs1(i,2);  X(7,i)=Vs2(i,2);  X(8,i)=VpVs(i,2);
   end
   if Nlayer>=3
      X(9,i)=H(i,3);  X(10,i)=Vs1(i,3); X(11,i)=Vs2(i,3); X(12,i)=VpVs(i,3);
   end   
   if Nlayer>=4
      X(13,i)=H(i,4); X(14,i)=Vs1(i,4); X(15,i)=Vs2(i,4); X(16,i)=VpVs(i,4);
   end
end
 txt{1}='H1';  txt{2}='VS11';  txt{3}='VS12';  txt{4}='VpVs1';
 txt{5}='H2';  txt{6}='VS21';  txt{7}='VS22';  txt{8}='VpVs2';
 txt{9}='H3'; txt{10}='VS31'; txt{11}='VS32'; txt{12}='VpVs3';
txt{13}='H4'; txt{14}='VS41'; txt{15}='VS42'; txt{16}='VpVs4';


if onlyH
   clear X txt;
   for i=1:nkeep
      X(1,i)=H(i,1);
      if Nlayer>=2 X(2,i)=H(i,2); end
      if Nlayer>=3 X(3,i)=H(i,3); end
      if Nlayer>=4 X(4,i)=H(i,4); end
   end
   txt{1}='H1';  txt{2}='H2';  txt{3}='H3';  txt{4}='H4';
end


L=size(X,1);     % # of variables
switch L         % # rws, columns
   case(1); disp('Error'); case(2); r=1; c=1;  case(3); r=1; c=3;
   case(4); r=3; c=2;      case(5); r=5; c=2;  case(6); r=5; c=3;
   case(7); r=7; c=3;      case(8); r=7; c=4;  case(9); r=6; c=3;
   case(10); r=6; c=4;    case(11); r=7; c=4; case(12); r=6; c=4;
   case(13); r=5; c=4;    case(14); r=6; c=4; case(15); r=7; c=5;
   case(16); r=6; c=5;
end

iplmax=r*c;      % # of plot per page
oszt2=1;         % 1/# of samples
m35=18;          % point size
ipl=0;           % subplot index
figure

disp(['Total: ',num2str(L*(L-1)/2),' figures... be patient!'])

for i1=1:L
   for i2=i1+1:L

      ipl=ipl+1;
      if ipl>iplmax
         ipl=ipl-iplmax; figure;
      end
      disp(ipl);
      hold on; subplot(r,c,ipl); hold on;

      for i=round(nkeep/oszt2):-1:1
         p=plot(X(i1,i),X(i2,i),'.');
         set(p,'Color',[C(datdens(i),:)],'MarkerSize',m35);
      end

%      xl=xlim; yl=ylim;
      box on
      dxa=max(X(i1,:))-min(X(i1,:));
      dya=max(X(i2,:))-min(X(i2,:));
      xlim([min(X(i1,:))-dxa/10 max(X(i1,:))+dxa/10])
      ylim([min(X(i2,:))-dya/10 max(X(i2,:))+dya/10])
      XLAB=xlabel(txt{i1}); YLAB=ylabel(txt{i2});
      drawnow;
   end
end

%---------
%figure
%hold on;
%for i=1:length(C)
%   p=plot(i,i,'x');
%   set(p,'Color',[C(i,:)],'MarkerSize',15);
%   p=plot(i,i,'o');
%   set(p,'Color',[C(i,:)],'MarkerSize',15);
%end
%title('COLOR PALETTE !!')