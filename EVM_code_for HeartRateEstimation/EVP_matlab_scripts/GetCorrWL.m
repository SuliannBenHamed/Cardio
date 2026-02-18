function [corrcoeff] = GetCorrWL(cw,cperiod,FilterLow,FilterHigh,t, EcgFreqs)

[~ ,imin] = min(abs(cperiod-60/FilterLow));
[~ ,imax] = min(abs(cperiod-60/FilterHigh));
w = cw(imax:imin);
p = cperiod(imax:imin);
corr = [];

for y=1:length(t)
    [corrmax , index] = min(abs(cperiod-60/EcgFreqs(y)));
%     if corrmax > 1
%         corr = [corr corr(end)];  
%     else
    corr = [corr max(cw(index,y))];
%     end
end
corrcoeff = mean(corr);