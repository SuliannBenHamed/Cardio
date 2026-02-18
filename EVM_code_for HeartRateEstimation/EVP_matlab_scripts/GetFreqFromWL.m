function [Freqs] = GetFreqFromWL(cw, cperiod, FilterLow, FilterHigh)
%%
max_freq = [];
[~ ,imin] = min(abs(cperiod-60/FilterLow));
[~ ,imax] = min(abs(cperiod-60/FilterHigh));
periods = cperiod(imax:imin);
w = cw([imax:imin],:);
corr = [];
%%
% for y=1:length(cw)
%     [corrmax ,index] = max(abs(cw(:,y)));
%     if 60/cperiod(index) >= FilterLow && 60/cperiod(index) <= FilterHigh
%       max_freq = [max_freq cperiod(index)];
%     else
%         if y ~= 1
%             max_freq = [max_freq max_freq(end)];
%         else
% %             max_freq = [max_freq cperiod(index)];
%             max_freq = [max_freq 0];
%         end
%     end
% end

for y=1:length(w)
    [corrmax ,index] = max(abs(w(:,y)));
    max_freq = [max_freq periods(index)];
end



% max_freq(~isfinite(max_freq)) = 0;
% moy = mean(max_freq);
% for i=1:length(max_freq)
%     if max_freq(i) == 0
%        max_freq(i) = moy;
%     end
% end

% max_freq(~isfinite(max_freq)) = 0;
% Freqs = max_freq;

Freqs = 60./max_freq;