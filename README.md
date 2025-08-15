# EXTRACTING HEART RATE FROM FACIAL MACAQUE VIDEOS USING EULERIAN VIDEO MAGNIFICATION (EVM)

## **[Automated video-based heart rate tracking for the anesthetized and behaving monkey](https://www.nature.com/articles/s41598-020-74954-5)**

Mathilda Froesel*, Quentin Goudard*, Marc Hauser, Maëva Gacoin & Suliann Ben Hamed (2020) **_Scientific Reports_** _Vol 10_, 17940. DOI: https://doi.org/10.1038/s41598-020-74954-5

Heart rate (HR) is extremely valuable in the study of complex behaviours and their physiological correlates in non-human primates. However, collecting this information is often challenging, involving either invasive implants or tedious behavioural training. In the present study, we implement a Eulerian video magnification (EVM) heart tracking method in the macaque monkey combined with wavelet transform. This is based on a measure of image to image fluctuations in skin reflectance due to changes in blood influx. We show a strong temporal coherence and amplitude match between EVM-based heart tracking and ground truth ECG, from both color (RGB) and infrared (IR) videos, in anesthetized macaques, to a level comparable to what can be achieved in humans. We further show that this method allows to identify consistent HR changes following the presentation of conspecific emotional voices or faces. EVM is used to extract HR in humans but has never been applied to non-human primates. Video photoplethysmography allows to extract awake macaques HR from RGB videos. In contrast, our method allows to extract awake macaques HR from both RGB and IR videos and is particularly resilient to the head motion that can be observed in awake behaving monkeys. Overall, we believe that this method can be generalized as a tool to track HR of the awake behaving monkey, for ethological, behavioural, neuroscience or welfare purposes.

This work uses the Eulerian Video Magnification (EVM) processing pipeline created by the MIT : http://people.csail.mit.edu/mrub/evm/

Wu, H.-Y., Rubinstein, M., Shih, E., Guttag, J., Durand, F., Freeman, W., 2012. Eulerian video magnification for revealing subtle changes in the world. ACM Trans. Graph. 31, 65:1-65:8. https://doi.org/10.1145/2185520.2185561

### Define ROI in Video 

This version of this script assumes location of region of interest is fixed throughout video.
Place Video you want to process in EVM_Matlab/data.
Run CreateRoiFile.m, select Video, draw ROI, on enter, choose ROI name. It saved in EVM_Matlab/data.


