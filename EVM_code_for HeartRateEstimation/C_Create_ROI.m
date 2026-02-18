% Script: C_Create_ROI.m
% Description: Helper utility to define the Region of Interest (ROI) 
%              on a reference video.
% You might want to create multiple ROIs in order to identify which one
% best captures heart rate.

clear; clc;

% Select a reference video (usually one of the EVM processed videos)
fprintf('Select a representative video to define the ROI.\n');
[VideoName, VideoPath] = uigetfile('*.avi', 'SELECT A VIDEO');

if isequal(VideoName, 0)
    return; 
end

% Define where to save the ROI file
[RoiName, RoiPath] = uiputfile('ROI.mat', 'SAVE ROI FILE AS');

if isequal(RoiName, 0)
    return;
end

% Call the selection function
% Note: 'SelectROI' is assumed to be a custom function wrapping imrect or roipoly
fullVideoPath = fullfile(VideoPath, VideoName);
savePath = fullfile(RoiPath, RoiName);

if exist('SelectROI', 'file')
    SelectROI(fullVideoPath, savePath);
    fprintf('ROI saved successfully.\n');
else
    % Fallback if SelectROI is not in path: Basic implementation
    v = VideoReader(fullVideoPath);
    frame = readFrame(v);
    figure; imshow(frame);
    title('Draw the ROI (e.g., forehead/cheek). Double click to finish.');
    h = imrect; 
    position = wait(h);
    rectFace = round(position); % Saving as 'rectFace' to match previous scripts
    save(savePath, 'rectFace');
    fprintf('ROI saved using basic imrect.\n');
    close;
end