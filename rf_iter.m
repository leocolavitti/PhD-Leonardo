function RF=rf_iter(Z,R,nb)

% RF=rf_iter(Z,R,<nb>)
%
% Iterative deconvolution method
% based on Ligorria & Ammon (BSSA,89-5,1999)
%
% Inputs:
%   Z (SAC-structure)   : trace, base of the deconvolution
%   R (SAC-structure)   : trace to deconvolve
%   nb: default = 30    : number of iterations
%
% Ouput:
%   RF (SAC-structure)  : same format as R except that trace is the RF
%
% Note: optional parameters to set inside the function
% Revised 16 Feb 2005 GH
% Revised 16 Mar 2016 GH

% ----------------------------------------
% OPTIONAL PARAMETERS

is_plot=0;    % 1 to represent the evolution at each step
is_all=1;     % 1 to deconvolve the entire R.trace;
              % 0 to deconvolve R only at a length equal to Z.trace
is_conv=0;    % 1 to convolve the RF by a gaussian
paramconv=.4; % parameter to set width of the Gaussian (if is_conv=1)

% ----------------------------------------      

if nargin<3   % if number of iterations was not provided
   nb = 30;
end      

% 1- Handle traces
% -----------------
RF=R;         % RF header is like R (trace will be changed)
if size(Z.trace,2)==1,trZ=Z.trace;else,trZ=Z.trace';end
if size(R.trace,2)==1,trR=R.trace;else,trR=R.trace';end   
nz=length(trZ);
nr=length(trR);
if nz>nr,trZ=trZ(1:nr);end      % cut Z trace if it is longer than R

% 2- Deconvolution
% -----------------
dirac_sum=zeros(nr,1);    % empty vector for RF
xcz=xcorr_GH(trZ,trZ);       % autocorrelation of the vertical trace
mxcz=max(abs(xcz));       % reference (max.) amplitude
trH=trR;                  % radial trace that will be updated/diminished
ii=0;                     % loop counter

while ii<nb
   ii=ii+1;               % increment loop
      %if mod(ii,100)==0 disp(['iteration no. ' n2s(ii)]); end
   dirac=zeros(nr,1);     % empty vector for this loop
      %% before 08.10.2001. (ask JV why): xcr=conv(trZ,trH); 
   xcr=xcorr_GH(trZ,trH);    % cross-correlation to find shift w. best fit
   
   if is_all==0           % deconvolve full/reduced trace
      [mxcr,ixcr]=max(abs(xcr(nr:2*nr-nz-1)));
   else
      [mxcr,ixcr]=max(abs(xcr(nr:nr+nz-1)));
   end

   dirac(ixcr)=xcr(ixcr+nr-1)/mxcz;    % place dirac at max. xcorr loc.

   newh=conv(trZ,dirac);  % adding a dirac takes away this from R trace
   newh=newh(1:nr);       % limit length
   
   if is_plot==1          % graphical representation
      time=[1:length(dirac_sum)]*R.delta;
      subplot(3,1,1)
        plot(xcr(nr:nr+nz-1)/mxcz);           hold on
        plot(ixcr,xcr(ixcr+nr-1)/mxcz,'r*');  hold off
      subplot(3,1,2)
        plot(time,dirac_sum);    hold on
        plot(time,dirac,'r');    hold off
      subplot(3,1,3)
        plot(time,trH,'k--');    hold on
        plot(time,trH-newh,'r'); hold off
      drawnow
      pause
   end
   
   dirac_sum=dirac_sum+dirac;   % add this loop's dirac to overall RF
   trH=trH-newh;                % substract effect from R trace
end

% 3- Write results
% -----------------
RF.trace=dirac_sum;             % all diracs = RF
RF.kcmpnm=[R.kcmpnm 'RFi'];     % update channel name

if is_conv==1                   % convolve with Gaussian if needed
   RF=conv_gauss(RF,paramconv);
end   

%-end-of-script--------------------------------------------------------!
