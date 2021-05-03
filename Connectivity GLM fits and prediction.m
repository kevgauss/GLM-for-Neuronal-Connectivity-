
datdir = 'm380/';
load([datdir, 'm380_All_goodclusteIDs']);
load([datdir, 'm380_AllTriggers_analysis']);
load([datdir, 'm380_Joined_all_channels']);
load([datdir, 'spontSpks']);

% MechTTL = Triggers.MechTTL;
% MechStim = Triggers.MechStim;
Laser = Triggers.Laser;
% plot(Laser);
%% data preparation
% tsp = ; 
chunkstart = 500000;
% chunkend = 40000000; %20min
% chunkend = 20000000; %10min
chunkend = 10000000; %5min
%chunkend = 5000000; %2min30s
% tsp = sortedData{134,2}*fs;
tsp = spontSpks{67,1}*fs;
nT = size(Laser,1);
N=1;
tbins = (N/2:N:nT);
sps1 = hist(tsp,tbins)';
sps1pos = sps1(sps1>0);

% tsp2 = sortedData{545,2}*fs;
tsp2 = spontSpks{218,1}*fs;
sps2 = hist(tsp2,tbins)';

sps = sps2(chunkstart:chunkend);
Stim = sps1(chunkstart:chunkend);
spspos = sps(sps>0);

dtStim = 1/fs;
dtSp = 1/fs;
dt = 1/fs;
nkt = 3000;
% nkt = 3000;
sta = simpleSTC(Stim,sps,nkt); 
sta = reshape(sta,nkt,[]); 

exptmask= [];  

nkbasis = 8;  
nhbasis = 8;  
hpeakFinal = .2;   
gg0 = makeFittingStruct_GLM(dtStim,dtSp,nkt,nkbasis,sta,nhbasis,hpeakFinal);
gg0.sps = sps; 
gg0.mask = exptmask; 
gg0.ihw = randn(size(gg0.ihw))*1;  
[negloglival0,rr] = neglogli_GLM(gg0,Stim);
fprintf('Initial negative log-likelihood: %.5f\n', negloglival0);


opts = {'display', 'iter', 'maxiter', 100};
[gg1, negloglival] = MLfit_GLM(gg0,Stim,opts);

% 
% sps_B = sps1(chunkstart:chunkend);
% Stim_B = sps2(chunkstart:chunkend);
% sta_B = simpleSTC(Stim_B,sps_B,nkt); 
% sta_B = reshape(sta,nkt,[]); 
% 
% exptmask= [];  
% 
% nkbasis = 8;  
% nhbasis = 8;  
% hpeakFinal = .2;   
% gg0_B = makeFittingStruct_GLM(dtStim,dtSp,nkt,nkbasis,sta_B,nhbasis,hpeakFinal);
% gg0_B.sps = sps_B; 
% gg0_B.mask = exptmask; 
% gg0_B.ihw = randn(size(gg0_B.ihw))*1;  
% [negloglival0_B,rr_B] = neglogli_GLM(gg0_B,Stim_B);
% fprintf('Initial negative log-likelihood: %.5f\n', negloglival0_B);
% 
% 
% opts = {'display', 'iter', 'maxiter', 100};
% [gg1_B, negloglival_B] = MLfit_GLM(gg0_B,Stim_B,opts);


%% simulation

sim_chunkstart = 33000000;
sim_chunkend = 33100000;
Window = sim_chunkend - sim_chunkstart;

sim_sps = sps2(sim_chunkstart:sim_chunkend);
sim_Stim = sps1(sim_chunkstart:sim_chunkend);

fprintf('---------------------------------------------------\n');
reps = 100;
fprintf('Initiate simulation. Number of repetition = %i\n', reps);
max = 300;
fprintf('Set maximum number of spike = %d\n', max);
sim = [];
for i=1:reps
    
    [tsp2, ~, Itot, Istm] = simGLM(gg1, sim_Stim); 
%     window = round(1000*t(end));
    window = 3500;
    tspsize = size(tsp2,1);
    Sim = zeros(1,window);
    tsp = round(1000*tsp2);
    for i = 1:tspsize
        Sim(tsp(i)) = 1;
    end
    SimSpks = numel(Sim(Sim>0));
    if SimSpks < max
        sim = [sim ; Sim];
    end
end
simSize = size(sim,1);
fprintf('Number of accepted repetition = %d\n', simSize);

%% summation histogram
simLenght = size(sim,2);
sumHist = sum(sim,1);

posHist = sumHist(sumHist>0);
merge = simLenght/10;
SumHist = sum(reshape(sumHist,[],merge),1)';

%% plot

iiplot = 1:Window+1;
ttplot = iiplot*dt*1000;

iplotSum = 1:size(SumHist,1);
tplotSum = iplotSum*10;

% subplot(311);
% plot(Laser(chunkstart:chunkend))
% subplot(312);
% plot(sps1);
% subplot(313);
% plot(sps2);
% 
% figure;

subplot(811);
plot(ttplot,sim_Stim);
title('S1 neuron spike counts as stimulus');
subplot(812);
plot(ttplot,sim_sps);
title('VPL neuron spike counts we are trying to predict');
subplot(8,1,3:6);
imagesc(1:window,1:50,sim);
title('50 trials simulation');
suptitle('Prediction of VPL activity with S1 as input');
subplot(8,1,7:8);
bar(tplotSum,SumHist);
xlabel('t (ms)');
% figure;
% 
% subplot(221);
% iiplot = -nkt+1:0;
% ttplot = iiplot*dt*1000;
% plot(ttplot,gg1.k,ttplot,gg1.k*0,'k--','linewidth',1.5);
% xlabel('t (ms)');
% title('S1 \rightarrow VPL: stimulus filter');
% subplot(222);
% iplot=1:nkt;
% plot(gg1.iht(iplot)*1000, gg1.ih(iplot),'r', gg1.iht(iplot)*1000, gg1.ih(iplot)*0,'k--','linewidth',1.5);
% xlabel('t (ms)');
% title('S1 \rightarrow VPL: post-spike filter');
% subplot(223);
% iiplot = -nkt+1:0;
% ttplot = iiplot*dt*1000;
% plot(ttplot,gg1_B.k,ttplot,gg1_B.k*0,'k--','linewidth',1.5);
% xlabel('t (ms)');
% title('VPL \rightarrow S1: stimulus filter');
% subplot(224);
% iplot=1:nkt;
% plot(gg1_B.iht(iplot)*1000, gg1_B.ih(iplot),'r', gg1_B.iht(iplot)*1000, gg1_B.ih(iplot)*0,'k--','linewidth',1.5);
% xlabel('t (ms)');
% title('VPL \rightarrow S1: post-spike filter');
% suptitle('GLM connectivity filters between S1_305 and VPL_314');