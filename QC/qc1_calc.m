% QC1_CALC
% Quality control measurements on ZNE data for RF purposes (Calculation)
% -------------------------------------------------------------------------
% PART 1: Read data and determine rmsall, maxpk, maxbg,
%         rmsbg, medians for array (opt), get magnitude
%
% -rmsall:  RMS of the entire trace
% -rmsbg:   RMS of the background signal [between 30 and 5 secs before P-wave]
% -maxbg:   MAXIMUM of the background
% -maxpk:   MAXIMUM of the peak [between -5 and 20 seconds before P-wave]
%
% Modified from previous versions  20 Jan 2011 (C) György Hétenyi
% Adapted to EASI data 22 Mar 2016 György Hétenyi
% Adapted to Central Alps 20 Sept 2016 Leonardo Colavitti
% -------------------------------------------------------------------------

clc; clear; close all;

% Input file of trace name: 
% /Users/lcolavit/Database/ALL_DATA/ZNE_file/HH/listZNE_Folder_ALL
% For Comparison with Lombardi et al., 2008:
% /Users/lcolavit/Database/Comp_Lombardi/BNALP/ZNE_file/listZNERT_BNALP or
% /Users/lcolavit/Database/ALL_DATA/ZNE_file/HH
% /Users/lcolavit/Database/ALL_DATA/ZNE_file/HH/PROVA_BNALP
% /Users/lcolavit/Database/ALL_DATA/ZNE_file/HH/PROVA_BFO

% Add useful directories
addpath /Users/lcolavit/Documents/MATLAB/Tools;
addpath /Users/lcolavit/Documents/MATLAB/Signal_Proc_G;

% Read trace names
listoffiles=input('Enter the name of the file containing the trace names: ','s');
ad=input('Process array data by event? (y/n) ','s');

tic;
% Define Event index
evindex=1:13;
lev=length(evindex);
% -------------------------------------------------------------------------
% GET ONLY Z,N,E COMPONENTS
% -------------------------------------------------------------------------
% Execute UNIX command and return output
% Show different traces names
unix(['grep ".[ZNE].SAC" ' listoffiles ' > tmpf']);
fnames=textread('tmpf','%s');
% Show different station names
unix(['awk -F. ''{print $2}'' ' listoffiles ' | sort | uniq > tmps']);
snames=textread('tmps','%s');
unix('rm tmpf tmps');
L1=size(fnames,1);      % Number of traces computed
L2=size(fnames{1},2);   % Number of unique stations
% LTest=24762;          % Number of test traces computed
disp(['List OK: ' n2s(L1) ' traces']) % Show number of traces computed
toc;
disp('(Computation time for reading traces)');
% -------------------------------------------------------------------------
% FILTERING PARAMETERS 
% (CHECK QC parameters in György Hétenyi thesis, p.113)
% -------------------------------------------------------------------------
lo=1/10;        % Lower cut-off frequency [Hz] change here the frequency content [1/5]
hi=1;           % High cut-off frequency  [Hz] change here the frequency content [2]
orderf=2;       % Gaussian convolution width = 1/(2*pi*hi)
hann=15;        % Hanning window
% cg=0.1592/hi; % Gaussian convolution width = 1/(2*pi*hi)

% Time limits -------------------------------------------------------------
tP=60;                          % P-wave arrival in the ZNE-traces
trms1=max(-30,-tP); trms2=-5;   % Background compared to P-wave [min] [max]
tpk1=-5;    tpk2=20;            % Peak      [min] [max]
tsg1=0;     tsg2=30;            % Signal    [min] [max]
tcd1=60;    tcd2=90;            % Coda time [min] [max]

% Initialization ----------------------------------------------------------

% Root-mean-square of the entire trace
qrmsallZ=zeros(L1/3,1); qrmsallN=zeros(L1/3,1); qrmsallE=zeros(L1/3,1);

% Root-mean-square of the background signal
qrmsbgZ =zeros(L1/3,1); %qrmsbgN =zeros(L1/3,1); qrmsbgE =zeros(L1/3,1);

% Maximum value of the background
qmaxbgZ =zeros(L1/3,1); %qmaxbgN =zeros(L1/3,1); qmaxbgE =zeros(L1/3,1);

% Maximum value of the peak
qmaxpkZ =zeros(L1/3,1); %qmaxpkN =zeros(L1/3,1); qmaxpkE =zeros(L1/3,1);

% Check these two values below
qrmssgZ =zeros(L1/3,1); %qrmssgN =zeros(L1/3,1); qrmssgE =zeros(L1/3,1);
qrmscdZ =zeros(L1/3,1); %qrmscdN =zeros(L1/3,1); qrmscdE =zeros(L1/3,1);

% Computation -------------------------------------------------------------

