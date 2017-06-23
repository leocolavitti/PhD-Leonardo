% QC2_SORT
% Quality control measurements on ZNE data for RF purposes (Sorting)
% Statistics on the restrictiveness and efficiency of the QC procedures
% are described in Table 3.3 of György Hétenyi thesis
% -------------------------------------------------------------------------
% PART 2: Statistics and Test
% 
% Modified from previous versions  20 Jan 2011 (C) György Hétenyi
% Adapted to EASI data 22 Mar 2016 György Hétenyi
% Adapted to Central Alps 20 Sept 2016 Leonardo Colavitti
% -------------------------------------------------------------------------

clc; clear; close all;
ifplot=1;
% -------------------------------------------------------------------------
% READ FILE 
% -------------------------------------------------------------------------
% Input filename [output of qc1_calc]
loadit=input('Please enter the filename without extension you want to use: ','s');
% Input filename:
% /Users/lcolavit/Database/ALL_DATA/ZNE_file/HH/Test_ALL_DATASET
loadit=[loadit '.mat'];
load(loadit);
% [Remember that variable fnames is specified in the .mat file]
L1=size(fnames,1); 
L2=size(fnames{1},2); 
xl=[0 L1/3];
% -------------------------------------------------------------------------
% LIST PARAMETERS SELECTION 
% (Include C(5) only if you want to test impulsiveness)
% -------------------------------------------------------------------------
% Put minimum magnitude (change from 6.0 to 5.2 for all data)
magmin=6.0;
% Choose here your list
list='Alps3';

switch list
   % Structure of C
   % C = [C1  C2  C3  C4]
    
   % HiCLIMB --- Test with my data
   case('W1'); C=[100 100  1  1];   % Weak   1     138837/213019   65%
   case('W2'); C=[ 15  15  2  2];   % Weak   2     74185 /213019   35%
   case('W3'); C=[ 10  10  2 15];   % Weak   3     18260 /213019   8% 
   case('S3'); C=[  5   5  3 30];   % Strong 3     7908  /213019  3.8%
   case('S2'); C=[  3   3  3 30];   % Strong 2     7713  /213019  3.6%
   case('S1'); C=[  2   2  5 30];   % Strong 1     7116  /213016  3.3%  
   
  % CBP
   case('cbpW'); C=[100 100 2 3];
   case('cbpS'); C=[  2   2 7 15/sqrt(2)];
   case('cbpWx');C=[ 10  10 1.5 2];
       
  % Bhutan
   case('S'); C=[2 2 10 15];
   case('M'); C=[3 3  5  9]; % loglog slope change
   case('W'); C=[4 4  2  2];
   case('B'); C=[2 2 2.5 4]; % bhutan
       
  % EASI       20s-2s                 8s-1s,   5s-2Hz 
   case('Es'); C=[2.5 2.5 4.5 7.5];   % C=[2.5 2.5 7 12];
   case('Ew'); C=[10 10 1.1 sqrt(2)]; % C=[10 10 1.1 2];
  
  % WRITE THE PARAMETER OF MY MODEL HERE:     
  % Central Alps 5s-2Hz
    case('Alps0');   C=[     8       8       1.1     1.1    ]; % Super Weak  129356 / 213019 (61%)   4513 Ev; 81 Stats
    case('Alps1');   C=[     4       4       1.1     1.5    ]; % Weak        127966 / 213019 (60%)   4513 Ev; 81 Stats 
    case('Alps2');   C=[     2       2       2       3.5    ]; % Medium      66591  / 213019 (31%)   3733 Ev; 80 Stats
    case('Alps3');   C=[     2       2       10      15     ]; % Strong      14018  / 213019 (6.5%)  1061 Ev; 80 Stats
    otherwise; C=[2 2 2 2];
