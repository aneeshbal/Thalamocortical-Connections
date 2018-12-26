%% Network parameters
Tmax = 5000; 
Ne=2700; Ni=600; Nth = 3300; % thalamic neurons
N=Ne+Ni+Nth;
re=rand(Ne,1); ri=rand(Ni,1);

a = [0.02*ones(Ne,1); 0.1*ones(Ni/2,1); 0.02*ones(100,1); 0.1*ones(100,1); 0.02*ones(100,1); 0.02*ones(2640,1); 0.1*ones(660,1)];
b = [0.2*ones(Ne,1); 0.25*ones(Ni/2,1); 0.25*ones(100,1); 0.25*ones(100,1); 0.25*ones(100,1); 0.2*ones(2640,1); 0.25*ones(660,1)];
c = [-65+5*rand(450,1); -55+5*rand(450,1); -65*ones(240,1); -55*ones(240,1); -60*ones(420,1); -65*ones(450,1); -60*ones(450,1); -65*ones(Ni,1); -65*ones(Nth,1)];
d = [6*ones(450,1); 6*ones(450,1); 5*ones(480,1); 6*ones(420,1); 6*ones(450,1); 6*ones(450,1); 2*ones(Ni,1); 6*ones(2640,1); 2*ones(660,1)];

v= -65+15*rand(N,1); %neurons starting from -65 to -50
u=b.*v;

%% Izhikevich network w/ 6 different input settings
% x = 0;
% p = .6;
% tau = 150;
% HebbCoupling = 1; % implement plasticity in the future

rates = zeros(N,1); 
% x_record = zeros(Tmax,1);
% v_record = zeros(Tmax,N);
% I_record = zeros(Tmax,N);
LFP = zeros(Tmax,1); % total LFP
tcLFP = zeros(Tmax,1) ; % thalamocortical LFP
thalLFP = zeros(Tmax,1); % thalamic LFP
CorticalLFP = zeros(Tmax,1); % Cortical LFP
firings=[]; 

for t=1:Tmax
    %%%% Basal Input and Tonic Inhibition seen 
    I=[2*randn(Ne,1);1*randn(Ni,1); 2*randn(2640,1); 1*randn(660,1)]; 
    
    %%%% Setting 1 - Low thalamic input
    if (t>200 && t<700) 
        I(3301:5942) = 9*ones(2642,1); % results in beta rhythm and partially activated column
    end
    %%%% Setting 2 - Sensory input only to thalamic structures (traditional circuitry)
    if t> 800 && t<1600
        I(3301:5942) = 14*ones(2642,1).*(rand(2642,1)>.1); % sufficient to activate column
    end
    %%%% Setting 3 - Sensory input directly to thalamus AND cortex (Constantinople 2013)
    if t>1700 && t<2300 
        I(901:1800) = 3*ones(900,1);
        I(3301:5942) = 14*ones(2642,1); 
    end
    %%%% Setting 4 - Direct L4 activation (Constantinople 2013)
    if t>2400 && t<3000
        I(901:1800) = 12*ones(900,1); % partially activated, L5 not activated 
    end
    %%%% Setting 5 - Brief thalamic input
    if t>3100 && t<3125
        I(3301:5942) = 14*ones(2642,1); % does not activate column
    end
    %%%% Setting 6 - Low thalamic activation
    if t>3200 && t<3800
        I(3301:5942) = 14*ones(2642,1).*(rand(2642,1)>.8); % does not sufficiently activate column (need stronger input)
    end
    
    %%%% Testing model over time
    if t>4000 && t<5000
        I(3301:5942) = 14*ones(2642,1); % model does not break down over time 
    end
    
    %%%% network dynamics
    fired=find(v>=-10);     
    firings=[firings; t+0*fired,fired]; 
    v(fired)=c(fired);
    u(fired)=u(fired)+d(fired);
    I=I+sum(S(:,fired),2);  
    v=v+0.5*(0.04*v.^2+5*v+140-u+I); 
    v=v+0.5*(0.04*v.^2+5*v+140-u+I);
    v(v>50) = 0;
    u=u+a.*(b.*v-u);
    
    %%%% record keeping
    tc = [v(901:1800);v(3301:6600)];
    thal = v(3301:6600);
    Cortical = v(1:3300);

%     x_record(t,:) = x;
%     v_record(t,:) = v;
%     I_record(t,:) = I;
    LFP(t) = mean(v);
    tcLFP(t) = mean(tc);
    thalLFP(t) = mean(thal);
    CorticalLFP(t) = mean(Cortical);
    
end
