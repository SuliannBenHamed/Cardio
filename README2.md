Here is the standard GitHub-style README.md in English. It is formatted to be copy-pasted directly into your repository root.

It includes the Description, Dependencies, Installation, Usage Workflow, and the required Citations.
Video-Based Heart Rate Tracking (EVM Toolbox)

This repository contains a suite of MATLAB scripts for extracting heart rate signals from video recordings using Eulerian Video Magnification (EVM) combined with Wavelet Transform analysis.

This pipeline allows for non-contact monitoring of physiological signals (PPG) and has been validated for use with both humans and non-human primates.

References & Citations

If you use this code or method in your research, please cite the following methodological paper:

    Automated video-based heart rate tracking for the anesthetized and behaving monkey M. Froesel, Q. Goudard, M. Hauser, M. Gacoin, S. Ben Hamed Scientific Reports 10, 17940 (2020). DOI: 10.1038/s41598-020-74954-5

For details regarding response timings to stimuli or specific experimental contexts referenced in the development of this tool, please refer to:

    Socially meaningful visual context either enhances or inhibits vocalisation processing in the macaque brain M. Froesel, M. Gacoin, S. Clavagnier, M. Hauser, Q. Goudard, S. Ben Hamed Nature Communications 13, 4886 (2022). DOI: 10.1038/s41467-022-32512-9

Prerequisites & Dependencies

To run these scripts, you need the following:

    MATLAB (Recommend version R2018b or later).

        Image Processing Toolbox

        Signal Processing Toolbox

    EVM Matlab Code (MIT CSAIL):

        You must download the original Eulerian Video Magnification source code.

        Ensure the folder EVM_matlab_scripts (specifically amplify_spatial_Gdown_temporal_ideal.m) is in your MATLAB path.

    Wavelet Coherence Toolbox:

        The extraction script relies on wt.m (Continuous Wavelet Transform).

        Ensure the wavelet-coherence-master folder is in your MATLAB path. (it is in EVM_matlab_scripts)

Usage Workflow

The pipeline is divided into 4 sequential steps (Scripts A to D).
Step A: Spatial Cropping (Optional is you video focused on the subject face)

Script: A_Batch_Spatial_Crop.m

Pre-processes raw video files to stabilize the region of interest.

    Input: Folder containing raw .avi or .mp4 files.

    Action: Allows the user to manually draw a bounding box around the subject's face/skin area on the first frame.

    Output: Saves cropped, stabilized videos in a processed_videos subfolder.

Step B: EVM Magnification

Script: B_EVM_Magnification.m

Applies the Eulerian Video Magnification algorithm to amplify color changes related to blood flow.

    Parameters:

        alpha: Amplification factor (Default: 10–20 but can be at 100 if no results)

        fl / fh: Frequency limits (Hz).

    Output: Generates magnified videos in an EVM_Results folder.

Step C: ROI Definition

Script: C_Create_ROI.m

A helper utility to define the specific skin patch (Region of Interest) for signal extraction.

    Action: Select a representative video and draw the ROI (e.g., cheek, forehead).

    Output: Saves a .mat file containing the ROI coordinates.

    Note: For legacy MATLAB versions (<2018b), use B_CreateRoiFile_2018a.m.

Step D: Signal Extraction & Analysis

Script: D_HeartRate_Extraction.m

Extracts the heart rate signal using the method described in Froesel et al. (2020).

    Methodology:

        Spatial averaging of pixels within the ROI.

        Temporal bandpass filtering (Butterworth).

        Continuous Wavelet Transform (CWT).

        Max-power frequency extraction.

        Cubic Spline smoothing.

    Input: The .mat ROI file and the folder containing EVM videos.

    Output: Saves raw data (.mat), heatmaps, and heart rate plots (.png).