disp('Computing...'); 
tic
j=0;
mag=zeros(L1/3,1);
for i=1:3:L1; % Change this to test the code [default: L1]
   j=j+1;
   if mod(j,100)==0;
      disp(j); end
   clear E N Z sps ibg ibg ipk;
   
   % In the for loop, include the path of all events
   dir0='/Users/lcolavit/Database/ALL_DATA/ZNE_file/HH/';
   % dir0='/Users/lcolavit/Database/Comp_Lombardi/BNALP/ZNE_file/';
   
   E=readsac([dir0 fnames{i}]);    % Read East     component
   N=readsac([dir0 fnames{i+1}]);  % Read North    component
   Z=readsac([dir0 fnames{i+2}]);  % Read Vertical component
   
   sps=Z.delta;             % Sampling time interval [120 secs]

   E=bpf2n(E,lo,hi,orderf,hann); % Butterworth filter on East component 
   N=bpf2n(N,lo,hi,orderf,hann); % Butterworth filter on North component   
   Z=bpf2n(Z,lo,hi,orderf,hann); % Butterworth filter on Vertical component   

   ibg=round((tP+trms1)/sps+1:(tP+trms2)/sps+2);  % Background
   ipk=round((tP+ tpk1)/sps+1:(tP+ tpk2)/sps+2);  % Peak
   isg=round((tP+ tsg1)/sps+1:(tP+ tsg2)/sps+2);  % Signal
   icd=round((tP+ tcd1)/sps+1:(tP+ tcd2)/sps+2);  % Coda time

   qrmsallE(j)=    rms(E);             
   % qrmsbgE(j)=    rms(E.trace(ibg));
   % qmaxbgE(j)=max(abs(E.trace(ibg))); 
   % qmaxpkE(j)=max(abs(E.trace(ipk)));
   % qrmssgE(j)=rms(E.trace(isg));  
   % qrmscdE(j)=rms(E.trace(icd));

   qrmsallN(j)=    rms(N);             
   % qrmsbgN(j)=    rms(N.trace(ibg));
   % qmaxbgN(j)=max(abs(N.trace(ibg))); 
   % qmaxpkN(j)=max(abs(N.trace(ipk)));
   % qrmssgN(j)=rms(N.trace(isg));  
   % qrmscdN(j)=rms(N.trace(icd));

   qrmsallZ(j)=    rms(Z);              % RMS of the whole trace;             
   qrmsbgZ(j)=     rms(Z.trace(ibg));   % RMS of the background;
   qmaxbgZ(j)=max(abs(Z.trace(ibg)));   % Max of the background;
   qmaxpkZ(j)=max(abs(Z.trace(ipk)));   % Max of the peak;
   qrmssgZ(j)=rms(Z.trace(isg));        % RMS of the signal;    
   qrmscdZ(j)=rms(Z.trace(icd));        % RMS of the coda;    
  
   mag(j)=Z.mag;
end
disp('Done!')
toc
disp('(Computation time for filter parameters)');
% -------------------------------------------------------------------------
% ARRAY DATA (OPTIONAL, COMPARES RMS TO MEDIAN FOR THE EVENTS)
% -------------------------------------------------------------------------
% Check on input 
if ad=='y'

  % Determine events and file names ---------------------------------------
  % Check on event names
tic
  disp('Getting event names...')
  tmpnames=fnames;  
   for i=1:L1; 
      tmpnames{i}=fnames{i}(evindex);
   end
   evnames=unique(tmpnames);     
   clear tmpnames;
   Nev=length(evnames);
   trid=zeros(L1/3,1);  % Change this to test the code [default: L1]
  for i=1:3:L1;
      clear trn
      trn=fnames{i}(evindex);
  trid((i-1)/3+1)=strmatch(trn,evnames); % trace/event ID, Use strncmp
  end
   clear i j
toc
disp('(Computation time to get event names)')
% -------------------------------------------------------------------------
% EVENT STATISTICS 
% -------------------------------------------------------------------------

% Get median values -------------------------------------------------------
tic
   disp('Event stats...');
   qC1C2E=zeros(size(qrmsallE)); % Initialize qC1C2 East
   qC1C2N=zeros(size(qrmsallN)); % Initialize qC1C2 North
   qC1C2Z=zeros(size(qrmsallZ)); % Initialize qC1C2 Vertical
   
   for i=1:Nev;
      clear iok ie in iz
      iok=find(i==trid);
      
      qrmsallmedianE=median(qrmsallE(iok));     % Median of East component
      qrmsallmedianN=median(qrmsallN(iok));     % Median of North component
      qrmsallmedianZ=median(qrmsallZ(iok));     % Median of Vertical component
      qC1C2E(iok)=qrmsallE(iok)/qrmsallmedianE; % Definition of qC1C2 East
      qC1C2N(iok)=qrmsallN(iok)/qrmsallmedianN; % Definition of qC1C2 North
      qC1C2Z(iok)=qrmsallZ(iok)/qrmsallmedianZ; % Definition of qC1C2 Vertical
   end
end
clear qrmsallmedian* 

% Outlier station by mean rms ---------------------------------------------
Si=[];
k=0;

% Check on different trace names
for i=1:3:L1;   % Change this to test the code [default: L1]
   k=k+1;
   Si{k}=fnames{i}(29:end-6); 
   % 15 chars considering file listZNERT_ALL; 
   % 29 chars considering file listZNERT_Folder_ALL; 
end
disp('Statistic: rmsallZ     rmsallN     rmsallE')
% Check on different station names
for i=1:length(snames)
   iok=strmatch(snames{i},Si);   % Use strncmp
   disp([snames{i} ': ' num2str(mean(qrmsallZ(iok))) '    ' num2str(mean(qrmsallN(iok))) '    ' num2str(mean(qrmsallE(iok)))]);
end
toc
disp('(Computation time to do event statistics)');
% -------------------------------------------------------------------------
% SAVE PARAMETERS
% -------------------------------------------------------------------------
saveit=input('Do you want to save your parameters? (y/n) ','s');
if saveit=='y'
  xout=input('Please enter the filename without extension you want to use: ','s');
  xout=[xout '.mat'];
  if ad=='y'
     save(xout,'fnames','evnames','trid','q*','mag')
  else
     save(xout,'fnames','q*','mag')
  end
end