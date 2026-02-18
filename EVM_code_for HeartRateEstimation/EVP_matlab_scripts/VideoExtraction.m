function [TimeVector, TemporalPulseSignal] = VideoExtraction(VideoName, ROI, F_high, F_Low)

v = VideoReader(VideoName);

TemporalPulseSignal = [];
while hasFrame(v)
    frame = imcrop(readFrame(v), ROI);
    TemporalPulseSignal = [TemporalPulseSignal mean(mean(mean(frame)))];
end

TimeVector = [0:(1/(v.FrameRate)):length(TemporalPulseSignal)*(1/(v.FrameRate))-(1/(v.FrameRate))];
TemporalPulseSignal = bandpass(TemporalPulseSignal,[F_Low/60 F_high/60],1/TimeVector(2));
end