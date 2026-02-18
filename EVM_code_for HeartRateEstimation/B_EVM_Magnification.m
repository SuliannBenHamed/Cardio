% Script: B_EVM_Magnification.m
% Description: Applies Eulerian Video Magnification to cropped videos.
%              Requires 'amplify_spatial_Gdown_temporal_ideal' in path.
% Cropped video from the MyVideo/processed_videos directory
% if level = 6 doesn't work, change to 5

clear; clc;

%% 1. PARAMETERS
% Adjust these parameters based on your specific setup
alpha = 10;           % Amplification factor (10-20 is standard for pulse)
level = 5;            % Laplacian pyramid levels
samplingRate = 30;    % Video Frame Rate (ensure this matches your camera)
chromAttenuation = 0; % 0 = Magnify intensity (better for skin), 1 = Color

% Frequency band (Heart Rate range in Hz)
% Example: 60 BPM = 1 Hz, 120 BPM = 2 Hz
% for awake macaques
min_BPM = 100; 
max_BPM = 180;

fl = min_BPM / 60;    % Lower bound Hz 
fh = max_BPM / 60;    % Upper bound Hz 

%% 2. SELECT DATA FOLDER
fprintf('Please select the folder containing the "_FinalCrop.avi" videos.\n');
dataDir = uigetdir('./MyVideo/processed_videos/', 'Select Processed Videos Folder');

if isequal(dataDir, 0)
    disp('No folder selected. Exiting.');
    return;
end

% Create Output Directory
resultsDir = fullfile(dataDir, 'EVM_Results');
if ~exist(resultsDir, 'dir'), mkdir(resultsDir); end

%% 3. BATCH PROCESSING LOOP
filesList = dir(fullfile(dataDir, '*_FinalCrop.avi'));

if isempty(filesList)
    error('No files ending with "_FinalCrop.avi" found in: %s', dataDir);
end

fprintf('Found %d videos to process.\n', length(filesList));

for i = 1:length(filesList)
    
    vidName = filesList(i).name;
    inFile = fullfile(dataDir, vidName);
    
    fprintf('------------------------------------------------\n');
    fprintf('Processing %d/%d: %s\n', i, length(filesList), vidName);
    
    try
        tic; 
        
        % Call the EVM function
        % Note: Ensure this function is in your MATLAB Path
        amplify_spatial_Gdown_temporal_ideal(inFile, resultsDir, ...
            alpha, level, fl, fh, samplingRate, chromAttenuation); 
        
        elapsedTime = toc; 
        fprintf('Done in %.2f seconds.\n', elapsedTime);
        
    catch ME
        fprintf(2, 'ERROR processing %s: %s\n', vidName, ME.message);
    end
end

fprintf('------------------------------------------------\n');
fprintf('Batch processing complete. Results saved in: %s\n', resultsDir);