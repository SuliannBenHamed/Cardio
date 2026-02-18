# EXTRACTING HEART RATE FROM FACIAL MACAQUE VIDEOS USING EULERIAN VIDEO MAGNIFICATION (EVM)

## **[Automated video-based heart rate tracking for the anesthetized and behaving monkey](https://www.nature.com/articles/s41598-020-74954-5)**

Mathilda Froesel*, Quentin Goudard*, Marc Hauser, Maëva Gacoin & Suliann Ben Hamed (2020) **_Scientific Reports_** _Vol 10_, 17940. DOI: https://doi.org/10.1038/s41598-020-74954-5

Heart rate (HR) is extremely valuable in the study of complex behaviours and their physiological correlates in non-human primates. However, collecting this information is often challenging, involving either invasive implants or tedious behavioural training. In the present study, we implement a Eulerian video magnification (EVM) heart tracking method in the macaque monkey combined with wavelet transform. This is based on a measure of image to image fluctuations in skin reflectance due to changes in blood influx. We show a strong temporal coherence and amplitude match between EVM-based heart tracking and ground truth ECG, from both color (RGB) and infrared (IR) videos, in anesthetized macaques, to a level comparable to what can be achieved in humans. We further show that this method allows to identify consistent HR changes following the presentation of conspecific emotional voices or faces. EVM is used to extract HR in humans but has never been applied to non-human primates. Video photoplethysmography allows to extract awake macaques HR from RGB videos. In contrast, our method allows to extract awake macaques HR from both RGB and IR videos and is particularly resilient to the head motion that can be observed in awake behaving monkeys. Overall, we believe that this method can be generalized as a tool to track HR of the awake behaving monkey, for ethological, behavioural, neuroscience or welfare purposes.

If you use this code or method in your research, please cite the following methodological paper:
* The Eulerian Video Magnification (EVM) processing pipeline created by the MIT : http://people.csail.mit.edu/mrub/evm/, [Wu, H.-Y., Rubinstein, M., Shih, E., Guttag, J., Durand, F., Freeman, W., 2012. Eulerian video magnification for revealing subtle changes in the world. ACM Trans. Graph. 31, 65:1-65:8.](https://doi.org/10.1145/2185520.2185561)
* It also uses the Cross wavelet and wavelet coherence toolbox for MATLAB: https://github.com/grinsted/wavelet-coherence, [Grinsted, A., J. C. Moore, S. Jevrejeva (2004), Application of the cross wavelet transform and wavelet coherence to geophysical time series, Nonlin. Process. Geophys., 11, 561566](https://doi.org/10.5194/npg-11-561-2004)
* [Automated video-based heart rate tracking for the anesthetized and behaving monkey M. Froesel, Q. Goudard, M. Hauser, M. Gacoin, S. Ben Hamed Scientific Reports 10, 17940 (2020)](https://doi.org/10.1038/s41598-020-74954-5)
* For details regarding response timings to stimuli or specific experimental contexts referenced in the development of this tool, please refer to: [Socially meaningful visual context either enhances or inhibits vocalisation processing in the macaque brain M. Froesel, M. Gacoin, S. Clavagnier, M. Hauser, Q. Goudard, S. Ben Hamed, Nature Communications 13, 4886 (2022)](http://doi.org/10.1038/s41467-022-32512-9)

### How to?

This repository contains a suite of MATLAB scripts for extracting heart rate signals from video recordings using Eulerian Video Magnification (EVM) combined with Wavelet Transform analysis.
This pipeline allows for non-contact monitoring of physiological signals (PPG) and has been validated for use with both humans and non-human primates.

#### Prerequisites & Dependencies

To run these scripts, you need the following:

* MATLAB_R2018b or later, Matlab Image Processing Toolbox, Matlab Signal Processing Toolbox
* EVM Matlab Code (MIT CSAIL): You have to download the original Eulerian Video Magnification source code, ensuring the folder EVM_matlab_scripts are in your MATLAB path. (it can be foudn in the EVM_matlab_scripts folder of this repository)
* Wavelet Coherence Toolbox: The extraction script relies on wt.m (Continuous Wavelet Transform). Ensure the wavelet-coherence-master folder is in your MATLAB path. (it can be foudn in the EVM_matlab_scripts folder of this repository)

#### Usage Workflow

The pipeline is divided into 4 sequential steps (Scripts A to D).

**Step A: Spatial Cropping (Optional if your video is focused on the subject face)**
 - Script: A_Batch_Spatial_Crop.m
   + Pre-processes raw video files to stabilize the region of interest.
     * Input: Folder containing raw .avi or .mp4 files.
     * Action: Allows the user to manually draw a bounding box around the subject's face/skin area on the first frame.
     * Output: Saves cropped, stabilized videos in a processed_videos subfolder.

**Step B: EVM Magnification**
- Script: B_EVM_Magnification.m
  + Applies the Eulerian Video Magnification algorithm to amplify color changes related to blood flow. Parameters:
    * alpha: Amplification factor (Default: 10–20 but can be at 100 if no results)
    * fl / fh: Frequency limits (Hz).
    * Output: Generates magnified videos in an EVM_Results folder.

**Step C: ROI Definition**
- Script: C_Create_ROI.m
  + A helper utility to define the specific skin patch (Region of Interest) for signal extraction.
    * Action: Select a representative video and draw the ROI (e.g., cheek, forehead).
    * Output: Saves a .mat file containing the ROI coordinates.
    * Note: For legacy MATLAB versions (<2018b), use B_CreateRoiFile_2018a.m.

**Step D: Signal Extraction & Analysis**
- Script: D_HeartRate_Extraction.m
  + Extracts the heart rate signal using the method described in Froesel et al. (2020). Methodology:
    * Spatial averaging of pixels within the ROI.
    * Temporal bandpass filtering (Butterworth).
    * Continuous Wavelet Transform (CWT).
    * Max-power frequency extraction.
    * Cubic Spline smoothing.
    * Input: The .mat ROI file and the folder containing EVM videos.
    * Output: Saves raw data (.mat), heatmaps, and heart rate plots (.png).
