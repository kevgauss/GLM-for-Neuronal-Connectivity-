datdir4 = 'NoiseStim_1081_IL8/2x5sec_4/';
load([datdir4,'1081_IL8_1h_151220_noiseStim2X5sec_4']);

tnoise4 = Trace_9_13_1_1(:,1);
tnoisesize4 = size(tnoise4,1);
tnoise4 = [tnoise4 ; tnoise4(tnoisesize4)+Trace_9_13_2_1(:,1)];
Stimnoise4 = [Trace_9_13_1_1(:,2) ; Trace_9_13_2_1(:,2)];
Vnoise4 = [Trace_9_13_1_2(:,2) ; Trace_9_13_2_2(:,2)];

datdir1 = 'NoiseStim_1081_IL8/2x5sec_1/';
load([datdir1,'1081_IL8_1h_151220_noiseStim2X5sec_1']);

tnoise1 = Trace_3_7_1_1(:,1);
tnoisesize1 = size(tnoise1,1);
tnoise1 = [tnoise1 ; tnoise1(tnoisesize1)+Trace_3_7_2_1(:,1)];
Stimnoise1 = [Trace_3_7_1_1(:,2) ; Trace_3_7_2_1(:,2)];
Vnoise1 = [Trace_3_7_1_2(:,2) ; Trace_3_7_2_2(:,2)];

datdir2 = 'NoiseStim_1081_IL8/2x5sec_2/';
load([datdir2,'1081_IL8_1h_151220_noiseStim2X5sec_2']);

tnoise2 = Trace_4_16_1_1(:,1);
tnoisesize2 = size(tnoise2,1);
tnoise2 = [tnoise2 ; tnoise2(tnoisesize2)+Trace_4_16_2_1(:,1)];
Stimnoise2 = [Trace_4_16_1_1(:,2) ; Trace_4_16_2_1(:,2)];
Vnoise2 = [Trace_4_16_1_2(:,2) ; Trace_4_16_2_2(:,2)];

datdir3 = 'NoiseStim_1081_IL8/2x5sec_3/';
load([datdir3,'1081_IL8_1h_151220_noiseStim2X5sec_3']);

tnoise3 = Trace_8_9_1_1(:,1);
tnoisesize3 = size(tnoise3,1);
tnoise3 = [tnoise3 ; tnoise3(tnoisesize3)+Trace_8_9_2_1(:,1)];
Stimnoise3 = [Trace_8_9_1_1(:,2) ; Trace_8_9_2_1(:,2)];
Vnoise3 = [Trace_8_9_1_2(:,2) ; Trace_8_9_2_2(:,2)];
% 
% subplot(411);
% histogram(Vnoise1*1000);
% title('cell 1');
% 
% subplot(412);
% histogram(Vnoise2*1000);
% title('cell 2');
% 
% subplot(413);
% histogram(Vnoise3*1000);
% title('cell 3');
% 
% subplot(414);
% histogram(Vnoise4*1000);
% title('cell 4');
% xlabel('U (mV)');
% 
% suptitle('Voltage densities of Noise stimulus driven cells');



histogram(Vnoise4*1000);
hold on
histogram(Vnoise3*1000);
hold on
histogram(Vnoise2*1000);
hold on
histogram(Vnoise1*1000);
legend('cell 4','cell 3','cell 2','cell 1');
xlabel('U (mV)');
ylabel('Bin counts');
title('Voltage densities');