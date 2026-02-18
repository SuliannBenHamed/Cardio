function [] = EVM_norm(t, evmperiod, evmw)
win=30;

evmwN=zeros(size(evmw));

for i=1:length(t)-win,

MIN=min(min(evmw(:,i:i+win)));

MAX=max(max(evmw(:,i:i+win)));

evmwN(:,i:i+win)=(evmw(:,i:i+win)-MIN)/(MAX-MIN);

end;

surface(t, 60./evmperiod, abs(evmwN),'EdgeColor', 'none');

set(gca,'ylim',[0 300]);

set(gca,'xlim',[350 550]);

set(gca,'xlim',[0 length(evmperiod)]);

colorbar;

ylabel("Pulse rate (BPM)");

xlabel("Time (sec)");

title("EVM");


