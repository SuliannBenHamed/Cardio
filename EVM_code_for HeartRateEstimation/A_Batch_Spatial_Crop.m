% Script: A_Batch_Spatial_Crop.m
% Description: Batch processes videos to spatially crop the subject's face.
%              This reduces file size and stabilizes the region for EVM.
% Draw the area to be cropped then double click; Nex impage is saved in
% subdirectory preprocessed_videos; For efficent EVM Heart-rate extraction,
% you want to focus on face or skin.

clear; clc;

%% 1. FOLDER SELECTION
fprintf('Please select the folder containing your raw videos.\n');
dataDir = uigetdir('./MyVideo/', 'Select Raw Video Folder');

if isequal(dataDir, 0)
    disp('No folder selected. Exiting.');
    return;
end

% Get list of video files (supports .avi and .mp4)
videoFiles = dir(fullfile(dataDir, '*.avi')); 
if isempty(videoFiles)
    videoFiles = dir(fullfile(dataDir, '*.mp4'));
end

if isempty(videoFiles)
    error('No video files found in the selected folder.');
end

fprintf('Found %d videos to process.\n', length(videoFiles));

% Create Output Folder
outputFolder = fullfile(dataDir, 'processed_videos');
if ~exist(outputFolder, 'dir'), mkdir(outputFolder); end

%% 2. BATCH PROCESSING LOOP
for k = 1:length(videoFiles)
    
    vidName = videoFiles(k).name;
    videoFullPath = fullfile(dataDir, vidName);
    [~, baseName, ~] = fileparts(vidName);
    
    fprintf('\n------------------------------------------------------\n');
    fprintf('Processing Video %d/%d: %s\n', k, length(videoFiles), vidName);

    % Setup Video Reader
    vReader = VideoReader(videoFullPath);
    Fps = vReader.FrameRate;
    
    % Read the first frame to allow user to draw the crop rectangle
    if hasFrame(vReader)
        firstFrame = readFrame(vReader);
    else
        warning('Video %s appears empty.', vidName);
        continue;
    end

    % --- INTERACTIVE CROP ---
    hFig = figure('Name', ['CROP: ' baseName], 'NumberTitle', 'off');
    imshow(firstFrame);
    title(['Draw rectangle on FACE for: ' baseName '. Double-click to confirm.'], 'Interpreter', 'none');
    
    % User draws rectangle
    [~, rectFace] = imcrop; 
    close(hFig);

    if isempty(rectFace)
        fprintf('Crop skipped for %s. Moving to next video.\n', baseName);
        continue; 
    end
    rectFace = round(rectFace);

    % --- PROCESS AND SAVE ---
    outputFile = fullfile(outputFolder, [baseName '_FinalCrop.avi']);
    vWriter = VideoWriter(outputFile, 'Uncompressed AVI'); % Uncompressed is best for EVM
    vWriter.FrameRate = Fps;
    open(vWriter);
    
    % Reset reader to beginning
    vReader.CurrentTime = 0;
    
    hWait = waitbar(0, ['Cropping ' baseName '...']);
    frameCount = 0;
    
    while hasFrame(vReader)
        frame = readFrame(vReader);
        croppedFrame = imcrop(frame, rectFace);
        writeVideo(vWriter, croppedFrame);
        
        frameCount = frameCount + 1;
        if mod(frameCount, 100) == 0
            % Update waitbar occasionally
            waitbar(vReader.CurrentTime / vReader.Duration, hWait); 
        end
    end

    close(hWait);
    close(vWriter);
    fprintf('Saved: %s\n', outputFile);
    
end

fprintf('\nAll videos processed!\n');