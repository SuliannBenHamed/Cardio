 clear all

FilterLow = 100;% 160;
FilterHigh = 140;%180;
[ROIName, ROIPath]= uigetfile('*','SELECT A ROI_BASE');
ROI= [ROIPath,ROIName];
load (ROI);
[VidName, VidPath] = uigetfile('*','SELECT A VIDEO');
Vname = [VidPath VidName];
[evmX, evmY] = VideoExtraction(Vname, ROI, FilterHigh, FilterLow);
evmX = evmX';
evmY = evmY';
%% MISE EN FORME DES DONNES 
t = evmX;
evm = evmY;
OUTt = t;
OUTevm = evm;

%% CALCUL DE DE LA CORRELATION ET TRANSFORMEES EN WL
[evmw,~,evmperiod,evmcoi] = wt([t evm], 'Dj', 1/48);
evmw(~isfinite(evmw)) = 0;
OUTevmw = evmw;
OUTevmperiod = evmperiod;

%% FILTRAGE, CALCUL DES FREQUENCES CORRELEES ET DU COEFF DE CORRELATION
EvmFreqs = GetFreqFromWL(evmw,evmperiod,FilterLow,FilterHigh);
 figure(1)
 EVM_norm(t, evmperiod, evmw)
 
t_threshold = 0.65*60/mean(EvmFreqs);
%% MOYENNES, FREQUENCES ET FREQUENCES CORRELEES

 slidingtime = 20;
 
[Freqt, OUTevmFreq] = GetSlidingMean(t, EvmFreqs, slidingtime);
% 


figure(2)
plot(t,EvmFreqs,Freqt,OUTevmFreq);
%xlim([0 length(OUTevmperiod)]);  
%title("SocposAgr");

%%
% save (['OUTevmFreq_' VidName(1:20)], 'OUTevmFreq');
% save (['Freqt_' VidName(1:20)], 'Freqt');
save OUTevmFreq
save Freqt