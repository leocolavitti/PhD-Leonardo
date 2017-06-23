% QC3_PASS
% Quality control measurements on ZNE data for RF purposes (Sorting)
% -------------------------------------------------------------------------
% PART 3: Threshold values for each parameter [run after Part 1 and 2]
%
% Modified from previous versions  20 Jan 2011 (C) György Hétenyi
% Adapted to EASI data 22 Mar 2016 György Hétenyi
% Adapted to Central Alps 20 Sept 2016 Leonardo Colavitti
% -------------------------------------------------------------------------

% Make everything clean
clear C1 C3 C4 C5 iokE1 iokE2 iokN1 iokN2 iokZ1 iokZ2 iokZ3 iokZ4 iokZ5
L3=size(fnames,1)/3;
c='b.-';
c2='b.';
% -------------------------------------------------------------------------
% PARAMETER RANGES TO TEST [Set steps here], choose here a criteria of
% qc2_sort --> output
% -------------------------------------------------------------------------
C1=1:.1:5; % C2=C1  % 5
C3=1:0.5:30;        % 30
C4=1:0.5:30;        % 30
C5=1:0.1:5;         % 5
% -------------------------------------------------------------------------
% Compute tests
% Check C1 ----------------------------------------------------------------
if exist('qC1C2Z')==1;
   for i=1:length(C1);
   iokE1(i)=length(find(qC1C2E<=C1(i)));   
   mE1(i)=mean(mag(find(qC1C2E<=C1(i))));
   iokN1(i)=length(find(qC1C2N<=C1(i)));   
   mN1(i)=mean(mag(find(qC1C2N<=C1(i))));
   iokZ1(i)=length(find(qC1C2Z<=C1(i)));   
   mZ1(i)=mean(mag(find(qC1C2Z<=C1(i))));
   iokZ2(i)=length(find(qC1C2Z>=1/C1(i))); 
   mE2(i)=mean(mag(find(qC1C2E>=1/C1(i))));
   iokN2(i)=length(find(qC1C2N>=1/C1(i))); 
   mN2(i)=mean(mag(find(qC1C2N>=1/C1(i))));
   iokE2(i)=length(find(qC1C2E>=1/C1(i))); 
   mZ2(i)=mean(mag(find(qC1C2Z>=1/C1(i))));
   end
