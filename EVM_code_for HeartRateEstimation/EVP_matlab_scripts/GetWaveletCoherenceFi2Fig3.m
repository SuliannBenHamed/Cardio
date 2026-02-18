% clear all
%%
Titre = "S1 IR";
FilterLow = 70;
FilterHigh = 90;
[ecgX, ecgY] = Load2Dcsv("ECG");
[evmX, evmY] =  Load2Dcsv("EVM");
ecgY = -ecgY;

%% MISE EN FORME DES DONNES 
maxTimeEcg = ecgX(end);
maxTimeEvm = evmX(end);

if maxTimeEvm < maxTimeEcg
   [~ ,index] = min(abs(ecgX-maxTimeEvm)); 
   ecgX = ecgX(1:index);
   ecgY = ecgY(1:index);
else
   [~ ,index] = min(abs(evmX-maxTimeEcg)); 
   evmX = evmX(1:index);
   evmY = evmY(1:index);
end
  
t = evmX;
ecg = [];
evm = evmY;

for i=1:length(t)
    [~ ,index] = min(abs(ecgX-t(i)));
    ecg = [ecg; ecgY(index)];
end

% ecg = bandpass(ecg,[FilterLow/60 FilterHigh/60],1/t(2));
% evm = bandpass(ecg,[FilterLow/60 FilterHigh/60],1/t(2));

OUTt = t;
OUTevm = evm;
OUTecg = ecg;

%% CALCUL DE DE LA CORRELATION ET TRANSFORMEES EN WL
[cw,~,cperiod,ccoi] = wtc([t ecg],[t evm]);
[evmw,~,evmperiod,evmcoi] = wt([t evm], 'Dj', 1/48);
[ecgw,~,ecgperiod,ecgcoi] = wt([t bandpass(ecg,[FilterLow/60 FilterHigh/60],1/t(2))], 'Dj', 1/48);

cw(~isfinite(cw)) = 0;
evmw(~isfinite(evmw)) = 0;
ecg(~isfinite(ecg)) = 0;

OUTcw = cw;
OUTcperiod = cperiod;
OUTecgw = ecgw;
OUTecgperiod = ecgperiod;
OUTevmw = evmw;
OUTevmperiod = evmperiod;

%% FILTRAGE, CALCUL DES FREQUENCES CORRELEES ET DU COEFF DE CORRELATION

CorrFreqs = GetFreqFromWL(cw,cperiod,FilterLow,FilterHigh);
EvmFreqs = GetFreqFromWL(evmw,evmperiod,FilterLow,FilterHigh);
CFreqs = GetFreqFromWL(cw,cperiod,FilterLow,FilterHigh);

t_threshold = 0.65*60/mean(EvmFreqs);

[t_EcgFreqs, EcgFreqs_] = FindRR(ecgX,ecgY,t_threshold);
EcgFreqs = [];
for i=1:length(t)
    [~ ,index] = min(abs(t_EcgFreqs-t(i)));
    EcgFreqs = [EcgFreqs EcgFreqs_(index)];
end
OUTcorrcoeff = GetCorrWL(cw,cperiod,FilterLow,FilterHigh,t, EcgFreqs);

%% MOYENNES, FREQUENCES ET FREQUENCES CORRELEES

slidingtime = 20;
[Freqt, OUTcorrFreq] = GetSlidingMean(t, CorrFreqs, slidingtime);
[~, OUTevmFreq] = GetSlidingMean(t, EvmFreqs, slidingtime);
[~, OUTecgFreq] = GetSlidingMean(t, EcgFreqs, slidingtime);

ymax = 1.3*mean(EcgFreqs);
ymin = 0.7*mean(EcgFreqs);

figure(1)

subplot(411);
plot(t,EcgFreqs,Freqt,OUTecgFreq);
ylim([ymin ymax]);
title("ECG");
ylabel("Pulse rate (BPM)");

subplot(412);
plot(t,EvmFreqs,Freqt,OUTevmFreq);
ylim([ymin ymax]);  
title("EVM");
subplot(413);

plot(Freqt,OUTecgFreq,Freqt,OUTevmFreq);
ylim([ymin ymax]);
title("ECG - EVM");
legend("ECG","EVM");
subplot(414);


plot(Freqt,abs(OUTevmFreq-OUTecgFreq));
title("Erreur");
xlabel("Time(s)") ;

%% PLOT WAVELETS

figure(2)
surface(t, 60./evmperiod, abs(evmw),'EdgeColor', 'none');
ylim([0 600])
colormap(jet)
colorbar;
title("EVM");

figure(3)
surface(t, 60./ecgperiod, abs(ecgw),'EdgeColor', 'none');
ylim([0 600])
colormap(jet)
colorbar;
title("ECG");

figure(4)
surface(t, 60./cperiod, abs(cw),'EdgeColor', 'none');
caxis([0 1.1])
ylim([0 200])
xlim([350 550])
colormap(jet)
colorbar;
title("Coherence");

%% PlotRawECg
figure(5)
plot(ecgX,ecgY)
xlim([100 105])
title("Raw ECG")