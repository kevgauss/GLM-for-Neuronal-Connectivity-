load('spsexample.mat');
load('stimexample.mat');

Learning = 0.8;
Totalsize = size(sps,1);
Learning_chunk_end = round(Learning*Totalsize);

GLM_sps = sps(1:Learning_chunk_end);
GLM_Stim = Stim(1:Learning_chunk_end);

fs = 3.003003003003004e+04;
dtStim = 1/fs;
dtSp = 1/fs;
dt = 1/fs;
nkt = 1500;
sta = simpleSTC(GLM_Stim,GLM_sps,nkt); 
sta = reshape(sta,nkt,[]); 

exptmask= [];  

nkbasis = 8;  
nhbasis = 8;  
hpeakFinal = .2;   
gg0 = makeFittingStruct_GLM(dtStim,dtSp,nkt,nkbasis,sta,nhbasis,hpeakFinal);
gg0.sps = GLM_sps; 
gg0.mask = exptmask; 
gg0.ihw = randn(size(gg0.ihw))*1;  
[negloglival0,rr] = neglogli_GLM(gg0,GLM_Stim);
fprintf('Initial negative log-likelihood: %.5f\n', negloglival0);


opts = {'display', 'iter', 'maxiter', 100};
[gg1, negloglival] = MLfit_GLM(gg0,GLM_Stim,opts);


%% simulation

sim_chunkstart = Learning_chunk_end+1;
sim_chunkend = Totalsize;


sim_sps = sps(sim_chunkstart:sim_chunkend);
sim_Stim = Stim(sim_chunkstart:sim_chunkend);

window = sim_chunkend - sim_chunkstart;
reps = 50;
sim = [];
for i=1:reps
    
    [tsp2, ~, Itot, Istm] = simGLM(gg1, sim_Stim); 
    Window = 30000;
    tspsize = size(tsp2,1);
    Sim = zeros(1,Window);
    tsp = round(1000*tsp2);
    for i = 1:tspsize
        Sim(tsp(i)) = 1;
    end
    sim = [sim ; Sim];
end

summed_sim = sum(sim,1);

%% plots

subplot(211);
iiplot = -nkt+1:0;
ttplot = iiplot*dt*1000;
plot(ttplot,gg1.k,ttplot,gg1.k*0,'k--','linewidth',1.5);
xlabel('t (ms)');
title('Stimulus filter');
subplot(212);
iplot=1:nkt;
plot(gg1.iht(iplot)*1000, gg1.ih(iplot),'r', gg1.iht(iplot)*1000, gg1.ih(iplot)*0,'k--','linewidth',1.5);
xlabel('t (ms)');
title('Post-spike filter');


figure;

subplot(711);
plot(sim_Stim);
title('Stimulus spike counts');
subplot(712);
plot(sim_sps);
title('Neuron to predict');
subplot(7,1,3:6);
imagesc(1:window,1:50,sim);
title('50 trials simulation');
subplot(717);
bar(summed_sim);
title('Summed predictions');
