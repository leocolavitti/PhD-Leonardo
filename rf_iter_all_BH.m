% Iterative time domain RF deconvolution
% Input: rotated ZRT data
% 
% Original program by György Hétenyi
% Edited by Leonardo Colavitti
% 05 Jul 2016

% Directories, files
% Input: file with ZNERT data obtained by script rot_all.m

dir0='/Users/lcolavit/Database/ALL_DATA/';
dir1=[dir0 'ZNE_file/BH/'];
dir2=[dir0 'RF/Iter5s_2Hz/BH/']; % Write output here!
event_file=[dir1 'listevents_ALL'];
tr_list_file='/listZNERT'; % Not necessary

% -------------------------------------------------------------------------

% PARAMETERS DEFINITION

% -------------------------------------------------------------------------

lo=1/5;         % Lower cut-off frequency [Hz] 
hi=2;           % High cut-off frequency  [Hz]
cg=0.1592/hi;   % Gaussian convolution width = 1/(2*pi*hi)
iter=100;       % Number of iterations in deconvolution
hann=15;        % Hanning window
orderf=2;       % filter order
tbefore=30;     % tbefore to keep
tafter=120;     % tafter to keep
calc_rms=0;     % RMS computation
fsamp=10;       % Final sampling rate
method='mean';  % Decimation method


ev_list=textread(event_file,'%s');   % Reading list of events
nev=length(ev_list);             
itrace=0;                       % itrace inizialization
success=zeros(1,nev);           % Definition of "success"

% -------------------------------------------------------------------------

% PROCESSING

% -------------------------------------------------------------------------

% Start Loop over events
tic
for iev=1:nev;
   % Check: Display number of current event contained in the loop
   disp(['Event ' num2str(iev) ' of ' num2str(nev) ' (' ev_list{iev} ')'  ]);
   % Check if output directory2 exist
   if ~isdir([dir2 ev_list{iev}(1:13)]) mkdir([dir2 ev_list{iev}(1:13)]); end
    
   F1=fopen([dir1 ev_list{iev} tr_list_file],'r');
   tnames = textscan(F1,'%25s\n'); % Keep 25 char (38 consider the folder)
   fclose(F1);
   
   % Condition length traces (remember that tnames is a cell!) 
   if length(tnames{1})~=0;
      n_traces=size(tnames{1},1); % returns the sizes of each dimension array in a vector

      % Display check number of station to be processed (Here I have only 1
      % station)
      disp(['   Processing ' num2str(n_traces/5) ' stations... please wait!']);

     % Loop on stations
      for ista=1:5:n_traces;
          % Display check 
            if mod(ista-1,50)==0; fprintf([num2str( (ista-1)/5 ) '... ']); end
            
     B=char(tnames{1}(ista+2,:));        % Transform cell into char file name
     NAME_R=[dir1 ev_list{iev} '/' B];   % R component: Concatenate horizontal string
 
     C=char(tnames{1}(ista+3,:));        % Transform cell into char file name
     NAME_T=[dir1 ev_list{iev} '/' C];   % T component: Concatenate horizontal string
     
     D=char(tnames{1}(ista+4,:));        % Transform cell into char file name
     NAME_Z=[dir1 ev_list{iev} '/' D];   % Z component: Concatenate horizontal string
 
% -------------------------------------------------------------------------

% READ SAC FILES

% -------------------------------------------------------------------------
     
     % Read traces
         R=readsac(NAME_R); % Component R 
         T=readsac(NAME_T); % Component T
         Z=readsac(NAME_Z); % Component Z
         r= round((1/Z.delta) / fsamp);
     % Apply data decimation, using function [decim_tr]    
         R=decim_tr(R,r,method);
         T=decim_tr(T,r,method);
         Z=decim_tr(Z,r,method);
                 
% -------------------------------------------------------------------------

% REAL PROCESSING

% -------------------------------------------------------------------------         
         
         % Check if NPTS that are number of points per data component are
         % the same for R, T and Z
         if (Z.npts==R.npts && Z.npts==T.npts && Z.npts>0);
            % Start count itrace
            itrace=itrace+1;
          
     % Filtering including rmean and hanning: use function [bpf2n]
            R=bpf2n(R,lo,hi,orderf,hann);   % Component R
            T=bpf2n(T,lo,hi,orderf,hann);   % Component T
            Z=bpf2n(Z,lo,hi,orderf,hann);   % Component Z
            
     % Make shift by cutting Z shorter
          % Control if trace cutting is correct  
          if Z.b<0; disp([nameZ ' : ' num2str(Z.b)]); Z.b=0; end
            Z=cut_tr(Z,Z.t1-Z.b-tbefore,Z.t1-Z.b+tafter);

     % Compute iterative time deconvolution (SET is_plot! if needed...): use function [rf_iter] 
            [RRFi]=rf_iter(Z,R,iter);      % Iterative time deconvolution component R 
            [TRFi]=rf_iter(Z,T,iter);      % Iterative time deconvolution component T 

     % Update header of iterative time deconvolution
            RRFi.user1=lo; RRFi.user2=hi; RRFi.user3=cg; RRFi.user4=iter;
            TRFi.user1=lo; TRFi.user2=hi; TRFi.user3=cg; TRFi.user4=iter;
RRF0=RRFi;
     % Keeping shorter trace length to save space, included 30 seconds before the P wave
            RRFi=cut_tr(RRFi,0,tbefore+tafter);
            TRFi=cut_tr(TRFi,0,tbefore+tafter);
            
% -------------------------------------------------------------------------

% WRITE SAC FILES

% -------------------------------------------------------------------------
            
     % Write out, here goes the name of the variable tnames!
            nameRout=([dir2 ev_list{iev} '/' B(1:end-5) 'RFi.R.SAC']); % Define name of RF for radial component
            nameTout=([dir2 ev_list{iev} '/' B(1:end-5) 'RFi.T.SAC']); % Define name of RF for tranverse component         
            writesac(RRFi,nameRout);
            writesac(TRFi,nameTout);

            % Condition to compute root mean square to view the fit F
            % between R and Z
            if calc_rms;
            Rnew=R;
            Rnew.trace = conv ( Z.trace , RRFi.trace ); % Compute convolution for radial component of new radial trace
            Rcut=cut_tr(R   ,R.t1-R.b-5,R.t1-R.b+30);   % Compute trace cutting of radial component of old trace
            Rnew=cut_tr(Rnew,R.t1-R.b-5,R.t1-R.b+30);   % Compute trace cutting of radial component of new trace
            F= 1 - ( rms(Rcut.trace-Rnew.trace)   / max( rms(Rcut.trace) , rms(Rnew.trace)) );
	        F=F*100;
            disp(['Fit is: ' num2str(F,'%2.1f') '%']);
            % End fit computation
            end
            
         % End fit real processing   
         end
         
      % End loop on stations   
      end
      
   % End loop on traces   
   end
   
   % Check if the process was successfull
   if iev==1 success(iev)=itrace;
   else success(iev)=itrace-sum(success(1:iev-1));
   end
%   disp(['    ' n2s(success(iev)) ' successful stations'])
%   toc
%   disp([n2s(sum(success)) ' traces']);
%   disp(' ');

% End loop on events
end
toc
