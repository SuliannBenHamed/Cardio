% Script: D_HeartRate_Extraction.m
% Description: Extracts heart rate using the method described in:
%              Froesel & Goudard et al. (2020), Sci Rep. "Automated video-based heart rate tracking..."
%              Steps: Spatial Average -> Butterworth Filter -> Wavelet -> Max Power -> Spline Smoothing

clear; clc; close all;

%% 1. PARAMETERS & CONFIGURATION
% -------------------------------------------------------------------------
% IMPORTANT: Adjust these filters based on your subject!
% Monkeys (Macaque): Low=120, High=180 (or wider depending on context)
% -------------------------------------------------------------------------

FilterLow = 50;   % Lower bound (BPM)
FilterHigh = 160; % Upper bound (BPM)

% Smoothing factor for Cubic Spline (from Froesel & Goudard et al.)
% Lower value = more smoothing. Standard: 0.001 to 0.01
SmoothingFactor = 0.001; 

% Add toolboxes paths if they are in subfolders
addpath(genpath('EVM_matlab_scripts')); 

%% 2. LOAD ROI (Region of Interest)
fprintf('------------------------------------------------\n');
fprintf('STEP 1: Select the ROI file (.mat)\n');
[ROIName, ROIPath] = uigetfile('*.mat', 'SELECT ROI FILE','./MyVideo/processed_videos');
if isequal(ROIName, 0), return; end
ROI_FullPath = fullfile(ROIPath, ROIName);

% Load ROI robustly (whatever the variable name inside)
roiData = load(ROI_FullPath);
vars = fieldnames(roiData);
ROI_Rect = roiData.(vars{1}); 
fprintf('   -> ROI loaded: %s\n', ROIName);

%% 3. LOAD VIDEO & EXTRACT RAW SIGNAL
fprintf('STEP 2: Select the Video file\n');
[VidName, VidPath] = uigetfile('*.*', 'SELECT VIDEO FILE','./MyVideo/processed_videos/EVM_Results');
if isequal(VidName, 0), return; end
VideoFullPath = fullfile(VidPath, VidName);
[~, baseName, ~] = fileparts(VidName);

fprintf('   -> Extracting spatial average signal (this may take time)...\n');

% Note: VideoExtraction usually returns X (time vector) and Y (signal)
% We pass filter values here if the function uses them for initial cleanup
[t, signal_raw] = VideoExtraction(VideoFullPath, ROI_Rect, FilterHigh, FilterLow);

% Transpose if necessary to have column vectors
if size(t, 1) < size(t, 2), t = t'; end
if size(signal_raw, 1) < size(signal_raw, 2), signal_raw = signal_raw'; end

%% 4. SIGNAL PROCESSING (The "Froesel" Method)

% --- A. Temporal Filtering (Butterworth) ---
% Removes noise outside the physiological range before Wavelet analysis
fprintf('   -> Applying Butterworth Bandpass Filter...\n');
dt = mean(diff(t));  
Fs = 1 / dt;   % Sampling frequency

% Normalized frequencies for Butterworth
Wn = [FilterLow/60, FilterHigh/60] / (Fs/2);  
[b, a] = butter(2, Wn, 'bandpass'); % 2nd order filter

% Zero-phase filtering
signal_filtered = filtfilt(b, a, signal_raw); 

% --- B. Wavelet Transform ---
fprintf('   -> Computing Wavelet Transform...\n');
% 'Dj', 1/48 provides high frequency resolution
[evmw, ~, evmperiod, ~] = wt([t, signal_filtered], 'Dj', 1/48);
evmw(~isfinite(evmw)) = 0;

% --- C. Extract Heart Rate (Max Power Method) ---
fprintf('   -> Extracting Heart Rate Trace...\n');

% 1. Convert scales to BPM
scales_BPM = 60 ./ evmperiod;

% 2. Crop Heatmap to Filter Limits
% Find indices corresponding to FilterLow and FilterHigh
[~, idx_Low] = min(abs(scales_BPM - FilterLow));
[~, idx_High] = min(abs(scales_BPM - FilterHigh));

% Ensure correct ordering (min to max index)
idx_start = min(idx_Low, idx_High);
idx_end   = max(idx_Low, idx_High);

% Crop the relevant band
band_BPM = scales_BPM(idx_start:idx_end);
band_Power = abs(evmw(idx_start:idx_end, :));

% 3. Find Max Power at each time point
[~, max_indices] = max(band_Power, [], 1);
HR_Raw_Trace = band_BPM(max_indices);

% --- D. Cubic Spline Smoothing ---
fprintf('   -> Applying Cubic Spline Smoothing...\n');
% csaps(x, y, p, xx) -> p is the smoothing parameter
HR_Smoothed = csaps(t, HR_Raw_Trace, 1/(Fs*1000*SmoothingFactor), t);

%% 5. VISUALIZATION
hFig = figure('Name', ['Results: ' baseName], 'Color', 'w', 'Position', [100 100 1000 600]);

%Subplot 1: Wavelet Heatmap
subplot(2, 1, 1);
%Plot surface (flipping Y dir for intuitive frequency reading)
imagesc(t, scales_BPM, abs(evmw));
axis xy; 
ylim([FilterLow-10, FilterHigh+10]);
colormap(jet);
ylabel('Heart Rate (BPM)');
title(['Wavelet Power Spectrum: ' baseName], 'Interpreter', 'none');
colorbar;
caxis([lo hi]);

% Subplot 2: Extracted Heart Rate
subplot(2, 1, 2);
plot(t, HR_Smoothed, 'r', 'LineWidth', 2);
ylabel('Heart Rate (BPM)');
xlabel('Time (s)');
title('Extracted Signal (Spline Smoothed)');
grid on;
ylim([FilterLow, FilterHigh]);
xlim([min(t), max(t)]);

%% 6. SAVE RESULTS
outputFile_Mat = fullfile(VidPath, ['Data_' baseName '.mat']);
outputFile_Img = fullfile(VidPath, ['Plot_' baseName '.png']);

save(outputFile_Mat, 't', 'HR_Smoothed', 'signal_raw', 'signal_filtered', 'FilterLow', 'FilterHigh');
saveas(hFig, outputFile_Img);

fprintf('------------------------------------------------\n');
fprintf('Done! Results saved to:\n%s\n', outputFile_Mat);