end
% Case: impulsive [comment here if you wouldn't like to show this case]
% C(5)=4;

% -------------------------------------------------------------------------
% TEST OF THE PARAMETERS
% -------------------------------------------------------------------------
if (exist('qC1C2Z')==1 && length(C)==5);
   iok=find(qC1C2E<=C(1) & qC1C2E>=1/C(2) & qC1C2N<=C(1) & qC1C2N>=1/C(2) & qC1C2Z<=C(1) & qC1C2Z>=1/C(2) & (qmaxpkZ./qmaxbgZ)>=C(3) & (qmaxpkZ./qrmsbgZ)>=sqrt(2)*C(4) & (qrmssgZ./qrmscdZ)>=C(5) & mag>=magmin);
elseif (exist('qC1C2Z')==1 && length(C)==4);
   iok=find(qC1C2E<=C(1) & qC1C2E>=1/C(2) & qC1C2N<=C(1) & qC1C2N>=1/C(2) & qC1C2Z<=C(1) & qC1C2Z>=1/C(2) & (qmaxpkZ./qmaxbgZ)>=C(3) & (qmaxpkZ./qrmsbgZ)>=sqrt(2)*C(4) & mag>=magmin);
elseif length(C)==4;
   iok=find( (qmaxpkZ./qmaxbgZ)>=C(3) & (qmaxpkZ./qrmsbgZ)>=sqrt(2)*C(4) & mag>=magmin);
end

% -------------------------------------------------------------------------
% RESULTS
% -------------------------------------------------------------------------
disp(['With list ' list ', you have kept >>:__' num2str(length(iok)) '__:<< traces out of ' num2str(L1/3)'.'])
disp(['The sorting criteria were: ' num2str(C)]);

yn=input(['Press "y" to write this into file "outlist_BFO_' list '.dat": '],'s');
if yn=='y'
   fid=fopen(['outlist_BFO_' list '.dat'],'w');
   
   for i=1:length(iok); % the value of lenght(iok) is the number of traces kept
      j=(iok(i)-1)*3+1; % --> Change index j in i in printing?
      char(fnames{j}(29:end-6)); % Maybe in comment?
      fprintf(fid,['%' num2str(L2-5) 's\n'],char(fnames{j}(1:end)));
   end
   fclose(fid);
   disp('Done');
end
% -------------------------------------------------------------------------
% PLOT RESULTS
% -------------------------------------------------------------------------
if ifplot
if exist('qC1C2Z')==1 
% -------------------------------------------------------------------------
% PLOT C1 and C2 
% -------------------------------------------------------------------------
   figure(1); 
   clf;
% -------------------------------------------------------------------------
% RMS ENTIRE TRACE / MEDIAN VALUE
% -------------------------------------------------------------------------
% East component ----------------------------------------------------------
   subplot(3,1,1); 
   hold on; 
   loglog(sort(qC1C2E),'b.'); 
   xlim(xl);
   plot(xl,[C(1) C(1)],'r'); 
   plot(xl,[1/C(2) 1/C(2)],'r')
   xlabel('Number of traces');
   ylim([0 C(1)*3]); 
   ylabel('RMS EAST')
   title('1/C2 <= qrmsall/median <= C1');
% -------------------------------------------------------------------------
% North component ---------------------------------------------------------  
   subplot(3,1,2); 
   hold on; 
   loglog(sort(qC1C2N),'b.'); 
   xlim(xl);
   plot(xl,[C(1) C(1)],'r'); 
   plot(xl,[1/C(2) 1/C(2)],'r');
   xlabel('Number of traces');
   ylim([0 C(1)*3]); 
   ylabel('RMS NORTH');
% -------------------------------------------------------------------------
% Vertical component ------------------------------------------------------
   subplot(3,1,3); 
   hold on; 
   loglog(sort(qC1C2Z),'b.'); 
   xlim(xl);
   plot(xl,[C(1) C(1)],'r'); 
   plot(xl,[1/C(2) 1/C(2)],'r');
   xlabel('Number of traces');
   ylim([0 C(1)*3]); 
   ylabel('RMS VERTICAL');
end
% -------------------------------------------------------------------------
% PLOT C3, C4, C5 [optional] and Magnitude
% ------------------------------------------------------------------------- 
figure(2); 
clf;
% -------------------------------------------------------------------------
% HIGH SIGNAL NOISE-TO-RATIO IN AMPLITUDE
% Plot maxpk/maxbg --------------------------------------------------------
subplot(2,2,1); 
hold on; 
loglog(sort(qmaxpkZ./qmaxbgZ),'b.');
xlim(xl); 
plot(xl,[C(3) C(3)],'r');
xlabel('Number of traces');
ylim([0 C(3)*3]);
ylabel('C3');
title('maxpk/maxbg >= C3');
% -------------------------------------------------------------------------
% HIGH SIGNAL NOISE-TO-RATIO COMPARED TO THE BACKGROUND NOISE
% Plot maxpk/rmsbg --------------------------------------------------------
subplot(2,2,2); 
hold on; 
loglog(sort(qmaxpkZ./qrmsbgZ),'b.');
xlim(xl); 
plot(xl,[C(4) C(4)]*sqrt(2),'r');
xlabel('Number of traces');
ylim([0 sqrt(2)*C(4)*3]);
ylabel('sqrt(2)*C4');
title('maxpk/rmsbg >= sqrt(2)*C4');
% -------------------------------------------------------------------------
% IMPULSIVE CASE
% Plot rmssg/rmscd --------------------------------------------------------
if length(C)==5;
   subplot(2,2,3); 
   hold on; 
   loglog(sort(qrmssgZ./qrmscdZ),'b.');
   xlim(xl); 
   plot(xl,[C(5) C(5)],'r');
   xlabel('Number of traces');
   ylim([0 C(5)*3]);
   ylabel('C5');
   title('rmssg/rmscd >= C5 (impulsive?)')
end
% -------------------------------------------------------------------------
% MAGNITUDE SELECTION
% Plot magnitude ----------------------------------------------------------
subplot(2,2,4);
plot(sort(mag),'b.');
hold on
xlim(xl);
xlabel('Number of traces');
plot(xl,[magmin magmin],'r');
ylim([min(mag)-0.5 max(mag)+0.5]);
ylabel('Magnitude');
title(['Magnitude >= ' num2str(magmin)]);
end % End plot 'Impulsive Case'