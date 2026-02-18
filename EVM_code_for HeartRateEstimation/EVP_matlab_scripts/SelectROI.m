function [ROI] = SelectROI(VideoName, SaveName)

v = VideoReader(VideoName);

% FIX 1: Avoid the black screen at the start
% Jump to 2 seconds (or half the video if it's very short)
if v.Duration > 2
    v.CurrentTime = 2; 
else
    v.CurrentTime = v.Duration / 2;
end

I = readFrame(v);
imshow(I);
%rectangle('Position',ROI);
r1 = drawrectangle('Label','OuterRectangle','Color',[1 0 0]);
ROI = r1.Position;

if ~strcmp(SaveName, '_')
    save(SaveName, 'ROI');
end
    