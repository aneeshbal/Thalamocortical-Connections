%% WARNING - takes 75-100 seconds to run!
clc; clear all;
tic

%% Initialize weight matrix
Thalamocortical_Weight_Matrix;
%%%% visualize
figure(1); 

subplot(3,1,1);
imagesc(S(1000:4000,100:4000)); % subset of weight matrix S
xlabel('Source neurons'); ylabel('Target neurons'); title('Subset of weight matrix "S"'); colorbar; colormap winter

subplot(3,1,2);
histogram(S(S~=0)); % connections
xlabel('Weight values'); ylabel('Frequency'); title('Synaptic distribution without "0" values');
set(gcf, 'Position', get(0, 'Screensize'));

subplot(3,1,3);
histogram(log(S(S>0))); % connections
xlabel('Log of weight values'); ylabel('Frequency'); title('Lognormal distribution of synaptic weights');
set(gcf, 'Position', get(0, 'Screensize'));

Percentage_Connections = (numel(S(S~=0))/numel(S))*100 % percentage of nonzero connections throughout thalamocortical circuitry

%% Run main network
Column_Network;
%%%% visualize
figure(2); 

subplot(2,1,1);
LFP(LFP > 0) = 0;
plot(LFP);
xlabel('Time in ms'); ylabel('Average Vm in mV'); title('LFP plot');

subplot(2,1,2);
thalLFP(thalLFP>0) = 0; CorticalLFP(CorticalLFP>0) = 0;
plot(thalLFP); hold on; plot(CorticalLFP); 
legend('thalLFP','CorticalLFP')
xlabel('Time in ms'); ylabel('Average Vm in mV'); title('Thalamic LFP vs cortical LFP - delay of spikes');
set(gcf, 'Position', get(0, 'Screensize'));

figure(3);
first = find(firings(:,1)<4000); second = find(firings(:,1)>3999);
plot(firings(first),firings(first,2),'.'); refline(0,900); refline(0,1800); refline(0,2700); refline(0,3300); 
xlabel('Time in ms'); ylabel('Neurons in network'); title('Raster plot of firing patterns (1-4000 ms)');
set(gcf, 'Position', get(0, 'Screensize'));

figure(4);
plot(firings(second),firings(second,2),'.'); refline(0,900); refline(0,1800); refline(0,2700); refline(0,3300); 
xlabel('Time in ms'); ylabel('Neurons in network'); title('Raster plot to assess model stability (4000-5000 ms)');
set(gcf, 'Position', get(0, 'Screensize'));

toc
