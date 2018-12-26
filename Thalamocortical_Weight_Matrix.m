%% Construction of weight matrix

%% Tuning parameters
L = 4; %arbitrary tuning factor
D = 0.25; % arbitrary tuning factor

%% Thalamocortical parameters + connections
n = 30; m = 55; o = 4; 
total = n*m*o;
[X,Y,Z] = meshgrid(1:n,1:m,1:o);

A = cell(total,1); % cell coordinates
for ii = 1:total
    A{ii,1} = [X(ii);Y(ii);Z(ii)];
end

S = zeros(total,total);
for ii = 1:total
    for jj = 1:total
        S(ii,jj) = exp(-(sqrt(sum((A{jj,1} - A{ii,1}).^2)))/L^2); %weights calculated using same formula as olfactory
    end
end
S = S - diag(diag(S)); % drop self synapses
nn=2701:3300; 
S(:,nn) = -3*S(:,nn);% stronger inhibitory synapses

% Thalamus = exp(randn(3300,3300));
% Thalamus = Thalamus - diag(diag(Thalamus));
% S(3301:6600,3301:6600) = Thalamus;
mm = (5942:6600);
S(:,mm) = -3*S(:,mm);% stronger inhibitory thalamic relay synapses 

%% Connectivity proportions
%%%% excitatory indices - layer 3 pyramidal, layer 4 pyramidal, layer 4 spiny, layer 5 pyramidal, layer 5 bursting
L3P = (1:900);L4P = (901:1380);L4E = (1381:1800);L5P = (1801:2250);L5IB = (2250:2700); 

%%%% inhibitory indices - layer 3 fast spiking, layer 4 fast spiking, layer 4 low threshold, layer 5 fast spiking, layer 5 low threshold
L3FS = (2701:2900);L4FS = (2901:3000);L4LTS = (3001:3100);L5FS = (3101:3200); L5LTS = (3201:3300);

%%%% thalamic indices - thalamocortical regular, thalamocortical bursting, E-interneurons, thalamic relay neurons (GABAergic)
TCr = (3301:3961); TCb = (3962:4621); TIr = (4622:5281); TIb = (5282:5941); TRN = (5942:6600);

T = {L3P L4P L4E L5P L5IB L3FS L4FS L4LTS L5FS L5LTS TCr TCb TIr TIb TRN};

%connection values
g = [
     %%%% excitatory connections 
     .25 .41 .41 .1 .1 .1 .1 .1 0 0 .4 .4 0 0 0; 
     .2 .1 .2 .1 .1 .1 .1 .1 .1 .1 .3 .3 0 0 0;
     .2 .2 .4 .1 .1 .1 .4 .35 .1 .1 .3 .3 0 0 0;
     .4 .1 .1 .25 .25 .1 .1 .1 0 0 .2 .22 0 0 0;
     .4 .1 .1 .25 .25 .1 .1 .1 0 0 .2 .22 0 0 0;
     %%%% inhibitory connections
     .25 .1 .1 .1 .1 .1 .1 .1 0 0 .1 .1 0 0 0;
     .1 .2 .4 .1 .1 .1 .1 .1 0 0 .1 .1 0 0 0;
     .1 .1 .1 .1 .1 .1 .1 .1 0 0 .04 .04 0 0 0;
     .1 .1 .1 .1 .1 .1 .1 .1 0 0 .1 .1 0 0 0;
     .1 .1 .1 .1 .2 .1 .1 .1 0 0 .1 .1 0 0 0;
     %%%% thalamic connections
     .14 0 0 0 0 0 0 0 0 0 0 0 0.1 .1 .26;
     .14 0 0 0 0 0 0 0 0 0 0 0 0.1 0 .26;
       0 0 0 0 0 0 0 0 0 0 0.2 0.2 .24 0 0;
       0 0 0 0 0 0 0 0 0 0 0.2 0.1 0 .24 0;
       0 0 0 0 0 0 0 0 0 0 0.1 0.1 0 0 0;];
      
for ii = 1:numel(T)
        for jj = 1:numel(T)
            S(T{ii},T{jj}) = S(T{ii},T{jj}).*(rand(numel(T{ii}),numel(T{jj}))<g(ii,jj));
        end
end

%% Tune matrix
S = D*S; %tuning!
S(1801:2700,L3P) = 2*S(1801:2700,L3P); %L3-L5 connections doubled
% S(901:1800,3301:6600) = 2*S(901:1800,3301:6600); %Thalamic connections doubled %% not needed!!
