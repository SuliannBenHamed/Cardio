function [rrX,rrY] = FindRR(X,Y,t_threshold)

% [a,b] = findpeaks(ecg2,'MinPeakDistance',20);
[~ ,index] = min(abs(X-t_threshold));

[a,b] = findpeaks(Y,'MinPeakDistance',index);

figure(1);
plot(X, Y,X(b),a,'x');

rrY = [];
rrX = [];
for i=1:length(a)-1
    rrX =[rrX X(b(i))];  
    rrY = [rrY (X(b(i+1)) - X(b(i)) )];    
end
rrY = 60./rrY;
% figure
% (2);
% p = polyfit(rrX,rrY, 12);
% ecg3 = polyval(p,t);
% 
% 
% plot(t, 60./ecg3, rrX,60./rrY);
% rrY = ecg3;

% figure(3);
% plot(rrX,60./ecg3, t,OUTecgFreq, t,OUTevmFreq);
% legend("peaks","ECG", "EVM");

