function [t2, M] = GetSlidingMean(t1, s, box_duration)
M = [];
[~, index] = min(abs(t1-box_duration));
for i = 1:length(s)
    M(i) = mean(s(max([1 i-index]):i));
end

t2 = t1 - t1(round(index/2));
[~, ibegin] = min(abs(t2-0));
t2 = t2(round(index/2):end);
M = M(round(index/2):end);
