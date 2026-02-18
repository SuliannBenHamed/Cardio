function [corrcoeff] = GetCorrWL(cw, cperiod,FilterLow,FilterHigh)

max_freq = [];
corr = [];

[~ ,imin] = min(abs(cperiod-60/FilterLow));
[~ ,imax] = min(abs(cperiod-60/FilterHigh));
periods = cperiod(imax:imin);
w = cw(imax:imin);
for y=1:length(w)
    [corrmax , index] = max(abs(w(:,y)));
    if corrmax > 1
        corr = [corr corr(end)];  
    else
        corr = [corr corrmax];
    end
end
corrcoeff = mean(corr);