end
% -------------------------------------------------------------------------
% Check C3 ----------------------------------------------------------------
for i=1:length(C3);
iokZ3(i)=length(find(qmaxpkZ./qmaxbgZ>=C3(i))); 
mZ3(i)=mean(mag(find(qmaxpkZ./qmaxbgZ>=C3(i))));
end
% -------------------------------------------------------------------------
% Check C4 ----------------------------------------------------------------
for i=1:length(C4)
iokZ4(i)=length(find((qmaxpkZ./qrmsbgZ)>=sqrt(2)*C4(i))); 
mZ4(i)=mean(mag(find((qmaxpkZ./qrmsbgZ)>=sqrt(2)*C4(i))));
end
% -------------------------------------------------------------------------
% Check C5 ----------------------------------------------------------------
for i=1:length(C5)
iokZ5(i)=length(find((qrmssgZ./qrmscdZ)>=C5(i))); 
mZ5(i)=mean(mag(find((qrmssgZ./qrmscdZ)>=C5(i))));
end
% -------------------------------------------------------------------------
% PLOT RESULTS (1)
% SATURATION-CURVES OF THE SIGNAL PROPERTIES WITH C
figure(3);
% clf;
if exist('qC1C2Z')==1
% -------------------------------------------------------------------------
% C1 [RMS ENTIRE TRACE / MEDIAN]-------------------------------------------
% -------------------------------------------------------------------------
% East component
subplot(3,3,1); 
hold on; 
box on; 
plot(C1,iokE1/L3,c); 
title('C1 [East]');
xlabel('C1');
ylabel('% Traces');
axis([min(C1) max(C1) 0 1]);
% -------------------------------------------------------------------------
% North component
subplot(3,3,4); 
hold on; 
box on; 
plot(C1,iokN1/L3,c); 
title('C1 [North]'); 
xlabel('C1');
ylabel('% Traces');
axis([min(C1) max(C1) 0 1]);
% -------------------------------------------------------------------------
% Vertical component
subplot(3,3,7); 
hold on; 
box on; 
plot(C1,iokZ1/L3,c); 
title('C1 [Vertical]'); 
xlabel('C1');
ylabel('% Traces');
axis([min(C1) max(C1) 0 1]);
% -------------------------------------------------------------------------
% C2 [RMS ENTIRE TRACE / MEDIAN]-------------------------------------------
% -------------------------------------------------------------------------
% East component
subplot(3,3,2); 
hold on; 
box on; 
plot(C1,iokE2/L3,c); 
title('C2 [East]'); 
xlabel('C2');
ylabel('% Traces');
axis([min(C1) max(C1) 0 1]);
% -------------------------------------------------------------------------
% North component
subplot(3,3,5); 
hold on; 
box on; 
plot(C1,iokN2/L3,c); 
title('C2 [North]'); 
xlabel('C2');
ylabel('% Traces');
axis([min(C1) max(C1) 0 1]);
% -------------------------------------------------------------------------
% Vertical component
subplot(3,3,8); 
hold on; 
box on; 
plot(C1,iokZ2/L3,c); 
title('C2 [Vertical]'); 
xlabel('C2');
ylabel('% Traces');
axis([min(C1) max(C1) 0 1]);
end
% -------------------------------------------------------------------------
% C3 [HIGH SIGNAL NOISE-TO-RATIO IN AMPLITUDE]-----------------------------
% -------------------------------------------------------------------------
subplot(3,3,3); 
hold on; 
box on; 
loglog(C3,iokZ3/L3,c); 
title('C3');
xlabel('C3');
ylabel('% Traces');
axis([min(C3) max(C3) 0 1]);
% -------------------------------------------------------------------------
% C4 [MAGNITUDE SELECTION]-------------------------------------------------
% -------------------------------------------------------------------------
subplot(3,3,6); 
hold on; 
box on; 
plot(C4,iokZ4/L3,c); 
title('C4');
xlabel('C4');
ylabel('% Traces');
axis([min(C4) max(C4) 0 1]);
% -------------------------------------------------------------------------
% C5 [IMPULSIVE CASE (OPTIONAL)]-------------------------------------------
% -------------------------------------------------------------------------
subplot(3,3,9); 
hold on; 
box on; 
plot(C5,iokZ5/L3,c); 
title('C5'); 
xlabel('C5');
ylabel('% Traces');
axis([min(C5) max(C5) 0 1]);
% -------------------------------------------------------------------------
% PLOT RESULTS (2)
% AVERAGE MAGNITUDE OF EVENTS SELECTED
figure(4);
% clf;
if exist('qC1C2Z')==1; 
% -------------------------------------------------------------------------
% C1 [RMS ENTIRE TRACE / MEDIAN]-------------------------------------------
% ------------------------------------------------------------------------- 
% East component
subplot(3,3,1); 
hold on; 
box on; 
plot(C1,mE1,c); 
title('C1 vs Magnitude [East]');
xlabel('C1');
ylabel('Mag');
axis([min(C1) max(C1) 5 7.5]);
% -------------------------------------------------------------------------
% North component
subplot(3,3,4); 
hold on; 
box on; 
plot(C1,mN1,c); 
title('C1 vs Magnitude [North]');
xlabel('C1');
ylabel('Mag');
axis([min(C1) max(C1) 5 7.5]);
% -------------------------------------------------------------------------
% Vertical component
subplot(3,3,7); 
hold on; 
box on; 
plot(C1,mZ1,c); 
title('C1 vs Magnitude [Vertical]');
xlabel('C1');
ylabel('Mag');
axis([min(C1) max(C1) 5 7.5]);
% -------------------------------------------------------------------------
% C2 [RMS ENTIRE TRACE / MEDIAN]-------------------------------------------
% -------------------------------------------------------------------------
% East component
subplot(3,3,2); 
hold on; 
box on; 
plot(C1,mE2,c); 
title('C2 vs Magnitude [East]'); 
xlabel('C2');
ylabel('Mag');
axis([min(C1) max(C1) 5 7.5]);
% -------------------------------------------------------------------------
% North component
subplot(3,3,5); 
hold on; 
box on; 
plot(C1,mN2,c); 
title('C2 vs Magnitude [North]');
xlabel('C2');
ylabel('Mag');
axis([min(C1) max(C1) 5 7.5]);
% -------------------------------------------------------------------------
% Vertical component
subplot(3,3,8); 
hold on; 
box on; 
plot(C1,mZ2,c); 
title('C2 vs Magnitude [Vertical]');
xlabel('C2');
ylabel('Mag');
axis([min(C1) max(C1) 5 7.5]);
end
% -------------------------------------------------------------------------
% C3 [HIGH SIGNAL NOISE-TO-RATIO IN AMPLITUDE]-----------------------------
% -------------------------------------------------------------------------
subplot(3,3,3); 
hold on; 
box on; 
plot(C3,mZ3,c); 
title('C3 vs Magnitude');
xlabel('C3');
ylabel('Mag');
axis([min(C3) max(C3) 5 7.5]);
% -------------------------------------------------------------------------
% C4 [IMPULSIVE CASE]------------------------------------------------------
% -------------------------------------------------------------------------
subplot(3,3,6); 
hold on; 
box on; 
plot(C4,mZ4,c); 
title('C4 vs Magnitude'); 
xlabel('C4');
ylabel('Mag');
axis([min(C4) max(C4) 5 7.5]);
% -------------------------------------------------------------------------
% C5 [MAGNITUDE SELECTION]-------------------------------------------------
% -------------------------------------------------------------------------
subplot(3,3,9); 
hold on; 
box on; 
plot(C5,mZ5,c); 
title('C5 vs Magnitude [Optional]'); 
xlabel('C5');
ylabel('Mag');
axis([min(C5) max(C5) 5 7.5]);
figure(5);
if exist('qC1C2Z')==1;
% -------------------------------------------------------------------------
% C1 or C2 [RMS ENTIRE TRACE / MEDIAN]-------------------------------------
% -------------------------------------------------------------------------
% East component
subplot(3,2,1); 
plot(mag,qC1C2E,c2); 
title('Magnitude vs qC1C2 [East]');
xlabel('Mag');
ylabel('qC1C2');
axis([min(mag) max(mag) min(C1) max(C1)]);
% -------------------------------------------------------------------------
% North component
subplot(3,2,3); 
plot(mag,qC1C2N,c2); 
title('Magnitude vs qC1C2 [North]'); 
xlabel('Mag');
ylabel('qC1C2');
axis([min(mag) max(mag) min(C1) max(C1)]);
% -------------------------------------------------------------------------
% Vertical component
subplot(3,2,5); 
plot(mag,qC1C2Z,c2); 
title('Magnitude vs qC1C2 [Vertical]'); 
xlabel('Mag');
ylabel('qC1C2');
axis([min(mag) max(mag) min(C1) max(C1)]);
end
% -------------------------------------------------------------------------
% C3 [HIGH SIGNAL NOISE-TO-RATIO IN AMPLITUDE]-----------------------------
% -------------------------------------------------------------------------
subplot(3,2,2); 
plot(mag,qmaxpkZ./qmaxbgZ,c2); 
title('Magnitude vs C3'); 
xlabel('Mag');
ylabel('C3');
axis([min(mag) max(mag) min(C1) max(C3)]);
% -------------------------------------------------------------------------
% C4 [MAGNITUDE SELECTION]-------------------------------------------------
% -------------------------------------------------------------------------
subplot(3,2,4); 
plot(mag,qmaxpkZ./qrmsbgZ,c2); 
title('Magnitude vs C4'); 
xlabel('Mag');
ylabel('C4');
axis([min(mag) max(mag) min(C1) max(C4)]);
% -------------------------------------------------------------------------
% C5 [IMPULSIVE CASE (OPTIONAL)]-------------------------------------------
% -------------------------------------------------------------------------
subplot(3,2,6); 
plot(mag,qrmssgZ./qrmscdZ,c2);
title('Magnitude vs C5 [Optional]');
xlabel('Mag');
ylabel('C5');
axis([min(mag) max(mag) min(C1) max(C5)]);